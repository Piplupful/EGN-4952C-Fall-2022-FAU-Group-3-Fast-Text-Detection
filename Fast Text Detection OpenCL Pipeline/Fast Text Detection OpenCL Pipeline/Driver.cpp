#include "textDetect.h"
#include <iostream>
#include <string>

// File Explorer Functionality
#include "yuvFileOpenUtil.h"
#include "ocv.h"
using namespace std;

//SYS ARG FORMAT: Input Folder Path, Input File Name (with .yuv), Output File Path, Number of time to run Text Detection Driver
int main(int argc, char* argv[])
{
	uint64_t width = 0;
	uint64_t height = 0;

	string inputFilePath;
	string yuvFileName;
	string outputFilePath;

	int numRuns;

	if (argc >= 5)
	{
		cout << "USING PROVIDED VALUES" << endl;
		inputFilePath = argv[1];
		yuvFileName = argv[2];
		outputFilePath = argv[3];
		numRuns = atoi(argv[4]);
		//Example Command Line Input: D:\xiph\50_Frame\ STARCRAFT_1920x1080p60_50Frame.yuv ../OUTPUT/ 5
		//							Input File Path		YUV Input File Name		Output File Path	Number of Runs
	}
	else //Default values.
	{
		cout << "USING DEFAULT VALUES" << endl;
		inputFilePath = "../../";
		yuvFileName = "GTAV_1920x1080p60_50Frame.yuv";
		outputFilePath = "../OUTPUT/";
		numRuns = 1;
	}

	//Open YUV File
	FILE* fp = openYUVFile(&width, &height, inputFilePath, yuvFileName);

	if (fp == NULL)
	{
		cout << "FILE POINTER NULL" << endl;
		exit(1);
	}

	//Initialize OpenCL Object, with .cl File Name, Kernel Function name, and Width of YUV Frame.
	OpenCL ocl("model.cl", "kernelTemplateDebug", width);
	//Width, for the purposes of this project, is set as Kernel Parameter 1.
	//Within the Text Detection Driver, Parameter 0 is the frame buffer, and Parameter 2 is the binary map used for our output.

	//Loop for multiple runs. Text detection driver function.
	for (int i = 0; i < numRuns; i++)
		textDetectDriver(&fp, ocl, yuvFileName, width, height, outputFilePath);

	return 0;
}