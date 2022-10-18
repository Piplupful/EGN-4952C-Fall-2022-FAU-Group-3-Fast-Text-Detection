#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cmath>
#include <vector>
#include <iostream>
#include <fstream>
#include <sstream>
#include "SimpleYUV.h"

using namespace std;

//blocksize, array with macroblock, size of corner quadrant, x,y position of macroblock
double avgQuadrantBlock(int blocksize, unsigned char* blockData, int q_size, int x, int y)
{
	double sum = 0;
	int xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
	int ylimit = y + q_size;
	for (int i = x; i < xlimit; i++)
	{
		for (int j = y; j < ylimit; j++)
		{
			//cout << blockData[i * blocksize + j] << " ";
			sum += blockData[i * blocksize + j];    // add each luma value to sum
		}
	}
	return sum / (q_size * q_size);
}

// The main function that calls its specific average quadrant function above
						// block size, array of macroblock, frame buffer, width, height of frame
int basicCharOutput(int blocksize, unsigned char* blockData, int width, int height)
{

	if (blocksize < 4 || ((log(blocksize) / log(2)) != int(log(blocksize) / log(2))))  // make sure number of blocks is power of 2
	{
		cout << "Error, given block size is not compatible with function" << endl;
		return -1;
	}
	else
	{
		// Variable that will hold averages
		float q1Avg, q2Avg, q3Avg, q4Avg, qcenter = 0;
		// Makes sure that the size of the quadrant is duable
		int q_size = 6;
		// cout << q_size << endl;
		q1Avg = avgQuadrantBlock(blocksize, blockData, q_size, 0, 0);   // quadrant 1 is left top corner so start at 0,0 of macroblock
		q2Avg = avgQuadrantBlock(blocksize, blockData, q_size, 0, blocksize - q_size);  // quadrant 2 is right top corner so if a 8x8 macroblock then from (5-7, 0-2)
		q3Avg = avgQuadrantBlock(blocksize, blockData, q_size, blocksize - q_size, 0);  // quadrant 3 is left bottom corner so if a 8x8 macroblock then from (0-2, 5-7)
		q4Avg = avgQuadrantBlock(blocksize, blockData, q_size, blocksize - q_size, blocksize - q_size); // quadrant 4 is the right bottom corner so if a 8x8 macroblock then from (5-7, 5-7)
		qcenter = avgQuadrantBlock(blocksize, blockData, 2, blocksize / 2 - 1, blocksize / 2 - 1); // This retrieves the average of the center in a 2x2 quadrant 
		//cout << q1Avg << " " << q2Avg << " " << q3Avg << " " << q4Avg << " " << qcenter << endl;
		// possible best solution is 30 difference in luma
		if (abs(q1Avg - q2Avg) < 30 && abs(q1Avg - q3Avg) < 30 && abs(q1Avg - 4) && abs(q2Avg - q3Avg) < 30 && abs(q2Avg - q4Avg) < 30 && abs(q3Avg - q4Avg) < 30)
		{
			double qAvg = (q1Avg + q2Avg + q3Avg + q4Avg) / 4;  // average of all quadrants except center
			//cout << qAvg << endl;
			if (abs(qAvg - qcenter) > 8)    // compare to center quadrant 
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return 0;
		}
	}
}

void stats(unsigned char* frameData, int blockSize, int width, int height, int frameNum, char fileName[2000])	//LARGE PRINT OUT, IN ORDER OF TOP LEFT GOING RIGHT IN CHUNKS OF BLOCKSIZE
{
	unsigned char* blockData;	//Self contained blockData
	blockData = new unsigned char[pow(2, blockSize)];

	int x = 0; int y = 0;
	std::ofstream myfile;
	string name = "../DATA OUT/"; // change based on video
	string fileNameS = fileName;
	fileNameS = fileNameS.substr(0, fileNameS.find_last_of('.'));
	name += fileNameS;
	string str1 = to_string(frameNum);
	name += "_";
	name.append(str1);
	name += ".csv";
	myfile.open(name, std::ios::app);
	if (myfile.is_open())
	{
		myfile << "X,Y,AVGQUADRANT_MACRO_VALUE,AVG_MACRO_VALUE,RANGE_MACRO_VALUE,MAX_MACRO_VALUE,MIN_MACRO_VALUE" << "\n";
	}
	else
	{
		cout << "Could not open";
	}

	for (y = 0; y < height; y = y + blockSize)
	{
		if (y < height - 8)
		{
			for (x = 0; x < width; x = x + blockSize)
			{
				getBlock(frameData, blockData, blockSize, x, y, width);
				double curAvg = averageYValOfBlock(blockData, blockSize);
				int minY = minYBlock(blockData, blockSize);
				int maxY = maxYBlock(blockData, blockSize);
				int range = rangeInBlock(blockData, blockSize);
				int avgQ = basicCharOutput(blockSize, blockData, width, height);
				//printf("X = %d, Y = %d, AvgQ = %d Avg = %f, Range = %d, Max = %d, Min = %d\n", x, y, avgQ, curAvg, range, maxY, minY);
				myfile << x << ", " << y << ", " << avgQ << ", " << curAvg << ", " << range << ", " << maxY << ", " << minY << "\n";
			}
		}
	}
	myfile.close();
}

int datasetCreate(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000])
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

	if (size != calculatedSize)
	{
		fprintf(stderr, "Wrong size of yuv image : %d bytes, expected %d bytes\n", size, (int)calculatedSize);
		fclose(fp);
		return 2;
	}

	int num[] = { 0, 124, 270, 410, 755, 920, 1026, 1283, 1429, 1785, 1987, 2350, 2800, 3000, 3345 }; //Change based on Frames

	for (int i = 0; i < 15; i++)
	{
		int x = num[i];
		_fseeki64(fp, frameSize * x, SEEK_SET);
		int r = fread(frameBuffer, 1, (uint64_t)width * (uint64_t)height, fp);
		if (r < width * height)
		{
			printf("Error reading into buffer, r = %d, size of Y = %d\n", r, (int)lumaSize);
			fclose(fp);
			return 2;

		}
		
		int blockSize = 16;
		unsigned char* blockData;
		blockData = new unsigned char[pow(2, blockSize)];
		stats(frameBuffer, blockSize, width, height, x, fileName);
	}

	fclose(fp);
}
