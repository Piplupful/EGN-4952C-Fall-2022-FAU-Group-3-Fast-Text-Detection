#include "textDetect.h"
#include <iostream>
#include <string>

// File Explorer Functionality
#include "yuvFileOpenUtil.h"
#include "ocv.h"
using namespace std;

int main()
{
	uint64_t width = 0;
	uint64_t height = 0;
	char fileName[2000];
	char filePath[2000];

	string binaryOutputFilePath = "../OUTPUT/";
	string visualOutputFilePath = "../DTC OUTPUT/";

	//Open YUV File
	openYUVFile_Win(&width, &height, fileName, filePath);

	//Initialize OpenCL Object, with .cl File Name, Kernel Function name, and Width of YUV Frame.

	//Loop for multiple runs. Text detection driver function.
	for (int i = 0; i < 1; i++)
		textDetectDriver(width, height, fileName, filePath);

	return 0;
}