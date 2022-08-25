//TODO:
//	-look into how Local Work Group Size affects performance. Might be easier done on future dummy function.
//	-Dummy OpenCL Functions: Based off getting Range of each macroblock (Max - Min Luma Value, and writing 1 or 0 to a binary map
//		(for the sake of simplicity, write to a text file), 1 being the Range is above some threshold.)
//			Text File will be numbered per frame.
//			Idea: create array of Total Number of Block 0's, overwrite 1 in respective position if block number's range is above some threshold.
//				At end, write to text file. Reset array at start for new frame.

//USE THIS AS REFERENCE FOR FUTURE DEVELOPMENT
//HOW TO SETUP OPENCL ENVIROMENT
//HOW TO WORK WITH YUV 4:2:0
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cmath>
#include <iostream>
#include <sstream>
#include <vector>
#include <string>
#include <tchar.h>
#include <memory.h>

// Macros for OpenCL versions
#define OPENCL_VERSION_1_2  1.2f
#define OPENCL_VERSION_2_0  2.0f

// Suppress a compiler warning about undefined CL_TARGET_OPENCL_VERSION
// Khronos ICD supports only latest OpenCL version
#define CL_TARGET_OPENCL_VERSION 220

// Suppress a compiler warning about 'clCreateCommandQueue': was declared deprecated
// for OpenCL 1.2
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS
#define __CL_ENABLE_EXCEPTIONS

#include "CL\cl.h"
#include "utils.h"

//for perf. counters
#include <Windows.h>
#include <chrono>;
using std::chrono::high_resolution_clock;
using std::chrono::duration;
using std::chrono::milliseconds;

//for File Browser Functionality
#include <ShObjIdl.h>
#include <regex>

const COMDLG_FILTERSPEC c_rgSaveTypes[] =
{
	{L"YUV 4:2:0 (*.yuv)",       L"*.yuv"},
};

#define _FILE_OFFSET_BITS 64
using namespace std;

#include "SimpleYUV.h"

//FUNCTION CONTROLS
bool avgFrameNonPara = 1;	//TURN OFF OR ON AVERAGE FRAME NON PARALLEL (FOR COMPARISON)

bool paraWriteAvg = 1;
bool nonParaWriteAvg = 1;	//TURN OFF OR ON AVERAGE PER BLOCK PER FRAME WRITE TO NEW YUV (FOR COMPARISON)

int main()	//MAKE INTO A PROPER FUNCTION LATER
{
	FILE* fp;

	//File Explorer Functionality, Easier YUV File Selection, Width/Height found by filename (YUV Standard)
	HRESULT hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED |
		COINIT_DISABLE_OLE1DDE);
	PWSTR pszFilePath;
	PWSTR pszName;
	if (SUCCEEDED(hr))
	{
		IFileOpenDialog* pFileOpen;

		// Create the FileOpenDialog object.
		hr = CoCreateInstance(CLSID_FileOpenDialog, NULL, CLSCTX_ALL,
			IID_IFileOpenDialog, reinterpret_cast<void**>(&pFileOpen));

		if (SUCCEEDED(hr))
		{
			// Show the Open dialog box.
			pFileOpen->SetFileTypes(ARRAYSIZE(c_rgSaveTypes), c_rgSaveTypes);
			hr = pFileOpen->Show(NULL);

			// Get the file name from the dialog box.
			if (SUCCEEDED(hr))
			{
				IShellItem* pItem;
				hr = pFileOpen->GetResult(&pItem);
				if (SUCCEEDED(hr))
				{
					hr = pItem->GetDisplayName(SIGDN_FILESYSPATH, &pszFilePath);
					pItem->GetDisplayName(SIGDN_NORMALDISPLAY, &pszName);
					// Display the file name to the user.
					if (SUCCEEDED(hr))
					{
						CoTaskMemFree(pszFilePath);
					}
					pItem->Release();
				}
			}
			pFileOpen->Release();
		}
		CoUninitialize();
	}
	
	//Pull Width x Height from YUV file name.	File name format: Name_With_No_Numbers_WidthxHeight_etc.yuv
	char filePath[1000];
	wcstombs(filePath, pszFilePath, 1000);	//file path for fopen_s
	char fileName[1000];
	wcstombs(fileName, pszName, 1000);		//file name to pull Width and Height

	string s = fileName;
	
	std::string widthS = std::regex_replace(
		s,
		std::regex("[^0-9]*([0-9]+).*"),
		std::string("$1")
	);

	s = s.substr(s.find_first_of("0123456789") + 1);	//Remove everything before Width
	s = s.substr(s.find_first_of("x") + 1);				//Remove Width and x

	std::string heightS = std::regex_replace(
		s,
		std::regex("[^0-9]*([0-9]+).*"),
		std::string("$1")
	);

	//Open File through fopen_s, filepath found through File Explorer.
	fopen_s(&fp, filePath, "rb");

	if (fp == NULL)
	{
		printf("Error, Returned NULL fp.\n");
		return 2;
	}

	_fseeki64(fp, 0, SEEK_END);
	uint64_t size = _ftelli64(fp);

	//Width x Height from File Name
	int width = stoi(widthS);
	int height = stoi(heightS);

	uint64_t frameSize = (width * height * 1.5);
	uint64_t sizeOfY = width * height; //Size of Y layer, without U and V (YUV 4:2:0)

	int frames = size / frameSize;
	uint64_t calculatedSize = (width * height * 1.5) * frames;	//For Error Checking

	int frameNum = 0; //KEEP TRACK OF FRAME NUMBER

	if (size != calculatedSize)
	{
		fprintf(stderr, "Wrong size of yuv image : %d bytes, expected %d bytes\n", size, calculatedSize);
		fclose(fp);
		return 2;
	}

	cout << fileName << " " << width << "x" << height << ", Frames = " << frames << endl;
	cout << "=================================================================" << endl;

	//Y,U,V	(For Full Frame info, use frameSize. For only Y (Luma), use sizeOfY)
	unsigned char* fullFrameBuffer;
	fullFrameBuffer = new unsigned char[frameSize];

	_fseeki64(fp, frameSize * frameNum, SEEK_SET);
	int r = fread(fullFrameBuffer, 1, frameSize, fp);

	if (r < sizeOfY)
	{
		fclose(fp);
		return 2;

	}
	
	//Create Block Buffer
	int blockSize = 16; //blockSize x blockSize
	int numBlocks = sizeOfY / (blockSize * blockSize);
	int x = 0, y = 0;

	setFullFrame(fp, fullFrameBuffer, width, height, &frameNum, frames, 0);

	//OPENCL START
	//Var
	int err;                            // error code returned from api calls

	cl_platform_id platform;
	cl_device_id device;
	cl_context context;
	cl_command_queue queue;
	cl_program program;
	cl_kernel kernel;

	char* source = NULL;
	size_t src_size = 0;

	cl_event event;

	double* averages;
	averages = new double[numBlocks];

	//Platform/Device
	err = clGetPlatformIDs(1, &platform, NULL);
	if (err != CL_SUCCESS) {
		cout << "Error: Cant get platform id!";
		return 1;
	}

	err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
	if (err != CL_SUCCESS)
	{
		cout << "Error: Failed to create a device group!";
		return 1;
	}

	//Context/Command Queue
	context = clCreateContext(0, 1, &device, NULL, NULL, NULL);
	queue = clCreateCommandQueue(context, device, 0, NULL);

	//Read Source -> Program/Kernel
	err = ReadSourceFromFile("avgBlocks.cl", &source, &src_size); //Read .cl file
	
	if (!err)
	{
		program = clCreateProgramWithSource(context, 1, (const char**)&source, &src_size, &err);
		err = clBuildProgram(program, 1, &device, "", NULL, NULL);
		kernel = clCreateKernel(program, "avgFrame16", &err);
	}
	
	//Memory Buffers
	cl_mem clFrameBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, frameSize, fullFrameBuffer, &err);
	cl_mem clAvgBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, numBlocks * 8, averages, &err);
	
	//Kernel Arguements
	err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &clFrameBuffer);
	err = clSetKernelArg(kernel, 1, sizeof(cl_mem), &clAvgBuffer);
	err = clSetKernelArg(kernel, 2, sizeof(int), &width);
	err = clSetKernelArg(kernel, 3, sizeof(int), &blockSize);

	//Enqueue and wait
	size_t global[] = { numBlocks };
	size_t local[] = { 16 };		//Local Size can be finicky, if left out, OpenCL will choose an appropriate value on it's own, but this may decrease performance.

	auto t1 = high_resolution_clock::now();	//TIMER AROUND OPERATION ONLY
	err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, global, NULL, 0, NULL, &event);
	clFinish(queue);
	auto t2 = high_resolution_clock::now();

	//Read
	err = clEnqueueReadBuffer(queue, clAvgBuffer, CL_TRUE, 0, numBlocks * 8, averages, 0, NULL, &event);
	//numBlocks * 8, as before, only 1/8th of the averages were being written to the averages array. This fixed the error, but I am unsure why it works.

	//print
	for (int i = numBlocks - 10; i < numBlocks; i++)
	{
		cout << "Average for Block "<< i << " = " << averages[i] << "\n";
	}
	duration<double, std::milli> ms_double = t2 - t1;
	cout << "\nOPENCL RUNTIME (AVERAGES)\t\t= " << ms_double.count() << " ms\n\n";

	//NONPARALLEL FOR COMPARISON
	if (avgFrameNonPara)
	{
		vector<double> frameAverages(numBlocks, 0);

		t1 = high_resolution_clock::now();	//TIMER AROUND OPERATION ONLY
		frameAverages = averageBlocksFrame(fullFrameBuffer, width, height, blockSize);
		t2 = high_resolution_clock::now();

		for (int i = numBlocks - 10; i < numBlocks; i++)
		{
			cout << "Average for Block " << i << " = " << frameAverages[i] << "\n";
		}
		duration<double, std::milli> ms_double = t2 - t1;
		cout << "NON PARALLEL RUNTIME (AVERAGES)\t\t= " << ms_double.count() << " ms\n\n";
	}

	//OPENCL WRITE TO NEW YUV WITH AVG BLOCKS
	if (paraWriteAvg)
	{
		//Context and Program previously created
		//Kernel
		kernel = clCreateKernel(program, "avgFrameWrite16", &err);

		//Memory Buffers
		cl_mem clFullFrameBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, frameSize, fullFrameBuffer, &err);

		//Kernel Arguments
		err = clSetKernelArg(kernel, 1, sizeof(int), &width);
		err = clSetKernelArg(kernel, 2, sizeof(int), &blockSize);

		//Global/Local
		size_t globalWork[] = { numBlocks };
		size_t localWork[] = { 4 };

		//Loop
		FILE* avgOutputPara;
		fopen_s(&avgOutputPara, "../avgOutputPara.yuv", "wb");	//Make Name Dynamic Later

		if (avgOutputPara == NULL)
		{
			printf("Error, Returned NULL fp.\n");
			exit(2);
		}

		ms_double = chrono::milliseconds::zero();
		
		for (uint64_t f = 0; f < frames; f++)
		{
			_fseeki64(fp, frameSize * f, SEEK_SET);			//Seek current frame raw data
			fread(fullFrameBuffer, 1, frameSize, fp);	//read all Values

			clFullFrameBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, frameSize, fullFrameBuffer, &err);	//Update buffer
			clSetKernelArg(kernel, 0, sizeof(cl_mem), &clFullFrameBuffer);	//Send current frame to GPU

			t1 = high_resolution_clock::now();
			err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, globalWork, NULL, 0, NULL, &event);
			clFinish(queue); //Wait to finish
			t2 = high_resolution_clock::now();

			ms_double += (t2 - t1);	//Time calcuated only for actual Operation, no memory transfers nor write times. Similarly done with the Non-para function for comparison.

			if (err != CL_SUCCESS)
			{
				cout << "Error enqueuing back. " << err << endl;
				exit(2);
			}

			err = clEnqueueReadBuffer(queue, clFullFrameBuffer, CL_TRUE, 0, frameSize, fullFrameBuffer, 0, NULL, &event); //Read back to main memory

			if (err != CL_SUCCESS)
			{
				cout << "Error reading back.";
				exit(3);
			}

			fwrite(fullFrameBuffer, 1, frameSize, avgOutputPara);
			clReleaseMemObject(clFullFrameBuffer);
		}
		
		fclose(avgOutputPara);
		
		cout << "OPENCL RUNTIME (WRITE)\t\t\t= " << ms_double.count() << " ms\n\n";
	}

	//NONPARALLEL WRITE TO NEW YUV WITH AVG BLOCKS
	if (nonParaWriteAvg)
	{
		ms_double = writeAvgBlockYUV(fp, width, height, frames, blockSize);
		cout << "NON PARALLEL RUNTIME (WRITE)\t\t= " << ms_double.count() << " ms\n\n";
	}

	clReleaseEvent(event);
	clReleaseKernel(kernel);
	clReleaseCommandQueue(queue);
	clReleaseContext(context);
	clReleaseProgram(program);
	clReleaseMemObject(clFrameBuffer);
	clReleaseMemObject(clAvgBuffer);

	fclose(fp);

	std::string str;
	std::cout << "Press enter to end.";
	std::getline(std::cin, str);
}

//Block Number = (x / block size) + ((y / blockSize) * (width / blockSize));
//From block number
//X = Block Number * BlockSize % Width
//Y = (Integer Truncate)((Block Number / (Width / BlockSize)) * blockSize)

//TO CHECK VALUES IN VOOYA: OPEN UP YUV IN VOOYA, CHECK Y VALUES WITH MAGNIFIER (SCROLL WHEEL UP TO ACTIVATE)
//MAGNIFIER CONTROLS PER PIXEL:		W - UP		S - DOWN		Q - LEFT		E - RIGHT