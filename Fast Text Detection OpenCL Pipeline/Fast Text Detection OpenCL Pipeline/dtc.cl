// TODO: Add OpenCL kernel code here.

int avgQuadrantBlock(int blocksize, unsigned char *blockData, int q_size, int x, int y)
{
    int sum = 0;
    int xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
    int ylimit = y + q_size;
    for (int i = x; i < xlimit; i++)
    {
        for (int j = y; j < ylimit; j++)
        {
            sum += (int)blockData[i * blocksize + j];    // add each luma value to sum
        }
    }
    return sum / (q_size * q_size);
}

__kernel void DTC_LD_5RUS(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
{
    int X = get_global_id(0) * 16;
	int Y = get_global_id(1) * 16;

    unsigned char *blockData[256];
	
	int AVG_MACRO_VALUE = 0;
	int MAX_MACRO_VALUE = -1;
	int MIN_MACRO_VALUE = 256;
	int RANGE_MACRO_VALUE = 0;
    int AVGQUADRANT_MACRO_VALUE = 0;
    int AVG_ROW_DIF = 0;
    int AVG_COL_DIF = 0;

	int offset = Y * width + X;

    for (int i = 0; i < 16; i++)			//over every x value
	{
		AVG_MACRO_VALUE += frame[offset + (i * width)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width)]);
        blockData[i * 16] = frame[offset + (i * width)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 1)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        blockData[i * 16 + 1] = frame[offset + (i * width + 1)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 2)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        blockData[i * 16 + 2] = frame[offset + (i * width + 2)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 3)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        blockData[i * 16 + 3] = frame[offset + (i * width + 3)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 4)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        blockData[i * 16 + 4] = frame[offset + (i * width + 4)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 5)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        blockData[i * 16 + 5] = frame[offset + (i * width + 5)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 6)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        blockData[i * 16 + 6] = frame[offset + (i * width + 6)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 7)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        blockData[i * 16 + 7] = frame[offset + (i * width + 7)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 8)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        blockData[i * 16 + 8] = frame[offset + (i * width + 8)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 9)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        blockData[i * 16 + 9] = frame[offset + (i * width + 9)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 10)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        blockData[i * 16 + 10] = frame[offset + (i * width + 10)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 11)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        blockData[i * 16 + 11] = frame[offset + (i * width + 11)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 12)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        blockData[i * 16 + 12] = frame[offset + (i * width + 12)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 13)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        blockData[i * 16 + 13] = frame[offset + (i * width + 13)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 14)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        blockData[i * 16 + 14] = frame[offset + (i * width + 14)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 15)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        blockData[i * 16 + 15] = frame[offset + (i * width + 15)];
	}
   
	if(Y != 1072)
    {
        AVG_MACRO_VALUE /= 256.0;

        for(int i = 0; i < 15; i++)
        {
            for(int j = 0; j < 16; j++)
            {
                AVG_ROW_DIF += abs_diff((int)blockData[i * 16 + j], (int)(blockData[((i+1) * 16) + j]));
            }
        }
        AVG_ROW_DIF = AVG_ROW_DIF / 240; //15 * 16

        for(int i = 0; i < 16; i++)
        {
            for(int j = 0; j < 15; j++)
            {
                AVG_COL_DIF += abs_diff((int)blockData[i * 16 + j], (int)blockData[i * 16 + (j + 1)]);
            }
        }
        AVG_COL_DIF = AVG_COL_DIF / 240; //16 * 15

        int q1Avg, q2Avg, q3Avg, q4Avg, qcenter = 0;
        int q_size = 4;

        q1Avg = avgQuadrantBlock(16, blockData, q_size, 0, 0);   // quadrant 1 is left top corner so start at 0,0 of macroblock
        q2Avg = avgQuadrantBlock(16, blockData, q_size, 0, 16 - q_size);  // quadrant 2 is right top corner so if a 8x8 macroblock then from (5-7, 0-2)
        q3Avg = avgQuadrantBlock(16, blockData, q_size, 16 - q_size, 0);  // quadrant 3 is left bottom corner so if a 8x8 macroblock then from (0-2, 5-7)
        q4Avg = avgQuadrantBlock(16, blockData, q_size, 16 - q_size, 16 - q_size); // quadrant 4 is the right bottom corner so if a 8x8 macroblock then from (5-7, 5-7)
        qcenter = avgQuadrantBlock(16, blockData, 2, 16 / 2 - 1, 16 / 2 - 1); // This retrieves the average of the center in a 2x2 quadrant

        if (abs_diff(q1Avg, q2Avg) < 30 && abs_diff(q1Avg, q3Avg) < 30 && abs_diff(q1Avg, q4Avg) && abs_diff(q2Avg, q3Avg) < 30 && abs_diff(q2Avg, q4Avg) < 30 && abs_diff(q3Avg, q4Avg) < 30)
        {
            int qAvg = (q1Avg + q2Avg + q3Avg + q4Avg) / 4;  // average of all quadrants except center

            if (abs_diff(qAvg, qcenter) > 8)    // compare to center quadrant 
            {
                AVGQUADRANT_MACRO_VALUE = 1;
            }
            else
            {
                AVGQUADRANT_MACRO_VALUE = 0;
            }
        }
        else
        {
            AVGQUADRANT_MACRO_VALUE = 0;
        }
    }
	else
    {
		AVG_MACRO_VALUE /= 128.0;	//1080p case, 1080/16 = 67.5

        for(int i = 0; i < 7; i++)
        {
            for(int j = 0; j < 16; j++)
            {
                AVG_ROW_DIF += abs_diff((int)blockData[i * 16 + j], (int)(blockData[((i+1) * 16) + j]));
            }
        }
        AVG_ROW_DIF = AVG_ROW_DIF / 112; //16 * 7

        for(int i = 0; i < 8; i++)
        {
            for(int j = 0; j < 15; j++)
            {
                AVG_COL_DIF += abs_diff((int)blockData[i * 16 + j], (int)blockData[i * 16 + (j + 1)]);
            }
        }
        AVG_COL_DIF = AVG_COL_DIF / 120; //15 * 8

        int q1Avg, q2Avg, qcenter = 0;
        int q_size = 4;

        q1Avg = avgQuadrantBlock(16, blockData, q_size, 0, 0);   // quadrant 1 is left top corner so start at 0,0 of macroblock
        q2Avg = avgQuadrantBlock(16, blockData, q_size, 0, 16 - q_size);  // quadrant 2 is right top corner so if a 8x8 macroblock then from (5-7, 0-2)
        qcenter = avgQuadrantBlock(16, blockData, 2, 16 / 2 - 1, 16 / 2 - 1); // This retrieves the average of the center in a 2x2 quadrant

        if (abs_diff(q1Avg, q2Avg) < 30)
        {
            int qAvg = (q1Avg + q2Avg) / 2;  // average of all quadrants except center

            if (abs_diff(qAvg, qcenter) > 8)    // compare to center quadrant 
            {
                AVGQUADRANT_MACRO_VALUE = 1;
            }
            else
            {
                AVGQUADRANT_MACRO_VALUE = 0;
            }
        }
        else
        {
            AVGQUADRANT_MACRO_VALUE = 0;
        }
    }

	RANGE_MACRO_VALUE = MAX_MACRO_VALUE - MIN_MACRO_VALUE;

	//All statistics gathered.
	int i = (X / 16) + ((int)(Y / 16) * (width / 16));	//numBlock

	//DTC OR OTHER CONVERTED MODEL

    if (MIN_MACRO_VALUE < 19.5) {
            if (MAX_MACRO_VALUE < 98.5) {
                if (RANGE_MACRO_VALUE < 69.5) {
                    if (Y < 824) {
                        if (Y < 696) {
                            if (X < 424) {
                                if (MAX_MACRO_VALUE < 21.5) {
                                    if (Y < 456) {
                                        binMap[i] = 1;
                                    }
                                    else if (Y >= 456) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 21.5) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (X >= 424) {
                                if (Y < 440) {
                                    if (AVG_MACRO_VALUE < 18.9) {
                                        if (AVG_MACRO_VALUE < 18.37) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 18.37) {
                                            if (Y < 88) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 88) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 18.9) {
                                        if (AVG_MACRO_VALUE < 24.58) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 24.58) {
                                            if (X < 872) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 872) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 440) {
                                    if (AVG_MACRO_VALUE < 24.42) {
                                        if (X < 712) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 712) {
                                            if (X < 808) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 808) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 24.42) {
                                        if (AVG_MACRO_VALUE < 33.32) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 33.32) {
                                            if (AVG_MACRO_VALUE < 70.56) {
                                                binMap[i] = 0;
                                            }
                                            else if (AVG_MACRO_VALUE >= 70.56) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (Y >= 696) {
                            if (RANGE_MACRO_VALUE < 21.5) {
                                if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                    if (MAX_MACRO_VALUE < 17.5) {
                                        if (Y < 728) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 728) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 17.5) {
                                        if (AVG_MACRO_VALUE < 17.37) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.37) {
                                            if (X < 232) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 232) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                                else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                    binMap[i] = 1;
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 21.5) {
                                if (X < 456) {
                                    if (Y < 792) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 792) {
                                        if (X < 344) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 344) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (X >= 456) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                    }
                    else if (Y >= 824) {
                        if (X < 1096) {
                            if (Y < 872) {
                                if (Y < 856) {
                                    binMap[i] = 1;
                                }
                                else if (Y >= 856) {
                                    if (X < 792) {
                                        binMap[i] = 0;
                                    }
                                    else if (X >= 792) {
                                        if (AVG_MACRO_VALUE < 18.19) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 18.19) {
                                            if (MIN_MACRO_VALUE < 16.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MIN_MACRO_VALUE >= 16.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 872) {
                                if (AVG_MACRO_VALUE < 28.89) {
                                    if (X < 104) {
                                        binMap[i] = 0;
                                    }
                                    else if (X >= 104) {
                                        if (AVG_MACRO_VALUE < 27.62) {
                                            if (AVG_MACRO_VALUE < 25.89) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 25.89) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 27.62) {
                                            if (MAX_MACRO_VALUE < 59.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MAX_MACRO_VALUE >= 59.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 28.89) {
                                    if (AVG_MACRO_VALUE < 32.56) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 32.56) {
                                        binMap[i] = 1;
                                    }
                                }
                            }
                        }
                        else if (X >= 1096) {
                            if (AVG_MACRO_VALUE < 42.53) {
                                if (RANGE_MACRO_VALUE < 5.5) {
                                    if (RANGE_MACRO_VALUE < 1.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 1.5) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 5.5) {
                                    if (Y < 920) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 920) {
                                        if (AVG_MACRO_VALUE < 34.48) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 34.48) {
                                            if (X < 1128) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 1128) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 42.53) {
                                if (X < 1120) {
                                    if (RANGE_MACRO_VALUE < 55.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 55.5) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (X >= 1120) {
                                    if (Y < 984) {
                                        binMap[i] = 1;
                                    }
                                    else if (Y >= 984) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 69.5) {
                    if (X < 1432) {
                        if (Y < 328) {
                            if (X < 1368) {
                                binMap[i] = 0;
                            }
                            else if (X >= 1368) {
                                if (AVG_MACRO_VALUE < 59.53) {
                                    if (X < 1400) {
                                        if (AVG_MACRO_VALUE < 59.48) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 59.48) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (X >= 1400) {
                                        if (AVG_MACRO_VALUE < 59.49) {
                                            if (AVG_MACRO_VALUE < 59.45) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 59.45) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 59.49) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 59.53) {
                                    binMap[i] = 1;
                                }
                            }
                        }
                        else if (Y >= 328) {
                            if (Y < 344) {
                                binMap[i] = 1;
                            }
                            else if (Y >= 344) {
                                if (RANGE_MACRO_VALUE < 79.5) {
                                    if (X < 96) {
                                        if (Y < 784) {
                                            binMap[i] = 1;
                                        }
                                        else if (Y >= 784) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 96) {
                                        if (AVG_MACRO_VALUE < 19.93) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 19.93) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 79.5) {
                                    if (Y < 936) {
                                        if (Y < 608) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 608) {
                                            if (MIN_MACRO_VALUE < 15.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MIN_MACRO_VALUE >= 15.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (Y >= 936) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                        }
                    }
                    else if (X >= 1432) {
                        if (Y < 392) {
                            if (X < 1704) {
                                if (AVG_MACRO_VALUE < 59.51) {
                                    if (AVG_MACRO_VALUE < 58.39) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 58.39) {
                                        if (Y < 56) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 56) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 59.51) {
                                    if (AVG_MACRO_VALUE < 59.51) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 59.51) {
                                        if (Y < 128) {
                                            if (Y < 16) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 16) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (Y >= 128) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (X >= 1704) {
                                if (AVG_MACRO_VALUE < 59.47) {
                                    binMap[i] = 0;
                                }
                                else if (AVG_MACRO_VALUE >= 59.47) {
                                    if (X < 1752) {
                                        binMap[i] = 1;
                                    }
                                    else if (X >= 1752) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                        }
                        else if (Y >= 392) {
                            if (AVG_MACRO_VALUE < 38.8) {
                                binMap[i] = 0;
                            }
                            else if (AVG_MACRO_VALUE >= 38.8) {
                                if (AVG_MACRO_VALUE < 59.82) {
                                    if (MAX_MACRO_VALUE < 88.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (MAX_MACRO_VALUE >= 88.5) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 59.82) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 98.5) {
                if (RANGE_MACRO_VALUE < 81.5) {
                    if (AVG_MACRO_VALUE < 33.03) {
                        binMap[i] = 0;
                    }
                    else if (AVG_MACRO_VALUE >= 33.03) {
                        binMap[i] = 1;
                    }
                }
                else if (RANGE_MACRO_VALUE >= 81.5) {
                    if (Y < 776) {
                        if (X < 904) {
                            if (MAX_MACRO_VALUE < 177.5) {
                                if (Y < 136) {
                                    if (X < 104) {
                                        if (MIN_MACRO_VALUE < 15.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MIN_MACRO_VALUE >= 15.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 104) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (Y >= 136) {
                                    if (Y < 232) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            if (X < 696) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 696) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (Y >= 232) {
                                        if (Y < 552) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 552) {
                                            if (X < 104) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 104) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 177.5) {
                                if (X < 824) {
                                    if (MAX_MACRO_VALUE < 181.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (MAX_MACRO_VALUE >= 181.5) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (X >= 824) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                        else if (X >= 904) {
                            if (Y < 760) {
                                if (X < 1528) {
                                    if (X < 1256) {
                                        if (Y < 696) {
                                            binMap[i] = 1;
                                        }
                                        else if (Y >= 696) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1256) {
                                        if (AVG_MACRO_VALUE < 97.71) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 97.71) {
                                            if (X < 1440) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 1440) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1528) {
                                    if (Y < 344) {
                                        if (AVG_MACRO_VALUE < 70.25) {
                                            if (X < 1608) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 1608) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 70.25) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (Y >= 344) {
                                        if (Y < 616) {
                                            binMap[i] = 1;
                                        }
                                        else if (Y >= 616) {
                                            if (Y < 712) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 712) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 760) {
                                binMap[i] = 0;
                            }
                        }
                    }
                    else if (Y >= 776) {
                        if (RANGE_MACRO_VALUE < 160.5) {
                            if (Y < 904) {
                                if (RANGE_MACRO_VALUE < 136.5) {
                                    binMap[i] = 0;
                                }
                                else if (RANGE_MACRO_VALUE >= 136.5) {
                                    if (RANGE_MACRO_VALUE < 137.5) {
                                        binMap[i] = 1;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 137.5) {
                                        if (MAX_MACRO_VALUE < 164.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MAX_MACRO_VALUE >= 164.5) {
                                            if (RANGE_MACRO_VALUE < 154.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 154.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 904) {
                                if (RANGE_MACRO_VALUE < 120.5) {
                                    if (Y < 936) {
                                        if (X < 568) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 568) {
                                            if (X < 1184) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 1184) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (Y >= 936) {
                                        if (AVG_MACRO_VALUE < 42.86) {
                                            if (AVG_MACRO_VALUE < 39.21) {
                                                binMap[i] = 0;
                                            }
                                            else if (AVG_MACRO_VALUE >= 39.21) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.86) {
                                            if (Y < 984) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 984) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 120.5) {
                                    if (X < 744) {
                                        if (X < 632) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 632) {
                                            if (Y < 1000) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 1000) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (X >= 744) {
                                        if (Y < 920) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 920) {
                                            if (Y < 1032) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 1032) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 160.5) {
                            if (Y < 1032) {
                                if (Y < 952) {
                                    if (RANGE_MACRO_VALUE < 219.5) {
                                        if (MAX_MACRO_VALUE < 179.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MAX_MACRO_VALUE >= 179.5) {
                                            if (RANGE_MACRO_VALUE < 194.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 194.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 219.5) {
                                        if (AVG_MACRO_VALUE < 75.1) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 75.1) {
                                            if (X < 1168) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 1168) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 952) {
                                    if (X < 152) {
                                        if (MAX_MACRO_VALUE < 180) {
                                            binMap[i] = 1;
                                        }
                                        else if (MAX_MACRO_VALUE >= 180) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 152) {
                                        if (X < 824) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 824) {
                                            if (X < 888) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 888) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 1032) {
                                if (X < 504) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 504) {
                                    if (MIN_MACRO_VALUE < 16.5) {
                                        if (AVG_MACRO_VALUE < 48.89) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 48.89) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 16.5) {
                                        if (RANGE_MACRO_VALUE < 213.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 213.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else if (MIN_MACRO_VALUE >= 19.5) {
            if (RANGE_MACRO_VALUE < 14.5) {
                if (Y < 888) {
                    if (Y < 824) {
                        if (AVG_MACRO_VALUE < 23.91) {
                            if (X < 328) {
                                binMap[i] = 0;
                            }
                            else if (X >= 328) {
                                binMap[i] = 1;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 23.91) {
                            if (AVG_MACRO_VALUE < 24.79) {
                                binMap[i] = 0;
                            }
                            else if (AVG_MACRO_VALUE >= 24.79) {
                                if (X < 8) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 8) {
                                    if (MAX_MACRO_VALUE < 196.5) {
                                        if (AVG_MACRO_VALUE < 68.53) {
                                            if (MAX_MACRO_VALUE < 72.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MAX_MACRO_VALUE >= 72.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 68.53) {
                                            if (AVG_MACRO_VALUE < 77.14) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 77.14) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 196.5) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                        }
                    }
                    else if (Y >= 824) {
                        if (AVG_MACRO_VALUE < 71.63) {
                            binMap[i] = 0;
                        }
                        else if (AVG_MACRO_VALUE >= 71.63) {
                            if (AVG_MACRO_VALUE < 136.59) {
                                if (X < 504) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 504) {
                                    if (MIN_MACRO_VALUE < 132.5) {
                                        if (AVG_MACRO_VALUE < 72.44) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 72.44) {
                                            if (MIN_MACRO_VALUE < 85.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MIN_MACRO_VALUE >= 85.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 132.5) {
                                        if (X < 728) {
                                            binMap[i] = 1;
                                        }
                                        else if (X >= 728) {
                                            if (X < 1616) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 1616) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 136.59) {
                                binMap[i] = 0;
                            }
                        }
                    }
                }
                else if (Y >= 888) {
                    if (Y < 1032) {
                        if (RANGE_MACRO_VALUE < 11.5) {
                            if (MAX_MACRO_VALUE < 136.5) {
                                if (AVG_MACRO_VALUE < 44.48) {
                                    if (MIN_MACRO_VALUE < 33.5) {
                                        if (AVG_MACRO_VALUE < 36.36) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 36.36) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 33.5) {
                                        if (X < 608) {
                                            if (X < 328) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 328) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (X >= 608) {
                                            if (X < 904) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 904) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 44.48) {
                                    if (AVG_MACRO_VALUE < 129.92) {
                                        if (AVG_MACRO_VALUE < 45.33) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 45.33) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 129.92) {
                                        if (X < 464) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 464) {
                                            if (X < 1304) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 1304) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 136.5) {
                                if (Y < 920) {
                                    binMap[i] = 0;
                                }
                                else if (Y >= 920) {
                                    if (AVG_MACRO_VALUE < 136.3) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 136.3) {
                                        if (MAX_MACRO_VALUE < 164.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MAX_MACRO_VALUE >= 164.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 11.5) {
                            if (AVG_MACRO_VALUE < 29.88) {
                                if (MIN_MACRO_VALUE < 22.5) {
                                    if (X < 1608) {
                                        binMap[i] = 0;
                                    }
                                    else if (X >= 1608) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 22.5) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 29.88) {
                                if (AVG_MACRO_VALUE < 31.32) {
                                    if (RANGE_MACRO_VALUE < 13.5) {
                                        if (Y < 936) {
                                            binMap[i] = 1;
                                        }
                                        else if (Y >= 936) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 13.5) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 31.32) {
                                    if (MAX_MACRO_VALUE < 39.5) {
                                        if (AVG_MACRO_VALUE < 33.03) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 33.03) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 39.5) {
                                        if (Y < 968) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 968) {
                                            if (X < 152) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 152) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Y >= 1032) {
                        binMap[i] = 0;
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 14.5) {
                if (X < 136) {
                    if (MIN_MACRO_VALUE < 74.5) {
                        if (Y < 632) {
                            if (MIN_MACRO_VALUE < 41.5) {
                                if (AVG_MACRO_VALUE < 39.02) {
                                    if (Y < 616) {
                                        binMap[i] = 1;
                                    }
                                    else if (Y >= 616) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 39.02) {
                                    if (Y < 312) {
                                        if (Y < 136) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 136) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (Y >= 312) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            if (Y < 328) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 328) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 41.5) {
                                if (Y < 504) {
                                    if (MAX_MACRO_VALUE < 73.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (MAX_MACRO_VALUE >= 73.5) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (Y >= 504) {
                                    if (RANGE_MACRO_VALUE < 152) {
                                        if (Y < 520) {
                                            if (AVG_MACRO_VALUE < 88.75) {
                                                binMap[i] = 0;
                                            }
                                            else if (AVG_MACRO_VALUE >= 88.75) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (Y >= 520) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 152) {
                                        binMap[i] = 1;
                                    }
                                }
                            }
                        }
                        else if (Y >= 632) {
                            if (MAX_MACRO_VALUE < 46.5) {
                                if (X < 120) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 120) {
                                    if (Y < 728) {
                                        binMap[i] = 1;
                                    }
                                    else if (Y >= 728) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 46.5) {
                                if (Y < 664) {
                                    if (AVG_MACRO_VALUE < 43.95) {
                                        if (X < 120) {
                                            if (MIN_MACRO_VALUE < 36) {
                                                binMap[i] = 0;
                                            }
                                            else if (MIN_MACRO_VALUE >= 36) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (X >= 120) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 43.95) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (Y >= 664) {
                                    if (RANGE_MACRO_VALUE < 32.5) {
                                        if (MAX_MACRO_VALUE < 58.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MAX_MACRO_VALUE >= 58.5) {
                                            if (AVG_MACRO_VALUE < 51.14) {
                                                binMap[i] = 0;
                                            }
                                            else if (AVG_MACRO_VALUE >= 51.14) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 32.5) {
                                        if (Y < 856) {
                                            if (MIN_MACRO_VALUE < 31.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MIN_MACRO_VALUE >= 31.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (Y >= 856) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 74.5) {
                        if (AVG_MACRO_VALUE < 108.27) {
                            if (MAX_MACRO_VALUE < 98.5) {
                                if (AVG_MACRO_VALUE < 91.05) {
                                    if (MIN_MACRO_VALUE < 75.5) {
                                        binMap[i] = 1;
                                    }
                                    else if (MIN_MACRO_VALUE >= 75.5) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 91.05) {
                                    binMap[i] = 1;
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 98.5) {
                                binMap[i] = 0;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 108.27) {
                            if (MAX_MACRO_VALUE < 131.5) {
                                if (MAX_MACRO_VALUE < 128.5) {
                                    if (MAX_MACRO_VALUE < 127.5) {
                                        binMap[i] = 1;
                                    }
                                    else if (MAX_MACRO_VALUE >= 127.5) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 128.5) {
                                    if (Y < 952) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 952) {
                                        binMap[i] = 1;
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 131.5) {
                                if (AVG_MACRO_VALUE < 134.08) {
                                    binMap[i] = 0;
                                }
                                else if (AVG_MACRO_VALUE >= 134.08) {
                                    if (RANGE_MACRO_VALUE < 36.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 36.5) {
                                        if (MIN_MACRO_VALUE < 84) {
                                            binMap[i] = 0;
                                        }
                                        else if (MIN_MACRO_VALUE >= 84) {
                                            if (AVG_MACRO_VALUE < 170.49) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 170.49) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (X >= 136) {
                    if (AVG_MACRO_VALUE < 24.73) {
                        if (AVG_MACRO_VALUE < 23.06) {
                            binMap[i] = 0;
                        }
                        else if (AVG_MACRO_VALUE >= 23.06) {
                            if (Y < 736) {
                                binMap[i] = 1;
                            }
                            else if (Y >= 736) {
                                binMap[i] = 0;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 24.73) {
                        if (RANGE_MACRO_VALUE < 205.5) {
                            if (MAX_MACRO_VALUE < 41.5) {
                                if (X < 1592) {
                                    if (X < 1032) {
                                        if (X < 808) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 808) {
                                            if (MAX_MACRO_VALUE < 21.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MAX_MACRO_VALUE >= 21.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (X >= 1032) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (X >= 1592) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 41.5) {
                                if (RANGE_MACRO_VALUE < 15.5) {
                                    if (Y < 920) {
                                        if (MAX_MACRO_VALUE < 60.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MAX_MACRO_VALUE >= 60.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (Y >= 920) {
                                        if (AVG_MACRO_VALUE < 49.52) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 49.52) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 15.5) {
                                    if (Y < 488) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 488) {
                                        if (AVG_MACRO_VALUE < 31.83) {
                                            if (RANGE_MACRO_VALUE < 20.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 20.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 31.83) {
                                            if (AVG_MACRO_VALUE < 38.74) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 38.74) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 205.5) {
                            if (X < 568) {
                                if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                    if (RANGE_MACRO_VALUE < 211.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 211.5) {
                                        if (RANGE_MACRO_VALUE < 213.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 213.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                    binMap[i] = 1;
                                }
                            }
                            else if (X >= 568) {
                                if (Y < 8) {
                                    binMap[i] = 0;
                                }
                                else if (Y >= 8) {
                                    if (X < 728) {
                                        binMap[i] = 1;
                                    }
                                    else if (X >= 728) {
                                        if (Y < 344) {
                                            if (Y < 200) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 200) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (Y >= 344) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
}

__kernel void DTC_B_REP(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
{
    int X = get_global_id(0) * 16;
	int Y = get_global_id(1) * 16;

    unsigned char *blockData[256];
	
	int AVG_MACRO_VALUE = 0;
	int MAX_MACRO_VALUE = -1;
	int MIN_MACRO_VALUE = 256;
	int RANGE_MACRO_VALUE = 0;
    int AVGQUADRANT_MACRO_VALUE = 0;
    int AVG_ROW_DIF = 0;
    int AVG_COL_DIF = 0;

	int offset = Y * width + X;

    for (int i = 0; i < 16; i++)			//over every x value
	{
		AVG_MACRO_VALUE += frame[offset + (i * width)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width)]);
        blockData[i * 16] = frame[offset + (i * width)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 1)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        blockData[i * 16 + 1] = frame[offset + (i * width + 1)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 2)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        blockData[i * 16 + 2] = frame[offset + (i * width + 2)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 3)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        blockData[i * 16 + 3] = frame[offset + (i * width + 3)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 4)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        blockData[i * 16 + 4] = frame[offset + (i * width + 4)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 5)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        blockData[i * 16 + 5] = frame[offset + (i * width + 5)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 6)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        blockData[i * 16 + 6] = frame[offset + (i * width + 6)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 7)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        blockData[i * 16 + 7] = frame[offset + (i * width + 7)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 8)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        blockData[i * 16 + 8] = frame[offset + (i * width + 8)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 9)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        blockData[i * 16 + 9] = frame[offset + (i * width + 9)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 10)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        blockData[i * 16 + 10] = frame[offset + (i * width + 10)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 11)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        blockData[i * 16 + 11] = frame[offset + (i * width + 11)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 12)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        blockData[i * 16 + 12] = frame[offset + (i * width + 12)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 13)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        blockData[i * 16 + 13] = frame[offset + (i * width + 13)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 14)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        blockData[i * 16 + 14] = frame[offset + (i * width + 14)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 15)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        blockData[i * 16 + 15] = frame[offset + (i * width + 15)];
	}
   
	if(Y != 1072)
    {
        AVG_MACRO_VALUE /= 256.0;

        for(int i = 0; i < 15; i++)
        {
            for(int j = 0; j < 16; j++)
            {
                AVG_ROW_DIF += abs_diff((int)blockData[i * 16 + j], (int)(blockData[((i+1) * 16) + j]));
            }
        }
        AVG_ROW_DIF = AVG_ROW_DIF / 240; //15 * 16

        for(int i = 0; i < 16; i++)
        {
            for(int j = 0; j < 15; j++)
            {
                AVG_COL_DIF += abs_diff((int)blockData[i * 16 + j], (int)blockData[i * 16 + (j + 1)]);
            }
        }
        AVG_COL_DIF = AVG_COL_DIF / 240; //16 * 15

        int q1Avg, q2Avg, q3Avg, q4Avg, qcenter = 0;
        int q_size = 4;

        q1Avg = avgQuadrantBlock(16, blockData, q_size, 0, 0);   // quadrant 1 is left top corner so start at 0,0 of macroblock
        q2Avg = avgQuadrantBlock(16, blockData, q_size, 0, 16 - q_size);  // quadrant 2 is right top corner so if a 8x8 macroblock then from (5-7, 0-2)
        q3Avg = avgQuadrantBlock(16, blockData, q_size, 16 - q_size, 0);  // quadrant 3 is left bottom corner so if a 8x8 macroblock then from (0-2, 5-7)
        q4Avg = avgQuadrantBlock(16, blockData, q_size, 16 - q_size, 16 - q_size); // quadrant 4 is the right bottom corner so if a 8x8 macroblock then from (5-7, 5-7)
        qcenter = avgQuadrantBlock(16, blockData, 2, 16 / 2 - 1, 16 / 2 - 1); // This retrieves the average of the center in a 2x2 quadrant

        if (abs_diff(q1Avg, q2Avg) < 30 && abs_diff(q1Avg, q3Avg) < 30 && abs_diff(q1Avg, q4Avg) && abs_diff(q2Avg, q3Avg) < 30 && abs_diff(q2Avg, q4Avg) < 30 && abs_diff(q3Avg, q4Avg) < 30)
        {
            int qAvg = (q1Avg + q2Avg + q3Avg + q4Avg) / 4;  // average of all quadrants except center

            if (abs_diff(qAvg, qcenter) > 8)    // compare to center quadrant 
            {
                AVGQUADRANT_MACRO_VALUE = 1;
            }
            else
            {
                AVGQUADRANT_MACRO_VALUE = 0;
            }
        }
        else
        {
            AVGQUADRANT_MACRO_VALUE = 0;
        }
    }
	else
    {
		AVG_MACRO_VALUE /= 128.0;	//1080p case, 1080/16 = 67.5

        for(int i = 0; i < 7; i++)
        {
            for(int j = 0; j < 16; j++)
            {
                AVG_ROW_DIF += abs_diff((int)blockData[i * 16 + j], (int)(blockData[((i+1) * 16) + j]));
            }
        }
        AVG_ROW_DIF = AVG_ROW_DIF / 112; //16 * 7

        for(int i = 0; i < 8; i++)
        {
            for(int j = 0; j < 15; j++)
            {
                AVG_COL_DIF += abs_diff((int)blockData[i * 16 + j], (int)blockData[i * 16 + (j + 1)]);
            }
        }
        AVG_COL_DIF = AVG_COL_DIF / 120; //15 * 8

        int q1Avg, q2Avg, qcenter = 0;
        int q_size = 4;

        q1Avg = avgQuadrantBlock(16, blockData, q_size, 0, 0);   // quadrant 1 is left top corner so start at 0,0 of macroblock
        q2Avg = avgQuadrantBlock(16, blockData, q_size, 0, 16 - q_size);  // quadrant 2 is right top corner so if a 8x8 macroblock then from (5-7, 0-2)
        qcenter = avgQuadrantBlock(16, blockData, 2, 16 / 2 - 1, 16 / 2 - 1); // This retrieves the average of the center in a 2x2 quadrant

        if (abs_diff(q1Avg, q2Avg) < 30)
        {
            int qAvg = (q1Avg + q2Avg) / 2;  // average of all quadrants except center

            if (abs_diff(qAvg, qcenter) > 8)    // compare to center quadrant 
            {
                AVGQUADRANT_MACRO_VALUE = 1;
            }
            else
            {
                AVGQUADRANT_MACRO_VALUE = 0;
            }
        }
        else
        {
            AVGQUADRANT_MACRO_VALUE = 0;
        }
    }

	RANGE_MACRO_VALUE = MAX_MACRO_VALUE - MIN_MACRO_VALUE;

	//All statistics gathered.
	int i = (X / 16) + ((int)(Y / 16) * (width / 16));	//numBlock

	//DTC OR OTHER CONVERTED MODEL
    if (X < 504) {
            if (AVG_MACRO_VALUE < 43.99) {
                if (MAX_MACRO_VALUE < 124.5) {
                    if (Y < 1048) {
                        if (Y < 712) {
                            if (Y < 632) {
                                if (X < 456) {
                                    if (AVG_MACRO_VALUE < 43.53) {
                                        if (AVG_MACRO_VALUE < 37.88) {
                                            if (Y < 360) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 360) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 37.88) {
                                            if (Y < 104) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 104) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 43.53) {
                                        if (X < 136) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 136) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (X >= 456) {
                                    if (RANGE_MACRO_VALUE < 5.5) {
                                        if (AVG_MACRO_VALUE < 16.97) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 16.97) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 5.5) {
                                        if (MIN_MACRO_VALUE < 28.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MIN_MACRO_VALUE >= 28.5) {
                                            if (Y < 392) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 392) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 632) {
                                binMap[i] = 0;
                            }
                        }
                        else if (Y >= 712) {
                            if (Y < 744) {
                                if (X < 240) {
                                    if (AVG_MACRO_VALUE < 41.9) {
                                        if (RANGE_MACRO_VALUE < 2.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 2.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 41.9) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (X >= 240) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (Y >= 744) {
                                if (Y < 888) {
                                    if (X < 24) {
                                        if (RANGE_MACRO_VALUE < 24.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 24.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (X >= 24) {
                                        if (AVG_MACRO_VALUE < 29.9) {
                                            if (AVG_MACRO_VALUE < 26.43) {
                                                binMap[i] = 0;
                                            }
                                            else if (AVG_MACRO_VALUE >= 26.43) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 29.9) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (Y >= 888) {
                                    binMap[i] = 1;
                                }
                            }
                        }
                    }
                    else if (Y >= 1048) {
                        binMap[i] = 0;
                    }
                }
                else if (MAX_MACRO_VALUE >= 124.5) {
                    binMap[i] = 1;
                }
            }
            else if (AVG_MACRO_VALUE >= 43.99) {
                if (X < 104) {
                    if (AVG_MACRO_VALUE < 58.81) {
                        if (Y < 392) {
                            binMap[i] = 0;
                        }
                        else if (Y >= 392) {
                            if (AVG_MACRO_VALUE < 44.58) {
                                binMap[i] = 1;
                            }
                            else if (AVG_MACRO_VALUE >= 44.58) {
                                if (Y < 632) {
                                    binMap[i] = 0;
                                }
                                else if (Y >= 632) {
                                    if (X < 72) {
                                        if (MIN_MACRO_VALUE < 24.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MIN_MACRO_VALUE >= 24.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 72) {
                                        binMap[i] = 1;
                                    }
                                }
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 58.81) {
                        if (AVG_MACRO_VALUE < 61.4) {
                            if (Y < 888) {
                                binMap[i] = 1;
                            }
                            else if (Y >= 888) {
                                binMap[i] = 0;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 61.4) {
                            if (AVG_MACRO_VALUE < 64.12) {
                                binMap[i] = 0;
                            }
                            else if (AVG_MACRO_VALUE >= 64.12) {
                                if (X < 88) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 88) {
                                    if (Y < 360) {
                                        binMap[i] = 1;
                                    }
                                    else if (Y >= 360) {
                                        if (RANGE_MACRO_VALUE < 36.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 36.5) {
                                            if (RANGE_MACRO_VALUE < 185) {
                                                binMap[i] = 0;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 185) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (X >= 104) {
                    if (MIN_MACRO_VALUE < 59.5) {
                        if (AVG_MACRO_VALUE < 115.85) {
                            binMap[i] = 0;
                        }
                        else if (AVG_MACRO_VALUE >= 115.85) {
                            if (Y < 1048) {
                                if (MIN_MACRO_VALUE < 48.5) {
                                    if (AVG_MACRO_VALUE < 121.39) {
                                        binMap[i] = 1;
                                    }
                                    else if (AVG_MACRO_VALUE >= 121.39) {
                                        if (RANGE_MACRO_VALUE < 110.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 110.5) {
                                            if (MIN_MACRO_VALUE < 39.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MIN_MACRO_VALUE >= 39.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 48.5) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (Y >= 1048) {
                                binMap[i] = 1;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 59.5) {
                        if (MIN_MACRO_VALUE < 61.5) {
                            if (AVG_MACRO_VALUE < 63.98) {
                                binMap[i] = 1;
                            }
                            else if (AVG_MACRO_VALUE >= 63.98) {
                                if (Y < 216) {
                                    if (Y < 184) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 184) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (Y >= 216) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 61.5) {
                            if (Y < 248) {
                                if (Y < 72) {
                                    binMap[i] = 1;
                                }
                                else if (Y >= 72) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (Y >= 248) {
                                if (AVG_MACRO_VALUE < 68.38) {
                                    if (X < 416) {
                                        binMap[i] = 0;
                                    }
                                    else if (X >= 416) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 68.38) {
                                    if (MIN_MACRO_VALUE < 66.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (MIN_MACRO_VALUE >= 66.5) {
                                        if (RANGE_MACRO_VALUE < 54.5) {
                                            if (X < 136) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 136) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 54.5) {
                                            if (MAX_MACRO_VALUE < 153.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MAX_MACRO_VALUE >= 153.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else if (X >= 504) {
            if (RANGE_MACRO_VALUE < 204.5) {
                if (MAX_MACRO_VALUE < 74.5) {
                    if (MAX_MACRO_VALUE < 69.5) {
                        if (RANGE_MACRO_VALUE < 46.5) {
                            if (X < 1304) {
                                binMap[i] = 0;
                            }
                            else if (X >= 1304) {
                                if (X < 1352) {
                                    binMap[i] = 1;
                                }
                                else if (X >= 1352) {
                                    if (X < 1384) {
                                        if (Y < 352) {
                                            if (Y < 328) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 328) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (Y >= 352) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1384) {
                                        if (Y < 984) {
                                            if (AVG_MACRO_VALUE < 42.25) {
                                                binMap[i] = 0;
                                            }
                                            else if (AVG_MACRO_VALUE >= 42.25) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (Y >= 984) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 46.5) {
                            if (AVG_MACRO_VALUE < 43.24) {
                                if (X < 768) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 768) {
                                    binMap[i] = 1;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 43.24) {
                                if (X < 1624) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 1624) {
                                    binMap[i] = 1;
                                }
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 69.5) {
                        binMap[i] = 0;
                    }
                }
                else if (MAX_MACRO_VALUE >= 74.5) {
                    if (Y < 424) {
                        if (MIN_MACRO_VALUE < 23.5) {
                            binMap[i] = 1;
                        }
                        else if (MIN_MACRO_VALUE >= 23.5) {
                            if (X < 1560) {
                                if (MAX_MACRO_VALUE < 79.5) {
                                    if (X < 1400) {
                                        if (Y < 392) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 392) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (X >= 1400) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 79.5) {
                                    if (Y < 296) {
                                        if (X < 1064) {
                                            binMap[i] = 1;
                                        }
                                        else if (X >= 1064) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (Y >= 296) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (X >= 1560) {
                                binMap[i] = 1;
                            }
                        }
                    }
                    else if (Y >= 424) {
                        if (Y < 456) {
                            if (X < 584) {
                                if (MAX_MACRO_VALUE < 94) {
                                    binMap[i] = 0;
                                }
                                else if (MAX_MACRO_VALUE >= 94) {
                                    if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                        binMap[i] = 1;
                                    }
                                    else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                        if (MIN_MACRO_VALUE < 89) {
                                            binMap[i] = 1;
                                        }
                                        else if (MIN_MACRO_VALUE >= 89) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (X >= 584) {
                                if (RANGE_MACRO_VALUE < 137.5) {
                                    if (AVG_MACRO_VALUE < 102.81) {
                                        if (X < 1112) {
                                            if (MIN_MACRO_VALUE < 30.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MIN_MACRO_VALUE >= 30.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (X >= 1112) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 102.81) {
                                        if (MIN_MACRO_VALUE < 53) {
                                            if (AVG_MACRO_VALUE < 111.14) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 111.14) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 53) {
                                            if (X < 1112) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 1112) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 137.5) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                        else if (Y >= 456) {
                            if (MAX_MACRO_VALUE < 105.5) {
                                if (AVG_MACRO_VALUE < 85.26) {
                                    if (AVG_MACRO_VALUE < 79.44) {
                                        if (AVG_MACRO_VALUE < 77.52) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 77.52) {
                                            if (Y < 568) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 568) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 79.44) {
                                        if (MAX_MACRO_VALUE < 96.5) {
                                            if (MAX_MACRO_VALUE < 93.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MAX_MACRO_VALUE >= 93.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 96.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 85.26) {
                                    if (MAX_MACRO_VALUE < 90.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (MAX_MACRO_VALUE >= 90.5) {
                                        if (RANGE_MACRO_VALUE < 56) {
                                            if (Y < 568) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 568) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 56) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 105.5) {
                                if (X < 1000) {
                                    if (AVG_MACRO_VALUE < 127.94) {
                                        if (MIN_MACRO_VALUE < 16.5) {
                                            if (X < 888) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 888) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 16.5) {
                                            if (Y < 488) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 488) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 127.94) {
                                        if (AVG_MACRO_VALUE < 133.8) {
                                            if (X < 920) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 920) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 133.8) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (X >= 1000) {
                                    if (MAX_MACRO_VALUE < 157.5) {
                                        if (MAX_MACRO_VALUE < 148.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MAX_MACRO_VALUE >= 148.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 157.5) {
                                        binMap[i] = 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 204.5) {
                if (Y < 552) {
                    if (MAX_MACRO_VALUE < 225) {
                        binMap[i] = 1;
                    }
                    else if (MAX_MACRO_VALUE >= 225) {
                        if (X < 1072) {
                            binMap[i] = 1;
                        }
                        else if (X >= 1072) {
                            binMap[i] = 0;
                        }
                    }
                }
                else if (Y >= 552) {
                    binMap[i] = 1;
                }
            }
        }
}

__kernel void randForestTest(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
{
    int X = get_global_id(0) * 16;
	int Y = get_global_id(1) * 16;

    int zeroCount = 0;
    int oneCount = 0;

    unsigned char *blockData[256];
	
	int AVG_MACRO_VALUE = 0;
	int MAX_MACRO_VALUE = -1;
	int MIN_MACRO_VALUE = 256;
	int RANGE_MACRO_VALUE = 0;
    int AVGQUADRANT_MACRO_VALUE = 0;
    int AVG_ROW_DIF = 0;
    int AVG_COL_DIF = 0;

	int offset = Y * width + X;

    for (int i = 0; i < 16; i++)			//over every x value
	{
		AVG_MACRO_VALUE += frame[offset + (i * width)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width)]);
        blockData[i * 16] = frame[offset + (i * width)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 1)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        blockData[i * 16 + 1] = frame[offset + (i * width + 1)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 2)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        blockData[i * 16 + 2] = frame[offset + (i * width + 2)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 3)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        blockData[i * 16 + 3] = frame[offset + (i * width + 3)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 4)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        blockData[i * 16 + 4] = frame[offset + (i * width + 4)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 5)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        blockData[i * 16 + 5] = frame[offset + (i * width + 5)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 6)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        blockData[i * 16 + 6] = frame[offset + (i * width + 6)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 7)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        blockData[i * 16 + 7] = frame[offset + (i * width + 7)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 8)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        blockData[i * 16 + 8] = frame[offset + (i * width + 8)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 9)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        blockData[i * 16 + 9] = frame[offset + (i * width + 9)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 10)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        blockData[i * 16 + 10] = frame[offset + (i * width + 10)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 11)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        blockData[i * 16 + 11] = frame[offset + (i * width + 11)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 12)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        blockData[i * 16 + 12] = frame[offset + (i * width + 12)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 13)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        blockData[i * 16 + 13] = frame[offset + (i * width + 13)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 14)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        blockData[i * 16 + 14] = frame[offset + (i * width + 14)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 15)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        blockData[i * 16 + 15] = frame[offset + (i * width + 15)];
	}
   
	if(Y != 1072)
    {
        AVG_MACRO_VALUE /= 256.0;

        for(int i = 0; i < 15; i++)
        {
            for(int j = 0; j < 16; j++)
            {
                AVG_ROW_DIF += abs_diff((int)blockData[i * 16 + j], (int)(blockData[((i+1) * 16) + j]));
            }
        }
        AVG_ROW_DIF = AVG_ROW_DIF / 240; //15 * 16

        for(int i = 0; i < 16; i++)
        {
            for(int j = 0; j < 15; j++)
            {
                AVG_COL_DIF += abs_diff((int)blockData[i * 16 + j], (int)blockData[i * 16 + (j + 1)]);
            }
        }
        AVG_COL_DIF = AVG_COL_DIF / 240; //16 * 15

        int q1Avg, q2Avg, q3Avg, q4Avg, qcenter = 0;
        int q_size = 4;

        q1Avg = avgQuadrantBlock(16, blockData, q_size, 0, 0);   // quadrant 1 is left top corner so start at 0,0 of macroblock
        q2Avg = avgQuadrantBlock(16, blockData, q_size, 0, 16 - q_size);  // quadrant 2 is right top corner so if a 8x8 macroblock then from (5-7, 0-2)
        q3Avg = avgQuadrantBlock(16, blockData, q_size, 16 - q_size, 0);  // quadrant 3 is left bottom corner so if a 8x8 macroblock then from (0-2, 5-7)
        q4Avg = avgQuadrantBlock(16, blockData, q_size, 16 - q_size, 16 - q_size); // quadrant 4 is the right bottom corner so if a 8x8 macroblock then from (5-7, 5-7)
        qcenter = avgQuadrantBlock(16, blockData, 2, 16 / 2 - 1, 16 / 2 - 1); // This retrieves the average of the center in a 2x2 quadrant

        if (abs_diff(q1Avg, q2Avg) < 30 && abs_diff(q1Avg, q3Avg) < 30 && abs_diff(q1Avg, q4Avg) && abs_diff(q2Avg, q3Avg) < 30 && abs_diff(q2Avg, q4Avg) < 30 && abs_diff(q3Avg, q4Avg) < 30)
        {
            int qAvg = (q1Avg + q2Avg + q3Avg + q4Avg) / 4;  // average of all quadrants except center

            if (abs_diff(qAvg, qcenter) > 8)    // compare to center quadrant 
            {
                AVGQUADRANT_MACRO_VALUE = 1;
            }
            else
            {
                AVGQUADRANT_MACRO_VALUE = 0;
            }
        }
        else
        {
            AVGQUADRANT_MACRO_VALUE = 0;
        }
    }
	else
    {
		AVG_MACRO_VALUE /= 128.0;	//1080p case, 1080/16 = 67.5

        for(int i = 0; i < 7; i++)
        {
            for(int j = 0; j < 16; j++)
            {
                AVG_ROW_DIF += abs_diff((int)blockData[i * 16 + j], (int)(blockData[((i+1) * 16) + j]));
            }
        }
        AVG_ROW_DIF = AVG_ROW_DIF / 112; //16 * 7

        for(int i = 0; i < 8; i++)
        {
            for(int j = 0; j < 15; j++)
            {
                AVG_COL_DIF += abs_diff((int)blockData[i * 16 + j], (int)blockData[i * 16 + (j + 1)]);
            }
        }
        AVG_COL_DIF = AVG_COL_DIF / 120; //15 * 8

        int q1Avg, q2Avg, qcenter = 0;
        int q_size = 4;

        q1Avg = avgQuadrantBlock(16, blockData, q_size, 0, 0);   // quadrant 1 is left top corner so start at 0,0 of macroblock
        q2Avg = avgQuadrantBlock(16, blockData, q_size, 0, 16 - q_size);  // quadrant 2 is right top corner so if a 8x8 macroblock then from (5-7, 0-2)
        qcenter = avgQuadrantBlock(16, blockData, 2, 16 / 2 - 1, 16 / 2 - 1); // This retrieves the average of the center in a 2x2 quadrant

        if (abs_diff(q1Avg, q2Avg) < 30)
        {
            int qAvg = (q1Avg + q2Avg) / 2;  // average of all quadrants except center

            if (abs_diff(qAvg, qcenter) > 8)    // compare to center quadrant 
            {
                AVGQUADRANT_MACRO_VALUE = 1;
            }
            else
            {
                AVGQUADRANT_MACRO_VALUE = 0;
            }
        }
        else
        {
            AVGQUADRANT_MACRO_VALUE = 0;
        }
    }

	RANGE_MACRO_VALUE = MAX_MACRO_VALUE - MIN_MACRO_VALUE;

	//All statistics gathered.
	int i = (X / 16) + ((int)(Y / 16) * (width / 16));	//numBlock

	//DTC OR OTHER CONVERTED MODEL
    //TREE 1
    if (RANGE_MACRO_VALUE < 38) {
            if (MAX_MACRO_VALUE < 166) {
                if (Y < 984) {
                    if (AVG_MACRO_VALUE < 20) {
                        if (X < 1560) {
                            zeroCount++;
                        }
                        else if (X >= 1560) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 20) {
                        if (X < 1144) {
                            zeroCount++;
                        }
                        else if (X >= 1144) {
                            zeroCount++;
                        }
                    }
                }
                else if (Y >= 984) {
                    if (MAX_MACRO_VALUE < 121) {
                        if (X < 1320) {
                            zeroCount++;
                        }
                        else if (X >= 1320) {
                            zeroCount++;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 121) {
                        if (Y < 1048) {
                            zeroCount++;
                        }
                        else if (Y >= 1048) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 166) {
                if (MIN_MACRO_VALUE < 169) {
                    if (Y < 136) {
                        if (Y < 120) {
                            zeroCount++;
                        }
                        else if (Y >= 120) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 136) {
                        if (Y < 920) {
                            zeroCount++;
                        }
                        else if (Y >= 920) {
                            zeroCount++;
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 169) {
                    zeroCount++;
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 38) {
            if (MIN_MACRO_VALUE < 26) {
                if (RANGE_MACRO_VALUE < 75) {
                    if (Y < 136) {
                        if (MAX_MACRO_VALUE < 61) {
                            oneCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 61) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 136) {
                        if (X < 24) {
                            zeroCount++;
                        }
                        else if (X >= 24) {
                            zeroCount++;
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 75) {
                    if (MAX_MACRO_VALUE < 210) {
                        if (X < 952) {
                            zeroCount++;
                        }
                        else if (X >= 952) {
                            zeroCount++;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 210) {
                        if (Y < 712) {
                            zeroCount++;
                        }
                        else if (Y >= 712) {
                            oneCount++;
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 26) {
                if (X < 584) {
                    if (MIN_MACRO_VALUE < 43) {
                        if (RANGE_MACRO_VALUE < 182) {
                            zeroCount++;
                        }
                        else if (RANGE_MACRO_VALUE >= 182) {
                            zeroCount++;
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 43) {
                        if (Y < 1048) {
                            zeroCount++;
                        }
                        else if (Y >= 1048) {
                            zeroCount++;
                        }
                    }
                }
                else if (X >= 584) {
                    if (MAX_MACRO_VALUE < 22) {
                        if (X < 1344) {
                            zeroCount++;
                        }
                        else if (X >= 1344) {
                            oneCount++;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 22) {
                        if (Y < 936) {
                            zeroCount++;
                        }
                        else if (Y >= 936) {
                            zeroCount++;
                        }
                    }
                }
            }
        }

    //TREE 2
    if (RANGE_MACRO_VALUE < 191) {
            if (RANGE_MACRO_VALUE < 37) {
                if (AVG_MACRO_VALUE < 146) {
                    if (X < 1128) {
                        if (AVG_MACRO_VALUE < 72) {
                            zeroCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 72) {
                            zeroCount++;
                        }
                    }
                    else if (X >= 1128) {
                        if (Y < 968) {
                            zeroCount++;
                        }
                        else if (Y >= 968) {
                            zeroCount++;
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 146) {
                    if (Y < 920) {
                        if (MAX_MACRO_VALUE < 171) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 171) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 920) {
                        if (X < 168) {
                            zeroCount++;
                        }
                        else if (X >= 168) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 37) {
                if (MIN_MACRO_VALUE < 26) {
                    if (Y < 136) {
                        if (Y < 88) {
                            zeroCount++;
                        }
                        else if (Y >= 88) {
                            oneCount++;
                        }
                    }
                    else if (Y >= 136) {
                        if (MAX_MACRO_VALUE < 97) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 97) {
                            zeroCount++;
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 26) {
                    if (X < 552) {
                        if (MIN_MACRO_VALUE < 43) {
                            zeroCount++;
                        }
                        else if (MIN_MACRO_VALUE >= 43) {
                            zeroCount++;
                        }
                    }
                    else if (X >= 552) {
                        if (Y < 936) {
                            zeroCount++;
                        }
                        else if (Y >= 936) {
                            zeroCount++;
                        }
                    }
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 191) {
            if (Y < 744) {
                if (X < 216) {
                    if (MIN_MACRO_VALUE < 30) {
                        if (Y < 696) {
                            zeroCount++;
                        }
                        else if (Y >= 696) {
                            oneCount++;
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 30) {
                        zeroCount++;
                    }
                }
                else if (X >= 216) {
                    if (X < 1712) {
                        if (MIN_MACRO_VALUE < 27) {
                            zeroCount++;
                        }
                        else if (MIN_MACRO_VALUE >= 27) {
                            zeroCount++;
                        }
                    }
                    else if (X >= 1712) {
                        if (RANGE_MACRO_VALUE < 209) {
                            zeroCount++;
                        }
                        else if (RANGE_MACRO_VALUE >= 209) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (Y >= 744) {
                if (X < 1576) {
                    if (MAX_MACRO_VALUE < 224) {
                        if (X < 272) {
                            oneCount++;
                        }
                        else if (X >= 272) {
                            zeroCount++;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 224) {
                        if (Y < 920) {
                            zeroCount++;
                        }
                        else if (Y >= 920) {
                            zeroCount++;
                        }
                    }
                }
                else if (X >= 1576) {
                    if (RANGE_MACRO_VALUE < 209) {
                        if (AVG_MACRO_VALUE < 96) {
                            oneCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 96) {
                            oneCount++;
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 209) {
                        oneCount++;
                    }
                }
            }
        }

    //TREE 3
    if (RANGE_MACRO_VALUE < 38) {
            if (MAX_MACRO_VALUE < 171) {
                if (Y < 920) {
                    if (Y < 744) {
                        if (AVG_MACRO_VALUE < 18) {
                            zeroCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 18) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 744) {
                        if (X < 1752) {
                            zeroCount++;
                        }
                        else if (X >= 1752) {
                            zeroCount++;
                        }
                    }
                }
                else if (Y >= 920) {
                    if (MAX_MACRO_VALUE < 125) {
                        if (X < 280) {
                            zeroCount++;
                        }
                        else if (X >= 280) {
                            zeroCount++;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 125) {
                        if (Y < 1048) {
                            zeroCount++;
                        }
                        else if (Y >= 1048) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 171) {
                if (Y < 936) {
                    if (Y < 72) {
                        if (AVG_MACRO_VALUE < 174) {
                            zeroCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 174) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 72) {
                        zeroCount++;
                    }
                }
                else if (Y >= 936) {
                    if (X < 1584) {
                        zeroCount++;
                    }
                    else if (X >= 1584) {
                        if (Y < 1000) {
                            oneCount++;
                        }
                        else if (Y >= 1000) {
                            zeroCount++;
                        }
                    }
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 38) {
            if (MIN_MACRO_VALUE < 26) {
                if (RANGE_MACRO_VALUE < 193) {
                    if (Y < 136) {
                        if (Y < 88) {
                            zeroCount++;
                        }
                        else if (Y >= 88) {
                            oneCount++;
                        }
                    }
                    else if (Y >= 136) {
                        if (RANGE_MACRO_VALUE < 75) {
                            zeroCount++;
                        }
                        else if (RANGE_MACRO_VALUE >= 75) {
                            zeroCount++;
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 193) {
                    if (Y < 712) {
                        if (Y < 104) {
                            zeroCount++;
                        }
                        else if (Y >= 104) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 712) {
                        if (MAX_MACRO_VALUE < 225) {
                            oneCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 225) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 26) {
                if (X < 584) {
                    if (MIN_MACRO_VALUE < 43) {
                        if (Y < 616) {
                            zeroCount++;
                        }
                        else if (Y >= 616) {
                            zeroCount++;
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 43) {
                        if (Y < 1048) {
                            zeroCount++;
                        }
                        else if (Y >= 1048) {
                            zeroCount++;
                        }
                    }
                }
                else if (X >= 584) {
                    if (MIN_MACRO_VALUE < 222) {
                        if (MAX_MACRO_VALUE < 226) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 226) {
                            zeroCount++;
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 222) {
                        if (X < 1192) {
                            zeroCount++;
                        }
                        else if (X >= 1192) {
                            oneCount++;
                        }
                    }
                }
            }
        }

    //TREE 4
    if (RANGE_MACRO_VALUE < 38) {
            if (MAX_MACRO_VALUE < 166) {
                if (Y < 984) {
                    if (AVG_MACRO_VALUE < 19) {
                        if (X < 1624) {
                            zeroCount++;
                        }
                        else if (X >= 1624) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 19) {
                        if (X < 1112) {
                            zeroCount++;
                        }
                        else if (X >= 1112) {
                            zeroCount++;
                        }
                    }
                }
                else if (Y >= 984) {
                    if (MAX_MACRO_VALUE < 121) {
                        if (X < 1320) {
                            zeroCount++;
                        }
                        else if (X >= 1320) {
                            zeroCount++;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 121) {
                        if (Y < 1048) {
                            zeroCount++;
                        }
                        else if (Y >= 1048) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 166) {
                if (X < 168) {
                    if (MAX_MACRO_VALUE < 171) {
                        if (Y < 920) {
                            zeroCount++;
                        }
                        else if (Y >= 920) {
                            oneCount++;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 171) {
                        if (AVG_MACRO_VALUE < 174) {
                            zeroCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 174) {
                            zeroCount++;
                        }
                    }
                }
                else if (X >= 168) {
                    if (Y < 936) {
                        if (X < 1304) {
                            zeroCount++;
                        }
                        else if (X >= 1304) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 936) {
                        if (X < 1688) {
                            zeroCount++;
                        }
                        else if (X >= 1688) {
                            zeroCount++;
                        }
                    }
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 38) {
            if (MIN_MACRO_VALUE < 26) {
                if (MAX_MACRO_VALUE < 190) {
                    if (Y < 136) {
                        if (Y < 88) {
                            zeroCount++;
                        }
                        else if (Y >= 88) {
                            oneCount++;
                        }
                    }
                    else if (Y >= 136) {
                        if (RANGE_MACRO_VALUE < 73) {
                            zeroCount++;
                        }
                        else if (RANGE_MACRO_VALUE >= 73) {
                            zeroCount++;
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 190) {
                    if (Y < 696) {
                        if (MAX_MACRO_VALUE < 192) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 192) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 696) {
                        if (X < 1560) {
                            zeroCount++;
                        }
                        else if (X >= 1560) {
                            oneCount++;
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 26) {
                if (X < 584) {
                    if (MIN_MACRO_VALUE < 43) {
                        if (Y < 584) {
                            zeroCount++;
                        }
                        else if (Y >= 584) {
                            zeroCount++;
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 43) {
                        if (Y < 1048) {
                            zeroCount++;
                        }
                        else if (Y >= 1048) {
                            zeroCount++;
                        }
                    }
                }
                else if (X >= 584) {
                    if (MAX_MACRO_VALUE < 20) {
                        if (X < 1288) {
                            zeroCount++;
                        }
                        else if (X >= 1288) {
                            oneCount++;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 20) {
                        if (Y < 936) {
                            zeroCount++;
                        }
                        else if (Y >= 936) {
                            zeroCount++;
                        }
                    }
                }
            }
        }

    //TREE 5
    if (RANGE_MACRO_VALUE < 38) {
            if (MAX_MACRO_VALUE < 171) {
                if (Y < 984) {
                    if (X < 1176) {
                        if (AVG_MACRO_VALUE < 119) {
                            zeroCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 119) {
                            zeroCount++;
                        }
                    }
                    else if (X >= 1176) {
                        if (MIN_MACRO_VALUE < 19) {
                            zeroCount++;
                        }
                        else if (MIN_MACRO_VALUE >= 19) {
                            zeroCount++;
                        }
                    }
                }
                else if (Y >= 984) {
                    if (MIN_MACRO_VALUE < 107) {
                        if (X < 1336) {
                            zeroCount++;
                        }
                        else if (X >= 1336) {
                            zeroCount++;
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 107) {
                        if (Y < 1048) {
                            zeroCount++;
                        }
                        else if (Y >= 1048) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 171) {
                if (Y < 936) {
                    if (Y < 72) {
                        if (MAX_MACRO_VALUE < 178) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 178) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 72) {
                        zeroCount++;
                    }
                }
                else if (Y >= 936) {
                    if (X < 1592) {
                        zeroCount++;
                    }
                    else if (X >= 1592) {
                        if (X < 1648) {
                            oneCount++;
                        }
                        else if (X >= 1648) {
                            zeroCount++;
                        }
                    }
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 38) {
            if (MIN_MACRO_VALUE < 26) {
                if (MAX_MACRO_VALUE < 220) {
                    if (Y < 136) {
                        if (Y < 88) {
                            zeroCount++;
                        }
                        else if (Y >= 88) {
                            oneCount++;
                        }
                    }
                    else if (Y >= 136) {
                        if (MAX_MACRO_VALUE < 96) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 96) {
                            zeroCount++;
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 220) {
                    if (Y < 744) {
                        if (X < 216) {
                            oneCount++;
                        }
                        else if (X >= 216) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 744) {
                        if (MAX_MACRO_VALUE < 224) {
                            oneCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 224) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 26) {
                if (X < 568) {
                    if (MIN_MACRO_VALUE < 43) {
                        if (MAX_MACRO_VALUE < 77) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 77) {
                            zeroCount++;
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 43) {
                        if (Y < 1048) {
                            zeroCount++;
                        }
                        else if (Y >= 1048) {
                            zeroCount++;
                        }
                    }
                }
                else if (X >= 568) {
                    if (MAX_MACRO_VALUE < 22) {
                        if (X < 1344) {
                            zeroCount++;
                        }
                        else if (X >= 1344) {
                            oneCount++;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 22) {
                        if (Y < 936) {
                            zeroCount++;
                        }
                        else if (Y >= 936) {
                            zeroCount++;
                        }
                    }
                }
            }
        }

    //TREE 6
    if (RANGE_MACRO_VALUE < 193) {
            if (RANGE_MACRO_VALUE < 38) {
                if (AVG_MACRO_VALUE < 146) {
                    if (MAX_MACRO_VALUE < 79) {
                        if (RANGE_MACRO_VALUE < 12) {
                            zeroCount++;
                        }
                        else if (RANGE_MACRO_VALUE >= 12) {
                            zeroCount++;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 79) {
                        if (Y < 376) {
                            zeroCount++;
                        }
                        else if (Y >= 376) {
                            zeroCount++;
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 146) {
                    if (Y < 472) {
                        if (Y < 136) {
                            zeroCount++;
                        }
                        else if (Y >= 136) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 472) {
                        if (Y < 488) {
                            zeroCount++;
                        }
                        else if (Y >= 488) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 38) {
                if (MIN_MACRO_VALUE < 26) {
                    if (Y < 136) {
                        if (MAX_MACRO_VALUE < 140) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 140) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 136) {
                        if (RANGE_MACRO_VALUE < 74) {
                            zeroCount++;
                        }
                        else if (RANGE_MACRO_VALUE >= 74) {
                            zeroCount++;
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 26) {
                    if (X < 600) {
                        if (MIN_MACRO_VALUE < 43) {
                            zeroCount++;
                        }
                        else if (MIN_MACRO_VALUE >= 43) {
                            zeroCount++;
                        }
                    }
                    else if (X >= 600) {
                        if (Y < 936) {
                            zeroCount++;
                        }
                        else if (Y >= 936) {
                            zeroCount++;
                        }
                    }
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 193) {
            if (MAX_MACRO_VALUE < 224) {
                if (Y < 712) {
                    if (RANGE_MACRO_VALUE < 206) {
                        if (MAX_MACRO_VALUE < 215) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 215) {
                            zeroCount++;
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 206) {
                        if (X < 1248) {
                            zeroCount++;
                        }
                        else if (X >= 1248) {
                            oneCount++;
                        }
                    }
                }
                else if (Y >= 712) {
                    if (MIN_MACRO_VALUE < 17) {
                        zeroCount++;
                    }
                    else if (MIN_MACRO_VALUE >= 17) {
                        if (Y < 984) {
                            oneCount++;
                        }
                        else if (Y >= 984) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 224) {
                if (X < 1576) {
                    if (X < 616) {
                        if (Y < 568) {
                            zeroCount++;
                        }
                        else if (Y >= 568) {
                            zeroCount++;
                        }
                    }
                    else if (X >= 616) {
                        if (AVG_MACRO_VALUE < 45) {
                            oneCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 45) {
                            zeroCount++;
                        }
                    }
                }
                else if (X >= 1576) {
                    if (Y < 904) {
                        if (Y < 648) {
                            zeroCount++;
                        }
                        else if (Y >= 648) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 904) {
                        if (Y < 1048) {
                            oneCount++;
                        }
                        else if (Y >= 1048) {
                            oneCount++;
                        }
                    }
                }
            }
        }

    //TREE 7
    if (RANGE_MACRO_VALUE < 41) {
            if (Y < 920) {
                if (MAX_MACRO_VALUE < 129) {
                    if (X < 1160) {
                        if (MAX_MACRO_VALUE < 95) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 95) {
                            zeroCount++;
                        }
                    }
                    else if (X >= 1160) {
                        if (X < 1752) {
                            zeroCount++;
                        }
                        else if (X >= 1752) {
                            zeroCount++;
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 129) {
                    if (AVG_MACRO_VALUE < 174) {
                        if (AVG_MACRO_VALUE < 174) {
                            zeroCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 174) {
                            oneCount++;
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 174) {
                        zeroCount++;
                    }
                }
            }
            else if (Y >= 920) {
                if (MAX_MACRO_VALUE < 121) {
                    if (Y < 1032) {
                        if (RANGE_MACRO_VALUE < 9) {
                            zeroCount++;
                        }
                        else if (RANGE_MACRO_VALUE >= 9) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 1032) {
                        if (X < 88) {
                            zeroCount++;
                        }
                        else if (X >= 88) {
                            zeroCount++;
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 121) {
                    if (Y < 1048) {
                        if (MAX_MACRO_VALUE < 141) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 141) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 1048) {
                        if (X < 440) {
                            oneCount++;
                        }
                        else if (X >= 440) {
                            zeroCount++;
                        }
                    }
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 41) {
            if (MIN_MACRO_VALUE < 26) {
                if (MAX_MACRO_VALUE < 215) {
                    if (Y < 216) {
                        if (AVG_MACRO_VALUE < 28) {
                            zeroCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 28) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 216) {
                        if (MAX_MACRO_VALUE < 78) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 78) {
                            zeroCount++;
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 215) {
                    if (Y < 712) {
                        if (Y < 104) {
                            zeroCount++;
                        }
                        else if (Y >= 104) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 712) {
                        if (MAX_MACRO_VALUE < 235) {
                            oneCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 235) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 26) {
                if (X < 584) {
                    if (MIN_MACRO_VALUE < 43) {
                        if (MAX_MACRO_VALUE < 219) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 219) {
                            zeroCount++;
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 43) {
                        if (Y < 1048) {
                            zeroCount++;
                        }
                        else if (Y >= 1048) {
                            zeroCount++;
                        }
                    }
                }
                else if (X >= 584) {
                    if (MIN_MACRO_VALUE < 223) {
                        if (Y < 936) {
                            zeroCount++;
                        }
                        else if (Y >= 936) {
                            zeroCount++;
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 223) {
                        if (X < 1184) {
                            zeroCount++;
                        }
                        else if (X >= 1184) {
                            oneCount++;
                        }
                    }
                }
            }
        }

    //VOTE
    if(zeroCount > oneCount)
        binMap[i] = 0;
    else
        binMap[i] = 1;
}

/*OLD CODE, IGNORE
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
*/