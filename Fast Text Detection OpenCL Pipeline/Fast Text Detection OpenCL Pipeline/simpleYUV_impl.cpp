#pragma once
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cmath>
#include <iostream>
#include <vector>
#include <chrono>;
using std::chrono::high_resolution_clock;
using std::chrono::duration;
using std::chrono::milliseconds;

#define _FILE_OFFSET_BITS 64

using namespace std;

void printBlock(unsigned char* blockData, int blockSize)
{
	for (int i = 0; i < blockSize; i++)						//i is equivalent to Y
	{
		for (int j = 0; j < blockSize; j++)					//j is equivalent to X
		{
			printf("%4d", blockData[i * blockSize + j]);	//i * blockSize = height of block, + j shifts right
		}
		printf("\n");
	}
}

//get 8x8 block based on X and Y coordinate (start from top left of frame)
void getBlock(unsigned char* frameData, unsigned char* blockData, int blockSize, int x, int y, int width)
{
	int offset = y * width + x;		//2d offset, from initial (0,0) -> (x,y)

	for (int j = 0; j < blockSize; j++)			//over every x value
	{
		for (int i = 0; i < blockSize; i++)		//over every y value
		{
			blockData[i * blockSize + j] = (frameData + offset)[i * width + j];	//save into corresponding block position
		}
	}
}
//Ideas: Cache (framedata + offset)?

//Same as function above, but i and j swapped within for loops to see if ordering matters, seemingly does not
void getBlockInverse(unsigned char* frameData, unsigned char* blockData, int blockSize, int x, int y, int width)
{
	int offset = y * width + x;		//2d offset, from initial (0,0) -> (x,y)

	for (int i = 0; i < blockSize; i++)			//over every y value
	{
		for (int j = 0; j < blockSize; j++)		//over every x value
		{
			blockData[i * blockSize + j] = (frameData + offset)[i * width + j];	//save into corresponding block position
		}
	}
}

void printCurFrame(unsigned char* frameData, int blockSize, int width, int height)	//LARGE PRINT OUT, IN ORDER OF TOP LEFT GOING RIGHT IN CHUNKS OF BLOCKSIZE
{
	unsigned char* blockData;	//Self contained blockData
	blockData = new unsigned char[pow(2, blockSize)];

	int x = 0; int y = 0;

	for (y = 0; y < height; y = y + blockSize)
	{
		for (x = 0; x < width; x = x + blockSize)
		{
			getBlock(frameData, blockData, blockSize, x, y, width);
			printBlock(blockData, blockSize);
		}
	}
}

//FULL = full YUV (U and V included (W * H * 1.5)
//NOT FULL = only Luma Y (size of Y = W * H)
void incrementFrame(FILE* fp, unsigned char* frameBuffer, uint64_t width, uint64_t height, int* frameNum, int totalFrames)
{
	*frameNum = *frameNum + 1;

	if (*frameNum >= totalFrames)	//Error check, if go over maximum total frames
	{
		*frameNum = *frameNum - 1;
		printf("TRIED TO EXCEED TOTAL VIDEO FRAMES, INCREMENT FAILED\n");
		return;
	}

	uint64_t frameSize = (width * height * 1.5);
	_fseeki64(fp, frameSize * (uint64_t)*frameNum, SEEK_SET);
	fread(frameBuffer, 1, (uint64_t)width * (uint64_t)height, fp);
}

void incrementFullFrame(FILE* fp, unsigned char* frameBuffer, int width, int height, int* frameNum, int totalFrames)
{
	*frameNum = *frameNum + 1;

	if (*frameNum >= totalFrames)	//Error check, if go over maximum total frames
	{
		*frameNum = *frameNum - 1;
		printf("TRIED TO EXCEED TOTAL VIDEO FRAMES, INCREMENT FAILED\n");
		return;
	}

	uint64_t frameSize = (width * height * 1.5);
	_fseeki64(fp, frameSize * (uint64_t)*frameNum, SEEK_SET);
	fread(frameBuffer, 1, frameSize, fp);
}

void setFrame(FILE* fp, unsigned char* frameBuffer, uint64_t width, uint64_t height, int* frameNum, int totalFrames, int SET)
{
	*frameNum = SET;

	if (*frameNum >= totalFrames)	//Error check, if SET is above totalFrames
	{
		*frameNum = totalFrames - 1;
		printf("TRIED TO EXCEED TOTAL VIDEO FRAMES, INCREMENT FAILED\n");
		return;
	}

	uint64_t frameSize = (width * height * 1.5);
	_fseeki64(fp, frameSize * (uint64_t)*frameNum, SEEK_SET);
	fread(frameBuffer, 1, (uint64_t)width * (uint64_t)height, fp);
}

void setFullFrame(FILE* fp, unsigned char* frameBuffer, int width, int height, int* frameNum, int totalFrames, int SET)
{
	*frameNum = SET;

	if (*frameNum >= totalFrames)	//Error check, if SET is above totalFrames
	{
		*frameNum = totalFrames - 1;
		printf("TRIED TO EXCEED TOTAL VIDEO FRAMES, INCREMENT FAILED\n");
		return;
	}

	int frameSize = (width * height * 1.5);
	_fseeki64(fp, frameSize * (uint64_t)*frameNum, SEEK_SET);
	fread(frameBuffer, 1, frameSize, fp);
}

double averageYValOfBlock(unsigned char* blockData, int blockSize)
{
	double sum = 0;
	int valCount = blockSize * blockSize;

	for (int i = 0; i < valCount; i++)
	{
		sum += blockData[i];
	}
	return sum / valCount;
}

void grayScaleConverter(FILE* fp, uint64_t width, uint64_t height, int totalFrames)
{
	FILE* gray;
	errno_t error = fopen_s(&gray, "../GrayOut.yuv", "wb");	//Make Name Dynamic Later

	if (fp == NULL)
	{
		printf("Error, Returned NULL fp.\n");
		exit(2);
	}

	uint64_t frameSize = (width * height * 1.5);
	int sizeOfY = width * height; //Size of Y later, without U and V (YUV 4:2:0)

	unsigned char* frameBuffer;
	frameBuffer = new unsigned char[sizeOfY];

	for (int i = 0; i < totalFrames; i++)
	{
		_fseeki64(fp, frameSize * (uint64_t)i, SEEK_SET);		//Seek current frame raw data
		fread(frameBuffer, 1, sizeOfY, fp);		//read ONLY Y VALUES
		fwrite(frameBuffer, 1, sizeOfY, gray);	//write ONLY Y VALUES to new file
	}
}

//Create Copy (Useless, but basis for below functions)
void copyYUV(FILE* fp, uint64_t width, uint64_t height, int totalFrames)
{
	FILE* copy = NULL;
	errno_t error = fopen_s(&copy, "../copy.yuv", "wb");	//Make Name Dynamic Later

	if (fp == NULL)
	{
		printf("Error, Returned NULL fp.\n");
		exit(2);
	}

	uint64_t frameSize = (width * height * 1.5);
	int sizeOfY = width * height; //Size of Y, without U and V (YUV 4:2:0)

	unsigned char* frameBuffer;
	frameBuffer = new unsigned char[frameSize];

	for (int i = 0; i < totalFrames; i++)
	{
		_fseeki64(fp, frameSize * (uint64_t)i, SEEK_SET);		//Seek current frame raw data
		fread(frameBuffer, 1, frameSize, fp);		//read ONLY Y VALUES
		if (copy != NULL)
			fwrite(frameBuffer, 1, frameSize, copy);	//write ONLY Y VALUES to new file
	}
}

//Write to a new YUV file, that increases Luma Y by N for each Y in frame
void saturateUpByN(FILE* fp, int width, int height, int totalFrames, int N)
{
	if (N > 255)
	{
		printf("Error, N > 255.\n");
		exit(2);
	}

	FILE* satByN;
	errno_t error = fopen_s(&satByN, "../saturateUp.yuv", "wb");	//Make Name Dynamic Later

	if (fp == NULL)
	{
		printf("Error, Returned NULL fp.\n");
		exit(2);
	}

	uint64_t frameSize = (width * height * 1.5);
	int sizeOfY = width * height; //Size of Y, without U and V (YUV 4:2:0)

	unsigned char* frameBuffer;
	frameBuffer = new unsigned char[frameSize];

	for (uint64_t i = 0; i < totalFrames; i++)
	{
		_fseeki64(fp, frameSize * i, SEEK_SET);		//Seek current frame raw data
		fread(frameBuffer, 1, frameSize, fp);		//read all Values

		for (int j = 0; j < sizeOfY; j++)
		{
			if (frameBuffer[j] + N > 255)
			{
				frameBuffer[j] = 255;
			}
			else
			{
				frameBuffer[j] += N;
			}
		}

		fwrite(frameBuffer, 1, frameSize, satByN);	//write ONLY Y VALUES to new file
	}
}
//To parallelize these two functions below, use SYCL Reductions.
int minYBlock(unsigned char* blockData, int blockSize)
{
	int min = blockData[0];
	int valCount = blockSize * blockSize;

	for (int i = 1; i < valCount; i++)
	{
		if (blockData[i] < min)
			min = blockData[i];
	}
	return min;
}

int maxYBlock(unsigned char* blockData, int blockSize)
{
	int max = blockData[0];
	int valCount = blockSize * blockSize;

	for (int i = 1; i < valCount; i++)
	{
		if (blockData[i] > max)
			max = blockData[i];
	}
	return max;
}

int rangeInBlock(unsigned char* blockData, int blockSize)	//To make into parallel, multiple reduction can be done.
{
	return maxYBlock(blockData, blockSize) - minYBlock(blockData, blockSize);
}

vector<bool> rangeMapFrame(unsigned char* frameBuffer, int width, int height, int blockSize, int* frameNum, int threshold)
{
	int x = 0; int y = 0; int i = 0;
	unsigned char* blockData;
	blockData = new unsigned char[pow(2, blockSize)];

	int numBlocks = width * height / (blockSize * blockSize);	//Number of blocks is the size of only Y in the frame, divided by the dimensions of 1 block
	vector<bool> map(numBlocks, 0);

	for (y = 0; y < height; y = y + blockSize)
	{
		for (x = 0; x < width; x = x + blockSize)
		{
			getBlock(frameBuffer, blockData, blockSize, x, y, width);
			//printBlock(blockData, blockSize);
			int range = rangeInBlock(blockData, blockSize);

			if (range > threshold)
			{
				map[i] = true;
			}

			i++;
		}
	}

	return map;
}

std::vector<double> averageBlocksFrame(unsigned char* frameBuffer, int width, int height, uint64_t blockSize)
{
	int x, y;
	int numBlocks = (width * height) / (blockSize * blockSize);
	std::vector<double> frameAverages(numBlocks, 0);
	unsigned char* blockData;
	blockData = new unsigned char[blockSize * blockSize];

	for (int i = 0; i < numBlocks; i++)
	{
		x = i * blockSize % width;
		y = (int)((i / (width / blockSize)) * blockSize);

		getBlock(frameBuffer, blockData, blockSize, x, y, width);
		frameAverages[i] = averageYValOfBlock(blockData, blockSize);
	}

	return frameAverages;
}

void getBlockFromNum(unsigned char* frameData, unsigned char* blockData, int blockSize, int blockNum, int width)
{
	int x = blockNum * blockSize % width;
	int y = (int)((blockNum / (width / blockSize)) * blockSize);

	getBlock(frameData, blockData, blockSize, x, y, width);
}

duration<double, std::milli> writeAvgBlockYUV(FILE* fp, uint64_t width, uint64_t height, int totalFrames, uint64_t blockSize)
{
	FILE* avgOutput;
	errno_t error = fopen_s(&avgOutput, "../avgOutput.yuv", "wb");	//Make Name Dynamic Later

	if (avgOutput == NULL)
	{
		printf("Error, Returned NULL fp.\n");
		exit(2);
	}

	uint64_t frameSize = (width * height * 1.5);
	uint64_t sizeOfY = width * height; //Size of Y, without U and V (YUV 4:2:0)
	uint64_t numBlocks = sizeOfY / (blockSize * blockSize);	//Number of Y Blocks

	unsigned char* frameBuffer;
	frameBuffer = new unsigned char[frameSize];

	int x, y;

	auto t1 = high_resolution_clock::now();
	auto t2 = high_resolution_clock::now();
	duration<double, std::milli> ms_double = chrono::milliseconds::zero();

	for (uint64_t f = 0; f < totalFrames; f++)
	{
		_fseeki64(fp, frameSize * f, SEEK_SET);		//Seek current frame raw data
		fread(frameBuffer, 1, frameSize, fp);		//read all Values

		t1 = high_resolution_clock::now();
		for (int b = 0; b < numBlocks; b++)
		{
			x = b * blockSize % width;
			y = (int)((b / (width / blockSize)) * blockSize);

			int sum = 0;

			int offset = y * width + x;

			for (int j = 0; j < blockSize; j++)			//over every x value
			{
				for (int i = 0; i < blockSize; i++)		//over every y value
				{
					sum += frameBuffer[offset + (i * width + j)]; //(frameBuf + offset)[i * width + j];	//save into corresponding block position
				}
			}

			int avg = sum / (blockSize * blockSize);

			for (int j = 0; j < blockSize; j++)			//over every x value
			{
				for (int i = 0; i < blockSize; i++)		//over every y value
				{
					frameBuffer[offset + (i * width + j)] = avg;
				}
			}
		}
		t2 = high_resolution_clock::now();

		ms_double += (t2 - t1);

		fwrite(frameBuffer, 1, frameSize, avgOutput);	//write ONLY Y VALUES to new file
	}

	fclose(avgOutput);

	return ms_double;
}

int avgRowDif(unsigned char* blockData, int width, int height)
{
	int difSum = 0;
	for (int i = 0; i < height - 1; i++)
	{
		for (int j = 0; j < width; j++)
		{
			int val = blockData[i * width + j] - blockData[((i + 1) * width) + j];
			difSum += abs(val);
		}
	}
	return difSum / (width * (height - 1));
}

int avgColDif(unsigned char* blockData, int width, int height)
{
	int difSum = 0;

	for (int i = 0; i < height; i++)
	{
		for (int j = 0; j < width - 1; j++)
		{
			int val = blockData[i * width + j] - blockData[i * width + (j + 1)];
			difSum += abs(val);
		}
	}
	return difSum / ((width - 1) * height);
}