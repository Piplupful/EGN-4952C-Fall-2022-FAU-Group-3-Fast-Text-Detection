#pragma once
#include <iostream>

int avgMain(FILE* inputFile, uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], bool print);					//2D
int rangeMain(FILE* inputFile, uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int thresh, bool print);		//1D
int rangeMain2D(FILE* inputFile, uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int thresh, bool print);	//2D Work Group Size, for Runtime Analysis
int rangeMain2DWrite(FILE* inputFile, uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int thresh, bool print);

//Experimental
int avgMainOpt(FILE* inputFile, uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], bool print);						//2D
int rangeMain2DVect(FILE* inputFile, uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int thresh, bool print);	//2D Work Group Size, for Runtime Analysis
