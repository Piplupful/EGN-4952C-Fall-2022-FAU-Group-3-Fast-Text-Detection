#pragma once
#include <iostream>

int avgMain(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], bool print);					//2D
int rangeMain(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int thresh, bool print);		//1D
int rangeMain2D(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int thresh, bool print);	//2D Work Group Size, for Runtime Analysis
int rangeMain2DWrite(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int thresh, bool print, bool chromaOut);

//Experimental
int avgMainOpt(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], bool print);						//2D
int rangeMain2DVect(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int thresh, bool print);	//2D Work Group Size, for Runtime Analysis
