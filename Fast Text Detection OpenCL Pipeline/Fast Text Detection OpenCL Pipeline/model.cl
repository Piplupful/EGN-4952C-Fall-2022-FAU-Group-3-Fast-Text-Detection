// TODO: Add OpenCL kernel code here.
__kernel void kernelTemplateDebug(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
{
    int X = get_global_id(0) * 16;  //coord on global frame
	int Y = get_global_id(1) * 16;

    int zeroCount = 0;  //Use with Multiple Trees, larger count is final decision on block
    int oneCount = 0;

    unsigned char *blockData[256];  //blockData for other calculations that cant be done on frame read
	
	int SUM_MACRO_VALUE = 0;
    //standard statistics
    float AVG_MACRO_VALUE = 0;
	int MAX_MACRO_VALUE = -1;
	int MIN_MACRO_VALUE = 256;
	int RANGE_MACRO_VALUE = 0;
    float VARIANCE = 0;
    //calculation to predict if 16x16 block contains text, developed by Nelson Mendez
    int AVGQUADRANT_MACRO_VALUE = 0;
    //Sum and Average of Difference between subsequent luma values by row or by column
    int SUM_ROW = 0;
    int SUM_COL = 0;
    int SUM_ROW_COL = 0;
    float AVG_ROW = 0;
    float AVG_COL = 0;

	int offset = Y * width + X;

    for (int i = 0; i < 16; i++)			//over every x value
	{
		SUM_MACRO_VALUE += frame[offset + (i * width)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width)]);
        blockData[i * 16] = frame[offset + (i * width)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 1)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 1)]);
        blockData[i * 16 + 1] = frame[offset + (i * width + 1)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 2)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 2)]);
        blockData[i * 16 + 2] = frame[offset + (i * width + 2)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 3)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 3)]);
        blockData[i * 16 + 3] = frame[offset + (i * width + 3)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 4)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 4)]);
        blockData[i * 16 + 4] = frame[offset + (i * width + 4)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 5)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 5)]);
        blockData[i * 16 + 5] = frame[offset + (i * width + 5)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 6)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 6)]);
        blockData[i * 16 + 6] = frame[offset + (i * width + 6)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 7)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 7)]);
        blockData[i * 16 + 7] = frame[offset + (i * width + 7)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 8)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 8)]);
        blockData[i * 16 + 8] = frame[offset + (i * width + 8)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 9)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 9)]);
        blockData[i * 16 + 9] = frame[offset + (i * width + 9)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 10)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 10)]);
        blockData[i * 16 + 10] = frame[offset + (i * width + 10)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 11)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 11)]);
        blockData[i * 16 + 11] = frame[offset + (i * width + 11)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 12)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 12)]);
        blockData[i * 16 + 12] = frame[offset + (i * width + 12)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 13)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 13)]);
        blockData[i * 16 + 13] = frame[offset + (i * width + 13)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 14)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 14)]);
        blockData[i * 16 + 14] = frame[offset + (i * width + 14)];

		SUM_MACRO_VALUE += frame[offset + (i * width + 15)];
        MIN_MACRO_VALUE = min(MIN_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        MAX_MACRO_VALUE = max(MAX_MACRO_VALUE, (int)frame[offset + (i * width + 15)]);
        blockData[i * 16 + 15] = frame[offset + (i * width + 15)];
	}

	if(Y != 1072)
    {
        //AVERAGE
        AVG_MACRO_VALUE = SUM_MACRO_VALUE / 256.0;

        //RANGE
        RANGE_MACRO_VALUE = MAX_MACRO_VALUE - MIN_MACRO_VALUE;

        //VARIANCE
        for (int i = 0; i < 16; i++)
        {
	        for (int j = 0; j < 16; j++)
	        {
		        VARIANCE += ((int)blockData[i * 16 + j] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + j] - AVG_MACRO_VALUE);
	        }
        }

        VARIANCE /= 256;

        //SUM AND AVERAGE OF DIFFERENCE IN ROW AND COL
        for(int i = 0; i < 15; i++)
        {
            for(int j = 0; j < 16; j++)
            {
                SUM_ROW += abs_diff((int)blockData[i * 16 + j], (int)(blockData[((i+1) * 16) + j]));
            }
        }
        AVG_ROW = SUM_ROW / 240; //15 * 16

        for(int i = 0; i < 16; i++)
        {
            for(int j = 0; j < 15; j++)
            {
                SUM_COL += abs_diff((int)blockData[i * 16 + j], (int)blockData[i * 16 + (j + 1)]);
            }
        }
        AVG_COL = SUM_COL / 240; //16 * 15

        SUM_ROW_COL = SUM_ROW + SUM_COL;

        //AVGQUADRANT_MACRO_VALUE CALCULATIONS
        int q1Avg, q2Avg, q3Avg, q4Avg, qcenter = 0;
        int q_size = 4;

        //int avgQuadrantBlock(int blocksize, unsigned char *blockData, int q_size, int x, int y)
        //q1Avg = avgQuadrantBlock(16, blockData, q_size, 0, 0);   // quadrant 1 is left top corner so start at 0,0 of macroblock
        
        int sum = 0;
        int x = 0;
        int y = 0;
        int xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        int ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                sum += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        q1Avg = sum / (q_size * q_size);
        
        //q2Avg = avgQuadrantBlock(16, blockData, q_size, 0, 16 - q_size);  // quadrant 2 is right top corner so if a 8x8 macroblock then from (5-7, 0-2)
        
        sum = 0;
        x = 0;
        y = 16 - q_size;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                sum += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        q2Avg = sum / (q_size * q_size);
        
        //q3Avg = avgQuadrantBlock(16, blockData, q_size, 16 - q_size, 0);  // quadrant 3 is left bottom corner so if a 8x8 macroblock then from (0-2, 5-7)
        
        sum = 0;
        x = 16 - q_size;
        y = 0;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                sum += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        q3Avg = sum / (q_size * q_size);
        
        //q4Avg = avgQuadrantBlock(16, blockData, q_size, 16 - q_size, 16 - q_size); // quadrant 4 is the right bottom corner so if a 8x8 macroblock then from (5-7, 5-7)
        
        sum = 0;
        x = 16 - q_size;
        y = 16 - q_size;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                sum += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        q4Avg = sum / (q_size * q_size);
        
        //qcenter = avgQuadrantBlock(16, blockData, 2, 16 / 2 - 1, 16 / 2 - 1); // This retrieves the average of the center in a 2x2 quadrant
        
        sum = 0;
        x = 16 / 2 - 1;
        y = 16 / 2 - 1;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                sum += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        qcenter = sum / (q_size * q_size);

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
        //AVERAGE
		AVG_MACRO_VALUE /= 128.0;	//1080p case, 1080/16 = 67.5

        //RANGE
        RANGE_MACRO_VALUE = MAX_MACRO_VALUE - MIN_MACRO_VALUE;

        //VARIANCE
        for (int i = 0; i < 8; i++)
        {
	        for (int j = 0; j < 16; j++)
	        {
		        VARIANCE += ((int)blockData[i * 16 + j] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + j] - AVG_MACRO_VALUE);
	        }
        }

        VARIANCE /= 128.0;

        //SUM AND AVERAGE OF DIFFERENCE IN ROW AND COL
        for(int i = 0; i < 7; i++)
        {
            for(int j = 0; j < 16; j++)
            {
                SUM_ROW += abs_diff((int)blockData[i * 16 + j], (int)(blockData[((i+1) * 16) + j]));
            }
        }
        AVG_ROW = SUM_ROW / 112; //16 * 7

        for(int i = 0; i < 8; i++)
        {
            for(int j = 0; j < 15; j++)
            {
                SUM_COL += abs_diff((int)blockData[i * 16 + j], (int)blockData[i * 16 + (j + 1)]);
            }
        }
        AVG_COL = SUM_COL / 120; //15 * 8

        SUM_ROW_COL = SUM_ROW + SUM_COL;

        //AVGQUADRANT_MACRO_VALUE CALCULATIONS
        int q1Avg, q2Avg, qcenter = 0;
        int q_size = 4;

        //q1Avg = avgQuadrantBlock(16, blockData, q_size, 0, 0);   // quadrant 1 is left top corner so start at 0,0 of macroblock
        int sum = 0;
        int x = 0;
        int y = 0;
        int xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        int ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                sum += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }
        q1Avg = sum / (q_size * q_size);

        //q2Avg = avgQuadrantBlock(16, blockData, q_size, 0, 16 - q_size);  // quadrant 2 is right top corner so if a 8x8 macroblock then from (5-7, 0-2)
        sum = 0;
        x = 0;
        y = 16 - q_size;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                sum += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        q2Avg = sum / (q_size * q_size);

        //qcenter = avgQuadrantBlock(16, blockData, 2, 16 / 2 - 1, 16 / 2 - 1); // This retrieves the average of the center in a 2x2 quadrant
        sum = 0;
        x = 16 / 2 - 1;
        y = 16 / 2 - 1;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                sum += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        qcenter = sum / (q_size * q_size);

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

	//All statistics gathered.
	int i = (X / 16) + ((int)(Y / 16) * (width / 16));	//numBlock

    //DTC OR OTHER CONVERTED MODEL

}