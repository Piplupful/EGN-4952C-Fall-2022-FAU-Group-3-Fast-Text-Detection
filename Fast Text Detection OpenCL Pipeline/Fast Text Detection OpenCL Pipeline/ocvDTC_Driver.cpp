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

// OpenCV
#include <opencv2/core.hpp>
#include <opencv2/ml/ml.hpp>

// For Performance Counters, Runtime Analysis
#include <Windows.h>
#include <chrono>
using std::chrono::high_resolution_clock;
using std::chrono::duration;
using std::chrono::milliseconds;

#include "ocl.h"

using namespace std;

int openCV_DTC_Driver(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000])
{
	FILE* fp;

	uint64_t blockSize = 16; //blockSize x blockSize

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
	unsigned char* frameBuffer;
	frameBuffer = new unsigned char[frameSize];

	_fseeki64(fp, frameSize * frameNum, SEEK_SET);
	int r = fread(frameBuffer, 1, frameSize, fp);

	if (r < frameSize)
	{
		cerr << "Read wrong frame size, error in reading YUV properly.";
		fclose(fp);
		exit(2);
	}

	//OPENCV LOAD
	cv::Ptr<cv::ml::RTrees> dtree = cv::ml::RTrees::load("../dtree.xml");
	if (dtree->empty())
		cout << "ERROR LOADING DTREE" << endl;
	else
		cout << "LOAD SUCCESS" << endl;

	//OPENCL START
	int err;	// error code returned from api calls
	auto startTime = high_resolution_clock::now();

	auto kernelStartTime = high_resolution_clock::now();	//Runtime of Kernel (Enqueue, and queue finish)
	auto kernelEndTime = high_resolution_clock::now();
	duration<double, std::milli> finalKernelRuntime = chrono::milliseconds::zero();

	bool* binMap;
	binMap = new bool[numBlocks];
	fill_n(binMap, numBlocks, 0);

	OpenCL ocl("dtc.cl");

	//INSERT VALID FUNCTION FROM VALID OPENCL FILE, STRING IN 2ND PARAMETER = FUNCTION NAME
	ocl.kernel = clCreateKernel(ocl.program, "dtcTextDetect", &err);

	if (err != CL_SUCCESS)
	{
		cerr << "Error: Failed to create kernel.\n";
		fclose(fp);
		exit(err);
	}

	//Memory Buffers
	cl_mem clFrameBuffer = clCreateBuffer(ocl.context, CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR, lumaSize, frameBuffer, &err);	//CL_MEM_READ_WRITE, if writing back frame data.
		//Include more cl_mem buffers before if necessary
		//	Example: cl_mem clAvgBuffer = clCreateBuffer(ocl.context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, numBlocks * 8, averages, &err);
	cl_mem clbinMap = clCreateBuffer(ocl.context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, numBlocks, binMap, &err);

	//Kernel Arguements
	err = clSetKernelArg(ocl.kernel, 0, sizeof(cl_mem), &clFrameBuffer);
	//Include more Kernel Arguements if necessary. Must include all memory buffers created previously. Single variables (Such as Width), can be directly accessed
	//	Example: err = clSetKernelArg(kernel, 2, sizeof(int), &width);
	err = clSetKernelArg(ocl.kernel, 1, sizeof(cl_mem), &clbinMap);

	err = clSetKernelArg(ocl.kernel, 2, sizeof(int), &width);

	//Enqueue and wait
	//Round in order to handle resolutions not easily divisible by blocksize.
	size_t global[] = { round((double)width / blockSize), round((double)height / blockSize) };	//For 1 Dimensionality, global[] = { Total Number of Blocks }.
										//For 2 Dimensionaltiy, globalWork[] = { width / blockSize, height / blockSize};, make sure to change 3rd parameter in clEnqueueNDRangeKernel() to 2.

	size_t local[] = { 4, 4 };			//Local Size can be finicky, if left out, OpenCL will choose an appropriate value on it's own, but this may decrease performance.
		//CL_DEVICE_MAX_WORK_GROUP_SIZE can be used to return maximum local work group size that your device may handle, but depending on the input, this may cause errors.

	FILE* dtcOutput;
	string dtcOutputFilePath = "../DTC OUTPUT/";
	dtcOutputFilePath += fileName;
	dtcOutputFilePath = dtcOutputFilePath.substr(0, dtcOutputFilePath.find_last_of('.'));
	dtcOutputFilePath += "_dtcOutput.yuv";
	fopen_s(&dtcOutput, dtcOutputFilePath.c_str(), "wb");

	auto opStartTime = high_resolution_clock::now();		//Runtime of entire operation (kernel runtime + memory transfers, etc)

	for (int f = 0; f < frames; f++)
	{
		fill_n(binMap, numBlocks, 0);

		_fseeki64(fp, frameSize * f, SEEK_SET);			//Seek current frame raw data
		fread(frameBuffer, 1, frameSize, fp);	//read all Values

		clFrameBuffer = clCreateBuffer(ocl.context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, lumaSize, frameBuffer, &err);	//Update buffers
		clSetKernelArg(ocl.kernel, 0, sizeof(cl_mem), &clFrameBuffer);	//Send current frame to GPU
		clbinMap = clCreateBuffer(ocl.context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, numBlocks, binMap, &err);	//Reset cl Buffer, otherwise output bleeds together
		clSetKernelArg(ocl.kernel, 1, sizeof(cl_mem), &clbinMap);

		kernelStartTime = high_resolution_clock::now();
		err = clEnqueueNDRangeKernel(ocl.queue, ocl.kernel, 2, NULL, global, local, 0, NULL, &ocl.event);

		if (err != CL_SUCCESS)
		{
			cerr << "Error: Failed to enqueue kernel.\n";
			fclose(fp);
			exit(err);
		}

		clFinish(ocl.queue);
		kernelEndTime = high_resolution_clock::now();

		finalKernelRuntime += (kernelEndTime - kernelStartTime);			//Runtime of only kernel function activity.

		clEnqueueReadBuffer(ocl.queue, clbinMap, CL_TRUE, 0, numBlocks, binMap, 0, NULL, &ocl.event);

		clFinish(ocl.queue);

		//Binary Map Output, as .txt for now
		FILE* outputFile;
		string outputFilePath = "../OUTPUT/" + to_string(f) + ".txt";

		fopen_s(&outputFile, outputFilePath.c_str(), "w+");

		if (outputFile != NULL)
		{
			for (int i = 0; i < numBlocks; i++)
			{
				fwrite(binMap[i] ? "1" : "0", sizeof(char), 1, outputFile);
			}

			fclose(outputFile);
		}

		//Chroma Manip
		for (int b = 0; b < (lumaSize / (64 * 64) + 4); b++)
		{
			int x = b * 64 % width;
			int stepY = (int)(b / (width / 64));
			int y = stepY * 64;	// For better integer truncation (large numbers)

			int blockNum = (x / 16) + ((y / 16) * (width / 16));

			bool trueFlag = 0;

			if (y != 1024)
			{
				for (int i = 0; i < 4; i++)
				{
					if ((binMap[blockNum + i * 120] == 1) || (binMap[blockNum + i * 120 + 1] == 1)
						|| (binMap[blockNum + i * 120 + 2] == 1) || (binMap[blockNum + i * 120 + 3] == 1))	//Check 4 consequitive 16x16 blocks
					{
						trueFlag = 1;
						break;
					}
				}
			}
			else
			{
				for (int i = 0; i < 3; i++)
				{
					if ((binMap[blockNum + i * 120] == 1) || (binMap[blockNum + i * 120 + 1] == 1)
						|| (binMap[blockNum + i * 120 + 2] == 1) || (binMap[blockNum + i * 120 + 3] == 1))
					{
						trueFlag = 1;
						break;
					}
				}
			}

			if (trueFlag)
			{
				if (y != 1024)
				{
					for (int j = 0; j < 64; j++)
					{
						for (int i = 0; i < 64; i++)
						{
							int m = x + i;
							int n = y + j;

							frameBuffer[(n / 2) * (width / 2) + (m / 2) + lumaSize] = 53;
							frameBuffer[(n / 2) * (width / 2) + (m / 2) + lumaSize + (lumaSize / 4)] = 34;
						}
					}
				}
				else
				{
					for (int j = 0; j < 56; j++)
					{
						for (int i = 0; i < 64; i++)
						{
							int m = x + i;
							int n = y + j;

							frameBuffer[(n / 2) * (width / 2) + (m / 2) + lumaSize] = 53;
							frameBuffer[(n / 2) * (width / 2) + (m / 2) + lumaSize + (lumaSize / 4)] = 34;
						}
					}
				}
			}
			else
			{
				if (y != 1024)
				{
					for (int j = 0; j < 64; j++)
					{
						for (int i = 0; i < 64; i++)
						{
							int m = x + i;
							int n = y + j;

							frameBuffer[(n / 2) * (width / 2) + (m / 2) + lumaSize] = 128;
							frameBuffer[(n / 2) * (width / 2) + (m / 2) + lumaSize + (lumaSize / 4)] = 128;
						}
					}
				}
				else
				{
					for (int j = 0; j < 56; j++)
					{
						for (int i = 0; i < 64; i++)
						{
							int m = x + i;
							int n = y + j;

							frameBuffer[(n / 2) * (width / 2) + (m / 2) + lumaSize] = 128;
							frameBuffer[(n / 2) * (width / 2) + (m / 2) + lumaSize + (lumaSize / 4)] = 128;
						}
					}
				}
			}
			
		}

		//YUV Output
		fwrite(frameBuffer, 1, frameSize, dtcOutput);
		clReleaseMemObject(clFrameBuffer);
	}

	auto opEndTime = high_resolution_clock::now();

	clReleaseMemObject(clFrameBuffer);

	if (dtcOutput != NULL)
		fclose(dtcOutput);

	//Runtime Print outs
	auto endTime = high_resolution_clock::now();
	duration<double, std::milli> finalRuntime = endTime - startTime;			//Total Runtime, from start of OpenCL section, after opening file and pre-openCL setup.
	duration<double, std::milli> finalOpRuntime = opEndTime - opStartTime;		//Runtime of loop, of operation, including memory transfers.

	FILE* runtimeStat;
	string csvFileName(fileName);
	csvFileName = csvFileName.substr(0, csvFileName.find_last_of('.'));
	csvFileName += "_DTC";	//2D Work Group Size Signifier
	string csvFilePath = "../RUNTIME/" + csvFileName + ".csv";

	string csvOut = "\n" + to_string(frames) + "," + to_string(finalKernelRuntime.count())
		+ "," + to_string(finalKernelRuntime.count() / frames) + "," + to_string(finalOpRuntime.count()) + "," + to_string(finalRuntime.count());

	fopen_s(&runtimeStat, csvFilePath.c_str(), "a");	//Mode "a" just adds onto existing file. No overwriting completely.

	if (runtimeStat != NULL)
	{
		_fseeki64(runtimeStat, 0, SEEK_END);
		int csvSize = ftell(runtimeStat);
		if (csvSize == 0)
		{
			string colName = "Frames,Kernel Runtime,Avg per Frame,Operation,Total";
			fwrite(colName.c_str(), 1, colName.size(), runtimeStat);
		}

		fwrite(csvOut.c_str(), 1, csvOut.size(), runtimeStat);
		fclose(runtimeStat);
	}

	cout << "Total number of frames\t\t=\t" << frames << "\n";
	cout << "Final Kernel Runtime\t\t=\t" << finalKernelRuntime.count() << "\n";
	cout << "Average runtime per frame\t=\t" << finalKernelRuntime.count() / frames << "\n";
	cout << "Final Operation Runtime\t\t=\t" << finalOpRuntime.count() << "\n";
	cout << "Final Total Runtime\t\t=\t" << finalRuntime.count() << "\n";

	cout << "\n";

	return 0;
}