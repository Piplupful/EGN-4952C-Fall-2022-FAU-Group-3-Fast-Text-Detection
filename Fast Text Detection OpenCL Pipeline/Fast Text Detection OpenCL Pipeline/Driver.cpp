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

	string inputFilePath;
	string yuvFileName;
	string outputFilePath;

	int numRuns;

	//TEMPORARY UNTIL ARGV IMPLEMENTED
	inputFilePath = "D:/xiph/50 Frame YUVs/";
	yuvFileName = "GTAV_1920x1080p60_50Frame.yuv";
	outputFilePath = "../OUTPUT/";
	numRuns = 20;
	//TEMP

	//Open YUV File
	FILE* fp = openYUVFile(&width, &height, inputFilePath, yuvFileName);

	if (fp == NULL)
	{
		cout << "FILE POINTER NULL" << endl;
		exit(1);
	}

	//Initialize OpenCL Object, with .cl File Name, Kernel Function name, and Width of YUV Frame.
	OpenCL ocl("model.cl", "kernelTemplateDebug", width);

	//Loop for multiple runs. Text detection driver function.
	for (int i = 0; i < numRuns; i++)
		textDetectDriver(&fp, ocl, yuvFileName, width, height, outputFilePath);

	return 0;
}