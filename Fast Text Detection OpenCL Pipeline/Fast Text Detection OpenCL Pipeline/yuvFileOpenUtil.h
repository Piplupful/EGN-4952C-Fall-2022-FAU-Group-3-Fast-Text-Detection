#pragma once

int openYUVFile(FILE* fp, uint64_t* width, uint64_t* height, char* fileName, char* filePath);

int frameExtract(FILE* inputFile, uint64_t width, uint64_t height, char fileName[2000], char filePath[2000]);