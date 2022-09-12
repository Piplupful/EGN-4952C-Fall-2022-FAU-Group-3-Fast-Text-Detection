#pragma once
#include <iostream>

int avgMain();
int rangeMain(FILE* inputFile, uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int thresh, bool print);
int rangeMain2D(FILE* inputFile, uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int thresh, bool print);	//2D Work Group Size, for Runtime Analysis

//Experimental
int rangeMain2DVect(FILE* inputFile, uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int thresh, bool print);	//2D Work Group Size, for Runtime Analysis