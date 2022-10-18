#pragma once
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cmath>
#include <iostream>
#include <vector>
#include <ratio>
#include <__msvc_chrono.hpp>

using std::chrono::high_resolution_clock;
using std::chrono::duration;
using std::chrono::milliseconds;

#define _FILE_OFFSET_BITS 64

void printBlock(unsigned char* blockData, int blockSize);


//get 8x8 block based on X and Y coordinate (start from top left of frame)
void getBlock(unsigned char* frameData, unsigned char* blockData, int blockSize, int x, int y, int width);

//Same as function above, but i and j swapped within for loops to see if ordering matters, seemingly does not
void getBlockInverse(unsigned char* frameData, unsigned char* blockData, int blockSize, int x, int y, int width);

void printCurFrame(unsigned char* frameData, int blockSize, int width, int height);	//LARGE PRINT OUT, IN ORDER OF TOP LEFT GOING RIGHT IN CHUNKS OF BLOCKSIZE

//FULL = full YUV (U and V included (W * H * 1.5)
//NOT FULL = only Luma Y (size of Y = W * H)
void incrementFrame(FILE* fp, unsigned char* frameBuffer, uint64_t width, uint64_t height, int* frameNum, int totalFrames);

void incrementFullFrame(FILE* fp, unsigned char* frameBuffer, int width, int height, int* frameNum, int totalFrames);

void setFrame(FILE* fp, unsigned char* frameBuffer, uint64_t width, uint64_t height, int* frameNum, int totalFrames, int SET);

void setFullFrame(FILE* fp, unsigned char* frameBuffer, int width, int height, int* frameNum, int totalFrames, int SET);

double averageYValOfBlock(unsigned char* blockData, int blockSize);

void grayScaleConverter(FILE* fp, uint64_t width, uint64_t height, int totalFrames);

//Create Copy (Useless, but basis for below functions)
void copyYUV(FILE* fp, uint64_t width, uint64_t height, int totalFrames);

//Write to a new YUV file, that increases Luma Y by N for each Y in frame
void saturateUpByN(FILE* fp, int width, int height, int totalFrames, int N);

int minYBlock(unsigned char* blockData, int blockSize);

int maxYBlock(unsigned char* blockData, int blockSize);

int rangeInBlock(unsigned char* blockData, int blockSize);	//To make into parallel, multiple reduction can be done.

std::vector<bool> rangeMapFrame(unsigned char* frameBuffer, int width, int height, int blockSize, int* frameNum, int threshold);

std::vector<double> averageBlocksFrame(unsigned char* frameBuffer, int width, int height, uint64_t blockSize);

void getBlockFromNum(unsigned char* frameData, unsigned char* blockData, int blockSize, int blockNum, int width);

duration<double, std::milli> writeAvgBlockYUV(FILE* fp, uint64_t width, uint64_t height, int totalFrames, uint64_t blockSize);