// TODO: Add OpenCL kernel code here.
__kernel void dtcTest(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
{
    int X = get_global_id(0) * 16;
	int Y = get_global_id(1) * 16;
	
	int AVG_MACRO_VALUE = 0;
	int MAX_MACRO_VALUE = -1;
	int MIN_MACRO_VALUE = 256;
	int RANGE_MACRO_VALUE = 0;
    int AVGQUADRANT_MACRO_VALUE = 0;

	int offset = Y * width + X;

    for (int i = 0; i < 16; i++)			//over every x value
	{
		AVG_MACRO_VALUE += frame[offset + (i * width + 0)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 0)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 0)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 1)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 2)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 3)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 4)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 5)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 6)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 7)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 8)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 9)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 10)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 11)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 12)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 13)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 14)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);

		AVG_MACRO_VALUE += frame[offset + (i * width + 15)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
	}

	if(Y != 1072)
		AVG_MACRO_VALUE /= 256.0;
	else
		AVG_MACRO_VALUE /= 128.0;	//1080p case, 1080/16 = 67.5

	RANGE_MACRO_VALUE = MAX_MACRO_VALUE - MIN_MACRO_VALUE;

	//All statistics gathered.
	int i = (X / 16) + ((int)(Y / 16) * (width / 16));	//numBlock

	//DTC OR OTHER CONVERTED MODEL

	if (RANGE_MACRO_VALUE < 206) {
            if (MIN_MACRO_VALUE < 24) {
                if (MAX_MACRO_VALUE < 60) {
                    if (AVG_MACRO_VALUE < 16) {
                        if (X < 1064) {
                            if (X < 968) {
                                binMap[i] = 0;
                            }
                            else if (X >= 968) {
                                binMap[i] = 0;
                            }
                        }
                        else if (X >= 1064) {
                            if (X < 1112) {
                                binMap[i] = 0;
                            }
                            else if (X >= 1112) {
                                binMap[i] = 0;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 16) {
                        if (RANGE_MACRO_VALUE < 9) {
                            if (MIN_MACRO_VALUE < 21) {
                                binMap[i] = 0;
                            }
                            else if (MIN_MACRO_VALUE >= 21) {
                                binMap[i] = 0;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 9) {
                            if (Y < 344) {
                                binMap[i] = 0;
                            }
                            else if (Y >= 344) {
                                binMap[i] = 0;
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 60) {
                    if (Y < 136) {
                        if (MAX_MACRO_VALUE < 135) {
                            if (AVG_MACRO_VALUE < 44) {
                                binMap[i] = 1;
                            }
                            else if (AVG_MACRO_VALUE >= 44) {
                                binMap[i] = 1;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 135) {
                            binMap[i] = 0;
                        }
                    }
                    else if (Y >= 136) {
                        if (RANGE_MACRO_VALUE < 81) {
                            if (Y < 1048) {
                                binMap[i] = 0;
                            }
                            else if (Y >= 1048) {
                                binMap[i] = 1;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 81) {
                            if (AVG_MACRO_VALUE < 66) {
                                binMap[i] = 0;
                            }
                            else if (AVG_MACRO_VALUE >= 66) {
                                binMap[i] = 0;
                            }
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 24) {
                if (MAX_MACRO_VALUE < 18) {
                    if (AVG_MACRO_VALUE < 82) {
                        binMap[i] = 1;
                    }
                    else if (AVG_MACRO_VALUE >= 82) {
                        if (Y < 488) {
                            binMap[i] = 1;
                        }
                        else if (Y >= 488) {
                            binMap[i] = 0;
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 18) {
                    if (Y < 1048) {
                        if (RANGE_MACRO_VALUE < 109) {
                            if (Y < 936) {
                                binMap[i] = 0;
                            }
                            else if (Y >= 936) {
                                binMap[i] = 0;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 109) {
                            if (MAX_MACRO_VALUE < 156) {
                                binMap[i] = 0;
                            }
                            else if (MAX_MACRO_VALUE >= 156) {
                                binMap[i] = 0;
                            }
                        }
                    }
                    else if (Y >= 1048) {
                        if (X < 440) {
                            if (AVG_MACRO_VALUE < 96) {
                                binMap[i] = 0;
                            }
                            else if (AVG_MACRO_VALUE >= 96) {
                                binMap[i] = 1;
                            }
                        }
                        else if (X >= 440) {
                            if (MAX_MACRO_VALUE < 233) {
                                binMap[i] = 0;
                            }
                            else if (MAX_MACRO_VALUE >= 233) {
                                binMap[i] = 0;
                            }
                        }
                    }
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 206) {
            if (MIN_MACRO_VALUE < 126) {
                if (MIN_MACRO_VALUE < 26) {
                    if (AVG_MACRO_VALUE < 147) {
                        if (Y < 480) {
                            if (X < 856) {
                                binMap[i] = 1;
                            }
                            else if (X >= 856) {
                                binMap[i] = 0;
                            }
                        }
                        else if (Y >= 480) {
                            if (X < 168) {
                                binMap[i] = 1;
                            }
                            else if (X >= 168) {
                                binMap[i] = 0;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 147) {
                        if (X < 512) {
                            if (X < 392) {
                                binMap[i] = 0;
                            }
                            else if (X >= 392) {
                                binMap[i] = 1;
                            }
                        }
                        else if (X >= 512) {
                            binMap[i] = 0;
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 26) {
                    if (AVGQUADRANT_MACRO_VALUE < 1) {
                        binMap[i] = 0;
                    }
                    else if (AVGQUADRANT_MACRO_VALUE >= 1) {
                        if (Y < 376) {
                            binMap[i] = 0;
                        }
                        else if (Y >= 376) {
                            if (RANGE_MACRO_VALUE < 208) {
                                binMap[i] = 0;
                            }
                            else if (RANGE_MACRO_VALUE >= 208) {
                                binMap[i] = 1;
                            }
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 126) {
                if (X < 1152) {
                    binMap[i] = 0;
                }
                else if (X >= 1152) {
                    binMap[i] = 1;
                }
            }
        }
}

//OLD CODE, IGNORE
__kernel void dtcStatCollection(__global unsigned char* frame, const int width, __global double* xOut,__global double* yOut, 
__global double* avgOut, __global double* rngOut, __global double* maxOut, __global double* minOut)	//16x16 ONLY
{
	int x = get_global_id(0) * 16;
	int y = get_global_id(1) * 16;
	
	double sum = 0;
	double max = -1;
	double min = 256;
	double range = 0;

	int offset = y * width + x;

	for (int j = 0; j < 16; j++)			//over every x value
	{
		for (int i = 0; i < 16; i++)		//over every y value
		{
			int val = frame[offset + (i * width + j)];

			sum += val; //(frameBuf + offset)[i * width + j];	//save into corresponding block position

			if(min > val)
				min = val;
			if(max < val)
				max = val;
		}
	}

	double avg;

	if(y != 1072)
		sum /= 256.0;
	else
		sum /= 128.0;	//1080p case, 1080/16 = 67.5

	range = max - min;

	//All statistics gathered.
	int i = (x / 16) + ((int)(y / 16) * (width / 16));

	xOut[i] = x;
	yOut[i] = y;
	avgOut[i] = sum;
	rngOut[i] = range;
	maxOut[i] = max;
	minOut[i] = min;
}