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
    float AVG_MACRO_VALUE = 0.0;
	int MAX_MACRO_VALUE = -1;
	int MIN_MACRO_VALUE = 256;
	int RANGE_MACRO_VALUE = 0;
    float VARIANCE = 0.0;
    //Quadrant Features, developed by Nelson Mendez
    int Q1SUM, Q2SUM, Q3SUM, Q4SUM, QCENTERSUM = 0;
    float Q1AVG, Q2AVG, Q3AVG, Q4AVG, QCENTERAVG = 0.0;
    int Q12SUM_DIFF, Q13SUM_DIFF, Q14SUM_DIFF, Q23SUM_DIFF, Q24SUM_DIFF, Q34SUM_DIFF = 0;
    float Q1CENT_AVGDIFF, Q2CENT_AVGDIFF, Q3CENT_AVGDIFF, Q4CENT_AVGDIFF = 0.0;
    //Sum and Average of Difference between subsequent luma values by row or by column
    int SUM_ROW = 0;
    int SUM_COL = 0;
    int SUM_ROW_COL = 0;
    float AVG_ROW = 0.0;
    float AVG_COL = 0.0;

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
		    VARIANCE += ((int)blockData[i * 16] - AVG_MACRO_VALUE) * ((int)blockData[i * 16] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 1] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 1] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 2] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 2] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 3] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 3] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 4] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 4] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 5] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 5] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 6] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 6] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 7] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 7] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 8] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 8] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 9] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 9] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 10] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 10] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 11] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 11] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 12] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 12] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 13] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 13] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 14] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 14] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 15] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 15] - AVG_MACRO_VALUE);
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

        //AVGQUADRANT CALCULATIONS
        int q_size = 6;

        //Q1, TOP LEFT
        
        int x = 0;
        int y = 0;
        int xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        int ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                Q1SUM += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        Q1AVG = Q1SUM / (q_size * q_size);
        
        //Q2, TOP RIGHT

        x = 0;
        y = 16 - q_size;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                Q2SUM += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        Q2AVG = Q2SUM / (q_size * q_size);
        
        //Q3, BOTTOM LEFT
        
        x = 16 - q_size;
        y = 0;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                Q3SUM += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        Q3AVG = Q3SUM / (q_size * q_size);
        
        //Q4, BOTTOM RIGHT
        
        x = 16 - q_size;
        y = 16 - q_size;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                Q4SUM += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        Q4AVG = Q4SUM / (q_size * q_size);
        
        //QCENTER

        q_size = 3;
        x = 16 / 2 - 1;
        y = 16 / 2 - 1;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                QCENTERSUM += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        QCENTERAVG = QCENTERSUM / (q_size * q_size);

        //SUM AND AVERAGES FOR AVGQUADRANT CALCULATED, NOW GET SUM AND AVG DIFFERENCES
        Q12SUM_DIFF = abs_diff(Q1SUM, Q2SUM);
        Q13SUM_DIFF = abs_diff(Q1SUM, Q3SUM);
        Q14SUM_DIFF = abs_diff(Q1SUM, Q4SUM);

        Q23SUM_DIFF = abs_diff(Q2SUM, Q3SUM);
        Q24SUM_DIFF = abs_diff(Q2SUM, Q4SUM);

        Q34SUM_DIFF = abs_diff(Q3SUM, Q4SUM);

        Q1CENT_AVGDIFF = fabs(Q1AVG - QCENTERAVG);
        Q2CENT_AVGDIFF = fabs(Q2AVG - QCENTERAVG);
        Q3CENT_AVGDIFF = fabs(Q3AVG - QCENTERAVG);
        Q4CENT_AVGDIFF = fabs(Q4AVG - QCENTERAVG);
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
	        VARIANCE += ((int)blockData[i * 16] - AVG_MACRO_VALUE) * ((int)blockData[i * 16] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 1] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 1] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 2] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 2] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 3] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 3] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 4] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 4] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 5] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 5] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 6] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 6] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 7] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 7] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 8] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 8] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 9] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 9] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 10] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 10] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 11] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 11] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 12] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 12] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 13] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 13] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 14] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 14] - AVG_MACRO_VALUE);
		    VARIANCE += ((int)blockData[i * 16 + 15] - AVG_MACRO_VALUE) * ((int)blockData[i * 16 + 15] - AVG_MACRO_VALUE);
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

        ////AVGQUADRANT CALCULATIONS
        int q_size = 6;

        //Q1, TOP LEFT

        int x = 0;
        int y = 0;
        int xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        int ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                Q1SUM += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }
        Q1AVG = Q1SUM / (q_size * q_size);

        //Q2, TOP RIGHT

        x = 0;
        y = 16 - q_size;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                Q2SUM += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        Q2AVG = Q2SUM / (q_size * q_size);

        //QCENTER

        q_size = 3;
        x = 16 / 2 - 1;
        y = 16 / 2 - 1;
        xlimit = x + q_size;    // limiters of the loops so that we only get a quadrant of size q_size x q_size
        ylimit = y + q_size;
        for (int i = x; i < xlimit; i++)
        {
            for (int j = y; j < ylimit; j++)
            {
                QCENTERSUM += (int)blockData[i * 16 + j];    // add each luma value to sum
            }
        }

        QCENTERAVG = QCENTERSUM / (q_size * q_size);

        //SUM AND AVERAGES FOR AVGQUADRANT CALCULATED, NOW GET SUM AND AVG DIFFERENCES
        Q12SUM_DIFF = abs_diff(Q1SUM, Q2SUM);

        Q1CENT_AVGDIFF = fabs(Q1AVG - QCENTERAVG);
        Q2CENT_AVGDIFF = fabs(Q2AVG - QCENTERAVG);
    }

	//All statistics gathered.
	int i = (X / 16) + ((int)(Y / 16) * (width / 16));	//numBlock

    //DTC OR OTHER CONVERTED MODEL
    
}