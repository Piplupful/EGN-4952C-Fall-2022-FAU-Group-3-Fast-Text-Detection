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

/*
OLD MODELS MODELS AND KERNEL FUNCTIONS BELOW
__kernel void repTest2(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
{
    int X = get_global_id(0) * 16;
	int Y = get_global_id(1) * 16;

    unsigned int *blockData[256];
    int j = 0;
	
	int AVG_MACRO_VALUE = 0;
	int MAX_MACRO_VALUE = -1;
	int MIN_MACRO_VALUE = 256;
	int RANGE_MACRO_VALUE = 0;
    int AVGQUADRANT_MACRO_VALUE = 0;

	int offset = Y * width + X;

    for (int i = 0; i < 16; i++)			//over every x value
	{
		AVG_MACRO_VALUE += frame[offset + (i * width)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width)]);
        blockData[j] = frame[offset + (i * width)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 1)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        blockData[j + 1] = frame[offset + (i * width + 1)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 2)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        blockData[j + 2] = frame[offset + (i * width + 2)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 3)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        blockData[j + 3] = frame[offset + (i * width + 3)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 4)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        blockData[j + 4] = frame[offset + (i * width + 4)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 5)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        blockData[j + 5] = frame[offset + (i * width + 5)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 6)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        blockData[j + 6] = frame[offset + (i * width + 6)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 7)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        blockData[j + 7] = frame[offset + (i * width + 7)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 8)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        blockData[j + 8] = frame[offset + (i * width + 8)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 9)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        blockData[j + 9] = frame[offset + (i * width + 9)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 10)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        blockData[j + 10] = frame[offset + (i * width + 10)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 11)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        blockData[j + 11] = frame[offset + (i * width + 11)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 12)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        blockData[j + 12] = frame[offset + (i * width + 12)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 13)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        blockData[j + 13] = frame[offset + (i * width + 13)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 14)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        blockData[j + 14] = frame[offset + (i * width + 14)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 15)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        blockData[j + 15] = frame[offset + (i * width + 15)];

        j += 16;
	}

	if(Y != 1072)
    {
        AVG_MACRO_VALUE /= 256.0;

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

	if (X < 840) {
            if (MAX_MACRO_VALUE < 109.5) {
                if (Y < 200) {
                    if (MAX_MACRO_VALUE < 99.5) {
                        if (MAX_MACRO_VALUE < 90.5) {
                            if (X < 728) {
                                if (RANGE_MACRO_VALUE < 47.5) {
                                    if (MIN_MACRO_VALUE < 76.5) {
                                        if (Y < 8) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 8) {
                                            if (MAX_MACRO_VALUE < 89.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MAX_MACRO_VALUE >= 89.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 76.5) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 47.5) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (X >= 728) {
                                binMap[i] = 0;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 90.5) {
                            binMap[i] = 0;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 99.5) {
                        if (X < 152) {
                            if (MAX_MACRO_VALUE < 107.5) {
                                binMap[i] = 0;
                            }
                            else if (MAX_MACRO_VALUE >= 107.5) {
                                if (X < 72) {
                                    if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                        if (RANGE_MACRO_VALUE < 40.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 40.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (X >= 72) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                        else if (X >= 152) {
                            if (Y < 72) {
                                if (X < 232) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 232) {
                                    if (X < 296) {
                                        if (RANGE_MACRO_VALUE < 37.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 37.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (X >= 296) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (Y >= 72) {
                                if (MIN_MACRO_VALUE < 45.5) {
                                    if (MIN_MACRO_VALUE < 42.5) {
                                        if (X < 664) {
                                            if (X < 504) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 504) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (X >= 664) {
                                            if (MIN_MACRO_VALUE < 36.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MIN_MACRO_VALUE >= 36.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 42.5) {
                                        if (MAX_MACRO_VALUE < 101.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MAX_MACRO_VALUE >= 101.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 45.5) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                    }
                }
                else if (Y >= 200) {
                    if (Y < 248) {
                        binMap[i] = 0;
                    }
                    else if (Y >= 248) {
                        if (Y < 680) {
                            if (MIN_MACRO_VALUE < 85.5) {
                                if (MAX_MACRO_VALUE < 66.5) {
                                    if (AVG_MACRO_VALUE < 61.59) {
                                        if (Y < 664) {
                                            if (AVG_MACRO_VALUE < 34.26) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 34.26) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (Y >= 664) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 61.59) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 66.5) {
                                    if (X < 792) {
                                        if (X < 136) {
                                            if (MIN_MACRO_VALUE < 44.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MIN_MACRO_VALUE >= 44.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (X >= 136) {
                                            if (AVG_MACRO_VALUE < 42.18) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 42.18) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (X >= 792) {
                                        if (AVG_MACRO_VALUE < 78.21) {
                                            if (MAX_MACRO_VALUE < 82.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MAX_MACRO_VALUE >= 82.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 78.21) {
                                            if (Y < 552) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 552) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 85.5) {
                                binMap[i] = 0;
                            }
                        }
                        else if (Y >= 680) {
                            if (MIN_MACRO_VALUE < 29.5) {
                                if (Y < 824) {
                                    if (X < 264) {
                                        if (X < 216) {
                                            if (MIN_MACRO_VALUE < 24.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MIN_MACRO_VALUE >= 24.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (X >= 216) {
                                            if (Y < 760) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 760) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (X >= 264) {
                                        if (X < 568) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 568) {
                                            if (MAX_MACRO_VALUE < 38.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MAX_MACRO_VALUE >= 38.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 824) {
                                    if (Y < 888) {
                                        if (MIN_MACRO_VALUE < 19.5) {
                                            if (AVG_MACRO_VALUE < 30.05) {
                                                binMap[i] = 0;
                                            }
                                            else if (AVG_MACRO_VALUE >= 30.05) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 19.5) {
                                            if (X < 24) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 24) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (Y >= 888) {
                                        if (X < 568) {
                                            if (X < 264) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 264) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (X >= 568) {
                                            if (MAX_MACRO_VALUE < 60.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MAX_MACRO_VALUE >= 60.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 29.5) {
                                if (Y < 792) {
                                    if (RANGE_MACRO_VALUE < 10.5) {
                                        if (X < 232) {
                                            if (X < 152) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 152) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (X >= 232) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 10.5) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (Y >= 792) {
                                    if (MIN_MACRO_VALUE < 41.5) {
                                        if (MAX_MACRO_VALUE < 40.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MAX_MACRO_VALUE >= 40.5) {
                                            if (AVG_MACRO_VALUE < 35.25) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 35.25) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 41.5) {
                                        if (MIN_MACRO_VALUE < 44.5) {
                                            if (AVG_MACRO_VALUE < 57.27) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 57.27) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 44.5) {
                                            if (MAX_MACRO_VALUE < 106.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MAX_MACRO_VALUE >= 106.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 109.5) {
                if (MIN_MACRO_VALUE < 60.5) {
                    if (AVG_MACRO_VALUE < 26.46) {
                        if (X < 560) {
                            if (Y < 680) {
                                if (RANGE_MACRO_VALUE < 157) {
                                    binMap[i] = 0;
                                }
                                else if (RANGE_MACRO_VALUE >= 157) {
                                    if (MIN_MACRO_VALUE < 21.5) {
                                        if (RANGE_MACRO_VALUE < 169.5) {
                                            if (X < 528) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 528) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 169.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 21.5) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (Y >= 680) {
                                binMap[i] = 1;
                            }
                        }
                        else if (X >= 560) {
                            if (MIN_MACRO_VALUE < 20) {
                                if (X < 728) {
                                    if (RANGE_MACRO_VALUE < 167) {
                                        if (Y < 648) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 648) {
                                            if (MIN_MACRO_VALUE < 18) {
                                                binMap[i] = 1;
                                            }
                                            else if (MIN_MACRO_VALUE >= 18) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 167) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (X >= 728) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 20) {
                                binMap[i] = 0;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 26.46) {
                        if (Y < 200) {
                            if (X < 216) {
                                if (MAX_MACRO_VALUE < 113.5) {
                                    if (Y < 104) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 104) {
                                        if (MAX_MACRO_VALUE < 112.5) {
                                            if (X < 200) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 200) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 112.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 113.5) {
                                    if (Y < 136) {
                                        if (RANGE_MACRO_VALUE < 65.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 65.5) {
                                            if (RANGE_MACRO_VALUE < 67.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 67.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (Y >= 136) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (X >= 216) {
                                if (X < 280) {
                                    if (Y < 184) {
                                        if (MAX_MACRO_VALUE < 116.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MAX_MACRO_VALUE >= 116.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (Y >= 184) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (X >= 280) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                        else if (Y >= 200) {
                            if (Y < 216) {
                                if (MAX_MACRO_VALUE < 114.5) {
                                    if (AVG_MACRO_VALUE < 86.42) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 86.42) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 114.5) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (Y >= 216) {
                                if (RANGE_MACRO_VALUE < 74.5) {
                                    if (MAX_MACRO_VALUE < 115.5) {
                                        if (X < 200) {
                                            if (MAX_MACRO_VALUE < 113.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MAX_MACRO_VALUE >= 113.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (X >= 200) {
                                            if (AVG_MACRO_VALUE < 51.88) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 51.88) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 115.5) {
                                        if (Y < 392) {
                                            if (X < 296) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 296) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (Y >= 392) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 74.5) {
                                    if (Y < 312) {
                                        if (AVG_MACRO_VALUE < 91.6) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 91.6) {
                                            if (AVG_MACRO_VALUE < 91.63) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 91.63) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (Y >= 312) {
                                        if (X < 584) {
                                            if (AVG_MACRO_VALUE < 93.95) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 93.95) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (X >= 584) {
                                            if (RANGE_MACRO_VALUE < 101.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 101.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 60.5) {
                    if (X < 376) {
                        if (AVG_MACRO_VALUE < 112.97) {
                            if (AVG_MACRO_VALUE < 110.2) {
                                if (AVG_MACRO_VALUE < 81.18) {
                                    binMap[i] = 0;
                                }
                                else if (AVG_MACRO_VALUE >= 81.18) {
                                    if (AVG_MACRO_VALUE < 81.48) {
                                        binMap[i] = 1;
                                    }
                                    else if (AVG_MACRO_VALUE >= 81.48) {
                                        if (AVG_MACRO_VALUE < 83.31) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 83.31) {
                                            if (MIN_MACRO_VALUE < 82.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MIN_MACRO_VALUE >= 82.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 110.2) {
                                if (Y < 1032) {
                                    if (MIN_MACRO_VALUE < 79.5) {
                                        if (Y < 24) {
                                            binMap[i] = 1;
                                        }
                                        else if (Y >= 24) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 79.5) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            if (RANGE_MACRO_VALUE < 16.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 16.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (Y >= 1032) {
                                    if (X < 184) {
                                        binMap[i] = 0;
                                    }
                                    else if (X >= 184) {
                                        binMap[i] = 1;
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 112.97) {
                            if (Y < 920) {
                                if (Y < 360) {
                                    if (MAX_MACRO_VALUE < 162.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (MAX_MACRO_VALUE >= 162.5) {
                                        if (MIN_MACRO_VALUE < 66.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MIN_MACRO_VALUE >= 66.5) {
                                            if (AVG_MACRO_VALUE < 169.36) {
                                                binMap[i] = 1;
                                            }
                                            else if (AVG_MACRO_VALUE >= 169.36) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 360) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (Y >= 920) {
                                if (Y < 936) {
                                    if (AVG_MACRO_VALUE < 136.9) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 136.9) {
                                        if (X < 168) {
                                            if (X < 104) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 104) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (X >= 168) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (Y >= 936) {
                                    if (X < 72) {
                                        if (MAX_MACRO_VALUE < 126.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MAX_MACRO_VALUE >= 126.5) {
                                            if (MAX_MACRO_VALUE < 132.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MAX_MACRO_VALUE >= 132.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (X >= 72) {
                                        if (Y < 1032) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 1032) {
                                            if (AVG_MACRO_VALUE < 116.56) {
                                                binMap[i] = 0;
                                            }
                                            else if (AVG_MACRO_VALUE >= 116.56) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (X >= 376) {
                        if (MAX_MACRO_VALUE < 112.5) {
                            if (AVG_MACRO_VALUE < 111.22) {
                                binMap[i] = 0;
                            }
                            else if (AVG_MACRO_VALUE >= 111.22) {
                                binMap[i] = 1;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 112.5) {
                            if (Y < 264) {
                                binMap[i] = 0;
                            }
                            else if (Y >= 264) {
                                if (Y < 1048) {
                                    if (AVG_MACRO_VALUE < 106.02) {
                                        if (AVG_MACRO_VALUE < 105.99) {
                                            if (X < 408) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 408) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 105.99) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 106.02) {
                                        if (AVG_MACRO_VALUE < 111.44) {
                                            if (RANGE_MACRO_VALUE < 71.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 71.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 111.44) {
                                            if (Y < 424) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 424) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 1048) {
                                    if (AVG_MACRO_VALUE < 121.44) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 121.44) {
                                        if (X < 776) {
                                            if (RANGE_MACRO_VALUE < 15.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 15.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (X >= 776) {
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
    else if (X >= 840) {
        if (MIN_MACRO_VALUE < 28.5) {
            if (Y < 600) {
                if (MAX_MACRO_VALUE < 24.5) {
                    if (X < 920) {
                        binMap[i] = 0;
                    }
                    else if (X >= 920) {
                        if (X < 1368) {
                            if (AVG_MACRO_VALUE < 19.69) {
                                if (X < 1240) {
                                    if (X < 1224) {
                                        if (X < 1112) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 1112) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1224) {
                                        if (Y < 488) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 488) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (X >= 1240) {
                                    if (Y < 344) {
                                        if (Y < 328) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 328) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (Y >= 344) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 19.69) {
                                if (X < 1304) {
                                    if (X < 1016) {
                                        if (Y < 216) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 216) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (X >= 1016) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (X >= 1304) {
                                    if (AVG_MACRO_VALUE < 20.16) {
                                        if (Y < 104) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 104) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 20.16) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                        }
                        else if (X >= 1368) {
                            if (Y < 168) {
                                if (X < 1528) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 1528) {
                                    if (Y < 56) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 56) {
                                        if (AVG_MACRO_VALUE < 18.94) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 18.94) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (Y >= 168) {
                                binMap[i] = 0;
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 24.5) {
                    if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                        if (X < 872) {
                            if (MAX_MACRO_VALUE < 48) {
                                binMap[i] = 0;
                            }
                            else if (MAX_MACRO_VALUE >= 48) {
                                if (AVG_MACRO_VALUE < 35.1) {
                                    if (Y < 496) {
                                        if (Y < 432) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 432) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (Y >= 496) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 35.1) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                        else if (X >= 872) {
                            if (X < 1480) {
                                if (MIN_MACRO_VALUE < 18.5) {
                                    if (X < 1112) {
                                        if (Y < 512) {
                                            binMap[i] = 1;
                                        }
                                        else if (Y >= 512) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1112) {
                                        if (Y < 568) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 568) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 18.5) {
                                    if (X < 1160) {
                                        if (MAX_MACRO_VALUE < 138.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MAX_MACRO_VALUE >= 138.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1160) {
                                        if (MIN_MACRO_VALUE < 25.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MIN_MACRO_VALUE >= 25.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                            }
                            else if (X >= 1480) {
                                if (AVG_MACRO_VALUE < 29.61) {
                                    binMap[i] = 0;
                                }
                                else if (AVG_MACRO_VALUE >= 29.61) {
                                    if (X < 1768) {
                                        if (X < 1560) {
                                            binMap[i] = 1;
                                        }
                                        else if (X >= 1560) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1768) {
                                        if (MIN_MACRO_VALUE < 26.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MIN_MACRO_VALUE >= 26.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                        if (RANGE_MACRO_VALUE < 37.5) {
                            binMap[i] = 0;
                        }
                        else if (RANGE_MACRO_VALUE >= 37.5) {
                            if (RANGE_MACRO_VALUE < 38.5) {
                                if (X < 1080) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 1080) {
                                    if (X < 1160) {
                                        binMap[i] = 1;
                                    }
                                    else if (X >= 1160) {
                                        if (AVG_MACRO_VALUE < 52.42) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 52.42) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 38.5) {
                                if (MIN_MACRO_VALUE < 26.5) {
                                    if (AVG_MACRO_VALUE < 41.11) {
                                        if (MIN_MACRO_VALUE < 22.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MIN_MACRO_VALUE >= 22.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 41.11) {
                                        if (Y < 248) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 248) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 26.5) {
                                    if (X < 1000) {
                                        if (AVG_MACRO_VALUE < 44.56) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 44.56) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (X >= 1000) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (Y >= 600) {
                if (X < 1784) {
                    if (AVG_MACRO_VALUE < 80.65) {
                        if (X < 1768) {
                            if (MIN_MACRO_VALUE < 18.5) {
                                if (MIN_MACRO_VALUE < 16.5) {
                                    if (Y < 632) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 632) {
                                        if (X < 1000) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 1000) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 16.5) {
                                    if (AVG_MACRO_VALUE < 18.09) {
                                        if (Y < 728) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 728) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 18.09) {
                                        if (Y < 744) {
                                            binMap[i] = 1;
                                        }
                                        else if (Y >= 744) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 18.5) {
                                if (Y < 936) {
                                    if (MAX_MACRO_VALUE < 59.5) {
                                        if (X < 1064) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 1064) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 59.5) {
                                        if (X < 1288) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 1288) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (Y >= 936) {
                                    if (MIN_MACRO_VALUE < 23.5) {
                                        if (X < 1352) {
                                            binMap[i] = 1;
                                        }
                                        else if (X >= 1352) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 23.5) {
                                        if (X < 1608) {
                                            binMap[i] = 1;
                                        }
                                        else if (X >= 1608) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 1768) {
                            if (RANGE_MACRO_VALUE < 94.5) {
                                binMap[i] = 0;
                            }
                            else if (RANGE_MACRO_VALUE >= 94.5) {
                                if (MIN_MACRO_VALUE < 20) {
                                    if (AVG_MACRO_VALUE < 39.09) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 39.09) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 20) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 80.65) {
                        if (Y < 664) {
                            if (AVG_MACRO_VALUE < 102.45) {
                                if (RANGE_MACRO_VALUE < 146) {
                                    binMap[i] = 0;
                                }
                                else if (RANGE_MACRO_VALUE >= 146) {
                                    if (RANGE_MACRO_VALUE < 167) {
                                        if (MAX_MACRO_VALUE < 177.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MAX_MACRO_VALUE >= 177.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 167) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 102.45) {
                                if (AVG_MACRO_VALUE < 138.01) {
                                    binMap[i] = 0;
                                }
                                else if (AVG_MACRO_VALUE >= 138.01) {
                                    if (AVG_MACRO_VALUE < 139.86) {
                                        binMap[i] = 1;
                                    }
                                    else if (AVG_MACRO_VALUE >= 139.86) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                        }
                        else if (Y >= 664) {
                            if (Y < 728) {
                                binMap[i] = 0;
                            }
                            else if (Y >= 728) {
                                if (X < 1528) {
                                    if (X < 1064) {
                                        if (Y < 752) {
                                            binMap[i] = 1;
                                        }
                                        else if (Y >= 752) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1064) {
                                        if (Y < 984) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 984) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (X >= 1528) {
                                    if (RANGE_MACRO_VALUE < 123.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 123.5) {
                                        if (MIN_MACRO_VALUE < 20) {
                                            binMap[i] = 1;
                                        }
                                        else if (MIN_MACRO_VALUE >= 20) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (X >= 1784) {
                    if (MIN_MACRO_VALUE < 19.5) {
                        if (Y < 760) {
                            if (AVG_MACRO_VALUE < 19.26) {
                                if (Y < 744) {
                                    if (X < 1864) {
                                        if (X < 1848) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 1848) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1864) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (Y >= 744) {
                                    if (X < 1864) {
                                        if (X < 1848) {
                                            binMap[i] = 1;
                                        }
                                        else if (X >= 1848) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (X >= 1864) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 19.26) {
                                if (Y < 680) {
                                    binMap[i] = 0;
                                }
                                else if (Y >= 680) {
                                    if (X < 1864) {
                                        if (AVG_MACRO_VALUE < 20.38) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 20.38) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (X >= 1864) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                        }
                        else if (Y >= 760) {
                            if (MAX_MACRO_VALUE < 187.5) {
                                if (Y < 840) {
                                    if (X < 1864) {
                                        if (AVG_MACRO_VALUE < 17.81) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 17.81) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (X >= 1864) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (Y >= 840) {
                                    if (MAX_MACRO_VALUE < 40.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (MAX_MACRO_VALUE >= 40.5) {
                                        if (MAX_MACRO_VALUE < 125.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MAX_MACRO_VALUE >= 125.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 187.5) {
                                binMap[i] = 1;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 19.5) {
                        if (Y < 1016) {
                            if (RANGE_MACRO_VALUE < 196.5) {
                                binMap[i] = 0;
                            }
                            else if (RANGE_MACRO_VALUE >= 196.5) {
                                if (MAX_MACRO_VALUE < 234.5) {
                                    binMap[i] = 1;
                                }
                                else if (MAX_MACRO_VALUE >= 234.5) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                        else if (Y >= 1016) {
                            if (MIN_MACRO_VALUE < 25.5) {
                                binMap[i] = 0;
                            }
                            else if (MIN_MACRO_VALUE >= 25.5) {
                                if (AVG_MACRO_VALUE < 34.15) {
                                    binMap[i] = 0;
                                }
                                else if (AVG_MACRO_VALUE >= 34.15) {
                                    if (RANGE_MACRO_VALUE < 13.5) {
                                        binMap[i] = 1;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 13.5) {
                                        if (RANGE_MACRO_VALUE < 180.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 180.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        else if (MIN_MACRO_VALUE >= 28.5) {
            if (RANGE_MACRO_VALUE < 11.5) {
                if (AVG_MACRO_VALUE < 31.27) {
                    if (AVG_MACRO_VALUE < 31.26) {
                        if (X < 1528) {
                            binMap[i] = 0;
                        }
                        else if (X >= 1528) {
                            if (X < 1640) {
                                binMap[i] = 1;
                            }
                            else if (X >= 1640) {
                                binMap[i] = 0;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 31.26) {
                        binMap[i] = 1;
                    }
                }
                else if (AVG_MACRO_VALUE >= 31.27) {
                    if (RANGE_MACRO_VALUE < 3.5) {
                        if (AVG_MACRO_VALUE < 102.74) {
                            if (RANGE_MACRO_VALUE < 2.5) {
                                if (AVG_MACRO_VALUE < 52.06) {
                                    binMap[i] = 0;
                                }
                                else if (AVG_MACRO_VALUE >= 52.06) {
                                    if (MIN_MACRO_VALUE < 51.5) {
                                        if (Y < 424) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 424) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 51.5) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 2.5) {
                                binMap[i] = 0;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 102.74) {
                            if (Y < 840) {
                                if (Y < 120) {
                                    binMap[i] = 0;
                                }
                                else if (Y >= 120) {
                                    if (AVG_MACRO_VALUE < 103.22) {
                                        if (X < 1072) {
                                            binMap[i] = 1;
                                        }
                                        else if (X >= 1072) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 103.22) {
                                        if (Y < 136) {
                                            binMap[i] = 1;
                                        }
                                        else if (Y >= 136) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (Y >= 840) {
                                if (AVG_MACRO_VALUE < 143.44) {
                                    binMap[i] = 0;
                                }
                                else if (AVG_MACRO_VALUE >= 143.44) {
                                    if (AVG_MACRO_VALUE < 144.17) {
                                        if (Y < 1000) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 1000) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 144.17) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 3.5) {
                        if (AVG_MACRO_VALUE < 33.36) {
                            binMap[i] = 0;
                        }
                        else if (AVG_MACRO_VALUE >= 33.36) {
                            if (AVG_MACRO_VALUE < 170) {
                                if (X < 888) {
                                    if (AVG_MACRO_VALUE < 41.71) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 41.71) {
                                        if (AVG_MACRO_VALUE < 42.21) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.21) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (X >= 888) {
                                    if (AVG_MACRO_VALUE < 33.37) {
                                        binMap[i] = 1;
                                    }
                                    else if (AVG_MACRO_VALUE >= 33.37) {
                                        if (AVG_MACRO_VALUE < 33.87) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 33.87) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 170) {
                                binMap[i] = 0;
                            }
                        }
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 11.5) {
                if (Y < 712) {
                    if (Y < 72) {
                        if (X < 1672) {
                            if (MAX_MACRO_VALUE < 225.5) {
                                binMap[i] = 0;
                            }
                            else if (MAX_MACRO_VALUE >= 225.5) {
                                if (X < 1256) {
                                    if (AVG_MACRO_VALUE < 202.94) {
                                        if (MAX_MACRO_VALUE < 231.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MAX_MACRO_VALUE >= 231.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 202.94) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (X >= 1256) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                        else if (X >= 1672) {
                            if (Y < 40) {
                                if (MAX_MACRO_VALUE < 20.5) {
                                    binMap[i] = 1;
                                }
                                else if (MAX_MACRO_VALUE >= 20.5) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (Y >= 40) {
                                if (AVG_MACRO_VALUE < 148.46) {
                                    if (AVG_MACRO_VALUE < 73.38) {
                                        if (X < 1752) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 1752) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 73.38) {
                                        if (AVG_MACRO_VALUE < 93.09) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 93.09) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 148.46) {
                                    binMap[i] = 1;
                                }
                            }
                        }
                    }
                    else if (Y >= 72) {
                        if (X < 1608) {
                            if (Y < 152) {
                                if (AVG_MACRO_VALUE < 145.4) {
                                    binMap[i] = 0;
                                }
                                else if (AVG_MACRO_VALUE >= 145.4) {
                                    if (MAX_MACRO_VALUE < 168.5) {
                                        if (MAX_MACRO_VALUE < 165.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MAX_MACRO_VALUE >= 165.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 168.5) {
                                        if (Y < 88) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 88) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (Y >= 152) {
                                if (X < 984) {
                                    if (RANGE_MACRO_VALUE < 21.5) {
                                        if (X < 872) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 872) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 21.5) {
                                        if (Y < 424) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 424) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (X >= 984) {
                                    if (AVG_MACRO_VALUE < 39.51) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 39.51) {
                                        if (AVG_MACRO_VALUE < 39.75) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 39.75) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 1608) {
                            if (Y < 216) {
                                binMap[i] = 0;
                            }
                            else if (Y >= 216) {
                                if (Y < 328) {
                                    if (X < 1640) {
                                        if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1640) {
                                        if (X < 1864) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 1864) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (Y >= 328) {
                                    if (AVG_MACRO_VALUE < 34.03) {
                                        binMap[i] = 1;
                                    }
                                    else if (AVG_MACRO_VALUE >= 34.03) {
                                        if (AVG_MACRO_VALUE < 141.75) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 141.75) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (Y >= 712) {
                    if (MAX_MACRO_VALUE < 51.5) {
                        if (X < 1800) {
                            if (X < 1752) {
                                if (MAX_MACRO_VALUE < 22.5) {
                                    if (X < 872) {
                                        binMap[i] = 1;
                                    }
                                    else if (X >= 872) {
                                        if (X < 1344) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 1344) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 22.5) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (X >= 1752) {
                                if (Y < 808) {
                                    if (AVG_MACRO_VALUE < 44.17) {
                                        if (AVG_MACRO_VALUE < 42.21) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.21) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 44.17) {
                                        if (Y < 728) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 728) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (Y >= 808) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                        else if (X >= 1800) {
                            if (MAX_MACRO_VALUE < 41.5) {
                                binMap[i] = 1;
                            }
                            else if (MAX_MACRO_VALUE >= 41.5) {
                                binMap[i] = 0;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 51.5) {
                        if (AVG_MACRO_VALUE < 47.73) {
                            if (MIN_MACRO_VALUE < 39.5) {
                                if (Y < 792) {
                                    if (X < 1848) {
                                        if (AVG_MACRO_VALUE < 45.77) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 45.77) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (X >= 1848) {
                                        if (AVG_MACRO_VALUE < 47.64) {
                                            binMap[i] = 0;
                                        }
                                        else if (AVG_MACRO_VALUE >= 47.64) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (Y >= 792) {
                                    if (AVG_MACRO_VALUE < 47.15) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 47.15) {
                                        if (AVG_MACRO_VALUE < 47.16) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 47.16) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 39.5) {
                                binMap[i] = 0;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 47.73) {
                            if (MIN_MACRO_VALUE < 36.5) {
                                if (MAX_MACRO_VALUE < 222.5) {
                                    if (X < 1752) {
                                        binMap[i] = 0;
                                    }
                                    else if (X >= 1752) {
                                        if (X < 1768) {
                                            binMap[i] = 1;
                                        }
                                        else if (X >= 1768) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 222.5) {
                                    if (AVG_MACRO_VALUE < 79.04) {
                                        if (Y < 744) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 744) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 79.04) {
                                        if (RANGE_MACRO_VALUE < 193.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 193.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 36.5) {
                                if (X < 1896) {
                                    if (X < 1800) {
                                        if (Y < 936) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 936) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1800) {
                                        if (Y < 1000) {
                                            binMap[i] = 1;
                                        }
                                        else if (Y >= 1000) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                                else if (X >= 1896) {
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

__kernel void repTest1(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
{
    int X = get_global_id(0) * 16;
	int Y = get_global_id(1) * 16;

    unsigned int *blockData[256];
    int j = 0;
	
	int AVG_MACRO_VALUE = 0;
	int MAX_MACRO_VALUE = -1;
	int MIN_MACRO_VALUE = 256;
	int RANGE_MACRO_VALUE = 0;
    int AVGQUADRANT_MACRO_VALUE = 0;

	int offset = Y * width + X;

    for (int i = 0; i < 16; i++)			//over every x value
	{
		AVG_MACRO_VALUE += frame[offset + (i * width)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width)]);
        blockData[j] = frame[offset + (i * width)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 1)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        blockData[j + 1] = frame[offset + (i * width + 1)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 2)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        blockData[j + 2] = frame[offset + (i * width + 2)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 3)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        blockData[j + 3] = frame[offset + (i * width + 3)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 4)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        blockData[j + 4] = frame[offset + (i * width + 4)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 5)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        blockData[j + 5] = frame[offset + (i * width + 5)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 6)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        blockData[j + 6] = frame[offset + (i * width + 6)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 7)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        blockData[j + 7] = frame[offset + (i * width + 7)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 8)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        blockData[j + 8] = frame[offset + (i * width + 8)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 9)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        blockData[j + 9] = frame[offset + (i * width + 9)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 10)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        blockData[j + 10] = frame[offset + (i * width + 10)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 11)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        blockData[j + 11] = frame[offset + (i * width + 11)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 12)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        blockData[j + 12] = frame[offset + (i * width + 12)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 13)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        blockData[j + 13] = frame[offset + (i * width + 13)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 14)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        blockData[j + 14] = frame[offset + (i * width + 14)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 15)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        blockData[j + 15] = frame[offset + (i * width + 15)];

        j += 16;
	}

	if(Y != 1072)
    {
        AVG_MACRO_VALUE /= 256.0;

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

	if (AVG_MACRO_VALUE < 29.55) {
            if (Y < 136) {
                if (X < 1784) {
                    if (X < 472) {
                        if (AVG_MACRO_VALUE < 25.2) {
                            if (Y < 8) {
                                binMap[i] = 0;
                            }
                            else if (Y >= 8) {
                                if (AVG_MACRO_VALUE < 16.96) {
                                    if (X < 136) {
                                        if (X < 88) {
                                            if (Y < 40) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 40) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (X >= 88) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (X >= 136) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 16.96) {
                                    binMap[i] = 1;
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 25.2) {
                            if (AVG_MACRO_VALUE < 26.64) {
                                if (AVG_MACRO_VALUE < 25.48) {
                                    binMap[i] = 1;
                                }
                                else if (AVG_MACRO_VALUE >= 25.48) {
                                    if (Y < 96) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 96) {
                                        binMap[i] = 1;
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 26.64) {
                                if (MIN_MACRO_VALUE < 22.5) {
                                    if (X < 440) {
                                        binMap[i] = 0;
                                    }
                                    else if (X >= 440) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 22.5) {
                                    binMap[i] = 1;
                                }
                            }
                        }
                    }
                    else if (X >= 472) {
                        if (X < 1272) {
                            if (Y < 8) {
                                if (X < 920) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 920) {
                                    if (X < 984) {
                                        binMap[i] = 1;
                                    }
                                    else if (X >= 984) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (Y >= 8) {
                                if (MAX_MACRO_VALUE < 59.5) {
                                    binMap[i] = 0;
                                }
                                else if (MAX_MACRO_VALUE >= 59.5) {
                                    if (RANGE_MACRO_VALUE < 41.5) {
                                        binMap[i] = 1;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 41.5) {
                                        if (MIN_MACRO_VALUE < 16.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MIN_MACRO_VALUE >= 16.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                        }
                        else if (X >= 1272) {
                            if (X < 1336) {
                                if (MIN_MACRO_VALUE < 17) {
                                    binMap[i] = 1;
                                }
                                else if (MIN_MACRO_VALUE >= 17) {
                                    if (Y < 104) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 104) {
                                        binMap[i] = 1;
                                    }
                                }
                            }
                            else if (X >= 1336) {
                                if (AVG_MACRO_VALUE < 18.64) {
                                    if (X < 1544) {
                                        binMap[i] = 0;
                                    }
                                    else if (X >= 1544) {
                                        if (Y < 72) {
                                            if (X < 1656) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 1656) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (Y >= 72) {
                                            if (X < 1608) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 1608) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 18.64) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                    }
                }
                else if (X >= 1784) {
                    binMap[i] = 0;
                }
            }
            else if (Y >= 136) {
                if (AVG_MACRO_VALUE < 23.97) {
                    if (X < 1336) {
                        if (X < 1320) {
                            if (X < 1288) {
                                if (MAX_MACRO_VALUE < 103.5) {
                                    if (RANGE_MACRO_VALUE < 27.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 27.5) {
                                        if (RANGE_MACRO_VALUE < 67.5) {
                                            if (Y < 200) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 200) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 67.5) {
                                            if (X < 1072) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 1072) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 103.5) {
                                    binMap[i] = 1;
                                }
                            }
                            else if (X >= 1288) {
                                binMap[i] = 0;
                            }
                        }
                        else if (X >= 1320) {
                            if (RANGE_MACRO_VALUE < 3.5) {
                                if (Y < 968) {
                                    binMap[i] = 0;
                                }
                                else if (Y >= 968) {
                                    if (Y < 992) {
                                        binMap[i] = 1;
                                    }
                                    else if (Y >= 992) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 3.5) {
                                binMap[i] = 1;
                            }
                        }
                    }
                    else if (X >= 1336) {
                        if (MAX_MACRO_VALUE < 19.5) {
                            binMap[i] = 0;
                        }
                        else if (MAX_MACRO_VALUE >= 19.5) {
                            if (AVG_MACRO_VALUE < 23.62) {
                                if (X < 1768) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 1768) {
                                    if (Y < 712) {
                                        if (RANGE_MACRO_VALUE < 2.5) {
                                            if (X < 1864) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 1864) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 2.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (Y >= 712) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 23.62) {
                                if (X < 1464) {
                                    if (Y < 320) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 320) {
                                        binMap[i] = 1;
                                    }
                                }
                                else if (X >= 1464) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 23.97) {
                    if (MAX_MACRO_VALUE < 26.5) {
                        binMap[i] = 0;
                    }
                    else if (MAX_MACRO_VALUE >= 26.5) {
                        if (AVG_MACRO_VALUE < 28.7) {
                            binMap[i] = 0;
                        }
                        else if (AVG_MACRO_VALUE >= 28.7) {
                            if (RANGE_MACRO_VALUE < 100) {
                                if (Y < 1048) {
                                    binMap[i] = 0;
                                }
                                else if (Y >= 1048) {
                                    if (RANGE_MACRO_VALUE < 33.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 33.5) {
                                        binMap[i] = 1;
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 100) {
                                binMap[i] = 0;
                            }
                        }
                    }
                }
            }
        }
        else if (AVG_MACRO_VALUE >= 29.55) {
            if (RANGE_MACRO_VALUE < 20.5) {
                if (X < 1144) {
                    if (AVGQUADRANT_MACRO_VALUE < 0.5) {
                        if (MIN_MACRO_VALUE < 58.5) {
                            if (X < 888) {
                                if (X < 488) {
                                    if (Y < 968) {
                                        if (AVG_MACRO_VALUE < 29.63) {
                                            if (MAX_MACRO_VALUE < 34.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MAX_MACRO_VALUE >= 34.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 29.63) {
                                            if (AVG_MACRO_VALUE < 45.03) {
                                                binMap[i] = 0;
                                            }
                                            else if (AVG_MACRO_VALUE >= 45.03) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (Y >= 968) {
                                        if (X < 168) {
                                            if (RANGE_MACRO_VALUE < 4.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 4.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (X >= 168) {
                                            if (X < 312) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 312) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 488) {
                                    if (Y < 808) {
                                        if (RANGE_MACRO_VALUE < 18.5) {
                                            if (RANGE_MACRO_VALUE < 17.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 17.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 18.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (Y >= 808) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (X >= 888) {
                                binMap[i] = 0;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 58.5) {
                            if (AVG_MACRO_VALUE < 67.06) {
                                if (Y < 440) {
                                    binMap[i] = 0;
                                }
                                else if (Y >= 440) {
                                    if (Y < 584) {
                                        if (RANGE_MACRO_VALUE < 15.5) {
                                            if (RANGE_MACRO_VALUE < 10.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 10.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 15.5) {
                                            if (Y < 552) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 552) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (Y >= 584) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 67.06) {
                                if (MIN_MACRO_VALUE < 71.5) {
                                    if (X < 824) {
                                        if (RANGE_MACRO_VALUE < 6.5) {
                                            if (Y < 464) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 464) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 6.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 824) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 71.5) {
                                    if (MIN_MACRO_VALUE < 76.5) {
                                        if (Y < 552) {
                                            if (X < 1000) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 1000) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (Y >= 552) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 76.5) {
                                        binMap[i] = 1;
                                    }
                                }
                            }
                        }
                    }
                    else if (AVGQUADRANT_MACRO_VALUE >= 0.5) {
                        if (X < 736) {
                            if (MAX_MACRO_VALUE < 60.5) {
                                binMap[i] = 0;
                            }
                            else if (MAX_MACRO_VALUE >= 60.5) {
                                if (Y < 352) {
                                    binMap[i] = 0;
                                }
                                else if (Y >= 352) {
                                    binMap[i] = 1;
                                }
                            }
                        }
                        else if (X >= 736) {
                            binMap[i] = 0;
                        }
                    }
                }
                else if (X >= 1144) {
                    if (Y < 248) {
                        if (Y < 152) {
                            if (X < 1448) {
                                if (Y < 120) {
                                    binMap[i] = 0;
                                }
                                else if (Y >= 120) {
                                    if (AVG_MACRO_VALUE < 163.98) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 163.98) {
                                        if (AVG_MACRO_VALUE < 169.73) {
                                            binMap[i] = 1;
                                        }
                                        else if (AVG_MACRO_VALUE >= 169.73) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (X >= 1448) {
                                binMap[i] = 0;
                            }
                        }
                        else if (Y >= 152) {
                            binMap[i] = 0;
                        }
                    }
                    else if (Y >= 248) {
                        if (MAX_MACRO_VALUE < 57.5) {
                            if (AVG_MACRO_VALUE < 50.31) {
                                if (MAX_MACRO_VALUE < 55.5) {
                                    if (X < 1176) {
                                        if (MIN_MACRO_VALUE < 24.5) {
                                            binMap[i] = 1;
                                        }
                                        else if (MIN_MACRO_VALUE >= 24.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1176) {
                                        if (X < 1496) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 1496) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 55.5) {
                                    binMap[i] = 0;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 50.31) {
                                if (AVG_MACRO_VALUE < 50.35) {
                                    binMap[i] = 1;
                                }
                                else if (AVG_MACRO_VALUE >= 50.35) {
                                    if (AVG_MACRO_VALUE < 51.07) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 51.07) {
                                        if (X < 1704) {
                                            if (AVG_MACRO_VALUE < 52.36) {
                                                binMap[i] = 0;
                                            }
                                            else if (AVG_MACRO_VALUE >= 52.36) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (X >= 1704) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 57.5) {
                            if (RANGE_MACRO_VALUE < 16.5) {
                                if (X < 1848) {
                                    binMap[i] = 0;
                                }
                                else if (X >= 1848) {
                                    if (Y < 376) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 376) {
                                        if (Y < 392) {
                                            binMap[i] = 1;
                                        }
                                        else if (Y >= 392) {
                                            if (X < 1896) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 1896) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 16.5) {
                                if (Y < 824) {
                                    binMap[i] = 0;
                                }
                                else if (Y >= 824) {
                                    if (Y < 840) {
                                        if (RANGE_MACRO_VALUE < 18.5) {
                                            if (RANGE_MACRO_VALUE < 17.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 17.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (RANGE_MACRO_VALUE >= 18.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (Y >= 840) {
                                        if (RANGE_MACRO_VALUE < 19.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 19.5) {
                                            if (Y < 1016) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 1016) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 20.5) {
                if (AVG_MACRO_VALUE < 104.1) {
                    if (X < 1176) {
                        if (X < 1048) {
                            if (RANGE_MACRO_VALUE < 31.5) {
                                if (AVG_MACRO_VALUE < 65.67) {
                                    binMap[i] = 0;
                                }
                                else if (AVG_MACRO_VALUE >= 65.67) {
                                    if (AVG_MACRO_VALUE < 71.47) {
                                        binMap[i] = 0;
                                    }
                                    else if (AVG_MACRO_VALUE >= 71.47) {
                                        if (Y < 568) {
                                            if (Y < 280) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 280) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (Y >= 568) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 31.5) {
                                binMap[i] = 1;
                            }
                        }
                        else if (X >= 1048) {
                            if (Y < 680) {
                                if (MIN_MACRO_VALUE < 86.5) {
                                    if (Y < 152) {
                                        binMap[i] = 1;
                                    }
                                    else if (Y >= 152) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 86.5) {
                                    if (MAX_MACRO_VALUE < 114) {
                                        binMap[i] = 0;
                                    }
                                    else if (MAX_MACRO_VALUE >= 114) {
                                        if (RANGE_MACRO_VALUE < 32) {
                                            binMap[i] = 1;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 32) {
                                            binMap[i] = 0;
                                        }
                                    }
                                }
                            }
                            else if (Y >= 680) {
                                if (Y < 696) {
                                    if (MAX_MACRO_VALUE < 125.5) {
                                        if (MAX_MACRO_VALUE < 105.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MAX_MACRO_VALUE >= 105.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 125.5) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (Y >= 696) {
                                    if (MIN_MACRO_VALUE < 19.5) {
                                        binMap[i] = 1;
                                    }
                                    else if (MIN_MACRO_VALUE >= 19.5) {
                                        binMap[i] = 0;
                                    }
                                }
                            }
                        }
                    }
                    else if (X >= 1176) {
                        if (X < 1224) {
                            if (Y < 504) {
                                if (MIN_MACRO_VALUE < 61.5) {
                                    if (Y < 136) {
                                        if (MIN_MACRO_VALUE < 18.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MIN_MACRO_VALUE >= 18.5) {
                                            if (MAX_MACRO_VALUE < 139.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MAX_MACRO_VALUE >= 139.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (Y >= 136) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 61.5) {
                                    if (MAX_MACRO_VALUE < 112.5) {
                                        if (Y < 440) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 440) {
                                            if (MAX_MACRO_VALUE < 88) {
                                                binMap[i] = 0;
                                            }
                                            else if (MAX_MACRO_VALUE >= 88) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 112.5) {
                                        if (MIN_MACRO_VALUE < 76.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MIN_MACRO_VALUE >= 76.5) {
                                            if (MIN_MACRO_VALUE < 81.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MIN_MACRO_VALUE >= 81.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (Y >= 504) {
                                if (MIN_MACRO_VALUE < 42.5) {
                                    if (MIN_MACRO_VALUE < 25.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (MIN_MACRO_VALUE >= 25.5) {
                                        if (AVG_MACRO_VALUE < 69.14) {
                                            if (AVG_MACRO_VALUE < 43.02) {
                                                binMap[i] = 0;
                                            }
                                            else if (AVG_MACRO_VALUE >= 43.02) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 69.14) {
                                            if (RANGE_MACRO_VALUE < 159) {
                                                binMap[i] = 0;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 159) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 42.5) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                        else if (X >= 1224) {
                            if (AVG_MACRO_VALUE < 84.16) {
                                if (AVG_MACRO_VALUE < 78.47) {
                                    if (Y < 408) {
                                        if (AVG_MACRO_VALUE < 56.93) {
                                            if (MAX_MACRO_VALUE < 52.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MAX_MACRO_VALUE >= 52.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (AVG_MACRO_VALUE >= 56.93) {
                                            if (X < 1400) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 1400) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (Y >= 408) {
                                        if (MAX_MACRO_VALUE < 74.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MAX_MACRO_VALUE >= 74.5) {
                                            if (RANGE_MACRO_VALUE < 31.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 31.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 78.47) {
                                    if (RANGE_MACRO_VALUE < 69.5) {
                                        binMap[i] = 0;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 69.5) {
                                        if (MAX_MACRO_VALUE < 233.5) {
                                            if (RANGE_MACRO_VALUE < 83.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (RANGE_MACRO_VALUE >= 83.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 233.5) {
                                            if (Y < 696) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 696) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 84.16) {
                                if (MAX_MACRO_VALUE < 104.5) {
                                    binMap[i] = 0;
                                }
                                else if (MAX_MACRO_VALUE >= 104.5) {
                                    binMap[i] = 1;
                                }
                            }
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 104.1) {
                    if (X < 1288) {
                        if (AVG_MACRO_VALUE < 104.5) {
                            if (X < 1048) {
                                if (AVG_MACRO_VALUE < 104.35) {
                                    binMap[i] = 1;
                                }
                                else if (AVG_MACRO_VALUE >= 104.35) {
                                    if (X < 720) {
                                        binMap[i] = 1;
                                    }
                                    else if (X >= 720) {
                                        if (X < 744) {
                                            binMap[i] = 1;
                                        }
                                        else if (X >= 744) {
                                            if (Y < 656) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 656) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                }
                            }
                            else if (X >= 1048) {
                                binMap[i] = 0;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 104.5) {
                            if (AVG_MACRO_VALUE < 104.91) {
                                binMap[i] = 0;
                            }
                            else if (AVG_MACRO_VALUE >= 104.91) {
                                if (X < 248) {
                                    if (Y < 408) {
                                        if (MAX_MACRO_VALUE < 171.5) {
                                            if (MAX_MACRO_VALUE < 123.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MAX_MACRO_VALUE >= 123.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (MAX_MACRO_VALUE >= 171.5) {
                                            if (X < 136) {
                                                binMap[i] = 1;
                                            }
                                            else if (X >= 136) {
                                                binMap[i] = 0;
                                            }
                                        }
                                    }
                                    else if (Y >= 408) {
                                        if (Y < 920) {
                                            if (MAX_MACRO_VALUE < 112.5) {
                                                binMap[i] = 1;
                                            }
                                            else if (MAX_MACRO_VALUE >= 112.5) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (Y >= 920) {
                                            if (MAX_MACRO_VALUE < 227.5) {
                                                binMap[i] = 0;
                                            }
                                            else if (MAX_MACRO_VALUE >= 227.5) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                                else if (X >= 248) {
                                    if (MAX_MACRO_VALUE < 151.5) {
                                        if (Y < 392) {
                                            if (Y < 328) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 328) {
                                                binMap[i] = 1;
                                            }
                                        }
                                        else if (Y >= 392) {
                                            if (Y < 616) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 616) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 151.5) {
                                        binMap[i] = 1;
                                    }
                                }
                            }
                        }
                    }
                    else if (X >= 1288) {
                        if (MAX_MACRO_VALUE < 120.5) {
                            if (MIN_MACRO_VALUE < 97.5) {
                                binMap[i] = 0;
                            }
                            else if (MIN_MACRO_VALUE >= 97.5) {
                                if (Y < 1000) {
                                    if (X < 1560) {
                                        binMap[i] = 0;
                                    }
                                    else if (X >= 1560) {
                                        if (X < 1800) {
                                            binMap[i] = 1;
                                        }
                                        else if (X >= 1800) {
                                            if (Y < 936) {
                                                binMap[i] = 0;
                                            }
                                            else if (Y >= 936) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                }
                                else if (Y >= 1000) {
                                    binMap[i] = 0;
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 120.5) {
                            if (MIN_MACRO_VALUE < 73.5) {
                                if (Y < 376) {
                                    if (X < 1608) {
                                        if (Y < 152) {
                                            binMap[i] = 0;
                                        }
                                        else if (Y >= 152) {
                                            if (X < 1384) {
                                                binMap[i] = 0;
                                            }
                                            else if (X >= 1384) {
                                                binMap[i] = 1;
                                            }
                                        }
                                    }
                                    else if (X >= 1608) {
                                        binMap[i] = 0;
                                    }
                                }
                                else if (Y >= 376) {
                                    if (X < 1576) {
                                        if (MIN_MACRO_VALUE < 15.5) {
                                            if (Y < 488) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 488) {
                                                binMap[i] = 0;
                                            }
                                        }
                                        else if (MIN_MACRO_VALUE >= 15.5) {
                                            binMap[i] = 0;
                                        }
                                    }
                                    else if (X >= 1576) {
                                        if (MAX_MACRO_VALUE < 228.5) {
                                            binMap[i] = 0;
                                        }
                                        else if (MAX_MACRO_VALUE >= 228.5) {
                                            binMap[i] = 1;
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 73.5) {
                                if (AVG_MACRO_VALUE < 160.92) {
                                    binMap[i] = 0;
                                }
                                else if (AVG_MACRO_VALUE >= 160.92) {
                                    if (Y < 936) {
                                        binMap[i] = 0;
                                    }
                                    else if (Y >= 936) {
                                        if (X < 1560) {
                                            binMap[i] = 0;
                                        }
                                        else if (X >= 1560) {
                                            if (Y < 1000) {
                                                binMap[i] = 1;
                                            }
                                            else if (Y >= 1000) {
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
}

__kernel void dtcTest(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
{
    int X = get_global_id(0) * 16;
	int Y = get_global_id(1) * 16;

    unsigned int *blockData[256];
    int j = 0;
	
	int AVG_MACRO_VALUE = 0;
	int MAX_MACRO_VALUE = -1;
	int MIN_MACRO_VALUE = 256;
	int RANGE_MACRO_VALUE = 0;
    int AVGQUADRANT_MACRO_VALUE = 0;

	int offset = Y * width + X;

    for (int i = 0; i < 16; i++)			//over every x value
	{
		AVG_MACRO_VALUE += frame[offset + (i * width)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width)]);
        blockData[j] = frame[offset + (i * width)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 1)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        blockData[j + 1] = frame[offset + (i * width + 1)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 2)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        blockData[j + 2] = frame[offset + (i * width + 2)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 3)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        blockData[j + 3] = frame[offset + (i * width + 3)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 4)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        blockData[j + 4] = frame[offset + (i * width + 4)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 5)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        blockData[j + 5] = frame[offset + (i * width + 5)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 6)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        blockData[j + 6] = frame[offset + (i * width + 6)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 7)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        blockData[j + 7] = frame[offset + (i * width + 7)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 8)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        blockData[j + 8] = frame[offset + (i * width + 8)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 9)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        blockData[j + 9] = frame[offset + (i * width + 9)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 10)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        blockData[j + 10] = frame[offset + (i * width + 10)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 11)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        blockData[j + 11] = frame[offset + (i * width + 11)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 12)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        blockData[j + 12] = frame[offset + (i * width + 12)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 13)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        blockData[j + 13] = frame[offset + (i * width + 13)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 14)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        blockData[j + 14] = frame[offset + (i * width + 14)];

		AVG_MACRO_VALUE += frame[offset + (i * width + 15)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        blockData[j + 15] = frame[offset + (i * width + 15)];

        j += 16;
	}

	if(Y != 1072)
    {
        AVG_MACRO_VALUE /= 256.0;

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
*/