#pragma once
#include <stdint.h>
#include "ocl.h"

int textDetectDriver(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000]);

int textDetectDriver(FILE * FP, OpenCL ocl, uint64_t width, uint64_t height, string binMapOutput, string visualOutput);