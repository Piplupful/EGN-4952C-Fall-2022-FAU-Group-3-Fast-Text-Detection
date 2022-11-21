#pragma once
#include <stdint.h>
#include "ocl.h"

int textDetectDriver(FILE** FP, OpenCL ocl, string yuvName, uint64_t width, uint64_t height, string outputPath);