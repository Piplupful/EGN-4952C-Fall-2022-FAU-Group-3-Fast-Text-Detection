#pragma once

int openYUVFile_Win(uint64_t* width, uint64_t* height, char* fileName, char* filePath);

FILE * openYUVFile(uint64_t* width, uint64_t* height, string inputPath, string yuvFileName);

int frameExtract(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000]);

int frameCondense(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], int newFrames);

int datasetCreate(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000]);