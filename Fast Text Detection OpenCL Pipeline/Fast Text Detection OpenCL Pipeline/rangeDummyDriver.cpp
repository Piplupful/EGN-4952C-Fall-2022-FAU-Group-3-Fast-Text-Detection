//Block Number = (x / block size) + ((y / blockSize) * (width / blockSize));
//From block number to X and Y
//X = Block Number * BlockSize % Width
//Y = (Integer Truncate)((Block Number / (Width / BlockSize)) * blockSize)

//TO CHECK VALUES IN VOOYA: OPEN UP YUV IN VOOYA, CHECK Y VALUES WITH MAGNIFIER (SCROLL WHEEL UP TO ACTIVATE)
//MAGNIFIER CONTROLS PER PIXEL:		W - UP		S - DOWN		Q - LEFT		E - RIGHT

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cmath>
#include <iostream>
#include <sstream>
#include <string>
#include <tchar.h>
#include <memory.h>
#include <algorithm>

// For higher input capacity. Default of 32 only allows up to 4GB file size.
#define _FILE_OFFSET_BITS 64

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

// Include OpenCL library, and Intel SDK Utility Functions
#include "CL\cl.h"
#include "utils.h"

// For Performance Counters, Runtime Analysis
#include <Windows.h>
#include <chrono>
using std::chrono::high_resolution_clock;
using std::chrono::duration;
using std::chrono::milliseconds;

// File Explorer Functionality
#include "yuvFileOpenUtil.h"

using namespace std;

class OpenCL
{
public:
	OpenCL(string clFile)
	{
		int err;
		char* source = NULL;	//Used by util.cpp, from Intel OpenCL SDK. Stores .cl files for use in program and kernel creation.
		size_t src_size = 0;

		//Platform/Device Creation
		err = clGetPlatformIDs(1, &platform, NULL);
		if (err != CL_SUCCESS) {
			cerr << "Error: Cant get platform id.\n";
			exit(err);
		}

		err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL);	//CL_DEVICE_TYPE_GPU, picks first GPU device. CL_DEVICE_TYPE_CPU, picks processor.
		if (err != CL_SUCCESS)
		{
			cerr << "Error: Failed to create a device group.\n";
			exit(err);
		}

		//Context/Command Queue Creation
		context = clCreateContext(0, 1, &device, NULL, NULL, &err);
		if (err != CL_SUCCESS)
		{
			cerr << "Error: Failed to create context.\n";
			exit(err);
		}

		queue = clCreateCommandQueue(context, device, 0, &err);
		if (err != CL_SUCCESS)
		{
			cerr << "Error: Failed to create command queue.\n";
			exit(err);
		}

		//Read source file, create/build program with source flle
		err = ReadSourceFromFile(clFile.c_str(), &source, &src_size); //Read .cl file
		if (err != CL_SUCCESS)
		{
			cerr << "Error: Failed to read Source File.\n";
			exit(err);
		}

		program = clCreateProgramWithSource(context, 1, (const char**)&source, &src_size, &err);
		if (err != CL_SUCCESS)
		{
			cerr << "Error: Failed to create program from source file.\n";
			exit(err);
		}

		err = clBuildProgram(program, 1, &device, "", NULL, NULL);
		if (err != CL_SUCCESS)
		{
			cerr << "Error: Failed to build program.\n";
			exit(err);
		}

		event = NULL;
		kernel = NULL;
	}
	~OpenCL()
	{
		clReleaseEvent(event);
		clReleaseKernel(kernel);
		clReleaseCommandQueue(queue);
		clReleaseContext(context);
		clReleaseProgram(program);
	}

	cl_platform_id platform;
	cl_device_id device;
	cl_context context;
	cl_command_queue queue;
	cl_program program;
	cl_kernel kernel;
	cl_event event;
};

int rangeMain()
{
	FILE* fp = NULL;
	uint64_t width = 0;
	uint64_t height = 0;
	char fileName[2000];
	char filePath[2000];

	uint64_t blockSize = 16; //blockSize x blockSize

	//File Explorer Functionality, Easier YUV File Selection, Width/Height found by filename (YUV Standard)
	openYUVFile(fp, &width, &height, fileName, filePath);

	//Open File through fopen_s, filepath found through File Explorer.
	if (filePath != NULL)
		fopen_s(&fp, filePath, "rb");

	if (fp == NULL)
	{
		cout << "Error, Returned NULL fp.\n";
		return 2;
	}

	//YUV File Parameter Setup
	_fseeki64(fp, 0, SEEK_END);
	uint64_t size = _ftelli64(fp);	//Returns Byte Size of YUV input

	int frameNum = 0;

	uint64_t frameSize = (width * height * 1.5);
	uint64_t lumaSize = width * height; //Size of Y layer, without U and V (YUV 4:2:0)

	int frames = size / frameSize;
	uint64_t calculatedSize = (width * height * 1.5) * frames;	//For Error Checking

	if (size != calculatedSize)
	{
		cerr << "Wrong size of yuv read : " << (int)size << " bytes, expected " << (int)calculatedSize << " bytes\n";
		fclose(fp);
		exit(2);
	}

	const uint64_t numBlocks = lumaSize / (blockSize * blockSize);

	cout << fileName << " " << width << "x" << height << ", Frames = " << frames << endl;
	cout << "=================================================================" << endl;

	//Y,U,V	(For Full Frame info, use frameSize. For only Y (Luma), use lumaSize)
	unsigned char* fullFrameBuffer;
	fullFrameBuffer = new unsigned char[frameSize];

	_fseeki64(fp, frameSize * frameNum, SEEK_SET);
	int r = fread(fullFrameBuffer, 1, frameSize, fp);

	if (r < lumaSize)
	{
		cerr << "Read wrong frame size, error in reading YUV properly.";
		fclose(fp);
		exit(2);
	}

	//OPENCL START
	int err;	// error code returned from api calls
	auto startTime = high_resolution_clock::now();

	auto kernelStartTime = high_resolution_clock::now();	//Runtime of Kernel (Enqueue, and queue finish)
	auto kernelEndTime = high_resolution_clock::now();
	duration<double, std::milli> finalKernelRuntime = chrono::milliseconds::zero();

	int thresh = 70;	//Between 1 and 255

	bool* threshOut;
	threshOut = new bool[numBlocks];
	fill_n(threshOut, numBlocks, 0);

	OpenCL ocl("rangeDummy.cl");

	//INSERT VALID FUNCTION FROM VALID OPENCL FILE, STRING IN 2ND PARAMETER = FUNCTION NAME
	ocl.kernel = clCreateKernel(ocl.program, "rangeThresh", &err);

	if (err != CL_SUCCESS)
	{
		cerr << "Error: Failed to create kernel.\n";
		fclose(fp);
		exit(err);
	}

	//Memory Buffers
	cl_mem clFrameBuffer = clCreateBuffer(ocl.context, CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR, frameSize, fullFrameBuffer, &err);	//CL_MEM_READ_WRITE, if writing back frame data.
		//Include more cl_mem buffers before if necessary
		//	Example: cl_mem clAvgBuffer = clCreateBuffer(ocl.context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, numBlocks * 8, averages, &err);
	cl_mem clThreshBuffer = clCreateBuffer(ocl.context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, numBlocks, threshOut, &err);

	//Kernel Arguements
	err = clSetKernelArg(ocl.kernel, 0, sizeof(cl_mem), &clFrameBuffer);
	//Include more Kernel Arguements if necessary. Must include all memory buffers created previously. Single variables (Such as Width), can be directly accessed
	//	Example: err = clSetKernelArg(kernel, 2, sizeof(int), &width);
	err = clSetKernelArg(ocl.kernel, 1, sizeof(cl_mem), &clThreshBuffer);
	err = clSetKernelArg(ocl.kernel, 2, sizeof(int), &width);
	err = clSetKernelArg(ocl.kernel, 3, sizeof(int), &thresh);

//Enqueue and wait
	size_t global[] = { numBlocks };	//For 1 Dimensionality, global[] = { Total Number of Blocks }.
										//For 2 Dimensionaltiy, globalWork[] = { width / blockSize, height / blockSize};, make sure to change 3rd parameter in clEnqueueNDRangeKernel() to 2.

	size_t local[] = { NULL };			//Local Size can be finicky, if left out, OpenCL will choose an appropriate value on it's own, but this may decrease performance.
		//CL_DEVICE_MAX_WORK_GROUP_SIZE can be used to return maximum local work group size that your device may handle, but depending on the input, this may cause errors.

	auto opStartTime = high_resolution_clock::now();		//Runtime of entire operation (kernel runtime + memory transfers, etc)

	for (int f = 0; f < frames; f++)
	{
		fill_n(threshOut, numBlocks, 0);

		_fseeki64(fp, frameSize* f, SEEK_SET);			//Seek current frame raw data
		fread(fullFrameBuffer, 1, frameSize, fp);	//read all Values

		clFrameBuffer = clCreateBuffer(ocl.context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, frameSize, fullFrameBuffer, &err);	//Update buffer
		clSetKernelArg(ocl.kernel, 0, sizeof(cl_mem), &clFrameBuffer);	//Send current frame to GPU

		kernelStartTime = high_resolution_clock::now();
		clEnqueueNDRangeKernel(ocl.queue, ocl.kernel, 1, NULL, global, NULL, 0, NULL, &ocl.event);
		clFinish(ocl.queue);
		kernelEndTime = high_resolution_clock::now();

		finalKernelRuntime += (kernelEndTime - kernelStartTime);			//Runtime of only kernel function activity.

		clEnqueueReadBuffer(ocl.queue, clThreshBuffer, CL_TRUE, 0, numBlocks, threshOut, 0, NULL, &ocl.event);
		clFinish(ocl.queue);

		FILE* outputFile;
		string outputFilePath = "../OUTPUT/" + to_string(f) + ".txt";

		fopen_s(&outputFile, outputFilePath.c_str(), "w+");

		if (outputFile != NULL)
		{
			for (int i = 0; i < numBlocks; i++)
			{
				fwrite(threshOut[i] ? "1" : "0", sizeof(char), 1, outputFile);
			}

			fclose(outputFile);
		}
	}

	auto opEndTime = high_resolution_clock::now();

	clReleaseMemObject(clFrameBuffer);
	clReleaseMemObject(clThreshBuffer);

	fclose(fp);

	//Runtime Print outs
	auto endTime = high_resolution_clock::now();
	duration<double, std::milli> finalRuntime = endTime - startTime;			//Total Runtime, from start of OpenCL section, after opening file and pre-openCL setup.
	duration<double, std::milli> finalOpRuntime = opEndTime - opStartTime;		//Runtime of loop, of operation, including memory transfers.

	cout << "Total number of frames\t\t=\t" << frames << "\n";
	cout << "Final Kernel Runtime\t\t=\t" << finalKernelRuntime.count() << "\n";
	cout << "Average runtime per frame\t=\t" << finalKernelRuntime.count() / frames << "\n";
	cout << "Final Operation Runtime\t\t=\t" << finalOpRuntime.count() << "\n";
	cout << "Final Total Runtime\t\t=\t" << finalRuntime.count() << "\n";

	return 0;
}