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

__kernel void RF_8RUC_LD(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
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

            if (abs_diff(qAvg, qcenter) < 8)    // compare to center quadrant 
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
    if (MIN_MACRO_VALUE < 33.5) {
            if (AVG_MACRO_VALUE < 17.43) {
                if (X < 872) {
                    if (Y < 40) {
                        if (AVG_MACRO_VALUE < 16.94) {
                            if (AVG_MACRO_VALUE < 16.94) {
                                if (Y < 24) {
                                    zeroCount++;
                                }
                                else if (Y >= 24) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 16.94) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 16.94) {
                            if (X < 72) {
                                if (AVG_MACRO_VALUE < 16.96) {
                                    if (AVG_MACRO_VALUE < 16.95) {
                                        if (X < 24) {
                                            zeroCount++;
                                        }
                                        else if (X >= 24) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 16.95) {
                                        if (Y < 24) {
                                            if (AVG_MACRO_VALUE < 16.95) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 16.95) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 24) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 16.96) {
                                    if (AVG_MACRO_VALUE < 16.97) {
                                        if (Y < 24) {
                                            if (X < 8) {
                                                oneCount++;
                                            }
                                            else if (X >= 8) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 24) {
                                            if (X < 48) {
                                                oneCount++;
                                            }
                                            else if (X >= 48) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 16.97) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (X >= 72) {
                                if (X < 160) {
                                    if (AVG_MACRO_VALUE < 16.97) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 16.97) {
                                        if (X < 120) {
                                            oneCount++;
                                        }
                                        else if (X >= 120) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (X >= 160) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (Y >= 40) {
                        if (X < 168) {
                            zeroCount++;
                        }
                        else if (X >= 168) {
                            if (Y < 184) {
                                if (AVG_MACRO_VALUE < 16.97) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 16.97) {
                                    if (X < 304) {
                                        zeroCount++;
                                    }
                                    else if (X >= 304) {
                                        if (X < 480) {
                                            if (Y < 80) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 80) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 480) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Y >= 184) {
                                if (Y < 712) {
                                    if (AVG_MACRO_VALUE < 17.37) {
                                        if (AVG_MACRO_VALUE < 17.26) {
                                            if (AVG_MACRO_VALUE < 16.98) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 16.98) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.26) {
                                            if (RANGE_MACRO_VALUE < 1.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 1.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 17.37) {
                                        zeroCount++;
                                    }
                                }
                                else if (Y >= 712) {
                                    if (Y < 728) {
                                        if (AVG_MACRO_VALUE < 17.23) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.23) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Y >= 728) {
                                        if (X < 824) {
                                            if (RANGE_MACRO_VALUE < 8) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 8) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 824) {
                                            if (Y < 888) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 888) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (X >= 872) {
                    if (X < 1848) {
                        if (MIN_MACRO_VALUE < 15.5) {
                            oneCount++;
                        }
                        else if (MIN_MACRO_VALUE >= 15.5) {
                            if (X < 1368) {
                                if (RANGE_MACRO_VALUE < 1.5) {
                                    if (X < 1176) {
                                        if (AVG_MACRO_VALUE < 17.37) {
                                            if (Y < 128) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 128) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.37) {
                                            if (X < 936) {
                                                zeroCount++;
                                            }
                                            else if (X >= 936) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1176) {
                                        if (AVG_MACRO_VALUE < 17.24) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.24) {
                                            if (Y < 416) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 416) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 1.5) {
                                    if (AVG_MACRO_VALUE < 17.17) {
                                        if (AVG_MACRO_VALUE < 17.02) {
                                            if (AVG_MACRO_VALUE < 16.98) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 16.98) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.02) {
                                            if (X < 1024) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1024) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 17.17) {
                                        if (MIN_MACRO_VALUE < 16.5) {
                                            if (X < 1120) {
                                                oneCount++;
                                            }
                                            else if (X >= 1120) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 16.5) {
                                            if (AVG_MACRO_VALUE < 17.26) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 17.26) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 1368) {
                                if (X < 1752) {
                                    zeroCount++;
                                }
                                else if (X >= 1752) {
                                    if (MAX_MACRO_VALUE < 17.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 17.5) {
                                        if (Y < 104) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 104) {
                                            if (AVG_MACRO_VALUE < 17.07) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 17.07) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (X >= 1848) {
                        if (MAX_MACRO_VALUE < 39.5) {
                            if (Y < 56) {
                                zeroCount++;
                            }
                            else if (Y >= 56) {
                                if (AVG_MACRO_VALUE < 17.05) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 17.05) {
                                    if (Y < 120) {
                                        if (MAX_MACRO_VALUE < 18.5) {
                                            if (X < 1880) {
                                                oneCount++;
                                            }
                                            else if (X >= 1880) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 18.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 120) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 39.5) {
                            oneCount++;
                        }
                    }
                }
            }
            else if (AVG_MACRO_VALUE >= 17.43) {
                if (X < 728) {
                    if (MIN_MACRO_VALUE < 25.5) {
                        if (MIN_MACRO_VALUE < 24.5) {
                            if (Y < 648) {
                                if (AVG_MACRO_VALUE < 65.24) {
                                    if (AVG_MACRO_VALUE < 54.73) {
                                        if (RANGE_MACRO_VALUE < 143.5) {
                                            if (Y < 632) {
                                                oneCount++;
                                            }
                                            else if (Y >= 632) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 143.5) {
                                            if (MAX_MACRO_VALUE < 196.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 196.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 54.73) {
                                        if (Y < 632) {
                                            if (MIN_MACRO_VALUE < 15.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 15.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 632) {
                                            if (X < 176) {
                                                oneCount++;
                                            }
                                            else if (X >= 176) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 65.24) {
                                    if (MIN_MACRO_VALUE < 21.5) {
                                        if (MAX_MACRO_VALUE < 107.5) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                zeroCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 107.5) {
                                            if (AVG_MACRO_VALUE < 94.6) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 94.6) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 21.5) {
                                        if (Y < 304) {
                                            if (RANGE_MACRO_VALUE < 198.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 198.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 304) {
                                            if (MAX_MACRO_VALUE < 141) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 141) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 648) {
                                if (Y < 664) {
                                    if (AVG_MACRO_VALUE < 24.34) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 24.34) {
                                        if (MAX_MACRO_VALUE < 138.5) {
                                            if (MAX_MACRO_VALUE < 38.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 38.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 138.5) {
                                            if (AVG_MACRO_VALUE < 69.32) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 69.32) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 664) {
                                    if (MIN_MACRO_VALUE < 17.5) {
                                        if (MAX_MACRO_VALUE < 212.5) {
                                            if (X < 56) {
                                                zeroCount++;
                                            }
                                            else if (X >= 56) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 212.5) {
                                            if (AVG_MACRO_VALUE < 48.96) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 48.96) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 17.5) {
                                        if (X < 616) {
                                            if (MAX_MACRO_VALUE < 21.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 21.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 616) {
                                            if (Y < 888) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 888) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 24.5) {
                            if (AVG_MACRO_VALUE < 25.72) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 25.72) {
                                if (MAX_MACRO_VALUE < 150) {
                                    if (RANGE_MACRO_VALUE < 115) {
                                        if (RANGE_MACRO_VALUE < 103.5) {
                                            if (RANGE_MACRO_VALUE < 96.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 96.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 103.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 115) {
                                        if (RANGE_MACRO_VALUE < 117.5) {
                                            if (X < 240) {
                                                zeroCount++;
                                            }
                                            else if (X >= 240) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 117.5) {
                                            if (AVG_MACRO_VALUE < 46.86) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 46.86) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 150) {
                                    if (Y < 840) {
                                        if (AVG_MACRO_VALUE < 61.45) {
                                            if (AVG_MACRO_VALUE < 59.11) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 59.11) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 61.45) {
                                            if (Y < 264) {
                                                oneCount++;
                                            }
                                            else if (Y >= 264) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 840) {
                                        if (AVG_MACRO_VALUE < 118.88) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 118.88) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 25.5) {
                        if (AVG_MACRO_VALUE < 55.66) {
                            if (MAX_MACRO_VALUE < 214) {
                                if (RANGE_MACRO_VALUE < 48.5) {
                                    if (RANGE_MACRO_VALUE < 35.5) {
                                        if (MIN_MACRO_VALUE < 32.5) {
                                            if (AVG_MACRO_VALUE < 42.21) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 42.21) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 32.5) {
                                            if (RANGE_MACRO_VALUE < 24.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 24.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 35.5) {
                                        if (X < 536) {
                                            if (MAX_MACRO_VALUE < 77.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 77.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 536) {
                                            if (MIN_MACRO_VALUE < 28.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 28.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 48.5) {
                                    if (AVG_MACRO_VALUE < 51.17) {
                                        if (Y < 1016) {
                                            if (MAX_MACRO_VALUE < 130) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 130) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 1016) {
                                            if (MAX_MACRO_VALUE < 155.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 155.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 51.17) {
                                        if (X < 552) {
                                            if (Y < 992) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 992) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 552) {
                                            if (MIN_MACRO_VALUE < 29.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 29.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 214) {
                                if (RANGE_MACRO_VALUE < 205.5) {
                                    oneCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 205.5) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 55.66) {
                            if (Y < 312) {
                                if (Y < 184) {
                                    if (MIN_MACRO_VALUE < 28.5) {
                                        zeroCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 28.5) {
                                        if (Y < 120) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 120) {
                                            if (Y < 136) {
                                                oneCount++;
                                            }
                                            else if (Y >= 136) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 184) {
                                    if (MAX_MACRO_VALUE < 164) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 164) {
                                        if (RANGE_MACRO_VALUE < 134) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 134) {
                                            if (RANGE_MACRO_VALUE < 183) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 183) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 312) {
                                if (AVG_MACRO_VALUE < 56.03) {
                                    if (MAX_MACRO_VALUE < 78.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 78.5) {
                                        if (Y < 512) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 512) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                oneCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 56.03) {
                                    if (MIN_MACRO_VALUE < 32.5) {
                                        if (MAX_MACRO_VALUE < 136.5) {
                                            if (MAX_MACRO_VALUE < 105.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 105.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 136.5) {
                                            if (Y < 888) {
                                                oneCount++;
                                            }
                                            else if (Y >= 888) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 32.5) {
                                        if (Y < 504) {
                                            if (MAX_MACRO_VALUE < 111.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 111.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 504) {
                                            if (X < 424) {
                                                oneCount++;
                                            }
                                            else if (X >= 424) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (X >= 728) {
                    if (Y < 504) {
                        if (AVG_MACRO_VALUE < 92.04) {
                            if (X < 1112) {
                                if (RANGE_MACRO_VALUE < 3.5) {
                                    if (X < 952) {
                                        zeroCount++;
                                    }
                                    else if (X >= 952) {
                                        if (Y < 216) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 216) {
                                            if (X < 1096) {
                                                oneCount++;
                                            }
                                            else if (X >= 1096) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 3.5) {
                                    if (Y < 440) {
                                        if (RANGE_MACRO_VALUE < 12.5) {
                                            if (Y < 232) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 232) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 12.5) {
                                            if (Y < 152) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 152) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 440) {
                                        if (X < 1080) {
                                            if (RANGE_MACRO_VALUE < 101.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 101.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1080) {
                                            if (MAX_MACRO_VALUE < 107.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 107.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 1112) {
                                if (MAX_MACRO_VALUE < 92.5) {
                                    if (X < 1400) {
                                        if (RANGE_MACRO_VALUE < 50.5) {
                                            if (MAX_MACRO_VALUE < 59.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 59.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 50.5) {
                                            if (MAX_MACRO_VALUE < 84.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 84.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1400) {
                                        if (MAX_MACRO_VALUE < 81.5) {
                                            if (RANGE_MACRO_VALUE < 12.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 12.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 81.5) {
                                            if (Y < 360) {
                                                oneCount++;
                                            }
                                            else if (Y >= 360) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 92.5) {
                                    if (MIN_MACRO_VALUE < 25.5) {
                                        if (MAX_MACRO_VALUE < 97.5) {
                                            if (MIN_MACRO_VALUE < 19.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 19.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 97.5) {
                                            if (X < 1208) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1208) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 25.5) {
                                        if (X < 1224) {
                                            if (Y < 312) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 312) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1224) {
                                            if (X < 1384) {
                                                oneCount++;
                                            }
                                            else if (X >= 1384) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 92.04) {
                            if (X < 1048) {
                                if (MIN_MACRO_VALUE < 22.5) {
                                    if (X < 968) {
                                        zeroCount++;
                                    }
                                    else if (X >= 968) {
                                        if (MAX_MACRO_VALUE < 191.5) {
                                            if (X < 1000) {
                                                oneCount++;
                                            }
                                            else if (X >= 1000) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 191.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 22.5) {
                                    if (MIN_MACRO_VALUE < 29.5) {
                                        if (AVG_MACRO_VALUE < 93.07) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 93.07) {
                                            if (AVG_MACRO_VALUE < 146.84) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 146.84) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 29.5) {
                                        if (RANGE_MACRO_VALUE < 156.5) {
                                            if (MAX_MACRO_VALUE < 171) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 171) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 156.5) {
                                            if (MAX_MACRO_VALUE < 204) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 204) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 1048) {
                                if (Y < 472) {
                                    if (MAX_MACRO_VALUE < 144) {
                                        if (RANGE_MACRO_VALUE < 83) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 83) {
                                            if (RANGE_MACRO_VALUE < 112) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 112) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 144) {
                                        if (Y < 72) {
                                            if (AVG_MACRO_VALUE < 132.87) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 132.87) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 72) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Y >= 472) {
                                    if (Y < 488) {
                                        if (AVG_MACRO_VALUE < 97.01) {
                                            if (AVG_MACRO_VALUE < 94.6) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 94.6) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 97.01) {
                                            if (RANGE_MACRO_VALUE < 107) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 107) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 488) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (Y >= 504) {
                        if (MIN_MACRO_VALUE < 21.5) {
                            if (Y < 536) {
                                if (AVG_MACRO_VALUE < 36.81) {
                                    if (RANGE_MACRO_VALUE < 70.5) {
                                        if (MAX_MACRO_VALUE < 19.5) {
                                            if (MAX_MACRO_VALUE < 18.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 18.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 19.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 70.5) {
                                        if (MAX_MACRO_VALUE < 100.5) {
                                            if (X < 1568) {
                                                oneCount++;
                                            }
                                            else if (X >= 1568) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 100.5) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                oneCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 36.81) {
                                    if (X < 1232) {
                                        zeroCount++;
                                    }
                                    else if (X >= 1232) {
                                        if (AVG_MACRO_VALUE < 52.03) {
                                            if (RANGE_MACRO_VALUE < 78) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 78) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 52.03) {
                                            if (RANGE_MACRO_VALUE < 102) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 102) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 536) {
                                if (X < 1560) {
                                    if (Y < 552) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 552) {
                                        if (X < 1400) {
                                            if (MIN_MACRO_VALUE < 19.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 19.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1400) {
                                            if (MIN_MACRO_VALUE < 20.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 20.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1560) {
                                    if (Y < 744) {
                                        if (X < 1720) {
                                            if (RANGE_MACRO_VALUE < 4.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 4.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1720) {
                                            if (RANGE_MACRO_VALUE < 3.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 3.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 744) {
                                        if (AVG_MACRO_VALUE < 105.45) {
                                            if (X < 1784) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1784) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 105.45) {
                                            if (Y < 856) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 856) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 21.5) {
                            if (Y < 520) {
                                if (AVG_MACRO_VALUE < 50.84) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 50.84) {
                                    if (MIN_MACRO_VALUE < 23.5) {
                                        if (MAX_MACRO_VALUE < 114.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 114.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 23.5) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            zeroCount++;
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            if (MIN_MACRO_VALUE < 32.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 32.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 520) {
                                if (MAX_MACRO_VALUE < 84.5) {
                                    if (AVG_MACRO_VALUE < 55.35) {
                                        if (Y < 584) {
                                            if (X < 1160) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1160) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 584) {
                                            if (Y < 760) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 760) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 55.35) {
                                        if (AVG_MACRO_VALUE < 55.86) {
                                            if (RANGE_MACRO_VALUE < 56.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 56.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 55.86) {
                                            if (Y < 968) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 968) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 84.5) {
                                    if (Y < 568) {
                                        if (MAX_MACRO_VALUE < 187.5) {
                                            if (AVG_MACRO_VALUE < 58.52) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 58.52) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 187.5) {
                                            if (MAX_MACRO_VALUE < 193.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 193.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 568) {
                                        if (AVG_MACRO_VALUE < 57.79) {
                                            if (X < 1496) {
                                                oneCount++;
                                            }
                                            else if (X >= 1496) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 57.79) {
                                            if (AVG_MACRO_VALUE < 73.73) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 73.73) {
                                                oneCount++;
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
        else if (MIN_MACRO_VALUE >= 33.5) {
            if (RANGE_MACRO_VALUE < 28.5) {
                if (X < 1224) {
                    if (Y < 440) {
                        if (MIN_MACRO_VALUE < 82.5) {
                            if (RANGE_MACRO_VALUE < 14.5) {
                                if (RANGE_MACRO_VALUE < 9.5) {
                                    if (MIN_MACRO_VALUE < 40.5) {
                                        if (X < 920) {
                                            if (MAX_MACRO_VALUE < 48.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 48.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 920) {
                                            if (MAX_MACRO_VALUE < 46.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 46.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 40.5) {
                                        if (AVG_MACRO_VALUE < 81.49) {
                                            if (AVG_MACRO_VALUE < 80.68) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 80.68) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 81.49) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 9.5) {
                                    if (RANGE_MACRO_VALUE < 10.5) {
                                        if (AVG_MACRO_VALUE < 81.91) {
                                            if (MIN_MACRO_VALUE < 51.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 51.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 81.91) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 10.5) {
                                        if (AVG_MACRO_VALUE < 40.32) {
                                            if (AVG_MACRO_VALUE < 39.64) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 39.64) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 40.32) {
                                            if (Y < 72) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 72) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 14.5) {
                                if (X < 600) {
                                    if (MIN_MACRO_VALUE < 73.5) {
                                        if (Y < 424) {
                                            if (Y < 392) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 392) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 424) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 73.5) {
                                        if (AVG_MACRO_VALUE < 87.35) {
                                            if (Y < 296) {
                                                oneCount++;
                                            }
                                            else if (Y >= 296) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 87.35) {
                                            if (MAX_MACRO_VALUE < 97.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 97.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 600) {
                                    if (X < 680) {
                                        if (Y < 360) {
                                            if (MIN_MACRO_VALUE < 47.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 47.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 360) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 680) {
                                        if (AVG_MACRO_VALUE < 42.15) {
                                            if (X < 776) {
                                                zeroCount++;
                                            }
                                            else if (X >= 776) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.15) {
                                            if (X < 728) {
                                                zeroCount++;
                                            }
                                            else if (X >= 728) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 82.5) {
                            if (AVG_MACRO_VALUE < 94.39) {
                                if (Y < 152) {
                                    if (Y < 136) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 136) {
                                        if (MIN_MACRO_VALUE < 83.5) {
                                            if (AVG_MACRO_VALUE < 87.59) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 87.59) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 83.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Y >= 152) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 94.39) {
                                if (X < 568) {
                                    if (MIN_MACRO_VALUE < 112.5) {
                                        if (RANGE_MACRO_VALUE < 6.5) {
                                            if (X < 456) {
                                                oneCount++;
                                            }
                                            else if (X >= 456) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 6.5) {
                                            if (AVG_MACRO_VALUE < 109.36) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 109.36) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 112.5) {
                                        if (MAX_MACRO_VALUE < 155.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 155.5) {
                                            if (X < 72) {
                                                zeroCount++;
                                            }
                                            else if (X >= 72) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 568) {
                                    if (AVG_MACRO_VALUE < 124.59) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 124.59) {
                                        if (X < 760) {
                                            if (X < 616) {
                                                zeroCount++;
                                            }
                                            else if (X >= 616) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 760) {
                                            if (RANGE_MACRO_VALUE < 10.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 10.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Y >= 440) {
                        if (AVG_MACRO_VALUE < 47.79) {
                            if (X < 680) {
                                if (MIN_MACRO_VALUE < 41.5) {
                                    if (X < 616) {
                                        if (AVG_MACRO_VALUE < 43.29) {
                                            if (Y < 600) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 600) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 43.29) {
                                            if (AVG_MACRO_VALUE < 43.53) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 43.53) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 616) {
                                        zeroCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 41.5) {
                                    if (X < 408) {
                                        if (Y < 984) {
                                            if (RANGE_MACRO_VALUE < 8.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 8.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 984) {
                                            if (AVG_MACRO_VALUE < 46.2) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 46.2) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 408) {
                                        if (Y < 664) {
                                            if (RANGE_MACRO_VALUE < 10.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 10.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 664) {
                                            if (AVG_MACRO_VALUE < 46.46) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 46.46) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 680) {
                                if (X < 1144) {
                                    if (AVG_MACRO_VALUE < 41.72) {
                                        if (X < 824) {
                                            zeroCount++;
                                        }
                                        else if (X >= 824) {
                                            if (AVG_MACRO_VALUE < 41.12) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 41.12) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 41.72) {
                                        if (AVG_MACRO_VALUE < 44.35) {
                                            if (RANGE_MACRO_VALUE < 9.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 9.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 44.35) {
                                            if (AVG_MACRO_VALUE < 44.47) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 44.47) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1144) {
                                    if (RANGE_MACRO_VALUE < 13.5) {
                                        if (RANGE_MACRO_VALUE < 8.5) {
                                            if (X < 1192) {
                                                oneCount++;
                                            }
                                            else if (X >= 1192) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 8.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 13.5) {
                                        if (RANGE_MACRO_VALUE < 17.5) {
                                            if (X < 1176) {
                                                oneCount++;
                                            }
                                            else if (X >= 1176) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 17.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 47.79) {
                            if (MIN_MACRO_VALUE < 110.5) {
                                if (Y < 776) {
                                    if (X < 376) {
                                        if (RANGE_MACRO_VALUE < 18.5) {
                                            if (MAX_MACRO_VALUE < 111.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 111.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 18.5) {
                                            if (RANGE_MACRO_VALUE < 20.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 20.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 376) {
                                        if (RANGE_MACRO_VALUE < 2.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 2.5) {
                                            if (AVG_MACRO_VALUE < 95.86) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 95.86) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 776) {
                                    if (MIN_MACRO_VALUE < 96.5) {
                                        if (Y < 904) {
                                            if (MAX_MACRO_VALUE < 117.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 117.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 904) {
                                            if (RANGE_MACRO_VALUE < 3.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 3.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 96.5) {
                                        if (Y < 936) {
                                            if (RANGE_MACRO_VALUE < 12.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 12.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 936) {
                                            if (MAX_MACRO_VALUE < 126.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 126.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 110.5) {
                                if (AVG_MACRO_VALUE < 149.09) {
                                    if (Y < 856) {
                                        if (Y < 840) {
                                            if (AVG_MACRO_VALUE < 139.69) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 139.69) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 840) {
                                            if (X < 808) {
                                                oneCount++;
                                            }
                                            else if (X >= 808) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 856) {
                                        if (MAX_MACRO_VALUE < 124.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 124.5) {
                                            if (X < 168) {
                                                oneCount++;
                                            }
                                            else if (X >= 168) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 149.09) {
                                    if (Y < 920) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 920) {
                                        if (Y < 936) {
                                            if (AVG_MACRO_VALUE < 161.07) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 161.07) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 936) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (X >= 1224) {
                    if (MIN_MACRO_VALUE < 168.5) {
                        if (Y < 440) {
                            if (RANGE_MACRO_VALUE < 5.5) {
                                if (Y < 296) {
                                    if (AVG_MACRO_VALUE < 164.75) {
                                        if (MIN_MACRO_VALUE < 154.5) {
                                            if (Y < 24) {
                                                oneCount++;
                                            }
                                            else if (Y >= 24) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 154.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 164.75) {
                                        if (Y < 136) {
                                            if (X < 1384) {
                                                oneCount++;
                                            }
                                            else if (X >= 1384) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 136) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Y >= 296) {
                                    zeroCount++;
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 5.5) {
                                if (MAX_MACRO_VALUE < 87.5) {
                                    if (MAX_MACRO_VALUE < 83.5) {
                                        if (AVG_MACRO_VALUE < 40.56) {
                                            if (X < 1784) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1784) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 40.56) {
                                            if (Y < 392) {
                                                oneCount++;
                                            }
                                            else if (Y >= 392) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 83.5) {
                                        if (X < 1880) {
                                            zeroCount++;
                                        }
                                        else if (X >= 1880) {
                                            if (AVG_MACRO_VALUE < 76.58) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 76.58) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 87.5) {
                                    if (MAX_MACRO_VALUE < 106.5) {
                                        if (Y < 200) {
                                            if (AVG_MACRO_VALUE < 72.99) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 72.99) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 200) {
                                            if (MIN_MACRO_VALUE < 69.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 69.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 106.5) {
                                        if (Y < 360) {
                                            if (RANGE_MACRO_VALUE < 6.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 6.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 360) {
                                            if (MIN_MACRO_VALUE < 92.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 92.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (Y >= 440) {
                            if (MIN_MACRO_VALUE < 133.5) {
                                if (AVG_MACRO_VALUE < 134.39) {
                                    if (Y < 664) {
                                        if (Y < 568) {
                                            if (MAX_MACRO_VALUE < 41) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 41) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 568) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 664) {
                                        if (MIN_MACRO_VALUE < 38.5) {
                                            if (AVG_MACRO_VALUE < 47.95) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 47.95) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 38.5) {
                                            if (AVG_MACRO_VALUE < 46.89) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 46.89) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 134.39) {
                                    zeroCount++;
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 133.5) {
                                if (X < 1256) {
                                    if (Y < 1000) {
                                        if (Y < 984) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 984) {
                                            if (X < 1240) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1240) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 1000) {
                                        if (Y < 1016) {
                                            if (MAX_MACRO_VALUE < 145.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 145.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 1016) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (X >= 1256) {
                                    if (X < 1304) {
                                        if (AVG_MACRO_VALUE < 153.78) {
                                            if (MAX_MACRO_VALUE < 139.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 139.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 153.78) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 1304) {
                                        if (X < 1480) {
                                            zeroCount++;
                                        }
                                        else if (X >= 1480) {
                                            if (Y < 472) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 472) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 168.5) {
                        zeroCount++;
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 28.5) {
                if (RANGE_MACRO_VALUE < 116.5) {
                    if (AVG_MACRO_VALUE < 54.06) {
                        if (MAX_MACRO_VALUE < 113.5) {
                            if (MAX_MACRO_VALUE < 111.5) {
                                if (RANGE_MACRO_VALUE < 33.5) {
                                    if (AVG_MACRO_VALUE < 42.21) {
                                        if (Y < 928) {
                                            if (MAX_MACRO_VALUE < 27) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 27) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 928) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 42.21) {
                                        if (X < 872) {
                                            if (AVG_MACRO_VALUE < 44.74) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 44.74) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 872) {
                                            if (X < 1752) {
                                                oneCount++;
                                            }
                                            else if (X >= 1752) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 33.5) {
                                    if (X < 1800) {
                                        if (AVG_MACRO_VALUE < 53.89) {
                                            if (Y < 936) {
                                                oneCount++;
                                            }
                                            else if (Y >= 936) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 53.89) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 1800) {
                                        if (AVG_MACRO_VALUE < 52.4) {
                                            if (MAX_MACRO_VALUE < 76) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 76) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 52.4) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 111.5) {
                                if (Y < 488) {
                                    if (RANGE_MACRO_VALUE < 77.5) {
                                        if (RANGE_MACRO_VALUE < 74.5) {
                                            if (Y < 272) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 272) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 74.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 77.5) {
                                        oneCount++;
                                    }
                                }
                                else if (Y >= 488) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 113.5) {
                            if (X < 1768) {
                                if (Y < 296) {
                                    zeroCount++;
                                }
                                else if (Y >= 296) {
                                    if (Y < 312) {
                                        if (RANGE_MACRO_VALUE < 93.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 93.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 312) {
                                        if (X < 232) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                oneCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 232) {
                                            if (X < 1704) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1704) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 1768) {
                                if (X < 1832) {
                                    if (RANGE_MACRO_VALUE < 113.5) {
                                        oneCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 113.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (X >= 1832) {
                                    if (X < 1848) {
                                        if (MIN_MACRO_VALUE < 41.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 41.5) {
                                            if (AVG_MACRO_VALUE < 50.25) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 50.25) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1848) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 54.06) {
                        if (AVG_MACRO_VALUE < 134.48) {
                            if (MIN_MACRO_VALUE < 90.5) {
                                if (MAX_MACRO_VALUE < 202) {
                                    if (MAX_MACRO_VALUE < 192.5) {
                                        if (Y < 536) {
                                            if (RANGE_MACRO_VALUE < 80.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 80.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 536) {
                                            if (RANGE_MACRO_VALUE < 43.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 43.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 192.5) {
                                        if (X < 768) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                zeroCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 768) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 202) {
                                    oneCount++;
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 90.5) {
                                if (MIN_MACRO_VALUE < 119.5) {
                                    if (X < 904) {
                                        if (MAX_MACRO_VALUE < 191.5) {
                                            if (RANGE_MACRO_VALUE < 72.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 72.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 191.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 904) {
                                        if (MAX_MACRO_VALUE < 150.5) {
                                            if (RANGE_MACRO_VALUE < 46.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 46.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 150.5) {
                                            if (AVG_MACRO_VALUE < 129.36) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 129.36) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 119.5) {
                                    if (AVG_MACRO_VALUE < 134.22) {
                                        if (X < 1768) {
                                            if (AVG_MACRO_VALUE < 124.68) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 124.68) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1768) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 134.22) {
                                        if (X < 1408) {
                                            oneCount++;
                                        }
                                        else if (X >= 1408) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 134.48) {
                            if (AVG_MACRO_VALUE < 135.26) {
                                if (X < 488) {
                                    if (Y < 1024) {
                                        if (Y < 920) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 920) {
                                            if (X < 120) {
                                                oneCount++;
                                            }
                                            else if (X >= 120) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 1024) {
                                        oneCount++;
                                    }
                                }
                                else if (X >= 488) {
                                    if (X < 1120) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            if (MIN_MACRO_VALUE < 111.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 111.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 1120) {
                                        if (RANGE_MACRO_VALUE < 96) {
                                            if (MIN_MACRO_VALUE < 124.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 124.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 96) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 135.26) {
                                if (MIN_MACRO_VALUE < 47.5) {
                                    if (RANGE_MACRO_VALUE < 113.5) {
                                        if (MAX_MACRO_VALUE < 155.5) {
                                            if (MIN_MACRO_VALUE < 44.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 44.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 155.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 113.5) {
                                        oneCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 47.5) {
                                    if (AVG_MACRO_VALUE < 135.38) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 135.38) {
                                        if (MIN_MACRO_VALUE < 61.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 61.5) {
                                            if (MAX_MACRO_VALUE < 161.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 161.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 116.5) {
                    if (X < 568) {
                        if (Y < 936) {
                            if (Y < 216) {
                                if (MIN_MACRO_VALUE < 46.5) {
                                    if (RANGE_MACRO_VALUE < 190) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 190) {
                                        if (X < 360) {
                                            zeroCount++;
                                        }
                                        else if (X >= 360) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 46.5) {
                                    if (MIN_MACRO_VALUE < 90.5) {
                                        if (RANGE_MACRO_VALUE < 119.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 119.5) {
                                            if (RANGE_MACRO_VALUE < 153.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 153.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 90.5) {
                                        if (X < 272) {
                                            zeroCount++;
                                        }
                                        else if (X >= 272) {
                                            if (Y < 88) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 88) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 216) {
                                if (Y < 424) {
                                    if (X < 136) {
                                        if (RANGE_MACRO_VALUE < 123.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 123.5) {
                                            if (X < 40) {
                                                zeroCount++;
                                            }
                                            else if (X >= 40) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 136) {
                                        if (Y < 248) {
                                            if (MAX_MACRO_VALUE < 217.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 217.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 248) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Y >= 424) {
                                    if (X < 520) {
                                        if (AVG_MACRO_VALUE < 132.12) {
                                            if (AVG_MACRO_VALUE < 80.64) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 80.64) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 132.12) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 520) {
                                        if (AVG_MACRO_VALUE < 103.59) {
                                            if (X < 536) {
                                                oneCount++;
                                            }
                                            else if (X >= 536) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 103.59) {
                                            if (MAX_MACRO_VALUE < 187) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 187) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (Y >= 936) {
                            if (RANGE_MACRO_VALUE < 135.5) {
                                if (Y < 968) {
                                    if (MAX_MACRO_VALUE < 173) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 173) {
                                        oneCount++;
                                    }
                                }
                                else if (Y >= 968) {
                                    zeroCount++;
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 135.5) {
                                if (AVG_MACRO_VALUE < 160.33) {
                                    if (RANGE_MACRO_VALUE < 179) {
                                        if (X < 96) {
                                            zeroCount++;
                                        }
                                        else if (X >= 96) {
                                            if (RANGE_MACRO_VALUE < 148.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 148.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 179) {
                                        if (Y < 992) {
                                            oneCount++;
                                        }
                                        else if (Y >= 992) {
                                            if (RANGE_MACRO_VALUE < 194) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 194) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 160.33) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (X >= 568) {
                        if (Y < 1016) {
                            if (AVG_MACRO_VALUE < 189.6) {
                                if (X < 712) {
                                    if (RANGE_MACRO_VALUE < 135.5) {
                                        if (AVG_MACRO_VALUE < 187.38) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                zeroCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 187.38) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 135.5) {
                                        if (MAX_MACRO_VALUE < 218) {
                                            if (AVG_MACRO_VALUE < 140.08) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 140.08) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 218) {
                                            if (RANGE_MACRO_VALUE < 186.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 186.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 712) {
                                    if (AVG_MACRO_VALUE < 64.52) {
                                        if (MIN_MACRO_VALUE < 34.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 34.5) {
                                            if (Y < 184) {
                                                oneCount++;
                                            }
                                            else if (Y >= 184) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 64.52) {
                                        if (MIN_MACRO_VALUE < 59.5) {
                                            if (AVG_MACRO_VALUE < 84.89) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 84.89) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 59.5) {
                                            if (Y < 472) {
                                                oneCount++;
                                            }
                                            else if (Y >= 472) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 189.6) {
                                if (MAX_MACRO_VALUE < 235.5) {
                                    zeroCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 235.5) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (Y >= 1016) {
                            if (MIN_MACRO_VALUE < 51.5) {
                                if (X < 952) {
                                    zeroCount++;
                                }
                                else if (X >= 952) {
                                    if (MIN_MACRO_VALUE < 36.5) {
                                        zeroCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 36.5) {
                                        if (AVG_MACRO_VALUE < 53.92) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 53.92) {
                                            if (Y < 1048) {
                                                oneCount++;
                                            }
                                            else if (Y >= 1048) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 51.5) {
                                if (MIN_MACRO_VALUE < 52.5) {
                                    if (MAX_MACRO_VALUE < 214.5) {
                                        oneCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 214.5) {
                                        oneCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 52.5) {
                                    if (MAX_MACRO_VALUE < 228) {
                                        if (MAX_MACRO_VALUE < 225.5) {
                                            if (RANGE_MACRO_VALUE < 165.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 165.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 225.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 228) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

    //TREE 2
    if (RANGE_MACRO_VALUE < 26.5) {
            if (X < 1272) {
                if (AVG_MACRO_VALUE < 36.6) {
                    if (RANGE_MACRO_VALUE < 6.5) {
                        if (Y < 744) {
                            if (Y < 168) {
                                if (X < 344) {
                                    if (AVG_MACRO_VALUE < 22.29) {
                                        if (X < 328) {
                                            if (X < 136) {
                                                zeroCount++;
                                            }
                                            else if (X >= 136) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 328) {
                                            if (MAX_MACRO_VALUE < 20) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 20) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 22.29) {
                                        zeroCount++;
                                    }
                                }
                                else if (X >= 344) {
                                    if (Y < 8) {
                                        if (AVG_MACRO_VALUE < 17.51) {
                                            if (X < 984) {
                                                oneCount++;
                                            }
                                            else if (X >= 984) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.51) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 8) {
                                        if (AVG_MACRO_VALUE < 35.79) {
                                            if (AVG_MACRO_VALUE < 32.72) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 32.72) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 35.79) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Y >= 168) {
                                if (MAX_MACRO_VALUE < 16.5) {
                                    if (Y < 512) {
                                        if (Y < 488) {
                                            if (X < 1080) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1080) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 488) {
                                            if (X < 1064) {
                                                oneCount++;
                                            }
                                            else if (X >= 1064) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 512) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 16.5) {
                                    if (AVG_MACRO_VALUE < 29.17) {
                                        if (AVG_MACRO_VALUE < 24.77) {
                                            if (Y < 392) {
                                                oneCount++;
                                            }
                                            else if (Y >= 392) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 24.77) {
                                            if (AVG_MACRO_VALUE < 25.32) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 25.32) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 29.17) {
                                        if (Y < 200) {
                                            if (AVG_MACRO_VALUE < 29.55) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 29.55) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 200) {
                                            if (Y < 360) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 360) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (Y >= 744) {
                            if (X < 408) {
                                if (MAX_MACRO_VALUE < 30.5) {
                                    if (Y < 808) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 808) {
                                        if (X < 392) {
                                            if (Y < 1016) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 1016) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 392) {
                                            if (RANGE_MACRO_VALUE < 1.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 1.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 30.5) {
                                    if (X < 264) {
                                        if (AVG_MACRO_VALUE < 35.94) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 35.94) {
                                            if (AVG_MACRO_VALUE < 36.03) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 36.03) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 264) {
                                        if (MAX_MACRO_VALUE < 35.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 35.5) {
                                            if (RANGE_MACRO_VALUE < 1.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 1.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 408) {
                                if (AVG_MACRO_VALUE < 19.47) {
                                    if (X < 824) {
                                        zeroCount++;
                                    }
                                    else if (X >= 824) {
                                        if (AVG_MACRO_VALUE < 18.87) {
                                            if (RANGE_MACRO_VALUE < 1.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 1.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 18.87) {
                                            if (RANGE_MACRO_VALUE < 5.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 5.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 19.47) {
                                    if (MAX_MACRO_VALUE < 35.5) {
                                        if (X < 488) {
                                            if (X < 472) {
                                                zeroCount++;
                                            }
                                            else if (X >= 472) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 488) {
                                            if (MIN_MACRO_VALUE < 28.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 28.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 35.5) {
                                        if (AVG_MACRO_VALUE < 33.57) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 33.57) {
                                            if (RANGE_MACRO_VALUE < 1.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 1.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 6.5) {
                        if (Y < 440) {
                            if (X < 488) {
                                if (Y < 168) {
                                    if (MIN_MACRO_VALUE < 23.5) {
                                        if (Y < 48) {
                                            if (AVG_MACRO_VALUE < 23.83) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 23.83) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 48) {
                                            if (MAX_MACRO_VALUE < 42.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 42.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 23.5) {
                                        if (AVG_MACRO_VALUE < 26.43) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 26.43) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Y >= 168) {
                                    zeroCount++;
                                }
                            }
                            else if (X >= 488) {
                                if (Y < 392) {
                                    if (X < 1096) {
                                        if (MAX_MACRO_VALUE < 30.5) {
                                            if (X < 1008) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1008) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 30.5) {
                                            if (Y < 152) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 152) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1096) {
                                        zeroCount++;
                                    }
                                }
                                else if (Y >= 392) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (Y >= 440) {
                            if (X < 1192) {
                                if (Y < 472) {
                                    if (X < 792) {
                                        zeroCount++;
                                    }
                                    else if (X >= 792) {
                                        if (RANGE_MACRO_VALUE < 11.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 11.5) {
                                            if (X < 984) {
                                                oneCount++;
                                            }
                                            else if (X >= 984) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 472) {
                                    if (MAX_MACRO_VALUE < 50.5) {
                                        if (AVG_MACRO_VALUE < 36.58) {
                                            if (X < 1160) {
                                                oneCount++;
                                            }
                                            else if (X >= 1160) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 36.58) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 50.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (X >= 1192) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 36.6) {
                    if (Y < 904) {
                        if (MIN_MACRO_VALUE < 41.5) {
                            if (MAX_MACRO_VALUE < 62.5) {
                                if (Y < 680) {
                                    if (RANGE_MACRO_VALUE < 25.5) {
                                        if (Y < 616) {
                                            if (RANGE_MACRO_VALUE < 21.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 21.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 616) {
                                            if (MIN_MACRO_VALUE < 38.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 38.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 25.5) {
                                        if (AVG_MACRO_VALUE < 47.04) {
                                            if (Y < 512) {
                                                oneCount++;
                                            }
                                            else if (Y >= 512) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 47.04) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Y >= 680) {
                                    if (RANGE_MACRO_VALUE < 22.5) {
                                        if (Y < 696) {
                                            if (X < 296) {
                                                zeroCount++;
                                            }
                                            else if (X >= 296) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 696) {
                                            if (RANGE_MACRO_VALUE < 11.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 11.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 22.5) {
                                        if (Y < 696) {
                                            if (MAX_MACRO_VALUE < 53) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 53) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 696) {
                                            if (RANGE_MACRO_VALUE < 24.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 24.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 62.5) {
                                if (X < 984) {
                                    if (Y < 584) {
                                        if (RANGE_MACRO_VALUE < 24.5) {
                                            if (X < 672) {
                                                zeroCount++;
                                            }
                                            else if (X >= 672) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 24.5) {
                                            if (Y < 24) {
                                                oneCount++;
                                            }
                                            else if (Y >= 24) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 584) {
                                        zeroCount++;
                                    }
                                }
                                else if (X >= 984) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 41.5) {
                            if (AVG_MACRO_VALUE < 46.29) {
                                if (X < 680) {
                                    if (AVG_MACRO_VALUE < 45.26) {
                                        if (Y < 872) {
                                            if (RANGE_MACRO_VALUE < 5.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 5.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 872) {
                                            if (AVG_MACRO_VALUE < 43.84) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 43.84) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 45.26) {
                                        if (RANGE_MACRO_VALUE < 7.5) {
                                            if (Y < 712) {
                                                oneCount++;
                                            }
                                            else if (Y >= 712) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 7.5) {
                                            if (Y < 472) {
                                                oneCount++;
                                            }
                                            else if (Y >= 472) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 680) {
                                    if (X < 1080) {
                                        if (RANGE_MACRO_VALUE < 6.5) {
                                            if (AVG_MACRO_VALUE < 44.78) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 44.78) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 6.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 1080) {
                                        if (X < 1112) {
                                            if (Y < 440) {
                                                oneCount++;
                                            }
                                            else if (Y >= 440) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1112) {
                                            if (RANGE_MACRO_VALUE < 6.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 6.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 46.29) {
                                if (MAX_MACRO_VALUE < 49.5) {
                                    if (Y < 272) {
                                        if (X < 648) {
                                            if (X < 624) {
                                                zeroCount++;
                                            }
                                            else if (X >= 624) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 648) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 272) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 49.5) {
                                    if (X < 408) {
                                        if (X < 136) {
                                            if (RANGE_MACRO_VALUE < 19.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 19.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 136) {
                                            if (MAX_MACRO_VALUE < 113.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 113.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 408) {
                                        if (Y < 872) {
                                            if (X < 1128) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1128) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 872) {
                                            if (MAX_MACRO_VALUE < 62.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 62.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Y >= 904) {
                        if (MIN_MACRO_VALUE < 93.5) {
                            if (MAX_MACRO_VALUE < 101.5) {
                                if (RANGE_MACRO_VALUE < 3.5) {
                                    if (AVG_MACRO_VALUE < 77.3) {
                                        if (X < 936) {
                                            if (X < 120) {
                                                oneCount++;
                                            }
                                            else if (X >= 120) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 936) {
                                            if (RANGE_MACRO_VALUE < 1.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 1.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 77.3) {
                                        if (AVG_MACRO_VALUE < 93) {
                                            if (Y < 984) {
                                                oneCount++;
                                            }
                                            else if (Y >= 984) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 93) {
                                            if (AVG_MACRO_VALUE < 93.01) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 93.01) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 3.5) {
                                    if (AVG_MACRO_VALUE < 86.48) {
                                        if (X < 968) {
                                            if (X < 824) {
                                                zeroCount++;
                                            }
                                            else if (X >= 824) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 968) {
                                            if (X < 1144) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1144) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 86.48) {
                                        if (X < 472) {
                                            if (Y < 984) {
                                                oneCount++;
                                            }
                                            else if (Y >= 984) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 472) {
                                            if (MIN_MACRO_VALUE < 81.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 81.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 101.5) {
                                if (X < 792) {
                                    if (MIN_MACRO_VALUE < 89.5) {
                                        if (X < 776) {
                                            if (Y < 1000) {
                                                oneCount++;
                                            }
                                            else if (Y >= 1000) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 776) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 89.5) {
                                        if (RANGE_MACRO_VALUE < 19.5) {
                                            if (Y < 1000) {
                                                oneCount++;
                                            }
                                            else if (Y >= 1000) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 19.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (X >= 792) {
                                    if (X < 840) {
                                        if (X < 808) {
                                            oneCount++;
                                        }
                                        else if (X >= 808) {
                                            if (AVG_MACRO_VALUE < 101.21) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 101.21) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 840) {
                                        if (X < 944) {
                                            zeroCount++;
                                        }
                                        else if (X >= 944) {
                                            if (Y < 920) {
                                                oneCount++;
                                            }
                                            else if (Y >= 920) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 93.5) {
                            if (AVG_MACRO_VALUE < 102.5) {
                                if (AVG_MACRO_VALUE < 102.12) {
                                    if (Y < 968) {
                                        if (X < 1008) {
                                            if (AVG_MACRO_VALUE < 102.1) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 102.1) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1008) {
                                            if (X < 1064) {
                                                oneCount++;
                                            }
                                            else if (X >= 1064) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 968) {
                                        if (MIN_MACRO_VALUE < 99.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 99.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 102.12) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 102.5) {
                                if (MAX_MACRO_VALUE < 151.5) {
                                    if (AVG_MACRO_VALUE < 102.74) {
                                        if (RANGE_MACRO_VALUE < 12.5) {
                                            if (RANGE_MACRO_VALUE < 5.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 5.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 12.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 102.74) {
                                        if (MAX_MACRO_VALUE < 141.5) {
                                            if (MIN_MACRO_VALUE < 128.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 128.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 141.5) {
                                            if (MIN_MACRO_VALUE < 137.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 137.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 151.5) {
                                    if (X < 168) {
                                        if (Y < 920) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 920) {
                                            if (Y < 936) {
                                                oneCount++;
                                            }
                                            else if (Y >= 936) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 168) {
                                        if (RANGE_MACRO_VALUE < 25.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 25.5) {
                                            if (X < 1040) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1040) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (X >= 1272) {
                if (MAX_MACRO_VALUE < 44.5) {
                    if (AVG_MACRO_VALUE < 37.1) {
                        if (AVG_MACRO_VALUE < 37.09) {
                            if (MIN_MACRO_VALUE < 31.5) {
                                if (RANGE_MACRO_VALUE < 23.5) {
                                    if (AVG_MACRO_VALUE < 33.98) {
                                        if (AVG_MACRO_VALUE < 33.92) {
                                            if (Y < 1000) {
                                                oneCount++;
                                            }
                                            else if (Y >= 1000) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 33.92) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 33.98) {
                                        if (Y < 584) {
                                            if (X < 1832) {
                                                oneCount++;
                                            }
                                            else if (X >= 1832) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 584) {
                                            if (X < 1816) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1816) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 23.5) {
                                    if (X < 1824) {
                                        if (X < 1736) {
                                            if (AVG_MACRO_VALUE < 24.67) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 24.67) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1736) {
                                            if (MAX_MACRO_VALUE < 43.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 43.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1824) {
                                        if (AVG_MACRO_VALUE < 36.15) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 36.15) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 31.5) {
                                if (X < 1560) {
                                    zeroCount++;
                                }
                                else if (X >= 1560) {
                                    if (AVG_MACRO_VALUE < 36.5) {
                                        if (AVG_MACRO_VALUE < 36.47) {
                                            if (RANGE_MACRO_VALUE < 6.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 6.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 36.47) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 36.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 37.09) {
                            oneCount++;
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 37.1) {
                        if (X < 1560) {
                            zeroCount++;
                        }
                        else if (X >= 1560) {
                            if (AVG_MACRO_VALUE < 40.59) {
                                if (MAX_MACRO_VALUE < 43.5) {
                                    if (Y < 80) {
                                        oneCount++;
                                    }
                                    else if (Y >= 80) {
                                        if (MIN_MACRO_VALUE < 35.5) {
                                            if (RANGE_MACRO_VALUE < 17.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 17.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 35.5) {
                                            if (AVG_MACRO_VALUE < 39.13) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 39.13) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 43.5) {
                                    if (Y < 936) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 936) {
                                        if (Y < 960) {
                                            oneCount++;
                                        }
                                        else if (Y >= 960) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 40.59) {
                                if (RANGE_MACRO_VALUE < 5.5) {
                                    zeroCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 5.5) {
                                    if (X < 1608) {
                                        if (RANGE_MACRO_VALUE < 7) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 7) {
                                            oneCount++;
                                        }
                                    }
                                    else if (X >= 1608) {
                                        if (MIN_MACRO_VALUE < 37) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 37) {
                                            if (X < 1744) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1744) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 44.5) {
                    if (MIN_MACRO_VALUE < 39.5) {
                        if (MIN_MACRO_VALUE < 22.5) {
                            if (MAX_MACRO_VALUE < 45.5) {
                                if (Y < 568) {
                                    if (RANGE_MACRO_VALUE < 23.5) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            if (Y < 392) {
                                                oneCount++;
                                            }
                                            else if (Y >= 392) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 23.5) {
                                        if (AVG_MACRO_VALUE < 29.44) {
                                            if (RANGE_MACRO_VALUE < 25.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 25.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 29.44) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Y >= 568) {
                                    if (RANGE_MACRO_VALUE < 23.5) {
                                        if (Y < 760) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 760) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 23.5) {
                                        if (Y < 728) {
                                            oneCount++;
                                        }
                                        else if (Y >= 728) {
                                            if (X < 1680) {
                                                oneCount++;
                                            }
                                            else if (X >= 1680) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 45.5) {
                                if (AVG_MACRO_VALUE < 27.6) {
                                    oneCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 27.6) {
                                    if (Y < 864) {
                                        if (AVG_MACRO_VALUE < 31.35) {
                                            if (AVG_MACRO_VALUE < 30.93) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 30.93) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 31.35) {
                                            if (AVG_MACRO_VALUE < 33.46) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 33.46) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 864) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 22.5) {
                            if (Y < 376) {
                                if (MIN_MACRO_VALUE < 26.5) {
                                    if (Y < 40) {
                                        if (X < 1680) {
                                            zeroCount++;
                                        }
                                        else if (X >= 1680) {
                                            if (Y < 24) {
                                                oneCount++;
                                            }
                                            else if (Y >= 24) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 40) {
                                        if (X < 1880) {
                                            zeroCount++;
                                        }
                                        else if (X >= 1880) {
                                            if (Y < 264) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 264) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 26.5) {
                                    if (Y < 72) {
                                        if (AVG_MACRO_VALUE < 42.32) {
                                            if (Y < 8) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 8) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.32) {
                                            if (X < 1704) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1704) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 72) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (Y >= 376) {
                                if (X < 1608) {
                                    if (X < 1320) {
                                        zeroCount++;
                                    }
                                    else if (X >= 1320) {
                                        if (MAX_MACRO_VALUE < 50.5) {
                                            if (MAX_MACRO_VALUE < 49.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 49.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 50.5) {
                                            if (Y < 552) {
                                                oneCount++;
                                            }
                                            else if (Y >= 552) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1608) {
                                    if (AVG_MACRO_VALUE < 45.77) {
                                        if (Y < 872) {
                                            if (MIN_MACRO_VALUE < 38.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 38.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 872) {
                                            if (MAX_MACRO_VALUE < 56.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 56.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 45.77) {
                                        if (MAX_MACRO_VALUE < 55.5) {
                                            if (Y < 664) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 664) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 55.5) {
                                            if (MIN_MACRO_VALUE < 35.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 35.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 39.5) {
                        if (AVG_MACRO_VALUE < 46.78) {
                            if (X < 1368) {
                                zeroCount++;
                            }
                            else if (X >= 1368) {
                                if (Y < 24) {
                                    if (X < 1864) {
                                        if (RANGE_MACRO_VALUE < 4.5) {
                                            if (AVG_MACRO_VALUE < 44.1) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 44.1) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 4.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 1864) {
                                        if (MIN_MACRO_VALUE < 42.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 42.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Y >= 24) {
                                    if (AVG_MACRO_VALUE < 44.11) {
                                        if (Y < 40) {
                                            if (X < 1736) {
                                                oneCount++;
                                            }
                                            else if (X >= 1736) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 40) {
                                            if (Y < 72) {
                                                oneCount++;
                                            }
                                            else if (Y >= 72) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 44.11) {
                                        if (AVG_MACRO_VALUE < 45.75) {
                                            if (MIN_MACRO_VALUE < 41.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 41.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 45.75) {
                                            if (MAX_MACRO_VALUE < 51.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 51.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 46.78) {
                            if (X < 1368) {
                                if (RANGE_MACRO_VALUE < 10.5) {
                                    if (MIN_MACRO_VALUE < 44.5) {
                                        if (AVG_MACRO_VALUE < 47.75) {
                                            if (MAX_MACRO_VALUE < 51.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 51.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 47.75) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 44.5) {
                                        if (X < 1304) {
                                            if (AVG_MACRO_VALUE < 126.58) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 126.58) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1304) {
                                            if (AVG_MACRO_VALUE < 102.94) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 102.94) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 10.5) {
                                    if (Y < 424) {
                                        if (MAX_MACRO_VALUE < 78.5) {
                                            if (RANGE_MACRO_VALUE < 12.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 12.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 78.5) {
                                            if (AVG_MACRO_VALUE < 154.58) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 154.58) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 424) {
                                        if (Y < 984) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 984) {
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
                            else if (X >= 1368) {
                                if (Y < 280) {
                                    if (X < 1784) {
                                        if (MAX_MACRO_VALUE < 71.5) {
                                            if (AVG_MACRO_VALUE < 48.63) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 48.63) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 71.5) {
                                            if (Y < 152) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 152) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1784) {
                                        if (MAX_MACRO_VALUE < 53.5) {
                                            if (X < 1848) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1848) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 53.5) {
                                            if (MAX_MACRO_VALUE < 54.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 54.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 280) {
                                    if (AVG_MACRO_VALUE < 109.56) {
                                        if (Y < 440) {
                                            if (AVG_MACRO_VALUE < 48.83) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 48.83) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 440) {
                                            if (X < 1464) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1464) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 109.56) {
                                        if (X < 1480) {
                                            if (MIN_MACRO_VALUE < 109.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 109.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1480) {
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
                        }
                    }
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 26.5) {
            if (Y < 584) {
                if (Y < 568) {
                    if (X < 1048) {
                        if (X < 664) {
                            if (MAX_MACRO_VALUE < 115.5) {
                                if (MAX_MACRO_VALUE < 111.5) {
                                    if (MIN_MACRO_VALUE < 72.5) {
                                        if (X < 344) {
                                            if (X < 8) {
                                                oneCount++;
                                            }
                                            else if (X >= 8) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 344) {
                                            if (MIN_MACRO_VALUE < 41.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 41.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 72.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 111.5) {
                                    if (MIN_MACRO_VALUE < 40.5) {
                                        if (RANGE_MACRO_VALUE < 81.5) {
                                            if (MAX_MACRO_VALUE < 112.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 112.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 81.5) {
                                            if (AVG_MACRO_VALUE < 64.39) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 64.39) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 40.5) {
                                        if (AVG_MACRO_VALUE < 79.99) {
                                            if (AVG_MACRO_VALUE < 66.69) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 66.69) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 79.99) {
                                            if (AVG_MACRO_VALUE < 81.93) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 81.93) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 115.5) {
                                if (MIN_MACRO_VALUE < 49.5) {
                                    if (MAX_MACRO_VALUE < 138.5) {
                                        if (X < 568) {
                                            if (Y < 552) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 552) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 568) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 138.5) {
                                        if (MAX_MACRO_VALUE < 158.5) {
                                            if (AVG_MACRO_VALUE < 121.16) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 121.16) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 158.5) {
                                            if (X < 600) {
                                                oneCount++;
                                            }
                                            else if (X >= 600) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 49.5) {
                                    if (RANGE_MACRO_VALUE < 152.5) {
                                        if (Y < 552) {
                                            if (AVG_MACRO_VALUE < 74.58) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 74.58) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 552) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 152.5) {
                                        if (MIN_MACRO_VALUE < 73.5) {
                                            if (AVG_MACRO_VALUE < 142.91) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 142.91) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 73.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 664) {
                            if (MIN_MACRO_VALUE < 29.5) {
                                if (Y < 488) {
                                    if (Y < 440) {
                                        if (RANGE_MACRO_VALUE < 44.5) {
                                            if (MAX_MACRO_VALUE < 60.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 60.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 44.5) {
                                            if (MIN_MACRO_VALUE < 21.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 21.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 440) {
                                        if (X < 712) {
                                            zeroCount++;
                                        }
                                        else if (X >= 712) {
                                            if (MAX_MACRO_VALUE < 124.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 124.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 488) {
                                    if (AVG_MACRO_VALUE < 47.64) {
                                        if (X < 824) {
                                            if (Y < 552) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 552) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 824) {
                                            if (RANGE_MACRO_VALUE < 78.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 78.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 47.64) {
                                        if (MAX_MACRO_VALUE < 190) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 190) {
                                            if (MAX_MACRO_VALUE < 192) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 192) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 29.5) {
                                if (AVG_MACRO_VALUE < 37.69) {
                                    oneCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 37.69) {
                                    if (MAX_MACRO_VALUE < 102.5) {
                                        if (Y < 472) {
                                            if (Y < 104) {
                                                oneCount++;
                                            }
                                            else if (Y >= 104) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 472) {
                                            if (X < 1000) {
                                                oneCount++;
                                            }
                                            else if (X >= 1000) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 102.5) {
                                        if (Y < 440) {
                                            if (Y < 72) {
                                                oneCount++;
                                            }
                                            else if (Y >= 72) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 440) {
                                            if (AVG_MACRO_VALUE < 123.5) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 123.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (X >= 1048) {
                        if (X < 1256) {
                            if (MAX_MACRO_VALUE < 156.5) {
                                if (AVG_MACRO_VALUE < 113.7) {
                                    if (Y < 56) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 56) {
                                        if (Y < 216) {
                                            if (RANGE_MACRO_VALUE < 71.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 71.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 216) {
                                            if (RANGE_MACRO_VALUE < 113.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 113.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 113.7) {
                                    if (MAX_MACRO_VALUE < 153.5) {
                                        if (RANGE_MACRO_VALUE < 58.5) {
                                            if (Y < 72) {
                                                oneCount++;
                                            }
                                            else if (Y >= 72) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 58.5) {
                                            if (MAX_MACRO_VALUE < 132.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 132.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 153.5) {
                                        if (X < 1128) {
                                            zeroCount++;
                                        }
                                        else if (X >= 1128) {
                                            if (Y < 208) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 208) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 156.5) {
                                if (MAX_MACRO_VALUE < 178.5) {
                                    if (MIN_MACRO_VALUE < 122) {
                                        zeroCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 122) {
                                        if (Y < 96) {
                                            oneCount++;
                                        }
                                        else if (Y >= 96) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 178.5) {
                                    if (AVG_MACRO_VALUE < 152.63) {
                                        if (MIN_MACRO_VALUE < 71.5) {
                                            if (X < 1112) {
                                                oneCount++;
                                            }
                                            else if (X >= 1112) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 71.5) {
                                            if (RANGE_MACRO_VALUE < 83.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 83.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 152.63) {
                                        if (MAX_MACRO_VALUE < 228.5) {
                                            if (Y < 88) {
                                                oneCount++;
                                            }
                                            else if (Y >= 88) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 228.5) {
                                            if (Y < 56) {
                                                oneCount++;
                                            }
                                            else if (Y >= 56) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 1256) {
                            if (RANGE_MACRO_VALUE < 108.5) {
                                if (Y < 504) {
                                    if (X < 1336) {
                                        if (MAX_MACRO_VALUE < 167.5) {
                                            if (Y < 120) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 120) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 167.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 1336) {
                                        if (MIN_MACRO_VALUE < 17.5) {
                                            if (RANGE_MACRO_VALUE < 92.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 92.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 17.5) {
                                            if (AVG_MACRO_VALUE < 167.82) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 167.82) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 504) {
                                    if (RANGE_MACRO_VALUE < 78.5) {
                                        if (Y < 536) {
                                            if (RANGE_MACRO_VALUE < 69.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 69.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 536) {
                                            if (X < 1592) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1592) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 78.5) {
                                        if (X < 1624) {
                                            if (AVG_MACRO_VALUE < 49.51) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 49.51) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1624) {
                                            if (MAX_MACRO_VALUE < 119.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 119.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 108.5) {
                                if (MAX_MACRO_VALUE < 173.5) {
                                    if (Y < 328) {
                                        if (MIN_MACRO_VALUE < 44.5) {
                                            if (AVG_MACRO_VALUE < 124.19) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 124.19) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 44.5) {
                                            if (MIN_MACRO_VALUE < 51.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 51.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 328) {
                                        if (Y < 376) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 376) {
                                            if (MIN_MACRO_VALUE < 36.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 36.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 173.5) {
                                    if (Y < 488) {
                                        if (AVG_MACRO_VALUE < 199.45) {
                                            if (Y < 472) {
                                                oneCount++;
                                            }
                                            else if (Y >= 472) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 199.45) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 488) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (Y >= 568) {
                    if (RANGE_MACRO_VALUE < 74.5) {
                        if (AVG_MACRO_VALUE < 92.86) {
                            if (AVG_MACRO_VALUE < 91.46) {
                                if (AVG_MACRO_VALUE < 86.21) {
                                    if (AVG_MACRO_VALUE < 79.52) {
                                        if (RANGE_MACRO_VALUE < 73.5) {
                                            if (X < 1560) {
                                                oneCount++;
                                            }
                                            else if (X >= 1560) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 73.5) {
                                            if (X < 1040) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1040) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 79.52) {
                                        if (RANGE_MACRO_VALUE < 48) {
                                            if (MAX_MACRO_VALUE < 107) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 107) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 48) {
                                            if (X < 1480) {
                                                oneCount++;
                                            }
                                            else if (X >= 1480) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 86.21) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 91.46) {
                                if (X < 1104) {
                                    if (MAX_MACRO_VALUE < 121) {
                                        oneCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 121) {
                                        if (MAX_MACRO_VALUE < 122.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 122.5) {
                                            if (RANGE_MACRO_VALUE < 63.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 63.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1104) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 92.86) {
                            if (MAX_MACRO_VALUE < 144.5) {
                                if (X < 992) {
                                    if (AVG_MACRO_VALUE < 105.7) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 105.7) {
                                        if (AVG_MACRO_VALUE < 105.8) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 105.8) {
                                            if (MAX_MACRO_VALUE < 124.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 124.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 992) {
                                    if (X < 1080) {
                                        if (X < 1016) {
                                            oneCount++;
                                        }
                                        else if (X >= 1016) {
                                            if (RANGE_MACRO_VALUE < 29) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 29) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1080) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 144.5) {
                                if (X < 600) {
                                    if (X < 440) {
                                        zeroCount++;
                                    }
                                    else if (X >= 440) {
                                        if (AVG_MACRO_VALUE < 130.39) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 130.39) {
                                            if (AVG_MACRO_VALUE < 135.22) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 135.22) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 600) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 74.5) {
                        if (MIN_MACRO_VALUE < 19.5) {
                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                if (RANGE_MACRO_VALUE < 134) {
                                    if (MAX_MACRO_VALUE < 147) {
                                        if (AVG_MACRO_VALUE < 24.13) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 24.13) {
                                            if (MAX_MACRO_VALUE < 144.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 144.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 147) {
                                        zeroCount++;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 134) {
                                    if (MAX_MACRO_VALUE < 173) {
                                        if (X < 1296) {
                                            zeroCount++;
                                        }
                                        else if (X >= 1296) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 173) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                if (RANGE_MACRO_VALUE < 86) {
                                    if (AVG_MACRO_VALUE < 39.44) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 39.44) {
                                        zeroCount++;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 86) {
                                    if (X < 360) {
                                        zeroCount++;
                                    }
                                    else if (X >= 360) {
                                        if (X < 1104) {
                                            if (MAX_MACRO_VALUE < 119) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 119) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1104) {
                                            if (RANGE_MACRO_VALUE < 93) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 93) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 19.5) {
                            if (AVG_MACRO_VALUE < 63.56) {
                                if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                    if (MAX_MACRO_VALUE < 143.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 143.5) {
                                        if (MAX_MACRO_VALUE < 146) {
                                            if (AVG_MACRO_VALUE < 62.45) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 62.45) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 146) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                    if (MAX_MACRO_VALUE < 106) {
                                        if (AVG_MACRO_VALUE < 50.82) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 50.82) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 106) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 63.56) {
                                if (MAX_MACRO_VALUE < 111.5) {
                                    oneCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 111.5) {
                                    if (AVG_MACRO_VALUE < 77.55) {
                                        if (MIN_MACRO_VALUE < 42.5) {
                                            if (RANGE_MACRO_VALUE < 120.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 120.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 42.5) {
                                            if (AVG_MACRO_VALUE < 69.63) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 69.63) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 77.55) {
                                        if (AVG_MACRO_VALUE < 125.21) {
                                            if (RANGE_MACRO_VALUE < 172.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 172.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 125.21) {
                                            if (AVG_MACRO_VALUE < 128.76) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 128.76) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (Y >= 584) {
                if (RANGE_MACRO_VALUE < 52.5) {
                    if (Y < 696) {
                        if (AVG_MACRO_VALUE < 137.87) {
                            if (MAX_MACRO_VALUE < 126.5) {
                                if (MIN_MACRO_VALUE < 43.5) {
                                    if (X < 984) {
                                        if (X < 344) {
                                            if (MIN_MACRO_VALUE < 23.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 23.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 344) {
                                            if (AVG_MACRO_VALUE < 32.31) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 32.31) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 984) {
                                        if (Y < 664) {
                                            if (MAX_MACRO_VALUE < 72.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 72.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 664) {
                                            if (X < 1088) {
                                                oneCount++;
                                            }
                                            else if (X >= 1088) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 43.5) {
                                    if (X < 856) {
                                        zeroCount++;
                                    }
                                    else if (X >= 856) {
                                        if (X < 936) {
                                            if (MIN_MACRO_VALUE < 50) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 50) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 936) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 126.5) {
                                if (MIN_MACRO_VALUE < 87.5) {
                                    if (AVG_MACRO_VALUE < 109.58) {
                                        if (X < 712) {
                                            oneCount++;
                                        }
                                        else if (X >= 712) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 109.58) {
                                        oneCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 87.5) {
                                    if (AVG_MACRO_VALUE < 130.08) {
                                        if (MAX_MACRO_VALUE < 131.5) {
                                            if (AVG_MACRO_VALUE < 119.94) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 119.94) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 131.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 130.08) {
                                        if (MAX_MACRO_VALUE < 150.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 150.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 137.87) {
                            zeroCount++;
                        }
                    }
                    else if (Y >= 696) {
                        if (RANGE_MACRO_VALUE < 34.5) {
                            if (AVG_MACRO_VALUE < 144.8) {
                                if (MAX_MACRO_VALUE < 48.5) {
                                    if (RANGE_MACRO_VALUE < 27.5) {
                                        if (X < 1680) {
                                            if (AVG_MACRO_VALUE < 23.76) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 23.76) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1680) {
                                            if (X < 1752) {
                                                oneCount++;
                                            }
                                            else if (X >= 1752) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 27.5) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            if (AVG_MACRO_VALUE < 31.2) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 31.2) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 48.5) {
                                    if (AVG_MACRO_VALUE < 30.15) {
                                        if (AVG_MACRO_VALUE < 26.55) {
                                            if (AVG_MACRO_VALUE < 26.21) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 26.21) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 26.55) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 30.15) {
                                        if (Y < 760) {
                                            if (X < 1832) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1832) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 760) {
                                            if (Y < 776) {
                                                oneCount++;
                                            }
                                            else if (Y >= 776) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 144.8) {
                                if (AVG_MACRO_VALUE < 157.97) {
                                    if (RANGE_MACRO_VALUE < 28.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 28.5) {
                                        if (X < 912) {
                                            if (Y < 1040) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 1040) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 912) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 157.97) {
                                    if (X < 1880) {
                                        if (X < 1672) {
                                            if (MIN_MACRO_VALUE < 150.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 150.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1672) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 1880) {
                                        if (X < 1896) {
                                            oneCount++;
                                        }
                                        else if (X >= 1896) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 34.5) {
                            if (MAX_MACRO_VALUE < 87.5) {
                                if (AVG_MACRO_VALUE < 30.18) {
                                    if (X < 1064) {
                                        if (AVG_MACRO_VALUE < 30.15) {
                                            if (MAX_MACRO_VALUE < 59.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 59.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 30.15) {
                                            oneCount++;
                                        }
                                    }
                                    else if (X >= 1064) {
                                        if (AVG_MACRO_VALUE < 17.95) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.95) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 30.18) {
                                    if (AVG_MACRO_VALUE < 42.49) {
                                        if (MIN_MACRO_VALUE < 17.5) {
                                            if (X < 360) {
                                                zeroCount++;
                                            }
                                            else if (X >= 360) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 17.5) {
                                            if (MIN_MACRO_VALUE < 21.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 21.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 42.49) {
                                        if (X < 168) {
                                            if (MAX_MACRO_VALUE < 62) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 62) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 168) {
                                            if (AVG_MACRO_VALUE < 64.98) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 64.98) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 87.5) {
                                if (Y < 904) {
                                    if (X < 1816) {
                                        if (MIN_MACRO_VALUE < 44.5) {
                                            if (MAX_MACRO_VALUE < 91.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 91.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 44.5) {
                                            if (RANGE_MACRO_VALUE < 40.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 40.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1816) {
                                        if (AVG_MACRO_VALUE < 63.21) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 63.21) {
                                            if (MIN_MACRO_VALUE < 100.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 100.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 904) {
                                    if (RANGE_MACRO_VALUE < 41.5) {
                                        if (AVG_MACRO_VALUE < 70.29) {
                                            if (MAX_MACRO_VALUE < 91.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 91.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 70.29) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                zeroCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 41.5) {
                                        if (MIN_MACRO_VALUE < 40.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 40.5) {
                                            if (X < 1736) {
                                                oneCount++;
                                            }
                                            else if (X >= 1736) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 52.5) {
                    if (Y < 792) {
                        if (X < 1160) {
                            if (MIN_MACRO_VALUE < 17.5) {
                                if (Y < 760) {
                                    if (X < 104) {
                                        if (AVG_MACRO_VALUE < 42.64) {
                                            if (Y < 688) {
                                                oneCount++;
                                            }
                                            else if (Y >= 688) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.64) {
                                            if (RANGE_MACRO_VALUE < 218.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 218.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 104) {
                                        if (AVG_MACRO_VALUE < 59.06) {
                                            if (AVG_MACRO_VALUE < 37.33) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 37.33) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 59.06) {
                                            if (X < 768) {
                                                oneCount++;
                                            }
                                            else if (X >= 768) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 760) {
                                    if (X < 336) {
                                        if (MAX_MACRO_VALUE < 87.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 87.5) {
                                            if (RANGE_MACRO_VALUE < 102) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 102) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 336) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 17.5) {
                                if (X < 120) {
                                    if (X < 8) {
                                        zeroCount++;
                                    }
                                    else if (X >= 8) {
                                        if (AVG_MACRO_VALUE < 41.82) {
                                            if (AVG_MACRO_VALUE < 38.81) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 38.81) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 41.82) {
                                            if (RANGE_MACRO_VALUE < 64.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 64.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 120) {
                                    if (RANGE_MACRO_VALUE < 210.5) {
                                        if (Y < 760) {
                                            if (AVG_MACRO_VALUE < 75.01) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 75.01) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 760) {
                                            if (RANGE_MACRO_VALUE < 191.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 191.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 210.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (X >= 1160) {
                            if (Y < 744) {
                                if (MIN_MACRO_VALUE < 93.5) {
                                    if (RANGE_MACRO_VALUE < 54.5) {
                                        if (X < 1608) {
                                            if (X < 1568) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1568) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1608) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 54.5) {
                                        if (X < 1256) {
                                            if (AVG_MACRO_VALUE < 66.55) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 66.55) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1256) {
                                            if (Y < 616) {
                                                oneCount++;
                                            }
                                            else if (Y >= 616) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 93.5) {
                                    zeroCount++;
                                }
                            }
                            else if (Y >= 744) {
                                if (AVG_MACRO_VALUE < 44.05) {
                                    if (MAX_MACRO_VALUE < 88) {
                                        if (X < 1512) {
                                            oneCount++;
                                        }
                                        else if (X >= 1512) {
                                            if (MAX_MACRO_VALUE < 85) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 85) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 88) {
                                        if (Y < 760) {
                                            if (AVG_MACRO_VALUE < 40.74) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 40.74) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 760) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 44.05) {
                                    if (MAX_MACRO_VALUE < 101.5) {
                                        if (AVG_MACRO_VALUE < 57.17) {
                                            if (X < 1672) {
                                                oneCount++;
                                            }
                                            else if (X >= 1672) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 57.17) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 101.5) {
                                        if (RANGE_MACRO_VALUE < 78.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 78.5) {
                                            if (Y < 760) {
                                                oneCount++;
                                            }
                                            else if (Y >= 760) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Y >= 792) {
                        if (X < 24) {
                            if (MAX_MACRO_VALUE < 229.5) {
                                if (Y < 840) {
                                    if (MIN_MACRO_VALUE < 24) {
                                        if (AVG_MACRO_VALUE < 39.43) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 39.43) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 24) {
                                        zeroCount++;
                                    }
                                }
                                else if (Y >= 840) {
                                    zeroCount++;
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 229.5) {
                                oneCount++;
                            }
                        }
                        else if (X >= 24) {
                            if (X < 1896) {
                                if (MIN_MACRO_VALUE < 28.5) {
                                    if (X < 56) {
                                        if (MAX_MACRO_VALUE < 201) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 201) {
                                            if (MIN_MACRO_VALUE < 19) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 19) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 56) {
                                        if (X < 408) {
                                            if (MIN_MACRO_VALUE < 25.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 25.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 408) {
                                            if (MAX_MACRO_VALUE < 92.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 92.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 28.5) {
                                    if (Y < 856) {
                                        if (MAX_MACRO_VALUE < 112.5) {
                                            if (AVG_MACRO_VALUE < 59.93) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 59.93) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 112.5) {
                                            if (AVG_MACRO_VALUE < 131.75) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 131.75) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 856) {
                                        if (MIN_MACRO_VALUE < 41.5) {
                                            if (AVG_MACRO_VALUE < 60.26) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 60.26) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 41.5) {
                                            if (RANGE_MACRO_VALUE < 53.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 53.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 1896) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 3
    if (MIN_MACRO_VALUE < 34.5) {
            if (MAX_MACRO_VALUE < 18.5) {
                if (AVG_MACRO_VALUE < 17.43) {
                    if (MIN_MACRO_VALUE < 16.5) {
                        if (MAX_MACRO_VALUE < 16.5) {
                            if (Y < 968) {
                                if (Y < 352) {
                                    if (X < 1072) {
                                        if (X < 1016) {
                                            if (X < 1000) {
                                                oneCount++;
                                            }
                                            else if (X >= 1000) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1016) {
                                            oneCount++;
                                        }
                                    }
                                    else if (X >= 1072) {
                                        zeroCount++;
                                    }
                                }
                                else if (Y >= 352) {
                                    if (Y < 392) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 392) {
                                        if (X < 1032) {
                                            if (Y < 920) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 920) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1032) {
                                            if (Y < 920) {
                                                oneCount++;
                                            }
                                            else if (Y >= 920) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 968) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 16.5) {
                            if (Y < 728) {
                                if (Y < 288) {
                                    if (Y < 264) {
                                        if (AVG_MACRO_VALUE < 16.95) {
                                            if (AVG_MACRO_VALUE < 16.93) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 16.93) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 16.95) {
                                            if (X < 136) {
                                                oneCount++;
                                            }
                                            else if (X >= 136) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 264) {
                                        if (X < 1016) {
                                            if (AVG_MACRO_VALUE < 17.14) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 17.14) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1016) {
                                            if (AVG_MACRO_VALUE < 17.09) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 17.09) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 288) {
                                    zeroCount++;
                                }
                            }
                            else if (Y >= 728) {
                                if (X < 1408) {
                                    if (Y < 744) {
                                        if (X < 1064) {
                                            if (AVG_MACRO_VALUE < 16.94) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 16.94) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1064) {
                                            if (AVG_MACRO_VALUE < 16.95) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 16.95) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 744) {
                                        if (AVG_MACRO_VALUE < 17.23) {
                                            if (Y < 864) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 864) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.23) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (X >= 1408) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 16.5) {
                        if (AVG_MACRO_VALUE < 17.41) {
                            if (Y < 696) {
                                if (AVG_MACRO_VALUE < 17.4) {
                                    if (X < 808) {
                                        if (X < 440) {
                                            if (Y < 160) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 160) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 440) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 808) {
                                        if (AVG_MACRO_VALUE < 17.08) {
                                            if (Y < 480) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 480) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.08) {
                                            if (Y < 664) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 664) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 17.4) {
                                    if (X < 1376) {
                                        oneCount++;
                                    }
                                    else if (X >= 1376) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (Y >= 696) {
                                if (X < 864) {
                                    if (Y < 728) {
                                        if (Y < 712) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 712) {
                                            if (X < 552) {
                                                zeroCount++;
                                            }
                                            else if (X >= 552) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 728) {
                                        zeroCount++;
                                    }
                                }
                                else if (X >= 864) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 17.41) {
                            zeroCount++;
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 17.43) {
                    if (AVG_MACRO_VALUE < 17.44) {
                        if (AVG_MACRO_VALUE < 17.43) {
                            if (X < 1616) {
                                zeroCount++;
                            }
                            else if (X >= 1616) {
                                if (X < 1824) {
                                    oneCount++;
                                }
                                else if (X >= 1824) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 17.43) {
                            if (AVG_MACRO_VALUE < 17.44) {
                                if (X < 1192) {
                                    oneCount++;
                                }
                                else if (X >= 1192) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 17.44) {
                                if (X < 592) {
                                    zeroCount++;
                                }
                                else if (X >= 592) {
                                    if (Y < 760) {
                                        oneCount++;
                                    }
                                    else if (Y >= 760) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 17.44) {
                        if (Y < 728) {
                            if (X < 696) {
                                if (Y < 192) {
                                    if (Y < 120) {
                                        if (X < 296) {
                                            zeroCount++;
                                        }
                                        else if (X >= 296) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Y >= 120) {
                                        if (X < 320) {
                                            zeroCount++;
                                        }
                                        else if (X >= 320) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Y >= 192) {
                                    zeroCount++;
                                }
                            }
                            else if (X >= 696) {
                                if (AVG_MACRO_VALUE < 17.67) {
                                    if (Y < 712) {
                                        if (AVG_MACRO_VALUE < 17.59) {
                                            if (X < 1320) {
                                                oneCount++;
                                            }
                                            else if (X >= 1320) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.59) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Y >= 712) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 17.67) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (Y >= 728) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 18.5) {
                if (MIN_MACRO_VALUE < 17.5) {
                    if (Y < 392) {
                        if (MAX_MACRO_VALUE < 114.5) {
                            if (X < 344) {
                                zeroCount++;
                            }
                            else if (X >= 344) {
                                if (X < 1752) {
                                    if (MAX_MACRO_VALUE < 109.5) {
                                        if (X < 1688) {
                                            if (RANGE_MACRO_VALUE < 75.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 75.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1688) {
                                            if (AVG_MACRO_VALUE < 59.47) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 59.47) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 109.5) {
                                        if (Y < 344) {
                                            if (X < 1552) {
                                                oneCount++;
                                            }
                                            else if (X >= 1552) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 344) {
                                            if (AVG_MACRO_VALUE < 24.11) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 24.11) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1752) {
                                    if (AVG_MACRO_VALUE < 55.77) {
                                        if (AVG_MACRO_VALUE < 29.59) {
                                            if (RANGE_MACRO_VALUE < 42) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 42) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 29.59) {
                                            if (RANGE_MACRO_VALUE < 82.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 82.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 55.77) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 114.5) {
                            if (RANGE_MACRO_VALUE < 104.5) {
                                if (AVG_MACRO_VALUE < 40.04) {
                                    if (Y < 344) {
                                        if (X < 1152) {
                                            oneCount++;
                                        }
                                        else if (X >= 1152) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 344) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 40.04) {
                                    if (Y < 352) {
                                        if (MAX_MACRO_VALUE < 116.5) {
                                            if (RANGE_MACRO_VALUE < 98.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 98.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 116.5) {
                                            if (MAX_MACRO_VALUE < 119.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 119.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 352) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 104.5) {
                                if (Y < 248) {
                                    if (AVG_MACRO_VALUE < 98.66) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            if (Y < 232) {
                                                oneCount++;
                                            }
                                            else if (Y >= 232) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            if (MAX_MACRO_VALUE < 131.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 131.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 98.66) {
                                        if (X < 800) {
                                            zeroCount++;
                                        }
                                        else if (X >= 800) {
                                            if (AVG_MACRO_VALUE < 129.29) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 129.29) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 248) {
                                    if (AVG_MACRO_VALUE < 45.62) {
                                        if (MAX_MACRO_VALUE < 188.5) {
                                            if (MAX_MACRO_VALUE < 184) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 184) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 188.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 45.62) {
                                        if (Y < 344) {
                                            if (AVG_MACRO_VALUE < 66.56) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 66.56) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 344) {
                                            if (X < 744) {
                                                zeroCount++;
                                            }
                                            else if (X >= 744) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Y >= 392) {
                        if (Y < 408) {
                            if (RANGE_MACRO_VALUE < 52) {
                                if (X < 928) {
                                    zeroCount++;
                                }
                                else if (X >= 928) {
                                    if (X < 1792) {
                                        if (AVG_MACRO_VALUE < 24.84) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 24.84) {
                                            if (X < 1664) {
                                                oneCount++;
                                            }
                                            else if (X >= 1664) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1792) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 52) {
                                if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                    if (RANGE_MACRO_VALUE < 115) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 115) {
                                        if (AVG_MACRO_VALUE < 55.9) {
                                            if (AVG_MACRO_VALUE < 26.24) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 26.24) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 55.9) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                    if (AVG_MACRO_VALUE < 40.79) {
                                        if (X < 1080) {
                                            oneCount++;
                                        }
                                        else if (X >= 1080) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 40.79) {
                                        if (AVG_MACRO_VALUE < 74.57) {
                                            if (X < 504) {
                                                oneCount++;
                                            }
                                            else if (X >= 504) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 74.57) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Y >= 408) {
                            if (RANGE_MACRO_VALUE < 84.5) {
                                if (Y < 968) {
                                    if (AVG_MACRO_VALUE < 32.17) {
                                        if (X < 856) {
                                            if (RANGE_MACRO_VALUE < 3.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 3.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 856) {
                                            if (MAX_MACRO_VALUE < 99.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 99.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 32.17) {
                                        if (X < 280) {
                                            if (Y < 776) {
                                                oneCount++;
                                            }
                                            else if (Y >= 776) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 280) {
                                            if (AVG_MACRO_VALUE < 76.76) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 76.76) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 968) {
                                    if (AVG_MACRO_VALUE < 20.69) {
                                        if (RANGE_MACRO_VALUE < 17) {
                                            if (RANGE_MACRO_VALUE < 4.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 4.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 17) {
                                            if (X < 776) {
                                                zeroCount++;
                                            }
                                            else if (X >= 776) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 20.69) {
                                        if (MIN_MACRO_VALUE < 15.5) {
                                            if (X < 336) {
                                                oneCount++;
                                            }
                                            else if (X >= 336) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 15.5) {
                                            if (Y < 1048) {
                                                oneCount++;
                                            }
                                            else if (Y >= 1048) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 84.5) {
                                if (X < 56) {
                                    if (MAX_MACRO_VALUE < 133) {
                                        if (AVG_MACRO_VALUE < 37.83) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 37.83) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 133) {
                                        if (Y < 768) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 768) {
                                            if (RANGE_MACRO_VALUE < 155) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 155) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 56) {
                                    if (MAX_MACRO_VALUE < 101.5) {
                                        if (RANGE_MACRO_VALUE < 85.5) {
                                            if (AVG_MACRO_VALUE < 38.99) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 38.99) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 85.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 101.5) {
                                        if (AVG_MACRO_VALUE < 37.88) {
                                            if (Y < 488) {
                                                oneCount++;
                                            }
                                            else if (Y >= 488) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 37.88) {
                                            if (AVG_MACRO_VALUE < 39.23) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 39.23) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 17.5) {
                    if (X < 664) {
                        if (AVG_MACRO_VALUE < 66.99) {
                            if (RANGE_MACRO_VALUE < 176.5) {
                                if (X < 616) {
                                    if (AVG_MACRO_VALUE < 38.18) {
                                        if (RANGE_MACRO_VALUE < 155.5) {
                                            if (AVG_MACRO_VALUE < 38.13) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 38.13) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 155.5) {
                                            if (MAX_MACRO_VALUE < 197.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 197.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 38.18) {
                                        if (RANGE_MACRO_VALUE < 23.5) {
                                            if (AVG_MACRO_VALUE < 44.12) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 44.12) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 23.5) {
                                            if (MAX_MACRO_VALUE < 149.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 149.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 616) {
                                    if (Y < 296) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 296) {
                                        if (AVG_MACRO_VALUE < 32.46) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 32.46) {
                                            if (AVG_MACRO_VALUE < 36.45) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 36.45) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 176.5) {
                                if (MIN_MACRO_VALUE < 18.5) {
                                    if (MAX_MACRO_VALUE < 233.5) {
                                        if (Y < 320) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 320) {
                                            if (X < 216) {
                                                oneCount++;
                                            }
                                            else if (X >= 216) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 233.5) {
                                        if (X < 304) {
                                            oneCount++;
                                        }
                                        else if (X >= 304) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 18.5) {
                                    if (RANGE_MACRO_VALUE < 203.5) {
                                        if (AVG_MACRO_VALUE < 45.41) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 45.41) {
                                            if (MAX_MACRO_VALUE < 217.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 217.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 203.5) {
                                        if (X < 64) {
                                            zeroCount++;
                                        }
                                        else if (X >= 64) {
                                            if (AVG_MACRO_VALUE < 52.25) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 52.25) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 66.99) {
                            if (MIN_MACRO_VALUE < 32.5) {
                                if (X < 328) {
                                    if (X < 24) {
                                        zeroCount++;
                                    }
                                    else if (X >= 24) {
                                        if (Y < 728) {
                                            if (Y < 680) {
                                                oneCount++;
                                            }
                                            else if (Y >= 680) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 728) {
                                            if (AVG_MACRO_VALUE < 93.06) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 93.06) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 328) {
                                    if (X < 568) {
                                        if (AVG_MACRO_VALUE < 77.81) {
                                            if (AVG_MACRO_VALUE < 75.54) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 75.54) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 77.81) {
                                            if (MAX_MACRO_VALUE < 141.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 141.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 568) {
                                        if (MAX_MACRO_VALUE < 230.5) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                zeroCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 230.5) {
                                            if (Y < 968) {
                                                oneCount++;
                                            }
                                            else if (Y >= 968) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 32.5) {
                                if (X < 248) {
                                    if (Y < 632) {
                                        if (Y < 288) {
                                            if (X < 120) {
                                                zeroCount++;
                                            }
                                            else if (X >= 120) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 288) {
                                            if (MAX_MACRO_VALUE < 122.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 122.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 632) {
                                        if (AVG_MACRO_VALUE < 103.91) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 103.91) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (X >= 248) {
                                    if (X < 568) {
                                        if (Y < 456) {
                                            if (RANGE_MACRO_VALUE < 86.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 86.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 456) {
                                            if (X < 280) {
                                                zeroCount++;
                                            }
                                            else if (X >= 280) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 568) {
                                        if (AVG_MACRO_VALUE < 102.31) {
                                            if (Y < 536) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 536) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 102.31) {
                                            if (Y < 288) {
                                                oneCount++;
                                            }
                                            else if (Y >= 288) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (X >= 664) {
                        if (RANGE_MACRO_VALUE < 44.5) {
                            if (X < 1288) {
                                if (MIN_MACRO_VALUE < 24.5) {
                                    if (MIN_MACRO_VALUE < 23.5) {
                                        if (Y < 216) {
                                            if (X < 1080) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1080) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 216) {
                                            if (Y < 648) {
                                                oneCount++;
                                            }
                                            else if (Y >= 648) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 23.5) {
                                        if (AVG_MACRO_VALUE < 25.19) {
                                            if (X < 976) {
                                                zeroCount++;
                                            }
                                            else if (X >= 976) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 25.19) {
                                            if (MAX_MACRO_VALUE < 33.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 33.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 24.5) {
                                    if (AVG_MACRO_VALUE < 29.4) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 29.4) {
                                        if (MAX_MACRO_VALUE < 74.5) {
                                            if (Y < 1000) {
                                                oneCount++;
                                            }
                                            else if (Y >= 1000) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 74.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (X >= 1288) {
                                if (X < 1336) {
                                    if (AVG_MACRO_VALUE < 31.16) {
                                        if (RANGE_MACRO_VALUE < 27) {
                                            if (X < 1304) {
                                                oneCount++;
                                            }
                                            else if (X >= 1304) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 27) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 31.16) {
                                        if (MAX_MACRO_VALUE < 59.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 59.5) {
                                            if (Y < 368) {
                                                oneCount++;
                                            }
                                            else if (Y >= 368) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1336) {
                                    if (X < 1896) {
                                        if (MAX_MACRO_VALUE < 29.5) {
                                            if (AVG_MACRO_VALUE < 23.06) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 23.06) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 29.5) {
                                            if (AVG_MACRO_VALUE < 27.46) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 27.46) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1896) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 44.5) {
                            if (X < 1016) {
                                if (AVG_MACRO_VALUE < 51.82) {
                                    if (Y < 504) {
                                        if (AVG_MACRO_VALUE < 50.73) {
                                            if (X < 680) {
                                                zeroCount++;
                                            }
                                            else if (X >= 680) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 50.73) {
                                            if (MIN_MACRO_VALUE < 21.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 21.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 504) {
                                        if (RANGE_MACRO_VALUE < 116.5) {
                                            if (AVG_MACRO_VALUE < 24.87) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 24.87) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 116.5) {
                                            if (AVG_MACRO_VALUE < 32.81) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 32.81) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 51.82) {
                                    if (RANGE_MACRO_VALUE < 214.5) {
                                        if (Y < 472) {
                                            if (X < 984) {
                                                oneCount++;
                                            }
                                            else if (X >= 984) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 472) {
                                            if (X < 680) {
                                                oneCount++;
                                            }
                                            else if (X >= 680) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 214.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (X >= 1016) {
                                if (X < 1224) {
                                    if (Y < 568) {
                                        if (Y < 216) {
                                            if (RANGE_MACRO_VALUE < 63.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 63.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 216) {
                                            if (AVG_MACRO_VALUE < 57.84) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 57.84) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 568) {
                                        if (MAX_MACRO_VALUE < 80.5) {
                                            if (X < 1032) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1032) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 80.5) {
                                            if (RANGE_MACRO_VALUE < 81.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 81.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1224) {
                                    if (AVG_MACRO_VALUE < 53.94) {
                                        if (Y < 568) {
                                            if (X < 1320) {
                                                oneCount++;
                                            }
                                            else if (X >= 1320) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 568) {
                                            if (MIN_MACRO_VALUE < 18.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 18.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 53.94) {
                                        if (MAX_MACRO_VALUE < 200.5) {
                                            if (Y < 440) {
                                                oneCount++;
                                            }
                                            else if (Y >= 440) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 200.5) {
                                            if (Y < 952) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 952) {
                                                oneCount++;
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
        else if (MIN_MACRO_VALUE >= 34.5) {
            if (RANGE_MACRO_VALUE < 26.5) {
                if (AVG_MACRO_VALUE < 193.63) {
                    if (X < 952) {
                        if (Y < 536) {
                            if (Y < 280) {
                                if (X < 872) {
                                    if (Y < 40) {
                                        if (MIN_MACRO_VALUE < 36.5) {
                                            if (X < 848) {
                                                zeroCount++;
                                            }
                                            else if (X >= 848) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 36.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 40) {
                                        if (MIN_MACRO_VALUE < 120.5) {
                                            if (AVG_MACRO_VALUE < 43.64) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 43.64) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 120.5) {
                                            if (MIN_MACRO_VALUE < 144.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 144.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 872) {
                                    if (MAX_MACRO_VALUE < 72.5) {
                                        if (AVG_MACRO_VALUE < 54.92) {
                                            if (RANGE_MACRO_VALUE < 13.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 13.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 54.92) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 72.5) {
                                        if (Y < 104) {
                                            if (MIN_MACRO_VALUE < 59.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 59.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 104) {
                                            if (AVG_MACRO_VALUE < 181.3) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 181.3) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 280) {
                                if (X < 520) {
                                    if (Y < 360) {
                                        if (AVG_MACRO_VALUE < 111.47) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 111.47) {
                                            if (X < 312) {
                                                oneCount++;
                                            }
                                            else if (X >= 312) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 360) {
                                        if (X < 408) {
                                            if (RANGE_MACRO_VALUE < 5.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 5.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 408) {
                                            if (RANGE_MACRO_VALUE < 9.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 9.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 520) {
                                    if (MIN_MACRO_VALUE < 55.5) {
                                        if (RANGE_MACRO_VALUE < 22.5) {
                                            if (Y < 392) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 392) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 22.5) {
                                            if (AVG_MACRO_VALUE < 45.47) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 45.47) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 55.5) {
                                        if (AVG_MACRO_VALUE < 88.28) {
                                            if (MAX_MACRO_VALUE < 74.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 74.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 88.28) {
                                            if (MAX_MACRO_VALUE < 152.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 152.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (Y >= 536) {
                            if (Y < 552) {
                                if (AVG_MACRO_VALUE < 97.25) {
                                    if (X < 776) {
                                        if (AVG_MACRO_VALUE < 49.99) {
                                            if (AVG_MACRO_VALUE < 46.7) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 46.7) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 49.99) {
                                            if (X < 744) {
                                                zeroCount++;
                                            }
                                            else if (X >= 744) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 776) {
                                        if (MAX_MACRO_VALUE < 54.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 54.5) {
                                            if (RANGE_MACRO_VALUE < 16.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 16.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 97.25) {
                                    zeroCount++;
                                }
                            }
                            else if (Y >= 552) {
                                if (AVG_MACRO_VALUE < 47.78) {
                                    if (AVG_MACRO_VALUE < 47.35) {
                                        if (X < 680) {
                                            if (AVG_MACRO_VALUE < 43.49) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 43.49) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 680) {
                                            if (RANGE_MACRO_VALUE < 12.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 12.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 47.35) {
                                        if (X < 40) {
                                            if (MAX_MACRO_VALUE < 59.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 59.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 40) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 47.78) {
                                    if (AVG_MACRO_VALUE < 56.85) {
                                        if (MIN_MACRO_VALUE < 37.5) {
                                            if (X < 16) {
                                                oneCount++;
                                            }
                                            else if (X >= 16) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 37.5) {
                                            if (Y < 936) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 936) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 56.85) {
                                        if (X < 600) {
                                            if (AVG_MACRO_VALUE < 57.23) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 57.23) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 600) {
                                            if (AVG_MACRO_VALUE < 101.21) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 101.21) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (X >= 952) {
                        if (RANGE_MACRO_VALUE < 3.5) {
                            if (X < 1880) {
                                if (AVG_MACRO_VALUE < 166.22) {
                                    if (Y < 24) {
                                        if (AVG_MACRO_VALUE < 43.91) {
                                            if (X < 1432) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1432) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 43.91) {
                                            if (MAX_MACRO_VALUE < 55) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 55) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 24) {
                                        if (X < 1064) {
                                            if (MAX_MACRO_VALUE < 115) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 115) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1064) {
                                            if (Y < 40) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 40) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 166.22) {
                                    if (Y < 120) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 120) {
                                        if (MIN_MACRO_VALUE < 169) {
                                            if (Y < 168) {
                                                oneCount++;
                                            }
                                            else if (Y >= 168) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 169) {
                                            if (Y < 248) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 248) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 1880) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 3.5) {
                            if (X < 1768) {
                                if (MAX_MACRO_VALUE < 91.5) {
                                    if (MIN_MACRO_VALUE < 72.5) {
                                        if (Y < 472) {
                                            if (MIN_MACRO_VALUE < 47.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 47.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 472) {
                                            if (X < 968) {
                                                oneCount++;
                                            }
                                            else if (X >= 968) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 72.5) {
                                        if (X < 1032) {
                                            if (MIN_MACRO_VALUE < 83.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 83.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1032) {
                                            if (RANGE_MACRO_VALUE < 10.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 10.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 91.5) {
                                    if (AVG_MACRO_VALUE < 100.1) {
                                        if (X < 1672) {
                                            if (MIN_MACRO_VALUE < 83.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 83.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1672) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 100.1) {
                                        if (MIN_MACRO_VALUE < 96.5) {
                                            if (X < 1128) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1128) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 96.5) {
                                            if (X < 1304) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1304) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 1768) {
                                if (Y < 744) {
                                    if (AVG_MACRO_VALUE < 81.34) {
                                        if (AVG_MACRO_VALUE < 81.2) {
                                            if (AVG_MACRO_VALUE < 77.02) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 77.02) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 81.2) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 81.34) {
                                        if (X < 1880) {
                                            if (AVG_MACRO_VALUE < 125.18) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 125.18) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1880) {
                                            if (MIN_MACRO_VALUE < 94) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 94) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 744) {
                                    if (AVG_MACRO_VALUE < 45.72) {
                                        if (X < 1800) {
                                            if (MAX_MACRO_VALUE < 49.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 49.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1800) {
                                            if (X < 1864) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1864) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 45.72) {
                                        if (AVG_MACRO_VALUE < 45.82) {
                                            if (Y < 1016) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 1016) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 45.82) {
                                            if (RANGE_MACRO_VALUE < 8.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 8.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 193.63) {
                    if (MAX_MACRO_VALUE < 231) {
                        zeroCount++;
                    }
                    else if (MAX_MACRO_VALUE >= 231) {
                        if (MAX_MACRO_VALUE < 232.5) {
                            if (X < 840) {
                                if (RANGE_MACRO_VALUE < 6) {
                                    zeroCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 6) {
                                    oneCount++;
                                }
                            }
                            else if (X >= 840) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 232.5) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 26.5) {
                if (MAX_MACRO_VALUE < 71.5) {
                    if (X < 344) {
                        if (X < 120) {
                            if (RANGE_MACRO_VALUE < 27.5) {
                                if (Y < 904) {
                                    zeroCount++;
                                }
                                else if (Y >= 904) {
                                    if (Y < 992) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            zeroCount++;
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Y >= 992) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 27.5) {
                                if (RANGE_MACRO_VALUE < 34.5) {
                                    zeroCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 34.5) {
                                    if (AVG_MACRO_VALUE < 48.01) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 48.01) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (X >= 120) {
                            if (MIN_MACRO_VALUE < 42.5) {
                                if (RANGE_MACRO_VALUE < 33.5) {
                                    if (AVG_MACRO_VALUE < 46.18) {
                                        if (Y < 904) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 904) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 46.18) {
                                        if (AVG_MACRO_VALUE < 51.36) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 51.36) {
                                            if (AVG_MACRO_VALUE < 52.26) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 52.26) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 33.5) {
                                    if (X < 288) {
                                        zeroCount++;
                                    }
                                    else if (X >= 288) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 42.5) {
                                if (Y < 960) {
                                    oneCount++;
                                }
                                else if (Y >= 960) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (X >= 344) {
                        if (X < 1816) {
                            if (Y < 664) {
                                if (MAX_MACRO_VALUE < 69.5) {
                                    if (Y < 584) {
                                        if (X < 712) {
                                            zeroCount++;
                                        }
                                        else if (X >= 712) {
                                            if (AVG_MACRO_VALUE < 56.42) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 56.42) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 584) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 69.5) {
                                    if (RANGE_MACRO_VALUE < 32.5) {
                                        if (X < 960) {
                                            if (Y < 576) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 576) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 960) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 32.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (Y >= 664) {
                                if (RANGE_MACRO_VALUE < 32.5) {
                                    if (MAX_MACRO_VALUE < 65.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 65.5) {
                                        if (X < 1688) {
                                            if (AVG_MACRO_VALUE < 51.62) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 51.62) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1688) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 32.5) {
                                    if (MAX_MACRO_VALUE < 69.5) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            if (AVG_MACRO_VALUE < 115.24) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 115.24) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            if (MIN_MACRO_VALUE < 61.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 61.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 69.5) {
                                        if (MAX_MACRO_VALUE < 70.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 70.5) {
                                            if (Y < 800) {
                                                oneCount++;
                                            }
                                            else if (Y >= 800) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 1816) {
                            if (MIN_MACRO_VALUE < 118.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 118.5) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 71.5) {
                    if (RANGE_MACRO_VALUE < 185.5) {
                        if (X < 1864) {
                            if (MAX_MACRO_VALUE < 132.5) {
                                if (MIN_MACRO_VALUE < 59.5) {
                                    if (AVG_MACRO_VALUE < 54.37) {
                                        if (AVG_MACRO_VALUE < 54.16) {
                                            if (X < 1032) {
                                                oneCount++;
                                            }
                                            else if (X >= 1032) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 54.16) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                zeroCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 54.37) {
                                        if (Y < 1032) {
                                            if (AVG_MACRO_VALUE < 56.88) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 56.88) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 1032) {
                                            if (X < 1808) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1808) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 59.5) {
                                    if (AVG_MACRO_VALUE < 71.02) {
                                        if (AVG_MACRO_VALUE < 63.57) {
                                            if (Y < 952) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 952) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 63.57) {
                                            if (AVG_MACRO_VALUE < 68.82) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 68.82) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 71.02) {
                                        if (X < 1800) {
                                            if (RANGE_MACRO_VALUE < 68.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 68.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1800) {
                                            if (Y < 272) {
                                                oneCount++;
                                            }
                                            else if (Y >= 272) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 132.5) {
                                if (AVG_MACRO_VALUE < 146.62) {
                                    if (MAX_MACRO_VALUE < 196.5) {
                                        if (RANGE_MACRO_VALUE < 34.5) {
                                            if (MIN_MACRO_VALUE < 103.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 103.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 34.5) {
                                            if (X < 456) {
                                                zeroCount++;
                                            }
                                            else if (X >= 456) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 196.5) {
                                        if (Y < 1048) {
                                            if (X < 1848) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1848) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 1048) {
                                            if (MAX_MACRO_VALUE < 201) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 201) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 146.62) {
                                    if (MIN_MACRO_VALUE < 50.5) {
                                        if (X < 920) {
                                            if (MIN_MACRO_VALUE < 36.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 36.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 920) {
                                            if (AVG_MACRO_VALUE < 149.77) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 149.77) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 50.5) {
                                        if (X < 1608) {
                                            if (X < 1352) {
                                                oneCount++;
                                            }
                                            else if (X >= 1352) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1608) {
                                            if (RANGE_MACRO_VALUE < 83.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 83.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 1864) {
                            if (Y < 936) {
                                if (Y < 88) {
                                    if (Y < 56) {
                                        if (X < 1880) {
                                            if (RANGE_MACRO_VALUE < 134) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 134) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1880) {
                                            if (MAX_MACRO_VALUE < 88.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 88.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 56) {
                                        if (RANGE_MACRO_VALUE < 50) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 50) {
                                            if (X < 1880) {
                                                oneCount++;
                                            }
                                            else if (X >= 1880) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 88) {
                                    if (RANGE_MACRO_VALUE < 31.5) {
                                        if (MAX_MACRO_VALUE < 82.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 82.5) {
                                            if (RANGE_MACRO_VALUE < 28.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 28.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 31.5) {
                                        if (Y < 744) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 744) {
                                            if (RANGE_MACRO_VALUE < 148) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 148) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 936) {
                                if (MAX_MACRO_VALUE < 112) {
                                    if (MIN_MACRO_VALUE < 50) {
                                        zeroCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 50) {
                                        if (MAX_MACRO_VALUE < 100.5) {
                                            if (Y < 1000) {
                                                oneCount++;
                                            }
                                            else if (Y >= 1000) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 100.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 112) {
                                    if (MIN_MACRO_VALUE < 115) {
                                        if (RANGE_MACRO_VALUE < 96.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 96.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 115) {
                                        if (Y < 1000) {
                                            if (X < 1896) {
                                                oneCount++;
                                            }
                                            else if (X >= 1896) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 1000) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 185.5) {
                        if (X < 616) {
                            if (MIN_MACRO_VALUE < 40.5) {
                                if (X < 216) {
                                    if (Y < 432) {
                                        oneCount++;
                                    }
                                    else if (Y >= 432) {
                                        if (Y < 928) {
                                            if (AVG_MACRO_VALUE < 101.35) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 101.35) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 928) {
                                            if (RANGE_MACRO_VALUE < 190.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 190.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 216) {
                                    if (MIN_MACRO_VALUE < 37.5) {
                                        oneCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 37.5) {
                                        if (RANGE_MACRO_VALUE < 196.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 196.5) {
                                            if (AVG_MACRO_VALUE < 109.52) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 109.52) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 40.5) {
                                if (MAX_MACRO_VALUE < 235.5) {
                                    oneCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 235.5) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (X >= 616) {
                            if (X < 1320) {
                                if (MIN_MACRO_VALUE < 43.5) {
                                    if (X < 760) {
                                        if (Y < 952) {
                                            oneCount++;
                                        }
                                        else if (Y >= 952) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 760) {
                                        zeroCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 43.5) {
                                    if (X < 1024) {
                                        if (MIN_MACRO_VALUE < 47.5) {
                                            if (Y < 520) {
                                                oneCount++;
                                            }
                                            else if (Y >= 520) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 47.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 1024) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (X >= 1320) {
                                if (MIN_MACRO_VALUE < 39.5) {
                                    if (MIN_MACRO_VALUE < 38.5) {
                                        if (RANGE_MACRO_VALUE < 197.5) {
                                            if (Y < 920) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 920) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 197.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 38.5) {
                                        if (Y < 984) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 984) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 39.5) {
                                    if (Y < 224) {
                                        if (X < 1776) {
                                            oneCount++;
                                        }
                                        else if (X >= 1776) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 224) {
                                        if (AVG_MACRO_VALUE < 96.96) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 96.96) {
                                            if (X < 1600) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1600) {
                                                oneCount++;
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

    //TREE 4
    if (MAX_MACRO_VALUE < 73.5) {
            if (X < 1320) {
                if (RANGE_MACRO_VALUE < 24.5) {
                    if (AVG_MACRO_VALUE < 36.6) {
                        if (MAX_MACRO_VALUE < 18.5) {
                            if (AVG_MACRO_VALUE < 17.43) {
                                if (AVG_MACRO_VALUE < 17.41) {
                                    if (AVG_MACRO_VALUE < 16.95) {
                                        if (Y < 392) {
                                            if (AVG_MACRO_VALUE < 16.93) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 16.93) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 392) {
                                            if (X < 1080) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1080) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 16.95) {
                                        if (Y < 744) {
                                            if (Y < 728) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 728) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 744) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 17.41) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 17.43) {
                                if (Y < 680) {
                                    if (AVG_MACRO_VALUE < 17.47) {
                                        if (X < 1064) {
                                            zeroCount++;
                                        }
                                        else if (X >= 1064) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 17.47) {
                                        if (X < 432) {
                                            if (X < 312) {
                                                zeroCount++;
                                            }
                                            else if (X >= 312) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 432) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Y >= 680) {
                                    if (Y < 728) {
                                        if (X < 840) {
                                            if (Y < 712) {
                                                oneCount++;
                                            }
                                            else if (Y >= 712) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 840) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Y >= 728) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 18.5) {
                            if (Y < 168) {
                                if (AVG_MACRO_VALUE < 19.77) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 19.77) {
                                    if (X < 344) {
                                        if (AVG_MACRO_VALUE < 25.96) {
                                            if (MIN_MACRO_VALUE < 21.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 21.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 25.96) {
                                            if (X < 8) {
                                                oneCount++;
                                            }
                                            else if (X >= 8) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 344) {
                                        if (AVG_MACRO_VALUE < 32.6) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 32.6) {
                                            if (X < 1024) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1024) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 168) {
                                if (AVG_MACRO_VALUE < 36.58) {
                                    if (X < 664) {
                                        if (MIN_MACRO_VALUE < 28.5) {
                                            if (Y < 200) {
                                                oneCount++;
                                            }
                                            else if (Y >= 200) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 28.5) {
                                            if (Y < 760) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 760) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 664) {
                                        if (X < 680) {
                                            if (Y < 392) {
                                                oneCount++;
                                            }
                                            else if (Y >= 392) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 680) {
                                            if (Y < 648) {
                                                oneCount++;
                                            }
                                            else if (Y >= 648) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 36.58) {
                                    if (Y < 448) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 448) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 36.6) {
                        if (AVG_MACRO_VALUE < 50.65) {
                            if (AVG_MACRO_VALUE < 50.46) {
                                if (MIN_MACRO_VALUE < 41.5) {
                                    if (AVG_MACRO_VALUE < 49.05) {
                                        if (RANGE_MACRO_VALUE < 20.5) {
                                            if (AVG_MACRO_VALUE < 45.81) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 45.81) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 20.5) {
                                            if (Y < 904) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 904) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 49.05) {
                                        if (RANGE_MACRO_VALUE < 20.5) {
                                            if (Y < 568) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 568) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 20.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 41.5) {
                                    if (Y < 40) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 40) {
                                        if (X < 872) {
                                            if (Y < 776) {
                                                oneCount++;
                                            }
                                            else if (Y >= 776) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 872) {
                                            if (AVG_MACRO_VALUE < 45.29) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 45.29) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 50.46) {
                                if (MAX_MACRO_VALUE < 54.5) {
                                    if (Y < 216) {
                                        if (AVG_MACRO_VALUE < 50.52) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 50.52) {
                                            if (MIN_MACRO_VALUE < 48.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 48.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 216) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 54.5) {
                                    if (MIN_MACRO_VALUE < 48) {
                                        zeroCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 48) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 50.65) {
                            if (Y < 408) {
                                if (Y < 280) {
                                    if (X < 584) {
                                        zeroCount++;
                                    }
                                    else if (X >= 584) {
                                        if (MAX_MACRO_VALUE < 60.5) {
                                            if (Y < 104) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 104) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 60.5) {
                                            if (AVG_MACRO_VALUE < 55.41) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 55.41) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 280) {
                                    if (MAX_MACRO_VALUE < 59.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 59.5) {
                                        if (X < 1080) {
                                            if (X < 1048) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1048) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1080) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Y >= 408) {
                                if (X < 1192) {
                                    if (MAX_MACRO_VALUE < 70.5) {
                                        if (MIN_MACRO_VALUE < 40.5) {
                                            if (RANGE_MACRO_VALUE < 23.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 23.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 40.5) {
                                            if (X < 840) {
                                                zeroCount++;
                                            }
                                            else if (X >= 840) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 70.5) {
                                        if (AVG_MACRO_VALUE < 69.83) {
                                            if (RANGE_MACRO_VALUE < 21.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 21.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 69.83) {
                                            if (X < 584) {
                                                oneCount++;
                                            }
                                            else if (X >= 584) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1192) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 24.5) {
                    if (MAX_MACRO_VALUE < 63.5) {
                        if (MIN_MACRO_VALUE < 23.5) {
                            if (X < 472) {
                                if (RANGE_MACRO_VALUE < 44.5) {
                                    if (MIN_MACRO_VALUE < 22.5) {
                                        if (Y < 136) {
                                            if (RANGE_MACRO_VALUE < 43.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 43.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 136) {
                                            if (X < 328) {
                                                oneCount++;
                                            }
                                            else if (X >= 328) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 22.5) {
                                        if (Y < 712) {
                                            if (Y < 552) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 552) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 712) {
                                            if (AVG_MACRO_VALUE < 40.67) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 40.67) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 44.5) {
                                    zeroCount++;
                                }
                            }
                            else if (X >= 472) {
                                if (MAX_MACRO_VALUE < 50.5) {
                                    if (Y < 808) {
                                        if (Y < 712) {
                                            if (RANGE_MACRO_VALUE < 33.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 33.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 712) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 808) {
                                        if (MAX_MACRO_VALUE < 45.5) {
                                            if (AVG_MACRO_VALUE < 31.98) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 31.98) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 45.5) {
                                            if (MIN_MACRO_VALUE < 21.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 21.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 50.5) {
                                    if (MIN_MACRO_VALUE < 20.5) {
                                        if (Y < 104) {
                                            if (MAX_MACRO_VALUE < 59.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 59.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 104) {
                                            if (RANGE_MACRO_VALUE < 47.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 47.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 20.5) {
                                        if (MAX_MACRO_VALUE < 60.5) {
                                            if (Y < 968) {
                                                oneCount++;
                                            }
                                            else if (Y >= 968) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 60.5) {
                                            if (AVG_MACRO_VALUE < 36.49) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 36.49) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 23.5) {
                            if (X < 1208) {
                                if (AVG_MACRO_VALUE < 51.15) {
                                    if (AVG_MACRO_VALUE < 46.21) {
                                        if (X < 1192) {
                                            if (X < 1112) {
                                                oneCount++;
                                            }
                                            else if (X >= 1112) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1192) {
                                            if (Y < 576) {
                                                oneCount++;
                                            }
                                            else if (Y >= 576) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 46.21) {
                                        if (MIN_MACRO_VALUE < 37.5) {
                                            if (MIN_MACRO_VALUE < 36.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 36.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 37.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 51.15) {
                                    if (AVG_MACRO_VALUE < 51.23) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 51.23) {
                                        if (AVG_MACRO_VALUE < 53.67) {
                                            if (Y < 936) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 936) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 53.67) {
                                            if (X < 864) {
                                                oneCount++;
                                            }
                                            else if (X >= 864) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 1208) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 63.5) {
                        if (X < 680) {
                            if (RANGE_MACRO_VALUE < 51.5) {
                                if (X < 632) {
                                    if (Y < 840) {
                                        if (AVG_MACRO_VALUE < 56.8) {
                                            if (X < 136) {
                                                oneCount++;
                                            }
                                            else if (X >= 136) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 56.8) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 840) {
                                        if (MIN_MACRO_VALUE < 28.5) {
                                            if (RANGE_MACRO_VALUE < 48.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 48.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 28.5) {
                                            if (AVG_MACRO_VALUE < 48.54) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 48.54) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 632) {
                                    if (AVG_MACRO_VALUE < 54.45) {
                                        if (RANGE_MACRO_VALUE < 41.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 41.5) {
                                            if (RANGE_MACRO_VALUE < 43) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 43) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 54.45) {
                                        if (MIN_MACRO_VALUE < 20) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 20) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 51.5) {
                                if (X < 240) {
                                    zeroCount++;
                                }
                                else if (X >= 240) {
                                    if (Y < 968) {
                                        if (AVG_MACRO_VALUE < 68.15) {
                                            if (AVG_MACRO_VALUE < 43.18) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 43.18) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 68.15) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 968) {
                                        if (X < 568) {
                                            zeroCount++;
                                        }
                                        else if (X >= 568) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 680) {
                            if (Y < 456) {
                                if (MAX_MACRO_VALUE < 72.5) {
                                    if (MIN_MACRO_VALUE < 30.5) {
                                        if (X < 696) {
                                            if (MIN_MACRO_VALUE < 23.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 23.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 696) {
                                            if (RANGE_MACRO_VALUE < 48.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 48.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 30.5) {
                                        if (Y < 360) {
                                            if (MIN_MACRO_VALUE < 32.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 32.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 360) {
                                            if (MIN_MACRO_VALUE < 39) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 39) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 72.5) {
                                    if (X < 1112) {
                                        if (MIN_MACRO_VALUE < 42.5) {
                                            if (RANGE_MACRO_VALUE < 35.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 35.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 42.5) {
                                            if (MIN_MACRO_VALUE < 46.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 46.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1112) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (Y >= 456) {
                                if (Y < 552) {
                                    zeroCount++;
                                }
                                else if (Y >= 552) {
                                    if (X < 776) {
                                        if (MIN_MACRO_VALUE < 26.5) {
                                            if (MAX_MACRO_VALUE < 71.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 71.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 26.5) {
                                            if (AVG_MACRO_VALUE < 49.69) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 49.69) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 776) {
                                        if (Y < 696) {
                                            if (MAX_MACRO_VALUE < 65.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 65.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 696) {
                                            if (RANGE_MACRO_VALUE < 46.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 46.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (X >= 1320) {
                if (AVG_MACRO_VALUE < 41.56) {
                    if (Y < 88) {
                        if (X < 1880) {
                            if (X < 1528) {
                                zeroCount++;
                            }
                            else if (X >= 1528) {
                                if (AVG_MACRO_VALUE < 39.37) {
                                    if (X < 1864) {
                                        if (X < 1720) {
                                            if (Y < 8) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 8) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1720) {
                                            if (Y < 40) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 40) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1864) {
                                        if (MAX_MACRO_VALUE < 28.5) {
                                            if (AVG_MACRO_VALUE < 18.43) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 18.43) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 28.5) {
                                            if (AVG_MACRO_VALUE < 25.83) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 25.83) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 39.37) {
                                    if (X < 1768) {
                                        zeroCount++;
                                    }
                                    else if (X >= 1768) {
                                        if (AVG_MACRO_VALUE < 40.02) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 40.02) {
                                            if (RANGE_MACRO_VALUE < 34) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 34) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 1880) {
                            if (MIN_MACRO_VALUE < 16.5) {
                                if (RANGE_MACRO_VALUE < 23) {
                                    if (Y < 56) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 56) {
                                        oneCount++;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 23) {
                                    zeroCount++;
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 16.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Y >= 88) {
                        if (X < 1336) {
                            if (AVG_MACRO_VALUE < 23.09) {
                                if (MAX_MACRO_VALUE < 20) {
                                    if (AVG_MACRO_VALUE < 17.54) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 17.54) {
                                        oneCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 20) {
                                    if (Y < 104) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 104) {
                                        if (Y < 1016) {
                                            oneCount++;
                                        }
                                        else if (Y >= 1016) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 23.09) {
                                if (AVG_MACRO_VALUE < 31.41) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 31.41) {
                                    if (Y < 344) {
                                        if (Y < 312) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 312) {
                                            if (RANGE_MACRO_VALUE < 38.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 38.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 344) {
                                        if (MIN_MACRO_VALUE < 37.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 37.5) {
                                            if (AVG_MACRO_VALUE < 41.45) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 41.45) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 1336) {
                            if (MIN_MACRO_VALUE < 38.5) {
                                if (AVG_MACRO_VALUE < 40.26) {
                                    if (MIN_MACRO_VALUE < 31.5) {
                                        if (MAX_MACRO_VALUE < 19.5) {
                                            if (X < 1640) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1640) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 19.5) {
                                            if (AVG_MACRO_VALUE < 20.8) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 20.8) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 31.5) {
                                        if (Y < 712) {
                                            if (X < 1704) {
                                                oneCount++;
                                            }
                                            else if (X >= 1704) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 712) {
                                            if (X < 1752) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1752) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 40.26) {
                                    if (X < 1608) {
                                        if (AVG_MACRO_VALUE < 40.75) {
                                            if (X < 1592) {
                                                oneCount++;
                                            }
                                            else if (X >= 1592) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 40.75) {
                                            if (AVG_MACRO_VALUE < 41.11) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 41.11) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1608) {
                                        if (Y < 392) {
                                            if (MIN_MACRO_VALUE < 31.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 31.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 392) {
                                            if (Y < 872) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 872) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 38.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 41.56) {
                    if (MAX_MACRO_VALUE < 61.5) {
                        if (Y < 744) {
                            if (AVG_MACRO_VALUE < 54.02) {
                                if (Y < 664) {
                                    if (AVG_MACRO_VALUE < 51.19) {
                                        if (Y < 584) {
                                            if (X < 1736) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1736) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 584) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 51.19) {
                                        if (AVG_MACRO_VALUE < 51.45) {
                                            if (MAX_MACRO_VALUE < 58.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 58.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 51.45) {
                                            if (RANGE_MACRO_VALUE < 25.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 25.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 664) {
                                    if (RANGE_MACRO_VALUE < 10.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 10.5) {
                                        if (AVG_MACRO_VALUE < 42.17) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.17) {
                                            if (MAX_MACRO_VALUE < 54.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 54.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 54.02) {
                                if (X < 1800) {
                                    zeroCount++;
                                }
                                else if (X >= 1800) {
                                    if (MAX_MACRO_VALUE < 56.5) {
                                        oneCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 56.5) {
                                        if (RANGE_MACRO_VALUE < 5.5) {
                                            if (X < 1856) {
                                                oneCount++;
                                            }
                                            else if (X >= 1856) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 5.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Y >= 744) {
                            if (X < 1592) {
                                zeroCount++;
                            }
                            else if (X >= 1592) {
                                if (MIN_MACRO_VALUE < 37.5) {
                                    if (MIN_MACRO_VALUE < 32.5) {
                                        if (MIN_MACRO_VALUE < 31.5) {
                                            if (X < 1688) {
                                                oneCount++;
                                            }
                                            else if (X >= 1688) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 31.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 32.5) {
                                        if (Y < 904) {
                                            if (X < 1800) {
                                                oneCount++;
                                            }
                                            else if (X >= 1800) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 904) {
                                            if (AVG_MACRO_VALUE < 45.77) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 45.77) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 37.5) {
                                    if (MIN_MACRO_VALUE < 42.5) {
                                        if (MIN_MACRO_VALUE < 41.5) {
                                            if (AVG_MACRO_VALUE < 47.64) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 47.64) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 41.5) {
                                            if (AVG_MACRO_VALUE < 47.03) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 47.03) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 42.5) {
                                        if (X < 1720) {
                                            if (X < 1688) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1688) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1720) {
                                            if (MIN_MACRO_VALUE < 48.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 48.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 61.5) {
                        if (AVG_MACRO_VALUE < 50.2) {
                            if (AVG_MACRO_VALUE < 49.13) {
                                if (AVG_MACRO_VALUE < 45.47) {
                                    if (Y < 512) {
                                        if (X < 1784) {
                                            if (X < 1336) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1336) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1784) {
                                            if (Y < 112) {
                                                oneCount++;
                                            }
                                            else if (Y >= 112) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 512) {
                                        if (MIN_MACRO_VALUE < 26.5) {
                                            if (X < 1640) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1640) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 26.5) {
                                            if (AVG_MACRO_VALUE < 45.32) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 45.32) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 45.47) {
                                    if (X < 1608) {
                                        if (MAX_MACRO_VALUE < 70) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 70) {
                                            if (RANGE_MACRO_VALUE < 39.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 39.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1608) {
                                        if (X < 1800) {
                                            if (AVG_MACRO_VALUE < 48.4) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 48.4) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1800) {
                                            if (AVG_MACRO_VALUE < 46.4) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 46.4) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 49.13) {
                                if (AVG_MACRO_VALUE < 49.4) {
                                    if (Y < 264) {
                                        if (AVG_MACRO_VALUE < 49.19) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 49.19) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 264) {
                                        if (Y < 432) {
                                            oneCount++;
                                        }
                                        else if (Y >= 432) {
                                            if (Y < 512) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 512) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 49.4) {
                                    if (Y < 376) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 376) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            if (X < 1584) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1584) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 50.2) {
                            if (AVG_MACRO_VALUE < 51.03) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 51.03) {
                                if (Y < 456) {
                                    if (X < 1784) {
                                        if (AVG_MACRO_VALUE < 60.58) {
                                            if (MAX_MACRO_VALUE < 70.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 70.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 60.58) {
                                            if (MIN_MACRO_VALUE < 67.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 67.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1784) {
                                        if (Y < 56) {
                                            if (RANGE_MACRO_VALUE < 21.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 21.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 56) {
                                            if (MIN_MACRO_VALUE < 56.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 56.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 456) {
                                    if (MAX_MACRO_VALUE < 69.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 69.5) {
                                        if (MIN_MACRO_VALUE < 50.5) {
                                            if (MIN_MACRO_VALUE < 38.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 38.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 50.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else if (MAX_MACRO_VALUE >= 73.5) {
            if (RANGE_MACRO_VALUE < 28.5) {
                if (MIN_MACRO_VALUE < 191.5) {
                    if (MAX_MACRO_VALUE < 129.5) {
                        if (Y < 152) {
                            if (MAX_MACRO_VALUE < 103.5) {
                                if (X < 760) {
                                    if (X < 456) {
                                        if (MAX_MACRO_VALUE < 76.5) {
                                            if (X < 168) {
                                                oneCount++;
                                            }
                                            else if (X >= 168) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 76.5) {
                                            if (MAX_MACRO_VALUE < 82.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 82.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 456) {
                                        if (AVG_MACRO_VALUE < 87.42) {
                                            if (X < 712) {
                                                zeroCount++;
                                            }
                                            else if (X >= 712) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 87.42) {
                                            if (X < 648) {
                                                oneCount++;
                                            }
                                            else if (X >= 648) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 760) {
                                    if (MIN_MACRO_VALUE < 78.5) {
                                        if (RANGE_MACRO_VALUE < 27.5) {
                                            if (MIN_MACRO_VALUE < 75.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 75.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 27.5) {
                                            if (MAX_MACRO_VALUE < 86) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 86) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 78.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 103.5) {
                                if (AVG_MACRO_VALUE < 125.18) {
                                    if (MAX_MACRO_VALUE < 105.5) {
                                        if (MIN_MACRO_VALUE < 100.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 100.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 105.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 125.18) {
                                    if (AVG_MACRO_VALUE < 125.29) {
                                        if (AVG_MACRO_VALUE < 125.28) {
                                            if (RANGE_MACRO_VALUE < 10.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 10.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 125.28) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 125.29) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (Y >= 152) {
                            if (Y < 200) {
                                if (AVG_MACRO_VALUE < 105.04) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 105.04) {
                                    if (MAX_MACRO_VALUE < 113.5) {
                                        if (AVG_MACRO_VALUE < 111.16) {
                                            if (X < 496) {
                                                oneCount++;
                                            }
                                            else if (X >= 496) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 111.16) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 113.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (Y >= 200) {
                                if (Y < 968) {
                                    if (MAX_MACRO_VALUE < 128.5) {
                                        if (Y < 920) {
                                            if (Y < 904) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 904) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 920) {
                                            if (MIN_MACRO_VALUE < 99.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 99.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 128.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (Y >= 968) {
                                    if (Y < 1000) {
                                        if (X < 824) {
                                            if (Y < 984) {
                                                oneCount++;
                                            }
                                            else if (Y >= 984) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 824) {
                                            if (Y < 984) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 984) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 1000) {
                                        if (MAX_MACRO_VALUE < 114) {
                                            if (X < 1576) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1576) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 114) {
                                            if (AVG_MACRO_VALUE < 110.96) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 110.96) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 129.5) {
                        if (MAX_MACRO_VALUE < 130.5) {
                            if (RANGE_MACRO_VALUE < 12.5) {
                                if (RANGE_MACRO_VALUE < 3.5) {
                                    if (X < 520) {
                                        zeroCount++;
                                    }
                                    else if (X >= 520) {
                                        oneCount++;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 3.5) {
                                    if (AVG_MACRO_VALUE < 126.49) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 126.49) {
                                        if (AVG_MACRO_VALUE < 126.65) {
                                            if (Y < 1000) {
                                                oneCount++;
                                            }
                                            else if (Y >= 1000) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 126.65) {
                                            if (AVG_MACRO_VALUE < 127.02) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 127.02) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 12.5) {
                                if (RANGE_MACRO_VALUE < 13.5) {
                                    if (X < 640) {
                                        oneCount++;
                                    }
                                    else if (X >= 640) {
                                        zeroCount++;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 13.5) {
                                    if (RANGE_MACRO_VALUE < 16.5) {
                                        if (RANGE_MACRO_VALUE < 14.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 14.5) {
                                            if (X < 136) {
                                                oneCount++;
                                            }
                                            else if (X >= 136) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 16.5) {
                                        if (Y < 952) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 952) {
                                            if (RANGE_MACRO_VALUE < 21.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 21.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 130.5) {
                            if (X < 24) {
                                zeroCount++;
                            }
                            else if (X >= 24) {
                                if (RANGE_MACRO_VALUE < 16.5) {
                                    if (AVG_MACRO_VALUE < 127.58) {
                                        if (MIN_MACRO_VALUE < 116.5) {
                                            if (AVG_MACRO_VALUE < 126.65) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 126.65) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 116.5) {
                                            if (Y < 1032) {
                                                oneCount++;
                                            }
                                            else if (Y >= 1032) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 127.58) {
                                        if (AVG_MACRO_VALUE < 127.85) {
                                            if (X < 632) {
                                                oneCount++;
                                            }
                                            else if (X >= 632) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 127.85) {
                                            if (Y < 440) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 440) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 16.5) {
                                    if (Y < 952) {
                                        if (MIN_MACRO_VALUE < 113.5) {
                                            if (RANGE_MACRO_VALUE < 26.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 26.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 113.5) {
                                            if (AVG_MACRO_VALUE < 124.57) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 124.57) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 952) {
                                        if (AVG_MACRO_VALUE < 125.01) {
                                            if (X < 688) {
                                                zeroCount++;
                                            }
                                            else if (X >= 688) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 125.01) {
                                            if (Y < 968) {
                                                oneCount++;
                                            }
                                            else if (Y >= 968) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 191.5) {
                    if (X < 616) {
                        if (RANGE_MACRO_VALUE < 7.5) {
                            zeroCount++;
                        }
                        else if (RANGE_MACRO_VALUE >= 7.5) {
                            if (Y < 136) {
                                zeroCount++;
                            }
                            else if (Y >= 136) {
                                oneCount++;
                            }
                        }
                    }
                    else if (X >= 616) {
                        zeroCount++;
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 28.5) {
                if (MAX_MACRO_VALUE < 100.5) {
                    if (MIN_MACRO_VALUE < 66.5) {
                        if (RANGE_MACRO_VALUE < 84.5) {
                            if (Y < 584) {
                                if (RANGE_MACRO_VALUE < 75.5) {
                                    if (Y < 568) {
                                        if (Y < 552) {
                                            if (MAX_MACRO_VALUE < 99.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 99.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 552) {
                                            if (RANGE_MACRO_VALUE < 48.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 48.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 568) {
                                        if (X < 1096) {
                                            if (MIN_MACRO_VALUE < 29.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 29.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1096) {
                                            if (MIN_MACRO_VALUE < 55.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 55.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 75.5) {
                                    if (Y < 488) {
                                        if (Y < 328) {
                                            if (MAX_MACRO_VALUE < 98.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 98.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 328) {
                                            if (Y < 440) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 440) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 488) {
                                        if (Y < 520) {
                                            if (MIN_MACRO_VALUE < 17.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 17.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 520) {
                                            if (Y < 552) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 552) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 584) {
                                if (MAX_MACRO_VALUE < 92.5) {
                                    if (MIN_MACRO_VALUE < 58.5) {
                                        if (AVG_MACRO_VALUE < 70.12) {
                                            if (X < 1560) {
                                                oneCount++;
                                            }
                                            else if (X >= 1560) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 70.12) {
                                            if (Y < 920) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 920) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 58.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 92.5) {
                                    if (X < 1768) {
                                        if (X < 920) {
                                            if (AVG_MACRO_VALUE < 41.78) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 41.78) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 920) {
                                            if (MIN_MACRO_VALUE < 61) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 61) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1768) {
                                        if (X < 1864) {
                                            if (AVG_MACRO_VALUE < 74.99) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 74.99) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1864) {
                                            if (Y < 984) {
                                                oneCount++;
                                            }
                                            else if (Y >= 984) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 84.5) {
                            if (X < 928) {
                                zeroCount++;
                            }
                            else if (X >= 928) {
                                if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                    oneCount++;
                                }
                                else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                    if (Y < 240) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 240) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 66.5) {
                        if (Y < 720) {
                            if (AVG_MACRO_VALUE < 82.47) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 82.47) {
                                if (Y < 408) {
                                    if (Y < 344) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 344) {
                                        if (X < 1304) {
                                            zeroCount++;
                                        }
                                        else if (X >= 1304) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Y >= 408) {
                                    if (MAX_MACRO_VALUE < 96.5) {
                                        if (X < 696) {
                                            oneCount++;
                                        }
                                        else if (X >= 696) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 96.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (Y >= 720) {
                            if (Y < 888) {
                                oneCount++;
                            }
                            else if (Y >= 888) {
                                if (X < 416) {
                                    if (X < 256) {
                                        oneCount++;
                                    }
                                    else if (X >= 256) {
                                        if (X < 328) {
                                            zeroCount++;
                                        }
                                        else if (X >= 328) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (X >= 416) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 100.5) {
                    if (MAX_MACRO_VALUE < 104.5) {
                        if (AVG_MACRO_VALUE < 53.55) {
                            if (RANGE_MACRO_VALUE < 85.5) {
                                if (Y < 648) {
                                    if (X < 872) {
                                        if (AVG_MACRO_VALUE < 35.76) {
                                            if (Y < 192) {
                                                oneCount++;
                                            }
                                            else if (Y >= 192) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 35.76) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 872) {
                                        if (X < 888) {
                                            if (AVG_MACRO_VALUE < 48.27) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 48.27) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 888) {
                                            if (AVG_MACRO_VALUE < 44.54) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 44.54) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 648) {
                                    if (X < 704) {
                                        if (Y < 664) {
                                            if (MIN_MACRO_VALUE < 20) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 20) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 664) {
                                            if (RANGE_MACRO_VALUE < 71) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 71) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 704) {
                                        if (MIN_MACRO_VALUE < 24.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 24.5) {
                                            if (RANGE_MACRO_VALUE < 74.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 74.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 85.5) {
                                if (MIN_MACRO_VALUE < 15.5) {
                                    if (X < 1016) {
                                        if (AVG_MACRO_VALUE < 42.52) {
                                            if (X < 152) {
                                                zeroCount++;
                                            }
                                            else if (X >= 152) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.52) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 1016) {
                                        zeroCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 15.5) {
                                    if (AVG_MACRO_VALUE < 35.38) {
                                        if (Y < 712) {
                                            if (AVG_MACRO_VALUE < 30.38) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 30.38) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 712) {
                                            if (AVG_MACRO_VALUE < 26.09) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 26.09) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 35.38) {
                                        if (AVG_MACRO_VALUE < 45.54) {
                                            if (Y < 704) {
                                                oneCount++;
                                            }
                                            else if (Y >= 704) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 45.54) {
                                            if (AVG_MACRO_VALUE < 48.8) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 48.8) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 53.55) {
                            if (RANGE_MACRO_VALUE < 31.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 31.5) {
                                if (X < 1000) {
                                    if (RANGE_MACRO_VALUE < 84.5) {
                                        if (RANGE_MACRO_VALUE < 82.5) {
                                            if (Y < 56) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 56) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 82.5) {
                                            if (AVG_MACRO_VALUE < 78.73) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 78.73) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 84.5) {
                                        if (Y < 880) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 880) {
                                            if (Y < 968) {
                                                oneCount++;
                                            }
                                            else if (Y >= 968) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1000) {
                                    if (AVG_MACRO_VALUE < 67.63) {
                                        if (Y < 312) {
                                            if (AVG_MACRO_VALUE < 58.38) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 58.38) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 312) {
                                            if (RANGE_MACRO_VALUE < 74.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 74.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 67.63) {
                                        if (MAX_MACRO_VALUE < 102.5) {
                                            if (Y < 904) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 904) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 102.5) {
                                            if (X < 1192) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1192) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 104.5) {
                        if (X < 1896) {
                            if (X < 8) {
                                if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                    if (RANGE_MACRO_VALUE < 68) {
                                        if (Y < 112) {
                                            oneCount++;
                                        }
                                        else if (Y >= 112) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 68) {
                                        if (AVG_MACRO_VALUE < 67.67) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 67.67) {
                                            if (RANGE_MACRO_VALUE < 72.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 72.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                    if (MAX_MACRO_VALUE < 116.5) {
                                        if (AVG_MACRO_VALUE < 72.97) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 72.97) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 116.5) {
                                        if (Y < 176) {
                                            if (MAX_MACRO_VALUE < 121.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 121.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 176) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (X >= 8) {
                                if (RANGE_MACRO_VALUE < 36.5) {
                                    if (MIN_MACRO_VALUE < 71.5) {
                                        zeroCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 71.5) {
                                        if (X < 776) {
                                            if (MAX_MACRO_VALUE < 147.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 147.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 776) {
                                            if (X < 808) {
                                                zeroCount++;
                                            }
                                            else if (X >= 808) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 36.5) {
                                    if (AVG_MACRO_VALUE < 160.33) {
                                        if (MIN_MACRO_VALUE < 17.5) {
                                            if (Y < 344) {
                                                oneCount++;
                                            }
                                            else if (Y >= 344) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 17.5) {
                                            if (Y < 792) {
                                                oneCount++;
                                            }
                                            else if (Y >= 792) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 160.33) {
                                        if (AVG_MACRO_VALUE < 164.54) {
                                            if (MIN_MACRO_VALUE < 125.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 125.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 164.54) {
                                            if (RANGE_MACRO_VALUE < 153.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 153.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 1896) {
                            zeroCount++;
                        }
                    }
                }
            }
        }

    //TREE 5 (FINAL TREE)
    if (MIN_MACRO_VALUE < 34.5) {
            if (RANGE_MACRO_VALUE < 1.5) {
                if (Y < 360) {
                    if (AVG_MACRO_VALUE < 17.29) {
                        if (Y < 216) {
                            if (AVG_MACRO_VALUE < 17.02) {
                                if (AVG_MACRO_VALUE < 16.96) {
                                    if (Y < 40) {
                                        if (Y < 24) {
                                            if (X < 120) {
                                                zeroCount++;
                                            }
                                            else if (X >= 120) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 24) {
                                            if (AVG_MACRO_VALUE < 16.94) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 16.94) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 40) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 16.96) {
                                    if (X < 968) {
                                        if (X < 72) {
                                            if (AVG_MACRO_VALUE < 16.96) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 16.96) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 72) {
                                            if (Y < 144) {
                                                oneCount++;
                                            }
                                            else if (Y >= 144) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 968) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 17.02) {
                                if (Y < 112) {
                                    zeroCount++;
                                }
                                else if (Y >= 112) {
                                    if (Y < 160) {
                                        if (X < 1816) {
                                            oneCount++;
                                        }
                                        else if (X >= 1816) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 160) {
                                        if (X < 1072) {
                                            zeroCount++;
                                        }
                                        else if (X >= 1072) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Y >= 216) {
                            if (X < 1064) {
                                if (AVG_MACRO_VALUE < 17.07) {
                                    if (X < 984) {
                                        if (AVG_MACRO_VALUE < 17.01) {
                                            if (Y < 328) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 328) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.01) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 984) {
                                        if (Y < 320) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 320) {
                                            if (X < 1016) {
                                                oneCount++;
                                            }
                                            else if (X >= 1016) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 17.07) {
                                    if (AVG_MACRO_VALUE < 17.19) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 17.19) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (X >= 1064) {
                                if (X < 1088) {
                                    zeroCount++;
                                }
                                else if (X >= 1088) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 17.29) {
                        if (AVG_MACRO_VALUE < 23.37) {
                            if (Y < 56) {
                                zeroCount++;
                            }
                            else if (Y >= 56) {
                                if (MAX_MACRO_VALUE < 19.5) {
                                    if (X < 1720) {
                                        if (Y < 288) {
                                            if (Y < 160) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 160) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 288) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 1720) {
                                        if (X < 1744) {
                                            oneCount++;
                                        }
                                        else if (X >= 1744) {
                                            if (AVG_MACRO_VALUE < 17.67) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 17.67) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 19.5) {
                                    if (AVG_MACRO_VALUE < 19.08) {
                                        if (Y < 344) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 344) {
                                            if (X < 72) {
                                                zeroCount++;
                                            }
                                            else if (X >= 72) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 19.08) {
                                        if (Y < 216) {
                                            if (X < 648) {
                                                oneCount++;
                                            }
                                            else if (X >= 648) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 216) {
                                            if (AVG_MACRO_VALUE < 20.09) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 20.09) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 23.37) {
                            zeroCount++;
                        }
                    }
                }
                else if (Y >= 360) {
                    if (X < 104) {
                        if (AVG_MACRO_VALUE < 31.85) {
                            if (Y < 432) {
                                zeroCount++;
                            }
                            else if (Y >= 432) {
                                if (X < 24) {
                                    zeroCount++;
                                }
                                else if (X >= 24) {
                                    if (AVG_MACRO_VALUE < 19.08) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 19.08) {
                                        if (X < 40) {
                                            if (Y < 824) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 824) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 40) {
                                            if (X < 72) {
                                                oneCount++;
                                            }
                                            else if (X >= 72) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 31.85) {
                            zeroCount++;
                        }
                    }
                    else if (X >= 104) {
                        if (X < 472) {
                            if (AVG_MACRO_VALUE < 23.43) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 23.43) {
                                if (Y < 904) {
                                    if (X < 208) {
                                        if (MAX_MACRO_VALUE < 27) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 27) {
                                            if (X < 168) {
                                                oneCount++;
                                            }
                                            else if (X >= 168) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 208) {
                                        if (AVG_MACRO_VALUE < 27.11) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 27.11) {
                                            if (X < 256) {
                                                zeroCount++;
                                            }
                                            else if (X >= 256) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 904) {
                                    if (X < 128) {
                                        oneCount++;
                                    }
                                    else if (X >= 128) {
                                        if (MIN_MACRO_VALUE < 23.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 23.5) {
                                            if (Y < 920) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 920) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 472) {
                            if (X < 488) {
                                if (MIN_MACRO_VALUE < 21.5) {
                                    zeroCount++;
                                }
                                else if (MIN_MACRO_VALUE >= 21.5) {
                                    if (AVG_MACRO_VALUE < 22.8) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 22.8) {
                                        if (MIN_MACRO_VALUE < 26) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 26) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (X >= 488) {
                                if (AVG_MACRO_VALUE < 21.25) {
                                    if (Y < 392) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 392) {
                                        if (MAX_MACRO_VALUE < 17.5) {
                                            if (X < 1176) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1176) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 17.5) {
                                            if (Y < 552) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 552) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 21.25) {
                                    if (Y < 984) {
                                        if (AVG_MACRO_VALUE < 32.38) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 32.38) {
                                            if (MIN_MACRO_VALUE < 33.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 33.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 984) {
                                        if (AVG_MACRO_VALUE < 23.18) {
                                            if (AVG_MACRO_VALUE < 22.05) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 22.05) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 23.18) {
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
                        }
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 1.5) {
                if (X < 664) {
                    if (AVG_MACRO_VALUE < 56.78) {
                        if (MIN_MACRO_VALUE < 25.5) {
                            if (RANGE_MACRO_VALUE < 219.5) {
                                if (X < 648) {
                                    if (AVG_MACRO_VALUE < 20.37) {
                                        if (X < 520) {
                                            if (Y < 456) {
                                                oneCount++;
                                            }
                                            else if (Y >= 456) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 520) {
                                            if (RANGE_MACRO_VALUE < 125.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 125.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 20.37) {
                                        if (AVG_MACRO_VALUE < 55.06) {
                                            if (Y < 504) {
                                                oneCount++;
                                            }
                                            else if (Y >= 504) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 55.06) {
                                            if (X < 520) {
                                                zeroCount++;
                                            }
                                            else if (X >= 520) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 648) {
                                    if (Y < 920) {
                                        if (MIN_MACRO_VALUE < 18.5) {
                                            if (AVG_MACRO_VALUE < 36.76) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 36.76) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 18.5) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                zeroCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 920) {
                                        if (MIN_MACRO_VALUE < 16.5) {
                                            if (AVG_MACRO_VALUE < 42.95) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 42.95) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 16.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 219.5) {
                                zeroCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 25.5) {
                            if (MAX_MACRO_VALUE < 214) {
                                if (X < 24) {
                                    if (MIN_MACRO_VALUE < 31.5) {
                                        zeroCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 31.5) {
                                        if (MIN_MACRO_VALUE < 32.5) {
                                            if (AVG_MACRO_VALUE < 44.71) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 44.71) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 32.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (X >= 24) {
                                    if (Y < 1000) {
                                        if (X < 632) {
                                            if (MAX_MACRO_VALUE < 148.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 148.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 632) {
                                            if (MIN_MACRO_VALUE < 27.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 27.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 1000) {
                                        if (X < 312) {
                                            if (RANGE_MACRO_VALUE < 105.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 105.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 312) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 214) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 56.78) {
                        if (X < 568) {
                            if (MIN_MACRO_VALUE < 24.5) {
                                if (Y < 1048) {
                                    if (MIN_MACRO_VALUE < 17.5) {
                                        if (X < 184) {
                                            if (X < 88) {
                                                zeroCount++;
                                            }
                                            else if (X >= 88) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 184) {
                                            if (Y < 888) {
                                                oneCount++;
                                            }
                                            else if (Y >= 888) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 17.5) {
                                        if (Y < 600) {
                                            if (MAX_MACRO_VALUE < 98.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 98.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 600) {
                                            if (Y < 648) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 648) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 1048) {
                                    if (X < 360) {
                                        zeroCount++;
                                    }
                                    else if (X >= 360) {
                                        if (RANGE_MACRO_VALUE < 201) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 201) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 24.5) {
                                if (RANGE_MACRO_VALUE < 81.5) {
                                    if (AVG_MACRO_VALUE < 85.24) {
                                        if (Y < 120) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 120) {
                                            if (MAX_MACRO_VALUE < 111.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 111.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 85.24) {
                                        if (X < 40) {
                                            if (X < 24) {
                                                oneCount++;
                                            }
                                            else if (X >= 24) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 40) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                oneCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 81.5) {
                                    if (X < 440) {
                                        if (RANGE_MACRO_VALUE < 112.5) {
                                            if (MAX_MACRO_VALUE < 123.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 123.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 112.5) {
                                            if (RANGE_MACRO_VALUE < 137.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 137.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 440) {
                                        if (RANGE_MACRO_VALUE < 91.5) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                zeroCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 91.5) {
                                            if (MIN_MACRO_VALUE < 33.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 33.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 568) {
                            if (AVG_MACRO_VALUE < 106.91) {
                                if (MIN_MACRO_VALUE < 25.5) {
                                    if (AVG_MACRO_VALUE < 85.68) {
                                        if (X < 648) {
                                            if (MAX_MACRO_VALUE < 228) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 228) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 648) {
                                            if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                                oneCount++;
                                            }
                                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 85.68) {
                                        if (MIN_MACRO_VALUE < 17.5) {
                                            if (RANGE_MACRO_VALUE < 100.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 100.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 17.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 25.5) {
                                    if (MAX_MACRO_VALUE < 101.5) {
                                        if (Y < 336) {
                                            if (MAX_MACRO_VALUE < 100.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 100.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 336) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 101.5) {
                                        if (MAX_MACRO_VALUE < 225.5) {
                                            if (AVG_MACRO_VALUE < 104.49) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 104.49) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 225.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 106.91) {
                                if (Y < 800) {
                                    if (RANGE_MACRO_VALUE < 200.5) {
                                        if (Y < 224) {
                                            if (X < 608) {
                                                zeroCount++;
                                            }
                                            else if (X >= 608) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 224) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 200.5) {
                                        if (Y < 472) {
                                            oneCount++;
                                        }
                                        else if (Y >= 472) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Y >= 800) {
                                    if (Y < 968) {
                                        if (RANGE_MACRO_VALUE < 120.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 120.5) {
                                            if (RANGE_MACRO_VALUE < 132) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 132) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 968) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (X >= 664) {
                    if (Y < 504) {
                        if (Y < 200) {
                            if (X < 824) {
                                if (MIN_MACRO_VALUE < 28.5) {
                                    zeroCount++;
                                }
                                else if (MIN_MACRO_VALUE >= 28.5) {
                                    if (RANGE_MACRO_VALUE < 2.5) {
                                        if (X < 752) {
                                            zeroCount++;
                                        }
                                        else if (X >= 752) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 2.5) {
                                        if (X < 728) {
                                            if (MAX_MACRO_VALUE < 36.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 36.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 728) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (X >= 824) {
                                if (AVG_MACRO_VALUE < 17.79) {
                                    if (Y < 120) {
                                        if (RANGE_MACRO_VALUE < 2.5) {
                                            if (AVG_MACRO_VALUE < 17.59) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 17.59) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 2.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 120) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 17.79) {
                                    if (MIN_MACRO_VALUE < 16.5) {
                                        if (X < 1752) {
                                            if (RANGE_MACRO_VALUE < 63.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 63.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1752) {
                                            if (RANGE_MACRO_VALUE < 112.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 112.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 16.5) {
                                        if (X < 1704) {
                                            if (MAX_MACRO_VALUE < 118.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 118.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1704) {
                                            if (MAX_MACRO_VALUE < 90.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 90.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (Y >= 200) {
                            if (X < 1096) {
                                if (MIN_MACRO_VALUE < 21.5) {
                                    if (Y < 440) {
                                        if (X < 680) {
                                            if (MIN_MACRO_VALUE < 18.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 18.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 680) {
                                            if (AVG_MACRO_VALUE < 28.1) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 28.1) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 440) {
                                        if (RANGE_MACRO_VALUE < 101.5) {
                                            if (AVG_MACRO_VALUE < 26.7) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 26.7) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 101.5) {
                                            if (MAX_MACRO_VALUE < 211.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 211.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 21.5) {
                                    if (RANGE_MACRO_VALUE < 17.5) {
                                        if (X < 984) {
                                            if (RANGE_MACRO_VALUE < 6.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 6.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 984) {
                                            if (MAX_MACRO_VALUE < 28.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 28.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 17.5) {
                                        if (Y < 264) {
                                            if (X < 984) {
                                                oneCount++;
                                            }
                                            else if (X >= 984) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 264) {
                                            if (X < 680) {
                                                zeroCount++;
                                            }
                                            else if (X >= 680) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 1096) {
                                if (X < 1224) {
                                    if (RANGE_MACRO_VALUE < 49.5) {
                                        if (AVG_MACRO_VALUE < 42.2) {
                                            if (X < 1144) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1144) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.2) {
                                            if (Y < 392) {
                                                oneCount++;
                                            }
                                            else if (Y >= 392) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 49.5) {
                                        if (X < 1128) {
                                            if (MAX_MACRO_VALUE < 119) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 119) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1128) {
                                            if (MAX_MACRO_VALUE < 92.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 92.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1224) {
                                    if (X < 1816) {
                                        if (X < 1800) {
                                            if (Y < 440) {
                                                oneCount++;
                                            }
                                            else if (Y >= 440) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1800) {
                                            if (MIN_MACRO_VALUE < 24.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 24.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1816) {
                                        if (Y < 408) {
                                            if (Y < 344) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 344) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 408) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Y >= 504) {
                        if (MIN_MACRO_VALUE < 21.5) {
                            if (X < 728) {
                                if (RANGE_MACRO_VALUE < 68.5) {
                                    if (AVG_MACRO_VALUE < 18.2) {
                                        if (X < 712) {
                                            oneCount++;
                                        }
                                        else if (X >= 712) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 18.2) {
                                        if (AVG_MACRO_VALUE < 47.93) {
                                            if (MIN_MACRO_VALUE < 16.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 16.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 47.93) {
                                            if (RANGE_MACRO_VALUE < 64.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 64.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 68.5) {
                                    if (MAX_MACRO_VALUE < 114) {
                                        if (Y < 880) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 880) {
                                            if (MIN_MACRO_VALUE < 17.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 17.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 114) {
                                        if (RANGE_MACRO_VALUE < 123.5) {
                                            if (RANGE_MACRO_VALUE < 117.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 117.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 123.5) {
                                            if (RANGE_MACRO_VALUE < 218) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 218) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 728) {
                                if (RANGE_MACRO_VALUE < 147.5) {
                                    if (MAX_MACRO_VALUE < 126.5) {
                                        if (RANGE_MACRO_VALUE < 101.5) {
                                            if (MIN_MACRO_VALUE < 15.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 15.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 101.5) {
                                            if (AVG_MACRO_VALUE < 42.57) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 42.57) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 126.5) {
                                        if (RANGE_MACRO_VALUE < 113.5) {
                                            if (Y < 760) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 760) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 113.5) {
                                            if (Y < 552) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 552) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 147.5) {
                                    if (Y < 552) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 552) {
                                        if (AVG_MACRO_VALUE < 22.5) {
                                            if (MIN_MACRO_VALUE < 16.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 16.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 22.5) {
                                            if (MAX_MACRO_VALUE < 165.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 165.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 21.5) {
                            if (MAX_MACRO_VALUE < 127.5) {
                                if (X < 1160) {
                                    if (X < 1064) {
                                        if (AVG_MACRO_VALUE < 29.77) {
                                            if (RANGE_MACRO_VALUE < 2.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 2.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 29.77) {
                                            if (Y < 776) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 776) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1064) {
                                        if (RANGE_MACRO_VALUE < 83.5) {
                                            if (Y < 904) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 904) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 83.5) {
                                            if (MAX_MACRO_VALUE < 116.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 116.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1160) {
                                    if (Y < 520) {
                                        if (MIN_MACRO_VALUE < 23.5) {
                                            if (AVG_MACRO_VALUE < 50.49) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 50.49) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 23.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 520) {
                                        if (AVG_MACRO_VALUE < 58.9) {
                                            if (RANGE_MACRO_VALUE < 15.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 15.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 58.9) {
                                            if (AVG_MACRO_VALUE < 59.89) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 59.89) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 127.5) {
                                if (Y < 632) {
                                    if (RANGE_MACRO_VALUE < 119.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 119.5) {
                                        if (RANGE_MACRO_VALUE < 164.5) {
                                            if (RANGE_MACRO_VALUE < 162.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 162.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 164.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Y >= 632) {
                                    if (AVG_MACRO_VALUE < 48.54) {
                                        if (Y < 944) {
                                            if (X < 1736) {
                                                oneCount++;
                                            }
                                            else if (X >= 1736) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 944) {
                                            if (RANGE_MACRO_VALUE < 184) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 184) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 48.54) {
                                        if (X < 680) {
                                            if (RANGE_MACRO_VALUE < 117.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 117.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 680) {
                                            if (RANGE_MACRO_VALUE < 99.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 99.5) {
                                                oneCount++;
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
        else if (MIN_MACRO_VALUE >= 34.5) {
            if (MAX_MACRO_VALUE < 69.5) {
                if (MAX_MACRO_VALUE < 60.5) {
                    if (Y < 888) {
                        if (X < 1768) {
                            if (Y < 824) {
                                if (MAX_MACRO_VALUE < 49.5) {
                                    if (MAX_MACRO_VALUE < 47.5) {
                                        if (RANGE_MACRO_VALUE < 8.5) {
                                            if (Y < 680) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 680) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 8.5) {
                                            if (Y < 616) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 616) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 47.5) {
                                        if (MIN_MACRO_VALUE < 35.5) {
                                            if (Y < 312) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 312) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 35.5) {
                                            if (AVG_MACRO_VALUE < 46.23) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 46.23) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 49.5) {
                                    if (MIN_MACRO_VALUE < 41.5) {
                                        if (RANGE_MACRO_VALUE < 9.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 9.5) {
                                            if (AVG_MACRO_VALUE < 49.96) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 49.96) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 41.5) {
                                        if (AVG_MACRO_VALUE < 53.79) {
                                            if (X < 104) {
                                                zeroCount++;
                                            }
                                            else if (X >= 104) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 53.79) {
                                            if (AVG_MACRO_VALUE < 55.65) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 55.65) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 824) {
                                if (MIN_MACRO_VALUE < 38.5) {
                                    if (MAX_MACRO_VALUE < 52.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 52.5) {
                                        if (MIN_MACRO_VALUE < 37.5) {
                                            if (RANGE_MACRO_VALUE < 17.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 17.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 37.5) {
                                            if (X < 144) {
                                                zeroCount++;
                                            }
                                            else if (X >= 144) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 38.5) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (X >= 1768) {
                            if (Y < 664) {
                                if (Y < 408) {
                                    if (Y < 8) {
                                        if (MAX_MACRO_VALUE < 50) {
                                            if (X < 1848) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1848) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 50) {
                                            if (MIN_MACRO_VALUE < 39.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 39.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 8) {
                                        if (AVG_MACRO_VALUE < 49.64) {
                                            if (MAX_MACRO_VALUE < 51.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 51.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 49.64) {
                                            if (X < 1784) {
                                                oneCount++;
                                            }
                                            else if (X >= 1784) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 408) {
                                    zeroCount++;
                                }
                            }
                            else if (Y >= 664) {
                                if (Y < 744) {
                                    if (X < 1880) {
                                        if (AVG_MACRO_VALUE < 43.26) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 43.26) {
                                            if (X < 1864) {
                                                oneCount++;
                                            }
                                            else if (X >= 1864) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1880) {
                                        zeroCount++;
                                    }
                                }
                                else if (Y >= 744) {
                                    if (RANGE_MACRO_VALUE < 16.5) {
                                        if (AVG_MACRO_VALUE < 47.85) {
                                            if (MIN_MACRO_VALUE < 38.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 38.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 47.85) {
                                            if (MIN_MACRO_VALUE < 45.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 45.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 16.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (Y >= 888) {
                        if (RANGE_MACRO_VALUE < 20.5) {
                            if (X < 840) {
                                if (RANGE_MACRO_VALUE < 9.5) {
                                    if (MIN_MACRO_VALUE < 40.5) {
                                        if (AVG_MACRO_VALUE < 41.83) {
                                            if (Y < 984) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 984) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 41.83) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 40.5) {
                                        if (MAX_MACRO_VALUE < 46.5) {
                                            if (AVG_MACRO_VALUE < 41.5) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 41.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 46.5) {
                                            if (X < 120) {
                                                oneCount++;
                                            }
                                            else if (X >= 120) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 9.5) {
                                    if (MIN_MACRO_VALUE < 44.5) {
                                        if (X < 568) {
                                            if (MAX_MACRO_VALUE < 55.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 55.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 568) {
                                            if (MAX_MACRO_VALUE < 47.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 47.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 44.5) {
                                        if (MIN_MACRO_VALUE < 49.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 49.5) {
                                            if (AVG_MACRO_VALUE < 56.65) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 56.65) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 840) {
                                if (X < 1016) {
                                    if (MIN_MACRO_VALUE < 37.5) {
                                        zeroCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 37.5) {
                                        if (X < 888) {
                                            if (Y < 968) {
                                                oneCount++;
                                            }
                                            else if (Y >= 968) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 888) {
                                            if (MAX_MACRO_VALUE < 53.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 53.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1016) {
                                    if (RANGE_MACRO_VALUE < 16.5) {
                                        if (X < 1144) {
                                            if (AVG_MACRO_VALUE < 55.78) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 55.78) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 1144) {
                                            if (MIN_MACRO_VALUE < 36.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 36.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 16.5) {
                                        if (AVG_MACRO_VALUE < 45.77) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 45.77) {
                                            if (AVG_MACRO_VALUE < 45.93) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 45.93) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 20.5) {
                            if (Y < 920) {
                                zeroCount++;
                            }
                            else if (Y >= 920) {
                                if (X < 552) {
                                    if (Y < 936) {
                                        oneCount++;
                                    }
                                    else if (Y >= 936) {
                                        if (X < 168) {
                                            if (Y < 984) {
                                                oneCount++;
                                            }
                                            else if (Y >= 984) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 168) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (X >= 552) {
                                    if (MAX_MACRO_VALUE < 21.5) {
                                        if (X < 776) {
                                            zeroCount++;
                                        }
                                        else if (X >= 776) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 21.5) {
                                        if (MIN_MACRO_VALUE < 35.5) {
                                            if (Y < 976) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 976) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 35.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 60.5) {
                    if (X < 232) {
                        if (Y < 536) {
                            zeroCount++;
                        }
                        else if (Y >= 536) {
                            if (X < 56) {
                                if (Y < 952) {
                                    if (AVG_MACRO_VALUE < 51.86) {
                                        if (Y < 904) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 904) {
                                            if (RANGE_MACRO_VALUE < 24.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 24.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 51.86) {
                                        if (Y < 816) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 816) {
                                            if (AVG_MACRO_VALUE < 52.83) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 52.83) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 952) {
                                    if (RANGE_MACRO_VALUE < 2.5) {
                                        oneCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 2.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (X >= 56) {
                                if (AVG_MACRO_VALUE < 46.8) {
                                    if (Y < 960) {
                                        if (RANGE_MACRO_VALUE < 26.5) {
                                            if (RANGE_MACRO_VALUE < 23.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 23.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 26.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 960) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 46.8) {
                                    if (AVG_MACRO_VALUE < 51.51) {
                                        if (MAX_MACRO_VALUE < 65.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 65.5) {
                                            if (X < 96) {
                                                zeroCount++;
                                            }
                                            else if (X >= 96) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 51.51) {
                                        if (Y < 968) {
                                            if (AVG_MACRO_VALUE < 52.84) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 52.84) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 968) {
                                            if (Y < 1016) {
                                                oneCount++;
                                            }
                                            else if (Y >= 1016) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (X >= 232) {
                        if (Y < 1000) {
                            if (AVG_MACRO_VALUE < 45.44) {
                                if (Y < 888) {
                                    if (Y < 488) {
                                        if (AVG_MACRO_VALUE < 43.73) {
                                            if (X < 560) {
                                                oneCount++;
                                            }
                                            else if (X >= 560) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 43.73) {
                                            if (AVG_MACRO_VALUE < 43.92) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 43.92) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 488) {
                                        zeroCount++;
                                    }
                                }
                                else if (Y >= 888) {
                                    if (AVG_MACRO_VALUE < 44.66) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 44.66) {
                                        if (Y < 944) {
                                            oneCount++;
                                        }
                                        else if (Y >= 944) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 45.44) {
                                if (AVG_MACRO_VALUE < 46.48) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 46.48) {
                                    if (MIN_MACRO_VALUE < 41.5) {
                                        if (X < 712) {
                                            if (RANGE_MACRO_VALUE < 26.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 26.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 712) {
                                            if (X < 792) {
                                                oneCount++;
                                            }
                                            else if (X >= 792) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 41.5) {
                                        if (RANGE_MACRO_VALUE < 19.5) {
                                            if (MIN_MACRO_VALUE < 44.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 44.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 19.5) {
                                            if (MAX_MACRO_VALUE < 64.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 64.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (Y >= 1000) {
                            if (X < 280) {
                                if (X < 264) {
                                    oneCount++;
                                }
                                else if (X >= 264) {
                                    if (RANGE_MACRO_VALUE < 26) {
                                        oneCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 26) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (X >= 280) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 69.5) {
                if (RANGE_MACRO_VALUE < 26.5) {
                    if (Y < 152) {
                        if (MAX_MACRO_VALUE < 105.5) {
                            if (MIN_MACRO_VALUE < 81.5) {
                                if (AVG_MACRO_VALUE < 58.54) {
                                    if (MIN_MACRO_VALUE < 47.5) {
                                        if (MAX_MACRO_VALUE < 70.5) {
                                            if (MIN_MACRO_VALUE < 45.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 45.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 70.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 47.5) {
                                        if (X < 1168) {
                                            zeroCount++;
                                        }
                                        else if (X >= 1168) {
                                            if (Y < 56) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 56) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 58.54) {
                                    if (Y < 104) {
                                        if (MIN_MACRO_VALUE < 78.5) {
                                            if (RANGE_MACRO_VALUE < 5.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 5.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 78.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 104) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 81.5) {
                                if (Y < 104) {
                                    zeroCount++;
                                }
                                else if (Y >= 104) {
                                    if (MAX_MACRO_VALUE < 96.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 96.5) {
                                        if (X < 648) {
                                            if (MAX_MACRO_VALUE < 100.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 100.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 648) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 105.5) {
                            if (MIN_MACRO_VALUE < 117.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 117.5) {
                                if (X < 1272) {
                                    if (X < 1048) {
                                        if (RANGE_MACRO_VALUE < 4.5) {
                                            if (X < 80) {
                                                zeroCount++;
                                            }
                                            else if (X >= 80) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 4.5) {
                                            if (X < 56) {
                                                oneCount++;
                                            }
                                            else if (X >= 56) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1048) {
                                        zeroCount++;
                                    }
                                }
                                else if (X >= 1272) {
                                    if (MIN_MACRO_VALUE < 162.5) {
                                        if (AVG_MACRO_VALUE < 125.29) {
                                            if (AVG_MACRO_VALUE < 125.16) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 125.16) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 125.29) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 162.5) {
                                        if (AVG_MACRO_VALUE < 170.06) {
                                            if (X < 1448) {
                                                oneCount++;
                                            }
                                            else if (X >= 1448) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 170.06) {
                                            if (X < 1648) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1648) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Y >= 152) {
                        if (Y < 248) {
                            if (MAX_MACRO_VALUE < 90.5) {
                                if (MIN_MACRO_VALUE < 50.5) {
                                    if (RANGE_MACRO_VALUE < 20.5) {
                                        if (Y < 224) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 224) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 20.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 50.5) {
                                    zeroCount++;
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 90.5) {
                                if (MIN_MACRO_VALUE < 155.5) {
                                    if (RANGE_MACRO_VALUE < 17.5) {
                                        if (X < 1256) {
                                            if (X < 792) {
                                                oneCount++;
                                            }
                                            else if (X >= 792) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (X >= 1256) {
                                            if (X < 1368) {
                                                oneCount++;
                                            }
                                            else if (X >= 1368) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 17.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 155.5) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (Y >= 248) {
                            if (MAX_MACRO_VALUE < 70.5) {
                                if (X < 1112) {
                                    if (Y < 536) {
                                        if (AVG_MACRO_VALUE < 63.21) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 63.21) {
                                            if (AVG_MACRO_VALUE < 66.56) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 66.56) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 536) {
                                        if (AVG_MACRO_VALUE < 57.83) {
                                            if (Y < 928) {
                                                oneCount++;
                                            }
                                            else if (Y >= 928) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 57.83) {
                                            if (MIN_MACRO_VALUE < 52.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 52.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1112) {
                                    if (X < 1824) {
                                        zeroCount++;
                                    }
                                    else if (X >= 1824) {
                                        if (MIN_MACRO_VALUE < 53) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 53) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 70.5) {
                                if (AVG_MACRO_VALUE < 58.25) {
                                    if (X < 104) {
                                        if (MAX_MACRO_VALUE < 72.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 72.5) {
                                            if (X < 48) {
                                                zeroCount++;
                                            }
                                            else if (X >= 48) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 104) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 58.25) {
                                    if (X < 1240) {
                                        if (RANGE_MACRO_VALUE < 3.5) {
                                            if (AVG_MACRO_VALUE < 152.72) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 152.72) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 3.5) {
                                            if (Y < 440) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 440) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1240) {
                                        if (MIN_MACRO_VALUE < 52.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 52.5) {
                                            if (AVG_MACRO_VALUE < 164.37) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 164.37) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 26.5) {
                    if (MAX_MACRO_VALUE < 100.5) {
                        if (X < 472) {
                            if (MAX_MACRO_VALUE < 77.5) {
                                if (RANGE_MACRO_VALUE < 35.5) {
                                    if (AVG_MACRO_VALUE < 62.38) {
                                        if (MIN_MACRO_VALUE < 38.5) {
                                            if (X < 288) {
                                                zeroCount++;
                                            }
                                            else if (X >= 288) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 38.5) {
                                            if (AVG_MACRO_VALUE < 59.38) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 59.38) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 62.38) {
                                        zeroCount++;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 35.5) {
                                    zeroCount++;
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 77.5) {
                                if (Y < 264) {
                                    if (RANGE_MACRO_VALUE < 47.5) {
                                        if (Y < 152) {
                                            if (AVG_MACRO_VALUE < 62.56) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 62.56) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 152) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 47.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (Y >= 264) {
                                    if (AVG_MACRO_VALUE < 54.72) {
                                        if (AVG_MACRO_VALUE < 53.52) {
                                            if (RANGE_MACRO_VALUE < 59.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 59.5) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 53.52) {
                                            if (RANGE_MACRO_VALUE < 57.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 57.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 54.72) {
                                        if (RANGE_MACRO_VALUE < 57.5) {
                                            if (X < 8) {
                                                oneCount++;
                                            }
                                            else if (X >= 8) {
                                                oneCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 57.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 472) {
                            if (X < 984) {
                                if (X < 888) {
                                    if (RANGE_MACRO_VALUE < 50.5) {
                                        if (MAX_MACRO_VALUE < 89.5) {
                                            if (Y < 472) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 472) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 89.5) {
                                            if (Y < 120) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 120) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 50.5) {
                                        if (Y < 408) {
                                            if (X < 568) {
                                                zeroCount++;
                                            }
                                            else if (X >= 568) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 408) {
                                            if (RANGE_MACRO_VALUE < 58.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 58.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 888) {
                                    if (MIN_MACRO_VALUE < 65.5) {
                                        if (AVG_MACRO_VALUE < 59.05) {
                                            if (X < 936) {
                                                oneCount++;
                                            }
                                            else if (X >= 936) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 59.05) {
                                            if (AVG_MACRO_VALUE < 64.35) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 64.35) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 65.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (X >= 984) {
                                if (X < 1144) {
                                    if (Y < 568) {
                                        if (MIN_MACRO_VALUE < 64.5) {
                                            if (MAX_MACRO_VALUE < 86.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 86.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 64.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 568) {
                                        if (MAX_MACRO_VALUE < 95.5) {
                                            if (X < 1032) {
                                                oneCount++;
                                            }
                                            else if (X >= 1032) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 95.5) {
                                            if (AVG_MACRO_VALUE < 72.22) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 72.22) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1144) {
                                    if (X < 1208) {
                                        if (AVG_MACRO_VALUE < 57.41) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 57.41) {
                                            if (MAX_MACRO_VALUE < 78.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 78.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1208) {
                                        if (MIN_MACRO_VALUE < 35.5) {
                                            if (Y < 560) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 560) {
                                                oneCount++;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 35.5) {
                                            if (Y < 456) {
                                                oneCount++;
                                            }
                                            else if (Y >= 456) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 100.5) {
                        if (X < 1896) {
                            if (AVG_MACRO_VALUE < 152.15) {
                                if (X < 1720) {
                                    if (AVG_MACRO_VALUE < 54.97) {
                                        if (X < 392) {
                                            if (AVG_MACRO_VALUE < 44.74) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 44.74) {
                                                oneCount++;
                                            }
                                        }
                                        else if (X >= 392) {
                                            if (RANGE_MACRO_VALUE < 154) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 154) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 54.97) {
                                        if (RANGE_MACRO_VALUE < 36.5) {
                                            if (X < 1208) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1208) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 36.5) {
                                            if (RANGE_MACRO_VALUE < 80.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 80.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1720) {
                                    if (MAX_MACRO_VALUE < 108.5) {
                                        if (MIN_MACRO_VALUE < 40.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 40.5) {
                                            if (Y < 936) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 936) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 108.5) {
                                        if (AVG_MACRO_VALUE < 89.25) {
                                            if (X < 1832) {
                                                oneCount++;
                                            }
                                            else if (X >= 1832) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 89.25) {
                                            if (MIN_MACRO_VALUE < 36.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 36.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 152.15) {
                                if (X < 1592) {
                                    if (X < 1384) {
                                        if (Y < 152) {
                                            if (MAX_MACRO_VALUE < 232.5) {
                                                oneCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 232.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (Y >= 152) {
                                            if (MIN_MACRO_VALUE < 96.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 96.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 1384) {
                                        if (Y < 152) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 152) {
                                            if (AVG_MACRO_VALUE < 202.8) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 202.8) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1592) {
                                    if (MAX_MACRO_VALUE < 179.5) {
                                        if (Y < 1000) {
                                            if (AVG_MACRO_VALUE < 155.64) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 155.64) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 1000) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 179.5) {
                                        if (MAX_MACRO_VALUE < 233.5) {
                                            if (MIN_MACRO_VALUE < 96.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 96.5) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 233.5) {
                                            if (X < 1608) {
                                                oneCount++;
                                            }
                                            else if (X >= 1608) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 1896) {
                            zeroCount++;
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

__kernel void DTC_LD_5RUS_TEST(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
{
    int X = get_global_id(0) * 16;
	int Y = get_global_id(1) * 16;

    int zeroCount = 0;  //USE COUNTERS TO AVOID BUG ON INTEL GRAPHICS
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

    if (MIN_MACRO_VALUE < 19.5) {
            if (MAX_MACRO_VALUE < 98.5) {
                if (RANGE_MACRO_VALUE < 69.5) {
                    if (Y < 824) {
                        if (Y < 696) {
                            if (X < 424) {
                                if (MAX_MACRO_VALUE < 21.5) {
                                    if (Y < 456) {
                                        oneCount++;
                                    }
                                    else if (Y >= 456) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 21.5) {
                                    zeroCount++;
                                }
                            }
                            else if (X >= 424) {
                                if (Y < 440) {
                                    if (AVG_MACRO_VALUE < 18.9) {
                                        if (AVG_MACRO_VALUE < 18.37) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 18.37) {
                                            if (Y < 88) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 88) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 18.9) {
                                        if (AVG_MACRO_VALUE < 24.58) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 24.58) {
                                            if (X < 872) {
                                                zeroCount++;
                                            }
                                            else if (X >= 872) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 440) {
                                    if (AVG_MACRO_VALUE < 24.42) {
                                        if (X < 712) {
                                            zeroCount++;
                                        }
                                        else if (X >= 712) {
                                            if (X < 808) {
                                                oneCount++;
                                            }
                                            else if (X >= 808) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 24.42) {
                                        if (AVG_MACRO_VALUE < 33.32) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 33.32) {
                                            if (AVG_MACRO_VALUE < 70.56) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 70.56) {
                                                oneCount++;
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
                                            zeroCount++;
                                        }
                                        else if (Y >= 728) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 17.5) {
                                        if (AVG_MACRO_VALUE < 17.37) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.37) {
                                            if (X < 232) {
                                                oneCount++;
                                            }
                                            else if (X >= 232) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                    oneCount++;
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 21.5) {
                                if (X < 456) {
                                    if (Y < 792) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 792) {
                                        if (X < 344) {
                                            zeroCount++;
                                        }
                                        else if (X >= 344) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (X >= 456) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (Y >= 824) {
                        if (X < 1096) {
                            if (Y < 872) {
                                if (Y < 856) {
                                    oneCount++;
                                }
                                else if (Y >= 856) {
                                    if (X < 792) {
                                        zeroCount++;
                                    }
                                    else if (X >= 792) {
                                        if (AVG_MACRO_VALUE < 18.19) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 18.19) {
                                            if (MIN_MACRO_VALUE < 16.5) {
                                                oneCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 16.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 872) {
                                if (AVG_MACRO_VALUE < 28.89) {
                                    if (X < 104) {
                                        zeroCount++;
                                    }
                                    else if (X >= 104) {
                                        if (AVG_MACRO_VALUE < 27.62) {
                                            if (AVG_MACRO_VALUE < 25.89) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 25.89) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 27.62) {
                                            if (MAX_MACRO_VALUE < 59.5) {
                                                zeroCount++;
                                            }
                                            else if (MAX_MACRO_VALUE >= 59.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 28.89) {
                                    if (AVG_MACRO_VALUE < 32.56) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 32.56) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                        else if (X >= 1096) {
                            if (AVG_MACRO_VALUE < 42.53) {
                                if (RANGE_MACRO_VALUE < 5.5) {
                                    if (RANGE_MACRO_VALUE < 1.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 1.5) {
                                        oneCount++;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 5.5) {
                                    if (Y < 920) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 920) {
                                        if (AVG_MACRO_VALUE < 34.48) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 34.48) {
                                            if (X < 1128) {
                                                oneCount++;
                                            }
                                            else if (X >= 1128) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 42.53) {
                                if (X < 1120) {
                                    if (RANGE_MACRO_VALUE < 55.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 55.5) {
                                        oneCount++;
                                    }
                                }
                                else if (X >= 1120) {
                                    if (Y < 984) {
                                        oneCount++;
                                    }
                                    else if (Y >= 984) {
                                        zeroCount++;
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
                                zeroCount++;
                            }
                            else if (X >= 1368) {
                                if (AVG_MACRO_VALUE < 59.53) {
                                    if (X < 1400) {
                                        if (AVG_MACRO_VALUE < 59.48) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 59.48) {
                                            oneCount++;
                                        }
                                    }
                                    else if (X >= 1400) {
                                        if (AVG_MACRO_VALUE < 59.49) {
                                            if (AVG_MACRO_VALUE < 59.45) {
                                                oneCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 59.45) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 59.49) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 59.53) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (Y >= 328) {
                            if (Y < 344) {
                                oneCount++;
                            }
                            else if (Y >= 344) {
                                if (RANGE_MACRO_VALUE < 79.5) {
                                    if (X < 96) {
                                        if (Y < 784) {
                                            oneCount++;
                                        }
                                        else if (Y >= 784) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 96) {
                                        if (AVG_MACRO_VALUE < 19.93) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 19.93) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 79.5) {
                                    if (Y < 936) {
                                        if (Y < 608) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 608) {
                                            if (MIN_MACRO_VALUE < 15.5) {
                                                zeroCount++;
                                            }
                                            else if (MIN_MACRO_VALUE >= 15.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 936) {
                                        zeroCount++;
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
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 58.39) {
                                        if (Y < 56) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 56) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 59.51) {
                                    if (AVG_MACRO_VALUE < 59.51) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 59.51) {
                                        if (Y < 128) {
                                            if (Y < 16) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 16) {
                                                oneCount++;
                                            }
                                        }
                                        else if (Y >= 128) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (X >= 1704) {
                                if (AVG_MACRO_VALUE < 59.47) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 59.47) {
                                    if (X < 1752) {
                                        oneCount++;
                                    }
                                    else if (X >= 1752) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (Y >= 392) {
                            if (AVG_MACRO_VALUE < 38.8) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 38.8) {
                                if (AVG_MACRO_VALUE < 59.82) {
                                    if (MAX_MACRO_VALUE < 88.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 88.5) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 59.82) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 98.5) {
                if (RANGE_MACRO_VALUE < 81.5) {
                    if (AVG_MACRO_VALUE < 33.03) {
                        zeroCount++;
                    }
                    else if (AVG_MACRO_VALUE >= 33.03) {
                        oneCount++;
                    }
                }
                else if (RANGE_MACRO_VALUE >= 81.5) {
                    if (Y < 776) {
                        if (X < 904) {
                            if (MAX_MACRO_VALUE < 177.5) {
                                if (Y < 136) {
                                    if (X < 104) {
                                        if (MIN_MACRO_VALUE < 15.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 15.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 104) {
                                        zeroCount++;
                                    }
                                }
                                else if (Y >= 136) {
                                    if (Y < 232) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            oneCount++;
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            if (X < 696) {
                                                oneCount++;
                                            }
                                            else if (X >= 696) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 232) {
                                        if (Y < 552) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 552) {
                                            if (X < 104) {
                                                zeroCount++;
                                            }
                                            else if (X >= 104) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 177.5) {
                                if (X < 824) {
                                    if (MAX_MACRO_VALUE < 181.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 181.5) {
                                        oneCount++;
                                    }
                                }
                                else if (X >= 824) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (X >= 904) {
                            if (Y < 760) {
                                if (X < 1528) {
                                    if (X < 1256) {
                                        if (Y < 696) {
                                            oneCount++;
                                        }
                                        else if (Y >= 696) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 1256) {
                                        if (AVG_MACRO_VALUE < 97.71) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 97.71) {
                                            if (X < 1440) {
                                                zeroCount++;
                                            }
                                            else if (X >= 1440) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 1528) {
                                    if (Y < 344) {
                                        if (AVG_MACRO_VALUE < 70.25) {
                                            if (X < 1608) {
                                                oneCount++;
                                            }
                                            else if (X >= 1608) {
                                                zeroCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 70.25) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Y >= 344) {
                                        if (Y < 616) {
                                            oneCount++;
                                        }
                                        else if (Y >= 616) {
                                            if (Y < 712) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 712) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 760) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Y >= 776) {
                        if (RANGE_MACRO_VALUE < 160.5) {
                            if (Y < 904) {
                                if (RANGE_MACRO_VALUE < 136.5) {
                                    zeroCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 136.5) {
                                    if (RANGE_MACRO_VALUE < 137.5) {
                                        oneCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 137.5) {
                                        if (MAX_MACRO_VALUE < 164.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 164.5) {
                                            if (RANGE_MACRO_VALUE < 154.5) {
                                                oneCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 154.5) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 904) {
                                if (RANGE_MACRO_VALUE < 120.5) {
                                    if (Y < 936) {
                                        if (X < 568) {
                                            zeroCount++;
                                        }
                                        else if (X >= 568) {
                                            if (X < 1184) {
                                                oneCount++;
                                            }
                                            else if (X >= 1184) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                    else if (Y >= 936) {
                                        if (AVG_MACRO_VALUE < 42.86) {
                                            if (AVG_MACRO_VALUE < 39.21) {
                                                zeroCount++;
                                            }
                                            else if (AVG_MACRO_VALUE >= 39.21) {
                                                oneCount++;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.86) {
                                            if (Y < 984) {
                                                oneCount++;
                                            }
                                            else if (Y >= 984) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 120.5) {
                                    if (X < 744) {
                                        if (X < 632) {
                                            zeroCount++;
                                        }
                                        else if (X >= 632) {
                                            if (Y < 1000) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 1000) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (X >= 744) {
                                        if (Y < 920) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 920) {
                                            if (Y < 1032) {
                                                zeroCount++;
                                            }
                                            else if (Y >= 1032) {
                                                oneCount++;
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
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 179.5) {
                                            if (RANGE_MACRO_VALUE < 194.5) {
                                                zeroCount++;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 194.5) {
                                                oneCount++;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 219.5) {
                                        if (AVG_MACRO_VALUE < 75.1) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 75.1) {
                                            if (X < 1168) {
                                                oneCount++;
                                            }
                                            else if (X >= 1168) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 952) {
                                    if (X < 152) {
                                        if (MAX_MACRO_VALUE < 180) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 180) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (X >= 152) {
                                        if (X < 824) {
                                            zeroCount++;
                                        }
                                        else if (X >= 824) {
                                            if (X < 888) {
                                                oneCount++;
                                            }
                                            else if (X >= 888) {
                                                zeroCount++;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 1032) {
                                if (X < 504) {
                                    zeroCount++;
                                }
                                else if (X >= 504) {
                                    if (MIN_MACRO_VALUE < 16.5) {
                                        if (AVG_MACRO_VALUE < 48.89) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 48.89) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 16.5) {
                                        if (RANGE_MACRO_VALUE < 213.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 213.5) {
                                            zeroCount++;
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
                            zeroCount++;
                        }
                        else if (X >= 328) {
                            oneCount++;
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 23.91) {
                        if (AVG_MACRO_VALUE < 24.79) {
                            zeroCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 24.79) {
                            if (X < 8) {
                                zeroCount++;
                            }
                            else if (X >= 8) {
                                if (MAX_MACRO_VALUE < 196.5) {
                                    if (AVG_MACRO_VALUE < 68.53) {
                                        if (MAX_MACRO_VALUE < 72.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 72.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 68.53) {
                                        if (AVG_MACRO_VALUE < 77.14) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 77.14) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 196.5) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                }
                else if (Y >= 824) {
                    if (AVG_MACRO_VALUE < 71.63) {
                        zeroCount++;
                    }
                    else if (AVG_MACRO_VALUE >= 71.63) {
                        if (AVG_MACRO_VALUE < 136.59) {
                            if (X < 504) {
                                zeroCount++;
                            }
                            else if (X >= 504) {
                                if (MIN_MACRO_VALUE < 132.5) {
                                    if (AVG_MACRO_VALUE < 72.44) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 72.44) {
                                        if (MIN_MACRO_VALUE < 85.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 85.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 132.5) {
                                    if (X < 728) {
                                        oneCount++;
                                    }
                                    else if (X >= 728) {
                                        if (X < 1616) {
                                            zeroCount++;
                                        }
                                        else if (X >= 1616) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 136.59) {
                            zeroCount++;
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
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 36.36) {
                                        zeroCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 33.5) {
                                    if (X < 608) {
                                        if (X < 328) {
                                            oneCount++;
                                        }
                                        else if (X >= 328) {
                                            oneCount++;
                                        }
                                    }
                                    else if (X >= 608) {
                                        if (X < 904) {
                                            zeroCount++;
                                        }
                                        else if (X >= 904) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 44.48) {
                                if (AVG_MACRO_VALUE < 129.92) {
                                    if (AVG_MACRO_VALUE < 45.33) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 45.33) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 129.92) {
                                    if (X < 464) {
                                        zeroCount++;
                                    }
                                    else if (X >= 464) {
                                        if (X < 1304) {
                                            oneCount++;
                                        }
                                        else if (X >= 1304) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 136.5) {
                            if (Y < 920) {
                                zeroCount++;
                            }
                            else if (Y >= 920) {
                                if (AVG_MACRO_VALUE < 136.3) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 136.3) {
                                    if (MAX_MACRO_VALUE < 164.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 164.5) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 11.5) {
                        if (AVG_MACRO_VALUE < 29.88) {
                            if (MIN_MACRO_VALUE < 22.5) {
                                if (X < 1608) {
                                    zeroCount++;
                                }
                                else if (X >= 1608) {
                                    oneCount++;
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 22.5) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 29.88) {
                            if (AVG_MACRO_VALUE < 31.32) {
                                if (RANGE_MACRO_VALUE < 13.5) {
                                    if (Y < 936) {
                                        oneCount++;
                                    }
                                    else if (Y >= 936) {
                                        zeroCount++;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 13.5) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 31.32) {
                                if (MAX_MACRO_VALUE < 39.5) {
                                    if (AVG_MACRO_VALUE < 33.03) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 33.03) {
                                        oneCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 39.5) {
                                    if (Y < 968) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 968) {
                                        if (X < 152) {
                                            oneCount++;
                                        }
                                        else if (X >= 152) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (Y >= 1032) {
                    zeroCount++;
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
                                    oneCount++;
                                }
                                else if (Y >= 616) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 39.02) {
                                if (Y < 312) {
                                    if (Y < 136) {
                                        zeroCount++;
                                    }
                                    else if (Y >= 136) {
                                        zeroCount++;
                                    }
                                }
                                else if (Y >= 312) {
                                    if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                        if (Y < 328) {
                                            oneCount++;
                                        }
                                        else if (Y >= 328) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 41.5) {
                            if (Y < 504) {
                                if (MAX_MACRO_VALUE < 73.5) {
                                    zeroCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 73.5) {
                                    oneCount++;
                                }
                            }
                            else if (Y >= 504) {
                                if (RANGE_MACRO_VALUE < 152) {
                                    if (Y < 520) {
                                        if (AVG_MACRO_VALUE < 88.75) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 88.75) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Y >= 520) {
                                        zeroCount++;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 152) {
                                    oneCount++;
                                }
                            }
                        }
                    }
                    else if (Y >= 632) {
                        if (MAX_MACRO_VALUE < 46.5) {
                            if (X < 120) {
                                zeroCount++;
                            }
                            else if (X >= 120) {
                                if (Y < 728) {
                                    oneCount++;
                                }
                                else if (Y >= 728) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 46.5) {
                            if (Y < 664) {
                                if (AVG_MACRO_VALUE < 43.95) {
                                    if (X < 120) {
                                        if (MIN_MACRO_VALUE < 36) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 36) {
                                            oneCount++;
                                        }
                                    }
                                    else if (X >= 120) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 43.95) {
                                    oneCount++;
                                }
                            }
                            else if (Y >= 664) {
                                if (RANGE_MACRO_VALUE < 32.5) {
                                    if (MAX_MACRO_VALUE < 58.5) {
                                        oneCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 58.5) {
                                        if (AVG_MACRO_VALUE < 51.14) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 51.14) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 32.5) {
                                    if (Y < 856) {
                                        if (MIN_MACRO_VALUE < 31.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 31.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Y >= 856) {
                                        oneCount++;
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
                                    oneCount++;
                                }
                                else if (MIN_MACRO_VALUE >= 75.5) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 91.05) {
                                oneCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 98.5) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 108.27) {
                        if (MAX_MACRO_VALUE < 131.5) {
                            if (MAX_MACRO_VALUE < 128.5) {
                                if (MAX_MACRO_VALUE < 127.5) {
                                    oneCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 127.5) {
                                    zeroCount++;
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 128.5) {
                                if (Y < 952) {
                                    zeroCount++;
                                }
                                else if (Y >= 952) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 131.5) {
                            if (AVG_MACRO_VALUE < 134.08) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 134.08) {
                                if (RANGE_MACRO_VALUE < 36.5) {
                                    zeroCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 36.5) {
                                    if (MIN_MACRO_VALUE < 84) {
                                        zeroCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 84) {
                                        if (AVG_MACRO_VALUE < 170.49) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 170.49) {
                                            zeroCount++;
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
                        zeroCount++;
                    }
                    else if (AVG_MACRO_VALUE >= 23.06) {
                        if (Y < 736) {
                            oneCount++;
                        }
                        else if (Y >= 736) {
                            zeroCount++;
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 24.73) {
                    if (RANGE_MACRO_VALUE < 205.5) {
                        if (MAX_MACRO_VALUE < 41.5) {
                            if (X < 1592) {
                                if (X < 1032) {
                                    if (X < 808) {
                                        zeroCount++;
                                    }
                                    else if (X >= 808) {
                                        if (MAX_MACRO_VALUE < 21.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 21.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (X >= 1032) {
                                    zeroCount++;
                                }
                            }
                            else if (X >= 1592) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 41.5) {
                            if (RANGE_MACRO_VALUE < 15.5) {
                                if (Y < 920) {
                                    if (MAX_MACRO_VALUE < 60.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 60.5) {
                                        oneCount++;
                                    }
                                }
                                else if (Y >= 920) {
                                    if (AVG_MACRO_VALUE < 49.52) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 49.52) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 15.5) {
                                if (Y < 488) {
                                    zeroCount++;
                                }
                                else if (Y >= 488) {
                                    if (AVG_MACRO_VALUE < 31.83) {
                                        if (RANGE_MACRO_VALUE < 20.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 20.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 31.83) {
                                        if (AVG_MACRO_VALUE < 38.74) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 38.74) {
                                            zeroCount++;
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
                                    zeroCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 211.5) {
                                    if (RANGE_MACRO_VALUE < 213.5) {
                                        oneCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 213.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                oneCount++;
                            }
                        }
                        else if (X >= 568) {
                            if (Y < 8) {
                                zeroCount++;
                            }
                            else if (Y >= 8) {
                                if (X < 728) {
                                    oneCount++;
                                }
                                else if (X >= 728) {
                                    if (Y < 344) {
                                        if (Y < 200) {
                                            zeroCount++;
                                        }
                                        else if (Y >= 200) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Y >= 344) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    if(zeroCount > oneCount)
        binMap[i] = 0;
    else
        binMap[i] = 1;
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