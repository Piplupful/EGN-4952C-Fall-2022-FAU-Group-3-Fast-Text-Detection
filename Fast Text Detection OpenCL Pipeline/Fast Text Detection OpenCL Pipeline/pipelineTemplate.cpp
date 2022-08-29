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

int templateMain()
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
	if(filePath != NULL)
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
		cout << "Wrong size of yuv read : " << (int)size << " bytes, expected " << (int)calculatedSize << " bytes\n";
		fclose(fp);
		exit(2);
	}

	cout << fileName << " " << width << "x" << height << ", Frames = " << frames << endl;
	cout << "=================================================================" << endl;

	//Y,U,V	(For Full Frame info, use frameSize. For only Y (Luma), use lumaSize)
	unsigned char* fullFrameBuffer;
	fullFrameBuffer = new unsigned char[frameSize];

	_fseeki64(fp, frameSize * frameNum, SEEK_SET);
	int r = fread(fullFrameBuffer, 1, frameSize, fp);

	if (r < lumaSize)
	{
		fclose(fp);
		exit(2);

	}

	//Create Block Buffer
	int numBlocks = lumaSize / (blockSize * blockSize);
	int x = 0, y = 0;

	//OPENCL START
	int err;	// error code returned from api calls
	cl_event event;

	cl_platform_id platform;
	cl_device_id device;
	cl_context context;
	cl_command_queue queue;
	cl_program program;
	cl_kernel kernel;

	char* source = NULL;	//Used by util.cpp, from Intel OpenCL SDK. Stores .cl files for use in program and kernel creation.
	size_t src_size = 0;

	//Platform/Device Creation
	err = clGetPlatformIDs(1, &platform, NULL);
	if (err != CL_SUCCESS) {
		cout << "Error: Cant get platform id!";
		fclose(fp);
		exit(1);
	}

	err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &device, NULL);
	if (err != CL_SUCCESS)
	{
		cout << "Error: Failed to create a device group!";
		fclose(fp);
		exit(1);
	}

	//IDEA: OpenCL object creation parameter can be just valid openCL file. Constructor will handle boilerplate. Developer should pick out
	// Kernel function by accessing OpenCL object's kernel variable.

	//Context/Command Queue Creation
	context = clCreateContext(0, 1, &device, NULL, NULL, NULL);
	queue = clCreateCommandQueue(context, device, 0, NULL);

	//Read Source -> Program/Kernel, from utils.cpp, provided by Intel OpenCL SDK
	//INSERT VALID .CL FILE NAME IN FIRST PARAMETER
	err = ReadSourceFromFile("VALID OPENCL FILE NAME.cl", &source, &src_size); //Read .cl file			//Can be abstracted out

	if (!err)
	{
		program = clCreateProgramWithSource(context, 1, (const char**)&source, &src_size, &err);		//Can be abstracted out
		err = clBuildProgram(program, 1, &device, "", NULL, NULL);
		//INSERT VALID FUNCTION FROM VALID OPENCL FILE, STRING IN 2ND PARAMETER = FUNCTION NAME
		kernel = clCreateKernel(program, "INSERT VALID OPENCL KERNEL FUNCTION NAME HERE", &err);		//Cannot be abstracted out !!!
	}
	else
	{
		cout << "Error reading Source from .cl file.\n";
		fclose(fp);
		exit(2);
	}

	//Memory Buffers
	cl_mem clFrameBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, frameSize, fullFrameBuffer, &err);
		//Include more cl_mem buffers before if necessary/

	//Kernel Arguements
	err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &clFrameBuffer);
		//Include more Kernel Arguements if necessary. Must include all memory buffers created previously. Single variables (Such as Width), can be directly accessed
		//									Example: err = clSetKernelArg(kernel, 2, sizeof(int), &width);

	//Enqueue and wait
	size_t global[] = { numBlocks };	//For 1 Dimensionality, global[] = { Total Number of Blocks }.
										//For 2 Dimensionaltiy, globalWork[] = { height / blockSize, width / blockSize };, make sure to change 3rd parameter in clEnqueueNDRangeKernel() to 2.

	size_t local[] = { 16 };			//Local Size can be finicky, if left out, OpenCL will choose an appropriate value on it's own, but this may decrease performance.

	auto t1 = high_resolution_clock::now();	//TIMER AROUND OPERATION ONLY
	err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, global, NULL, 0, NULL, &event);
	clFinish(queue);
	auto t2 = high_resolution_clock::now();
	duration<double, std::milli> ms_double = t2 - t1;

	//Read back to main memory (For output and checking)
	//Example: err = clEnqueueReadBuffer(queue, clAvgBuffer, CL_TRUE, 0, numBlocks * 8, averages, 0, NULL, &event);


	clReleaseEvent(event);		//Deconstructor for OpenCL Object
	clReleaseKernel(kernel);
	clReleaseCommandQueue(queue);
	clReleaseContext(context);
	clReleaseProgram(program);
	clReleaseMemObject(clFrameBuffer);
	//RELEASE ANY OTHER CL_MEM OBJECTS BELOW
	//EXAMPLE:	clReleaseMemObject(clAvgBuffer);

	

	//OpenCL Template from Intel OpenCL SDK automatically shuts down debug CMD window on completion, even if set to not do so in Debug Settings. This fixes that issue to allow for
	//	post-debug run analysis.
	std::string holdOutput;
	std::cout << "Press enter to end.";
	std::getline(std::cin, holdOutput);

	fclose(fp);

	return 0;
}

//Block Number = (x / block size) + ((y / blockSize) * (width / blockSize));
//From block number
//X = Block Number * BlockSize % Width
//Y = (Integer Truncate)((Block Number / (Width / BlockSize)) * blockSize)

//TO CHECK VALUES IN VOOYA: OPEN UP YUV IN VOOYA, CHECK Y VALUES WITH MAGNIFIER (SCROLL WHEEL UP TO ACTIVATE)
//MAGNIFIER CONTROLS PER PIXEL:		W - UP		S - DOWN		Q - LEFT		E - RIGHT

//OpenCL Example, using for loop for output (From avgDriver):
/*
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
*/