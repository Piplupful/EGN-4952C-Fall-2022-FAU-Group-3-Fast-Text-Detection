#pragma once
#include "ocl.h"
#include "CL/cl.h"
#include <iostream>

using namespace std;

OpenCL::OpenCL(string clFile, string funcName, int width)
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

	kernel = clCreateKernel(program, funcName.c_str(), &err);
	if (err != CL_SUCCESS)
	{
		cerr << "Error: Failed to create kernel from .cl file.\n";
		exit(err);
	}

	err = clSetKernelArg(kernel, 1, sizeof(int), &width);
	if (err != CL_SUCCESS)
	{
		cerr << "Error: Failed to set kernel arg.\n";
		exit(err);
	}

	event = NULL;
}

void OpenCL::deviceInfoPrint()
{
	char name[1000];
	char vendor[1000];
	char deviceVer[1000];
	char driverVer[1000];
	cl_platform_id platID;

	int prefChar;
	int prefShort;
	int prefInt;
	int prefLong;
	int prefFloat;
	int prefDouble;

	clGetDeviceInfo(device, CL_DEVICE_NAME, sizeof(name), name, NULL);
	clGetDeviceInfo(device, CL_DEVICE_PLATFORM, sizeof(platID), &platID, NULL);
	clGetDeviceInfo(device, CL_DEVICE_VENDOR, sizeof(vendor), vendor, NULL);
	clGetDeviceInfo(device, CL_DEVICE_VERSION, sizeof(deviceVer), deviceVer, NULL);
	clGetDeviceInfo(device, CL_DRIVER_VERSION, sizeof(driverVer), driverVer, NULL);

	clGetDeviceInfo(device, CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR, sizeof(cl_uint), &prefChar, NULL);
	clGetDeviceInfo(device, CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT, sizeof(cl_uint), &prefShort, NULL);
	clGetDeviceInfo(device, CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT, sizeof(cl_uint), &prefInt, NULL);
	clGetDeviceInfo(device, CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG, sizeof(cl_uint), &prefLong, NULL);
	clGetDeviceInfo(device, CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT, sizeof(cl_uint), &prefFloat, NULL);
	clGetDeviceInfo(device, CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE, sizeof(cl_uint), &prefDouble, NULL);

	cout << name << " ; " << vendor << " Device Version: " << deviceVer << ", Driver Version: " << driverVer << endl;
	cout << "Platform ID: " << platID << endl;
	cout << "PREFERRED VECTOR WIDTHS\n==================" << endl;
	cout << "Char = " << prefChar << endl;
	cout << "Short = " << prefShort << endl;
	cout << "Int = " << prefInt << endl;
	cout << "Long = " << prefLong << endl;
	cout << "Float = " << prefFloat << endl;
	cout << "Double = " << prefDouble << endl;
}