#pragma once

int openYUVFile(uint64_t* width, uint64_t* height, char* fileName, char* filePath);

int frameExtract(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000]);

int datasetCreate(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000]);