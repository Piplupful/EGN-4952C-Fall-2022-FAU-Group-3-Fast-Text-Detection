//ffmpeg -i input.y4m -pix_fmt yuv420p output.yuv
//To convert .y4m from XIPH DERF into useable .yuv (4:2:0) video.

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

// OpenCV
#include "opencv2/opencv.hpp"
#include "opencv2/opencv_modules.hpp"
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp> 
#include <opencv2/imgproc/imgproc.hpp>

// For Performance Counters, Runtime Analysis
#include <Windows.h>
#include <chrono>
using std::chrono::high_resolution_clock;
using std::chrono::duration;
using std::chrono::milliseconds;

#include "ocl.h"

using namespace std;
using namespace cv;

int simpleThreshWrite(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], bool print)	//Print = 1, to see first frame of YUV output.
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

	cv::Mat img = cv::Mat(height + height / 2, width, CV_8UC1, frameBuffer, Mat::AUTO_STEP);
	//cv::Mat img = cv::Mat(blockSize, blockSize, CV_8UC1, blockData, Mat::AUTO_STEP);

	Mat BGR(cv::Size(width, height), CV_8UC1);
	Mat greyImg;
	Mat thrImg;

	cv::cvtColor(img, BGR, cv::COLOR_YUV2BGR_I420);
	cv::cvtColor(BGR, greyImg, cv::COLOR_BGR2GRAY);

	threshold(greyImg, thrImg, 127, 255, THRESH_BINARY);

	if (print)
	{
		namedWindow("127-255 Binary Threshold", WINDOW_NORMAL);
		resizeWindow("127-255 Binary Threshold", 1280, 720);
		imshow("127-255 Binary Threshold", thrImg);

		cv::waitKey(0);
		cv::destroyAllWindows();
	}

	FILE* threshOut;
	string threshOutFilePath = "../THRESH OUT/";
	threshOutFilePath += fileName;
	threshOutFilePath = threshOutFilePath.substr(0, threshOutFilePath.find_last_of('.'));
	threshOutFilePath += "ThreshOut.yuv";
	fopen_s(&threshOut, threshOutFilePath.c_str(), "wb");

	for (int f = 0; f < frames; f++)
	{
		_fseeki64(fp, frameSize * f, SEEK_SET);			//Seek current frame raw data
		fread(frameBuffer, 1, frameSize, fp);	//read all Values

		img = cv::Mat(height + height / 2, width, CV_8UC1, frameBuffer, Mat::AUTO_STEP);

		cv::cvtColor(img, BGR, cv::COLOR_YUV2BGR_I420);
		cv::cvtColor(BGR, greyImg, cv::COLOR_BGR2GRAY);

		threshold(greyImg, thrImg, 127, 255, THRESH_BINARY);
		cv::cvtColor(thrImg, thrImg, cv::COLOR_GRAY2BGR);
		cv::cvtColor(thrImg, img, cv::COLOR_BGR2YUV_I420);

		if(threshOut != NULL)
			fwrite(img.data, 1, frameSize, threshOut);
	}

	if (threshOut != NULL)
		fclose(threshOut);

	return 0;
}