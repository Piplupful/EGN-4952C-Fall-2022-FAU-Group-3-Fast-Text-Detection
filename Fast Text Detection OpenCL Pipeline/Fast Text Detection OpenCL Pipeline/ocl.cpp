#pragma once
#include "ocl.h"

OpenCL::OpenCL(string clFile)
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

OpenCL::~OpenCL()
{
	clReleaseEvent(event);
	clReleaseKernel(kernel);
	clReleaseCommandQueue(queue);
	clReleaseProgram(program);
	clReleaseContext(context);
}