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

// For Performance Counters, Runtime Analysis
#include <Windows.h>
#include <chrono>
using std::chrono::high_resolution_clock;
using std::chrono::duration;
using std::chrono::milliseconds;

using namespace std;

int frameExtract(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000])
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
	frameBuffer = new unsigned char[frameSize];	//FOR AVERAGE WRITE, DO FULL FRAME TO KEEP U AND V

	_fseeki64(fp, frameSize * frameNum, SEEK_SET);
	int r = fread(frameBuffer, 1, frameSize, fp);

	if (r < frameSize)
	{
		cerr << "Read wrong frame size, error in reading YUV properly.";
		fclose(fp);
		exit(2);
	}

	FILE* output;
	string outputFilePath = "../FRAME OUTPUT/";
	outputFilePath += fileName;
	outputFilePath = outputFilePath.substr(0, outputFilePath.find_last_of('.'));
	
	for (int f = 0; f < frames; f++)
	{
		string curOut = outputFilePath + "_";
		curOut += to_string(f);
		curOut += ".yuv";

		fopen_s(&output, curOut.c_str(), "wb");
		_fseeki64(fp, frameSize * f, SEEK_SET);			//Seek current frame raw data
		fread(frameBuffer, 1, frameSize, fp);	//read all Values

		if (output != NULL)
		{
			fwrite(frameBuffer, 1, frameSize, output);
			fclose(output);
		}
	}

	return 0;
}