//USE THIS AS REFERENCE FOR FUTURE DEVELOPMENT
//HOW TO SETUP OPENCL ENVIROMENT
//HOW TO WORK WITH YUV 4:2:0

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cmath>
#include <iostream>
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

using namespace std;
#include <chrono>;
using std::chrono::high_resolution_clock;
using std::chrono::duration;
using std::chrono::milliseconds;

#include "SimpleYUV.h"

#define _FILE_OFFSET_BITS 64

//VIDEO CONTROLS 1 = CREW, 2 = DUCK, 3 = FACTORY, 4 = GTAV
int vid = 1;

//FUNCTION CONTROLS
bool avgFrameNonPara = 1;	//TURN OFF OR ON AVERAGE FRAME NON PARALLEL (FOR COMPARISON)

bool paraWriteAvg = 1;
bool nonParaWriteAvg = 1;	//TURN OFF OR ON AVERAGE PER BLOCK PER FRAME WRITE TO NEW YUV (FOR COMPARISON)

int main()	//MAKE INTO A PROPER FUNCTION LATER
{
	FILE* fp;	//Idea: create initializeYUVParameters function later to handle start up
	//Make Dynamic Later if needed.

	int width = 0;
	int height = 0;
	int frames = 0;
	errno_t error;

	if (vid == 1)
	{
		error = fopen_s(&fp, "../CREW_704x576_30_orig_01.yuv", "rb");
		
		width = 704;
		height = 576;
		frames = 300;

		cout << "CREW VIDEO " << width << "x" << height << ", Frames = " << frames << "\n==========================================\n";
	}
	/*	From Old Code
	else if (vid == 2)
	{
		error = fopen_s(&fp, "../duck_take_off_1280x720_50.yuv", "rb");
		width = 1280;
		height = 720;
		frames = 500;

		cout << "DUCK VIDEO " << width << "x" << height << ", Frames = " << frames << "\n==========================================\n";
	}
	else if (vid == 3)
	{
		error = fopen_s(&fp, "../factory_1920x1080p30.yuv", "rb");
		width = 1920;
		height = 1080;
		frames = 1339;

		cout << "FACTORY VIDEO " << width << "x" << height << ", Frames = " << frames << "\n==========================================\n";
	}
	else if (vid == 4)
	{
		error = fopen_s(&fp, "../GTAV_1920x1080p60.yuv", "rb");
		width = 1920;
		height = 1080;
		frames = 3602;

		cout << "GTAV VIDEO " << width << "x" << height << ", Frames = " << frames << "\n==========================================\n";
	*/
	else if (width == 0)
	{
		exit(2);
	}

	if (fp == NULL)
	{
		printf("Error, Returned NULL fp.\n");
		return 2;
	}

	_fseeki64(fp, 0, SEEK_END);

	uint64_t size = _ftelli64(fp);
	uint64_t calculatedSize = (width * height * 1.5) * frames;

	uint64_t frameSize = (width * height * 1.5);
	uint64_t sizeOfY = width * height; //Size of Y later, without U and V (YUV 4:2:0)

	int frameNum = 0; //KEEP TRACK OF FRAME NUMBER

	if (size != calculatedSize)
	{
		fprintf(stderr, "Wrong size of yuv image : %d bytes, expected %d bytes\n", size, calculatedSize);
		fclose(fp);
		return 2;
	}

	//PUT FRAME INTO BUFFER, READ INTO MAIN MEMORY
	//Only LUMA (Y)
	unsigned char* frameBuffer;
	frameBuffer = new unsigned char[sizeOfY];

	_fseeki64(fp, frameSize * frameNum, SEEK_SET);
	int r = fread(frameBuffer, 1, sizeOfY, fp);

	//Y,U,V
	unsigned char* fullFrameBuffer;
	fullFrameBuffer = new unsigned char[frameSize];

	_fseeki64(fp, frameSize * frameNum, SEEK_SET);
	fread(fullFrameBuffer, 1, frameSize, fp);

	if (r < sizeOfY)
	{
		fclose(fp);
		return 2;

	}
	
	int blockSize = 8; //blockSize x blockSize
	int x = 0, y = 0;
	unsigned char* blockData;
	blockData = new unsigned char[blockSize * blockSize]; //2^8 = 256

	//TO CHECK VALUES IN VOOYA: OPEN UP YUV IN VOOYA, CHECK Y VALUES WITH MAGNIFIER (SCROLL WHEEL UP TO ACTIVATE)
	//MAGNIFIER CONTROLS PER PIXEL:		W - UP		S - DOWN		Q - LEFT		E - RIGHT

	x, y = 0;
	setFrame(fp, frameBuffer, width, height, &frameNum, frames, 0);
	int numBlocks = sizeOfY / (blockSize * blockSize);

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
		kernel = clCreateKernel(program, "avgFrame", &err);
	}
	
	//Memory Buffers
	cl_mem clFrameBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, sizeOfY, frameBuffer, &err);
	cl_mem clAvgBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, numBlocks, averages, &err);
	
	//Kernel Arguements
	err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &clFrameBuffer);
	err = clSetKernelArg(kernel, 1, sizeof(cl_mem), &clAvgBuffer);
	err = clSetKernelArg(kernel, 2, sizeof(int), &width);
	err = clSetKernelArg(kernel, 3, sizeof(int), &blockSize);

	//Enqueue and wait
	size_t global[] = { numBlocks };
	size_t local[] = { 16 };

	auto t1 = high_resolution_clock::now();	//TIMER AROUND OPERATION ONLY
	err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, global, local, 0, NULL, &event);
	clFinish(queue);
	auto t2 = high_resolution_clock::now();

	//Read
	err = clEnqueueReadBuffer(queue, clAvgBuffer, CL_TRUE, 0, numBlocks, averages, 0, NULL, &event);

	//print
	for (int i = 0; i < 10; i++)
	{
		//cout << "Average for Block "<< i << " = " << averages[i] << "\n";
	}
	duration<double, std::milli> ms_double = t2 - t1;
	cout << "\nOPENCL RUNTIME (AVERAGES)\t\t= " << ms_double.count() << " ms\n\n";

	//NONPARALLEL FOR COMPARISON
	if (avgFrameNonPara)
	{
		std::vector<double> frameAverages(numBlocks, 0);

		t1 = high_resolution_clock::now();	//TIMER AROUND OPERATION ONLY
		frameAverages = averageBlocksFrame(frameBuffer, width, height, blockSize);
		t2 = high_resolution_clock::now();

		for (int i = 0; i < 10; i++)
		{
			//std::cout << "Average for Block " << i << " = " << frameAverages[i] << "\n";
		}
		duration<double, std::milli> ms_double = t2 - t1;
		cout << "NON PARALLEL RUNTIME (AVERAGES)\t\t= " << ms_double.count() << " ms\n\n";
	}

	//OPENCL WRITE TO NEW YUV WITH AVG BLOCKS
	if (paraWriteAvg)
	{
		//Context and Program previously created
		//Kernel
		kernel = clCreateKernel(program, "avgFrameWrite", &err);

		//Memory Buffers
		cl_mem clFullFrameBuffer = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_USE_HOST_PTR, frameSize, fullFrameBuffer, &err);

		//Kernel Arguments
		err = clSetKernelArg(kernel, 1, sizeof(int), &width);
		err = clSetKernelArg(kernel, 2, sizeof(int), &blockSize);

		//Global/Local
		size_t globalWork[] = { numBlocks };
		size_t localWork[] = { 16 };

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
			err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, globalWork, localWork, 0, NULL, &event);
			clFinish(queue); //Wait to finish
			t2 = high_resolution_clock::now();

			ms_double += (t2 - t1);	//Time calcuated only for actual Operation, no memory transfers nor write times. Similarly done with the Non-para function for comparison.

			if (err != CL_SUCCESS)
			{
				cout << "Error enqueuing back.";
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

/*
//FULL FRAME TEST
printf("X = %d, Y = %d, Frame = %d\n", x, y, frameNum);
getBlock(fullFrameBuffer, blockData, blockSize, x, y, width);
printBlock(blockData, blockSize);
printf("\n");

incrementFullFrame(fp, fullFrameBuffer, width, height, &frameNum, frames);

printf("X = %d, Y = %d, Frame = %d\n", x, y, frameNum);
getBlock(fullFrameBuffer, blockData, blockSize, x, y, width);
printBlock(blockData, blockSize);
printf("\n");

setFullFrame(fp, fullFrameBuffer, width, height, &frameNum, frames, 3);

printf("X = %d, Y = %d, Frame = %d\n", x, y, frameNum);
getBlock(fullFrameBuffer, blockData, blockSize, x, y, width);
printBlock(blockData, blockSize);
printf("\n");
*/