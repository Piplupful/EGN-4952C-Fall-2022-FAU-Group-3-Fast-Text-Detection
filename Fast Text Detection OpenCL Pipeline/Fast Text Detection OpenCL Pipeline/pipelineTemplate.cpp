//Block Number = (x / block size) + ((y / blockSize) * (width / blockSize));
//From block number to X and Y
//X = Block Number * BlockSize % Width
//Y = (Integer Truncate)((Block Number / (Width / BlockSize)) * blockSize)

//TO CHECK VALUES IN VOOYA: OPEN UP YUV IN VOOYA, CHECK Y VALUES WITH MAGNIFIER (SCROLL WHEEL UP TO ACTIVATE)
//MAGNIFIER CONTROLS PER PIXEL:		W - UP		S - DOWN		Q - LEFT		E - RIGHT

//THIS IS MEANT TO BE A TEMPLATE FOR TESTING TEXT DETECTION METHODS. FOR A GOOD EXAMPLE WITH A DUMMY FUNCTION, CHECK rangeDummyDriver.cpp.

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

#include "ocl.h"

int templateMain()
{
	FILE* fp = NULL;
	uint64_t width = 0;
	uint64_t height = 0;
	char fileName[2000];
	char filePath[2000];

	uint64_t blockSize = 16; //blockSize x blockSize

	//File Explorer Functionality, Easier YUV File Selection, Width/Height found by filename (YUV Standard)
	openYUVFile(&width, &height, fileName, filePath);

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
		cerr << "Wrong size of yuv read : " << (int)size << " bytes, expected " << (int)calculatedSize << " bytes\n";
		fclose(fp);
		exit(2);
	}

	uint64_t numBlocks = lumaSize / (blockSize * blockSize);

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

	OpenCL ocl("VALID_OPENCL_FILE.cl");
	
	//INSERT VALID FUNCTION FROM VALID OPENCL FILE, STRING IN 2ND PARAMETER = FUNCTION NAME
	ocl.kernel = clCreateKernel(ocl.program, "VALID OPENCL KERNEL FUNCTION", &err);

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


	//Kernel Arguements
	err = clSetKernelArg(ocl.kernel, 0, sizeof(cl_mem), &clFrameBuffer);
		//Include more Kernel Arguements if necessary. Must include all memory buffers created previously. Single variables (Such as Width), can be directly accessed
		//	Example: err = clSetKernelArg(kernel, 2, sizeof(int), &width);


	//Enqueue and wait
	size_t global[] = { numBlocks };	//For 1 Dimensionality, global[] = { Total Number of Blocks }.
										//For 2 Dimensionaltiy, globalWork[] = { width / blockSize, height / blockSize};, make sure to change 3rd parameter in clEnqueueNDRangeKernel() to 2.

	size_t local[] = { 16 };			//Local Size can be finicky, if left out, OpenCL will choose an appropriate value on it's own, but this may decrease performance.
		//CL_DEVICE_MAX_WORK_GROUP_SIZE can be used to return maximum local work group size that your device may handle, but depending on the input, this may cause errors.

	//Enqueue Loop Example in comments at bottom of code. Refer to that or avgDriver.cpp.
	auto enqueueTime1 = high_resolution_clock::now();	//TIMER AROUND OPERATION ONLY, this times OpenCL runtime, not that of memory transfering.

	err = clEnqueueNDRangeKernel(ocl.queue, ocl.kernel, 1, NULL, global, NULL, 0, NULL, &ocl.event);
	clFinish(ocl.queue);

	auto enqueueTime2 = high_resolution_clock::now();
	duration<double, std::milli> ms_double = enqueueTime2 - enqueueTime1;

	//Read back to main memory (For output and checking)
	//	Example: err = clEnqueueReadBuffer(queue, clAvgBuffer, CL_TRUE, 0, numBlocks * 8, averages, 0, NULL, &event);


	clReleaseMemObject(clFrameBuffer);
	//RELEASE ANY OTHER CL_MEM OBJECTS BELOW
	//	Example:	clReleaseMemObject(clAvgBuffer);

	fclose(fp);

	auto finalTime = high_resolution_clock::now();
	duration<double, std::milli> finalRuntime = startTime - finalTime;
	cout << "\nFinal Total Runtime = " << finalRuntime.count() << "\n";

	//RUNTIME CSV FILE PRINT OUT TEMPLATE
	//This is an example for automatic runtime statistic printouts into a .csv file. Useful for analysis.
	FILE* runtimeStat;
	string csvFileName(fileName);
	csvFileName = csvFileName.substr(0, csvFileName.find_last_of('.'));
	string csvFilePath = "../RUNTIMETEMPLATE/" + csvFileName + ".csv";

	string csvOut = "\n" + to_string(frames) + "," + to_string(finalRuntime.count());	//ADD MORE COLUMN VALUES IF NECESSARY

	fopen_s(&runtimeStat, csvFilePath.c_str(), "a");	//Mode "a" just adds onto existing file. No overwriting completely.

	if (runtimeStat != NULL)
	{
		_fseeki64(runtimeStat, 0, SEEK_END);
		int csvSize = ftell(runtimeStat);
		if (csvSize == 0)
		{
			string colName = "Frames,Total";	//ADD MORE COLUMN NAMES IF NECESSARY
			cout << colName.size();
			fwrite(colName.c_str(), 1, colName.size(), runtimeStat);
		}

		fwrite(csvOut.c_str(), 1, csvOut.size(), runtimeStat);
		fclose(runtimeStat);
	}

	return 0;
}

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