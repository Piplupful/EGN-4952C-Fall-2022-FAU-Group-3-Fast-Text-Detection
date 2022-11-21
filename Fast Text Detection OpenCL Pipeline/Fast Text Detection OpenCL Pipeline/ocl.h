#pragma once
#include <string>
#include "CL\cl.h"
#include "utils.h"
#include <iostream>
using namespace std;

class OpenCL
{
public:
	OpenCL(string clFile, string funcName, int width);
	void deviceInfoPrint();

	cl_platform_id platform;
	cl_device_id device;
	cl_context context;
	cl_command_queue queue;
	cl_program program;
	cl_kernel kernel;
	cl_event event;
};