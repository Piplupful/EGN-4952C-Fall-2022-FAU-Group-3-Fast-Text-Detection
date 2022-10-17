#pragma once

int openCVTrainDTC(bool results);
int openCV_DTC_Driver_Proto(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000]);

int simpleThreshWrite(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000], bool print);