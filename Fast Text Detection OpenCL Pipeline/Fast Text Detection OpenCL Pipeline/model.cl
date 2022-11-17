__kernel void DTC_14F(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
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
    //TREE 1
    if (AVG_ROW < 2.94) {
            if (SUM_COL < 1.5) {
                if (Q3CENT_AVGDIFF < 0.01) {
                    if (MIN_MACRO_VALUE < 23.5) {
                        if (VARIANCE < 0) {
                            if (AVG_MACRO_VALUE < 20) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 20) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 0) {
                            if (MAX_MACRO_VALUE < 21.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 21.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 23.5) {
                        if (VARIANCE < 0) {
                            if (MIN_MACRO_VALUE < 26.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 26.5) {
                                oneCount++;
                            }
                        }
                        else if (VARIANCE >= 0) {
                            zeroCount++;
                        }
                    }
                }
                else if (Q3CENT_AVGDIFF >= 0.01) {
                    zeroCount++;
                }
            }
            else if (SUM_COL >= 1.5) {
                if (Q3CENT_AVGDIFF < 25.1) {
                    if (VARIANCE < 176.53) {
                        if (Q2CENT_AVGDIFF < 20.38) {
                            if (Q1CENT_AVGDIFF < 19.21) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 19.21) {
                                zeroCount++;
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 20.38) {
                            if (Q1CENT_AVGDIFF < 16.04) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 16.04) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 176.53) {
                        if (RANGE_MACRO_VALUE < 47.5) {
                            if (VARIANCE < 230.06) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 230.06) {
                                oneCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 47.5) {
                            if (SUM_COL < 1983) {
                                oneCount++;
                            }
                            else if (SUM_COL >= 1983) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Q3CENT_AVGDIFF >= 25.1) {
                    if (Q4CENT_AVGDIFF < 5.68) {
                        if (Q3CENT_AVGDIFF < 67.18) {
                            if (AVG_ROW < 2.91) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 2.91) {
                                oneCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 67.18) {
                            zeroCount++;
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 5.68) {
                        if (Q3CENT_AVGDIFF < 45.81) {
                            if (MAX_MACRO_VALUE < 154) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 154) {
                                zeroCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 45.81) {
                            if (AVG_COL < 5.95) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 5.95) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (AVG_ROW >= 2.94) {
            if (MIN_MACRO_VALUE < 58.5) {
                if (SUM_ROW_COL < 5711.5) {
                    if (Q2CENT_AVGDIFF < 49.4) {
                        if (Q1CENT_AVGDIFF < 56.5) {
                            if (SUM_ROW < 1445.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW >= 1445.5) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 56.5) {
                            if (AVG_COL < 1.73) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 1.73) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 49.4) {
                        if (Q1CENT_AVGDIFF < 20.04) {
                            if (AVG_MACRO_VALUE < 33.63) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 33.63) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 20.04) {
                            if (AVG_COL < 4.95) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 4.95) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (SUM_ROW_COL >= 5711.5) {
                    if (MAX_MACRO_VALUE < 114.5) {
                        if (AVG_MACRO_VALUE < 43.88) {
                            oneCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 43.88) {
                            if (MIN_MACRO_VALUE < 21.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 21.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 114.5) {
                        if (VARIANCE < 1380.64) {
                            if (AVG_MACRO_VALUE < 94.94) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 94.94) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 1380.64) {
                            if (MAX_MACRO_VALUE < 142.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 142.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 58.5) {
                if (MAX_MACRO_VALUE < 86.5) {
                    zeroCount++;
                }
                else if (MAX_MACRO_VALUE >= 86.5) {
                    if (SUM_ROW < 6825.5) {
                        if (SUM_ROW_COL < 1395.5) {
                            if (SUM_ROW_COL < 1361.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW_COL >= 1361.5) {
                                oneCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 1395.5) {
                            if (MAX_MACRO_VALUE < 118.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 118.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW >= 6825.5) {
                        if (SUM_COL < 3872) {
                            if (VARIANCE < 3684.05) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 3684.05) {
                                oneCount++;
                            }
                        }
                        else if (SUM_COL >= 3872) {
                            if (Q1CENT_AVGDIFF < 42.11) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 42.11) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 2
    if (SUM_ROW < 705.5) {
            if (VARIANCE < 174.79) {
                if (AVG_ROW < 0.01) {
                    if (MAX_MACRO_VALUE < 24) {
                        if (RANGE_MACRO_VALUE < 0.5) {
                            if (MAX_MACRO_VALUE < 20.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 20.5) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 0.5) {
                            if (MIN_MACRO_VALUE < 20) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 20) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 24) {
                        if (MIN_MACRO_VALUE < 27.5) {
                            zeroCount++;
                        }
                        else if (MIN_MACRO_VALUE >= 27.5) {
                            if (MIN_MACRO_VALUE < 31) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 31) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (AVG_ROW >= 0.01) {
                    if (Q1CENT_AVGDIFF < 19.93) {
                        if (SUM_COL < 4.5) {
                            zeroCount++;
                        }
                        else if (SUM_COL >= 4.5) {
                            if (SUM_ROW_COL < 1297.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 1297.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 19.93) {
                        if (MIN_MACRO_VALUE < 34.5) {
                            if (SUM_ROW < 685) {
                                zeroCount++;
                            }
                            else if (SUM_ROW >= 685) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 34.5) {
                            if (SUM_ROW_COL < 1042) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 1042) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (VARIANCE >= 174.79) {
                if (RANGE_MACRO_VALUE < 50.5) {
                    if (VARIANCE < 248.72) {
                        if (AVG_MACRO_VALUE < 32.79) {
                            if (AVG_COL < 7.03) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 7.03) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 32.79) {
                            if (MIN_MACRO_VALUE < 28.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 28.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 248.72) {
                        if (RANGE_MACRO_VALUE < 42.5) {
                            if (MAX_MACRO_VALUE < 59.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 59.5) {
                                oneCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 42.5) {
                            if (Q1CENT_AVGDIFF < 32.65) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 32.65) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 50.5) {
                    if (SUM_ROW < 122.5) {
                        if (SUM_COL < 3839.5) {
                            zeroCount++;
                        }
                        else if (SUM_COL >= 3839.5) {
                            oneCount++;
                        }
                    }
                    else if (SUM_ROW >= 122.5) {
                        if (Q1CENT_AVGDIFF < 2.06) {
                            if (RANGE_MACRO_VALUE < 119.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 119.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 2.06) {
                            if (Q3CENT_AVGDIFF < 1.4) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 1.4) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (SUM_ROW >= 705.5) {
            if (SUM_COL < 2040.5) {
                if (VARIANCE < 16.09) {
                    if (Q2CENT_AVGDIFF < 0.85) {
                        if (RANGE_MACRO_VALUE < 20.5) {
                            if (VARIANCE < 12.17) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 12.17) {
                                oneCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 20.5) {
                            zeroCount++;
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 0.85) {
                        zeroCount++;
                    }
                }
                else if (VARIANCE >= 16.09) {
                    if (Q3CENT_AVGDIFF < 28.1) {
                        if (MIN_MACRO_VALUE < 57.5) {
                            if (Q2CENT_AVGDIFF < 33.04) {
                                oneCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 33.04) {
                                zeroCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 57.5) {
                            if (AVG_ROW < 19.85) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 19.85) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 28.1) {
                        if (AVG_COL < 1.06) {
                            if (Q4CENT_AVGDIFF < 56.83) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 56.83) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_COL >= 1.06) {
                            if (AVG_COL < 1.09) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 1.09) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (SUM_COL >= 2040.5) {
                if (RANGE_MACRO_VALUE < 99.5) {
                    if (MAX_MACRO_VALUE < 134.5) {
                        if (Q4CENT_AVGDIFF < 8.69) {
                            if (RANGE_MACRO_VALUE < 92.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 92.5) {
                                oneCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 8.69) {
                            if (MAX_MACRO_VALUE < 101.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 101.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 134.5) {
                        if (Q4CENT_AVGDIFF < 9.53) {
                            if (VARIANCE < 246.54) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 246.54) {
                                zeroCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 9.53) {
                            if (VARIANCE < 509.16) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 509.16) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 99.5) {
                    if (AVG_MACRO_VALUE < 33.8) {
                        if (MAX_MACRO_VALUE < 160.5) {
                            if (SUM_ROW < 3787.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW >= 3787.5) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 160.5) {
                            if (MAX_MACRO_VALUE < 182) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 182) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 33.8) {
                        if (AVG_MACRO_VALUE < 67.45) {
                            if (Q2CENT_AVGDIFF < 70.53) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 70.53) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 67.45) {
                            if (MIN_MACRO_VALUE < 17.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 17.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 3
    if (SUM_ROW_COL < 1064.5) {
            if (SUM_ROW < 11.5) {
                if (MAX_MACRO_VALUE < 28.5) {
                    if (Q2CENT_AVGDIFF < 0.13) {
                        if (Q3CENT_AVGDIFF < 0.68) {
                            if (SUM_ROW < 1.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW >= 1.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 0.68) {
                            if (Q3CENT_AVGDIFF < 0.9) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 0.9) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 0.13) {
                        if (AVG_MACRO_VALUE < 22.57) {
                            if (Q4CENT_AVGDIFF < 0.68) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 0.68) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 22.57) {
                            zeroCount++;
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 28.5) {
                    zeroCount++;
                }
            }
            else if (SUM_ROW >= 11.5) {
                if (AVG_COL < 0.44) {
                    if (Q4CENT_AVGDIFF < 0.78) {
                        if (MAX_MACRO_VALUE < 37.5) {
                            if (SUM_ROW < 64.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW >= 64.5) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 37.5) {
                            if (SUM_ROW_COL < 1024.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW_COL >= 1024.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 0.78) {
                        if (SUM_ROW_COL < 161.5) {
                            if (MAX_MACRO_VALUE < 44.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 44.5) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 161.5) {
                            if (AVG_MACRO_VALUE < 68.57) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 68.57) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (AVG_COL >= 0.44) {
                    if (VARIANCE < 62.64) {
                        if (VARIANCE < 61.59) {
                            if (AVG_COL < 2.45) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 2.45) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 61.59) {
                            zeroCount++;
                        }
                    }
                    else if (VARIANCE >= 62.64) {
                        if (AVG_MACRO_VALUE < 157.35) {
                            if (AVG_MACRO_VALUE < 138.89) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 138.89) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 157.35) {
                            if (SUM_ROW < 182.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW >= 182.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (SUM_ROW_COL >= 1064.5) {
            if (MIN_MACRO_VALUE < 58.5) {
                if (SUM_ROW_COL < 6432) {
                    if (VARIANCE < 105.34) {
                        if (SUM_COL < 1097.5) {
                            if (Q3CENT_AVGDIFF < 0.08) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 0.08) {
                                oneCount++;
                            }
                        }
                        else if (SUM_COL >= 1097.5) {
                            if (Q1CENT_AVGDIFF < 0.12) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 0.12) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 105.34) {
                        if (MAX_MACRO_VALUE < 58.5) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 58.5) {
                            if (RANGE_MACRO_VALUE < 98.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 98.5) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (SUM_ROW_COL >= 6432) {
                    if (VARIANCE < 548.3) {
                        if (MAX_MACRO_VALUE < 196) {
                            if (AVG_COL < 13.87) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 13.87) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 196) {
                            oneCount++;
                        }
                    }
                    else if (VARIANCE >= 548.3) {
                        if (AVG_MACRO_VALUE < 76.37) {
                            if (MIN_MACRO_VALUE < 17.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 17.5) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 76.37) {
                            if (Q3CENT_AVGDIFF < 2.76) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 2.76) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 58.5) {
                if (SUM_ROW_COL < 1151.5) {
                    if (VARIANCE < 135.6) {
                        if (AVG_MACRO_VALUE < 77.11) {
                            if (MIN_MACRO_VALUE < 61.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 61.5) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 77.11) {
                            if (VARIANCE < 12.66) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 12.66) {
                                oneCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 135.6) {
                        if (Q1CENT_AVGDIFF < 1.83) {
                            if (Q3CENT_AVGDIFF < 8.18) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 8.18) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 1.83) {
                            zeroCount++;
                        }
                    }
                }
                else if (SUM_ROW_COL >= 1151.5) {
                    if (SUM_ROW_COL < 11165) {
                        if (AVG_ROW < 19.98) {
                            if (SUM_ROW_COL < 1210.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 1210.5) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_ROW >= 19.98) {
                            if (AVG_MACRO_VALUE < 120.66) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 120.66) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 11165) {
                        if (SUM_ROW < 7947) {
                            if (MIN_MACRO_VALUE < 73.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 73.5) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW >= 7947) {
                            zeroCount++;
                        }
                    }
                }
            }
        }

    //TREE 4
    if (SUM_ROW < 705.5) {
            if (Q4CENT_AVGDIFF < 0.01) {
                if (Q3CENT_AVGDIFF < 34.88) {
                    if (AVG_MACRO_VALUE < 19.29) {
                        if (RANGE_MACRO_VALUE < 2.5) {
                            if (SUM_COL < 8.5) {
                                oneCount++;
                            }
                            else if (SUM_COL >= 8.5) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 2.5) {
                            if (VARIANCE < 0.38) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 0.38) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 19.29) {
                        if (MIN_MACRO_VALUE < 60.5) {
                            if (MAX_MACRO_VALUE < 118.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 118.5) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 60.5) {
                            if (VARIANCE < 0.15) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 0.15) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Q3CENT_AVGDIFF >= 34.88) {
                    zeroCount++;
                }
            }
            else if (Q4CENT_AVGDIFF >= 0.01) {
                if (SUM_ROW_COL < 1064.5) {
                    if (SUM_ROW_COL < 1061.5) {
                        if (AVG_MACRO_VALUE < 16.94) {
                            if (Q3CENT_AVGDIFF < 0.18) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 0.18) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 16.94) {
                            if (Q1CENT_AVGDIFF < 17.63) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 17.63) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 1061.5) {
                        zeroCount++;
                    }
                }
                else if (SUM_ROW_COL >= 1064.5) {
                    if (SUM_COL < 2196) {
                        if (Q2CENT_AVGDIFF < 26.26) {
                            if (SUM_ROW < 646.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW >= 646.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 26.26) {
                            if (Q3CENT_AVGDIFF < 17.53) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 17.53) {
                                oneCount++;
                            }
                        }
                    }
                    else if (SUM_COL >= 2196) {
                        if (AVG_ROW < 0.26) {
                            if (Q3CENT_AVGDIFF < 5.57) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 5.57) {
                                oneCount++;
                            }
                        }
                        else if (AVG_ROW >= 0.26) {
                            if (AVG_COL < 13.26) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 13.26) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (SUM_ROW >= 705.5) {
            if (MIN_MACRO_VALUE < 55.5) {
                if (RANGE_MACRO_VALUE < 99.5) {
                    if (SUM_ROW_COL < 2290.5) {
                        if (VARIANCE < 323.81) {
                            if (VARIANCE < 253.61) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 253.61) {
                                oneCount++;
                            }
                        }
                        else if (VARIANCE >= 323.81) {
                            if (RANGE_MACRO_VALUE < 43.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 43.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 2290.5) {
                        if (SUM_COL < 2157.5) {
                            if (AVG_MACRO_VALUE < 68.68) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 68.68) {
                                oneCount++;
                            }
                        }
                        else if (SUM_COL >= 2157.5) {
                            if (AVG_MACRO_VALUE < 34.6) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 34.6) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 99.5) {
                    if (AVG_COL < 11.73) {
                        if (VARIANCE < 1091.78) {
                            if (Q2CENT_AVGDIFF < 38.04) {
                                oneCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 38.04) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 1091.78) {
                            if (MAX_MACRO_VALUE < 119) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 119) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (AVG_COL >= 11.73) {
                        if (AVG_COL < 11.78) {
                            if (Q1CENT_AVGDIFF < 49.81) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 49.81) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_COL >= 11.78) {
                            if (VARIANCE < 909.25) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 909.25) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 55.5) {
                if (MAX_MACRO_VALUE < 83.5) {
                    zeroCount++;
                }
                else if (MAX_MACRO_VALUE >= 83.5) {
                    if (SUM_ROW < 1460.5) {
                        if (SUM_ROW_COL < 2350.5) {
                            if (Q4CENT_AVGDIFF < 3.79) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 3.79) {
                                oneCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 2350.5) {
                            if (SUM_ROW_COL < 2559.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 2559.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW >= 1460.5) {
                        if (Q1CENT_AVGDIFF < 0.17) {
                            zeroCount++;
                        }
                        else if (Q1CENT_AVGDIFF >= 0.17) {
                            if (VARIANCE < 764.91) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 764.91) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 5
    if (VARIANCE < 60.42) {
            if (AVG_COL < 4.57) {
                if (SUM_ROW < 1217.5) {
                    if (Q4CENT_AVGDIFF < 0.01) {
                        if (AVG_MACRO_VALUE < 62.71) {
                            if (Q3CENT_AVGDIFF < 1.68) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 1.68) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 62.71) {
                            if (SUM_COL < 49) {
                                zeroCount++;
                            }
                            else if (SUM_COL >= 49) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 0.01) {
                        if (SUM_COL < 904.5) {
                            if (SUM_COL < 898.5) {
                                zeroCount++;
                            }
                            else if (SUM_COL >= 898.5) {
                                oneCount++;
                            }
                        }
                        else if (SUM_COL >= 904.5) {
                            if (AVG_COL < 4.03) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 4.03) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (SUM_ROW >= 1217.5) {
                    if (SUM_COL < 933.5) {
                        if (Q4CENT_AVGDIFF < 9.28) {
                            if (VARIANCE < 37.29) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 37.29) {
                                oneCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 9.28) {
                            zeroCount++;
                        }
                    }
                    else if (SUM_COL >= 933.5) {
                        zeroCount++;
                    }
                }
            }
            else if (AVG_COL >= 4.57) {
                zeroCount++;
            }
        }
        else if (VARIANCE >= 60.42) {
            if (MAX_MACRO_VALUE < 141.5) {
                if (SUM_COL < 2157.5) {
                    if (VARIANCE < 60.53) {
                        if (AVG_ROW < 4.04) {
                            if (SUM_COL < 905.5) {
                                oneCount++;
                            }
                            else if (SUM_COL >= 905.5) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_ROW >= 4.04) {
                            zeroCount++;
                        }
                    }
                    else if (VARIANCE >= 60.53) {
                        if (AVG_COL < 8.52) {
                            if (VARIANCE < 150.94) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 150.94) {
                                oneCount++;
                            }
                        }
                        else if (AVG_COL >= 8.52) {
                            if (RANGE_MACRO_VALUE < 112.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 112.5) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (SUM_COL >= 2157.5) {
                    if (SUM_ROW < 706) {
                        if (RANGE_MACRO_VALUE < 58.5) {
                            if (AVG_MACRO_VALUE < 35.99) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 35.99) {
                                oneCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 58.5) {
                            if (AVG_ROW < 1.56) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 1.56) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW >= 706) {
                        if (MAX_MACRO_VALUE < 115.5) {
                            if (MAX_MACRO_VALUE < 95.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 95.5) {
                                oneCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 115.5) {
                            if (Q3CENT_AVGDIFF < 30.6) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 30.6) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 141.5) {
                if (MIN_MACRO_VALUE < 40.5) {
                    if (Q2CENT_AVGDIFF < 9.53) {
                        if (SUM_ROW_COL < 5726) {
                            if (MAX_MACRO_VALUE < 234.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 234.5) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 5726) {
                            if (AVG_MACRO_VALUE < 92.13) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 92.13) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 9.53) {
                        if (AVG_COL < 0.51) {
                            if (AVG_COL < 0.41) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 0.41) {
                                oneCount++;
                            }
                        }
                        else if (AVG_COL >= 0.51) {
                            if (MIN_MACRO_VALUE < 17.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 17.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 40.5) {
                    if (SUM_COL < 5356.5) {
                        if (Q4CENT_AVGDIFF < 1.49) {
                            if (RANGE_MACRO_VALUE < 168.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 168.5) {
                                oneCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 1.49) {
                            if (VARIANCE < 5266.55) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 5266.55) {
                                oneCount++;
                            }
                        }
                    }
                    else if (SUM_COL >= 5356.5) {
                        if (Q1CENT_AVGDIFF < 109.07) {
                            if (MAX_MACRO_VALUE < 190.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 190.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 109.07) {
                            if (RANGE_MACRO_VALUE < 158.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 158.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 6
    if (SUM_ROW < 705.5) {
            if (SUM_ROW < 12.5) {
                if (MAX_MACRO_VALUE < 28.5) {
                    if (AVG_MACRO_VALUE < 22.93) {
                        if (MAX_MACRO_VALUE < 22.5) {
                            if (MIN_MACRO_VALUE < 21.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 21.5) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 22.5) {
                            if (VARIANCE < 0.01) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 0.01) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 22.93) {
                        if (MIN_MACRO_VALUE < 26) {
                            zeroCount++;
                        }
                        else if (MIN_MACRO_VALUE >= 26) {
                            if (Q1CENT_AVGDIFF < 0.04) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 0.04) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 28.5) {
                    zeroCount++;
                }
            }
            else if (SUM_ROW >= 12.5) {
                if (VARIANCE < 192.47) {
                    if (Q1CENT_AVGDIFF < 17.63) {
                        if (MAX_MACRO_VALUE < 94.5) {
                            if (Q2CENT_AVGDIFF < 0.17) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 0.17) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 94.5) {
                            if (AVG_MACRO_VALUE < 157.94) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 157.94) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 17.63) {
                        if (RANGE_MACRO_VALUE < 67.5) {
                            if (SUM_COL < 790.5) {
                                zeroCount++;
                            }
                            else if (SUM_COL >= 790.5) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 67.5) {
                            if (VARIANCE < 162.85) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 162.85) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (VARIANCE >= 192.47) {
                    if (MAX_MACRO_VALUE < 60.5) {
                        if (VARIANCE < 302.78) {
                            if (Q1CENT_AVGDIFF < 8.19) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 8.19) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 302.78) {
                            if (MAX_MACRO_VALUE < 59.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 59.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 60.5) {
                        if (AVG_COL < 9.15) {
                            if (AVG_MACRO_VALUE < 192.66) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 192.66) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_COL >= 9.15) {
                            if (Q2CENT_AVGDIFF < 97.19) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 97.19) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (SUM_ROW >= 705.5) {
            if (MIN_MACRO_VALUE < 55.5) {
                if (SUM_ROW_COL < 6432) {
                    if (Q4CENT_AVGDIFF < 41.81) {
                        if (Q3CENT_AVGDIFF < 46.71) {
                            if (Q2CENT_AVGDIFF < 48.01) {
                                oneCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 48.01) {
                                zeroCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 46.71) {
                            if (AVG_COL < 3) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 3) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 41.81) {
                        if (Q3CENT_AVGDIFF < 67.9) {
                            if (AVG_MACRO_VALUE < 120.38) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 120.38) {
                                oneCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 67.9) {
                            if (Q1CENT_AVGDIFF < 76.19) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 76.19) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (SUM_ROW_COL >= 6432) {
                    if (Q1CENT_AVGDIFF < 47.31) {
                        if (AVG_MACRO_VALUE < 44.67) {
                            if (SUM_COL < 3661.5) {
                                oneCount++;
                            }
                            else if (SUM_COL >= 3661.5) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 44.67) {
                            if (MAX_MACRO_VALUE < 140.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 140.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 47.31) {
                        if (Q3CENT_AVGDIFF < 87.06) {
                            if (Q4CENT_AVGDIFF < 2.79) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 2.79) {
                                oneCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 87.06) {
                            if (MAX_MACRO_VALUE < 180.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 180.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 55.5) {
                if (AVG_MACRO_VALUE < 87.14) {
                    if (SUM_COL < 535.5) {
                        if (VARIANCE < 39.18) {
                            zeroCount++;
                        }
                        else if (VARIANCE >= 39.18) {
                            if (Q4CENT_AVGDIFF < 10.96) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 10.96) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_COL >= 535.5) {
                        if (Q2CENT_AVGDIFF < 1.06) {
                            if (AVG_MACRO_VALUE < 84.01) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 84.01) {
                                oneCount++;
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 1.06) {
                            if (SUM_COL < 3007) {
                                oneCount++;
                            }
                            else if (SUM_COL >= 3007) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 87.14) {
                    if (AVG_COL < 1.72) {
                        if (AVG_ROW < 6.24) {
                            if (MIN_MACRO_VALUE < 73.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 73.5) {
                                oneCount++;
                            }
                        }
                        else if (AVG_ROW >= 6.24) {
                            if (Q4CENT_AVGDIFF < 65.38) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 65.38) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_COL >= 1.72) {
                        if (VARIANCE < 60.4) {
                            if (AVG_ROW < 3.52) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 3.52) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 60.4) {
                            if (Q4CENT_AVGDIFF < 0.14) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 0.14) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 7
    if (SUM_ROW_COL < 1064.5) {
            if (Q2CENT_AVGDIFF < 0.19) {
                if (AVG_ROW < 2.4) {
                    if (VARIANCE < 0.02) {
                        if (SUM_ROW_COL < 21.5) {
                            if (Q4CENT_AVGDIFF < 0.07) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 0.07) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 21.5) {
                            if (SUM_ROW < 11.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW >= 11.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 0.02) {
                        if (VARIANCE < 0.03) {
                            zeroCount++;
                        }
                        else if (VARIANCE >= 0.03) {
                            if (VARIANCE < 0.21) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 0.21) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (AVG_ROW >= 2.4) {
                    if (SUM_ROW_COL < 710) {
                        if (SUM_ROW_COL < 634.5) {
                            oneCount++;
                        }
                        else if (SUM_ROW_COL >= 634.5) {
                            if (Q4CENT_AVGDIFF < 8.42) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 8.42) {
                                oneCount++;
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 710) {
                        if (RANGE_MACRO_VALUE < 70.5) {
                            if (RANGE_MACRO_VALUE < 43) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 43) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 70.5) {
                            if (MAX_MACRO_VALUE < 101.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 101.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (Q2CENT_AVGDIFF >= 0.19) {
                if (MIN_MACRO_VALUE < 125.5) {
                    if (Q3CENT_AVGDIFF < 6.03) {
                        if (Q4CENT_AVGDIFF < 1.83) {
                            if (VARIANCE < 560.3) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 560.3) {
                                oneCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 1.83) {
                            if (SUM_ROW_COL < 354.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 354.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 6.03) {
                        if (SUM_ROW < 603) {
                            if (Q3CENT_AVGDIFF < 18.88) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 18.88) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW >= 603) {
                            if (VARIANCE < 208.46) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 208.46) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 125.5) {
                    if (MAX_MACRO_VALUE < 159.5) {
                        if (SUM_ROW < 157.5) {
                            if (AVG_MACRO_VALUE < 129) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 129) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW >= 157.5) {
                            if (Q1CENT_AVGDIFF < 1.32) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 1.32) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 159.5) {
                        if (Q2CENT_AVGDIFF < 12.81) {
                            if (MAX_MACRO_VALUE < 175.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 175.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 12.81) {
                            zeroCount++;
                        }
                    }
                }
            }
        }
        else if (SUM_ROW_COL >= 1064.5) {
            if (AVG_MACRO_VALUE < 94.74) {
                if (MAX_MACRO_VALUE < 57.5) {
                    if (Q3CENT_AVGDIFF < 4.01) {
                        if (SUM_ROW < 480.5) {
                            if (Q2CENT_AVGDIFF < 9.1) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 9.1) {
                                oneCount++;
                            }
                        }
                        else if (SUM_ROW >= 480.5) {
                            if (Q2CENT_AVGDIFF < 3) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 3) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 4.01) {
                        if (SUM_COL < 505.5) {
                            if (VARIANCE < 103.12) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 103.12) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_COL >= 505.5) {
                            if (MAX_MACRO_VALUE < 55.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 55.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 57.5) {
                    if (AVG_MACRO_VALUE < 94.43) {
                        if (AVG_MACRO_VALUE < 64.68) {
                            if (Q3CENT_AVGDIFF < 113.53) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 113.53) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 64.68) {
                            if (AVG_COL < 31.84) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 31.84) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 94.43) {
                        if (SUM_ROW_COL < 3118) {
                            if (Q2CENT_AVGDIFF < 2.86) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 2.86) {
                                oneCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 3118) {
                            if (SUM_COL < 1867.5) {
                                zeroCount++;
                            }
                            else if (SUM_COL >= 1867.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (AVG_MACRO_VALUE >= 94.74) {
                if (VARIANCE < 6222.56) {
                    if (VARIANCE < 29.56) {
                        zeroCount++;
                    }
                    else if (VARIANCE >= 29.56) {
                        if (MAX_MACRO_VALUE < 180.5) {
                            if (AVG_COL < 0.67) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 0.67) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 180.5) {
                            if (MIN_MACRO_VALUE < 17.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 17.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (VARIANCE >= 6222.56) {
                    if (Q3CENT_AVGDIFF < 182.89) {
                        if (RANGE_MACRO_VALUE < 199.5) {
                            if (Q1CENT_AVGDIFF < 47.58) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 47.58) {
                                oneCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 199.5) {
                            if (SUM_ROW_COL < 10883.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 10883.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 182.89) {
                        zeroCount++;
                    }
                }
            }
        }

    //TREE 8
    if (SUM_ROW < 705.5) {
            if (SUM_ROW < 15.5) {
                if (MAX_MACRO_VALUE < 28.5) {
                    if (Q3CENT_AVGDIFF < 0.9) {
                        if (Q3CENT_AVGDIFF < 0.68) {
                            if (AVG_MACRO_VALUE < 22.97) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 22.97) {
                                zeroCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 0.68) {
                            if (Q4CENT_AVGDIFF < 0.08) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 0.08) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 0.9) {
                        zeroCount++;
                    }
                }
                else if (MAX_MACRO_VALUE >= 28.5) {
                    if (SUM_COL < 584.5) {
                        zeroCount++;
                    }
                    else if (SUM_COL >= 584.5) {
                        if (SUM_ROW < 12.5) {
                            zeroCount++;
                        }
                        else if (SUM_ROW >= 12.5) {
                            oneCount++;
                        }
                    }
                }
            }
            else if (SUM_ROW >= 15.5) {
                if (SUM_ROW < 70.5) {
                    if (Q4CENT_AVGDIFF < 0.22) {
                        if (MIN_MACRO_VALUE < 27.5) {
                            if (Q4CENT_AVGDIFF < 0.06) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 0.06) {
                                zeroCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 27.5) {
                            if (VARIANCE < 0.24) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 0.24) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 0.22) {
                        if (Q1CENT_AVGDIFF < 0.6) {
                            if (Q3CENT_AVGDIFF < 0.4) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 0.4) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 0.6) {
                            if (Q1CENT_AVGDIFF < 23.54) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 23.54) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (SUM_ROW >= 70.5) {
                    if (VARIANCE < 73.23) {
                        if (Q4CENT_AVGDIFF < 11.57) {
                            if (SUM_ROW_COL < 1297.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 1297.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 11.57) {
                            if (Q2CENT_AVGDIFF < 6.26) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 6.26) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 73.23) {
                        if (RANGE_MACRO_VALUE < 42.5) {
                            if (VARIANCE < 269.92) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 269.92) {
                                oneCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 42.5) {
                            if (Q1CENT_AVGDIFF < 1.99) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 1.99) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (SUM_ROW >= 705.5) {
            if (SUM_COL < 3934.5) {
                if (AVG_MACRO_VALUE < 80.29) {
                    if (Q2CENT_AVGDIFF < 41.15) {
                        if (Q1CENT_AVGDIFF < 44.26) {
                            if (Q3CENT_AVGDIFF < 35.01) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 35.01) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 44.26) {
                            if (RANGE_MACRO_VALUE < 82.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 82.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 41.15) {
                        if (SUM_ROW_COL < 2577.5) {
                            if (Q4CENT_AVGDIFF < 0.15) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 0.15) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 2577.5) {
                            if (Q4CENT_AVGDIFF < 0.43) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 0.43) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 80.29) {
                    if (VARIANCE < 332.7) {
                        if (MAX_MACRO_VALUE < 98.5) {
                            if (Q1CENT_AVGDIFF < 15.96) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 15.96) {
                                oneCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 98.5) {
                            if (AVG_COL < 5.09) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 5.09) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 332.7) {
                        if (AVG_COL < 8.39) {
                            if (Q3CENT_AVGDIFF < 74.76) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 74.76) {
                                oneCount++;
                            }
                        }
                        else if (AVG_COL >= 8.39) {
                            if (Q4CENT_AVGDIFF < 76.06) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 76.06) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (SUM_COL >= 3934.5) {
                if (VARIANCE < 1807.88) {
                    if (MAX_MACRO_VALUE < 116.5) {
                        if (Q1CENT_AVGDIFF < 35.36) {
                            if (AVG_MACRO_VALUE < 52.96) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 52.96) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 35.36) {
                            if (AVG_COL < 17.63) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 17.63) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 116.5) {
                        if (MIN_MACRO_VALUE < 15.5) {
                            if (SUM_COL < 4532.5) {
                                zeroCount++;
                            }
                            else if (SUM_COL >= 4532.5) {
                                zeroCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 15.5) {
                            if (MAX_MACRO_VALUE < 184.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 184.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (VARIANCE >= 1807.88) {
                    if (AVG_MACRO_VALUE < 96.5) {
                        if (MAX_MACRO_VALUE < 144.5) {
                            if (Q1CENT_AVGDIFF < 70.31) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 70.31) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 144.5) {
                            if (VARIANCE < 2833.54) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 2833.54) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 96.5) {
                        if (SUM_ROW < 4717) {
                            if (MAX_MACRO_VALUE < 187.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 187.5) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW >= 4717) {
                            if (AVG_MACRO_VALUE < 136.96) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 136.96) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 9
    if (SUM_ROW < 705.5) {
            if (AVG_ROW < 0.01) {
                if (MIN_MACRO_VALUE < 23.5) {
                    if (MAX_MACRO_VALUE < 22.5) {
                        if (AVG_MACRO_VALUE < 21.99) {
                            if (VARIANCE < 0.01) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 0.01) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 21.99) {
                            zeroCount++;
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 22.5) {
                        if (RANGE_MACRO_VALUE < 8) {
                            if (SUM_COL < 8.5) {
                                oneCount++;
                            }
                            else if (SUM_COL >= 8.5) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 8) {
                            zeroCount++;
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 23.5) {
                    if (MIN_MACRO_VALUE < 27.5) {
                        zeroCount++;
                    }
                    else if (MIN_MACRO_VALUE >= 27.5) {
                        if (MIN_MACRO_VALUE < 28.5) {
                            oneCount++;
                        }
                        else if (MIN_MACRO_VALUE >= 28.5) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (AVG_ROW >= 0.01) {
                if (SUM_COL < 4.5) {
                    zeroCount++;
                }
                else if (SUM_COL >= 4.5) {
                    if (AVG_ROW < 0.26) {
                        if (MIN_MACRO_VALUE < 128) {
                            if (Q3CENT_AVGDIFF < 0.69) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 0.69) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 128) {
                            if (Q1CENT_AVGDIFF < 1.97) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 1.97) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_ROW >= 0.26) {
                        if (AVG_COL < 9.15) {
                            if (Q2CENT_AVGDIFF < 27.29) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 27.29) {
                                oneCount++;
                            }
                        }
                        else if (AVG_COL >= 9.15) {
                            if (VARIANCE < 935.32) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 935.32) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (SUM_ROW >= 705.5) {
            if (AVG_MACRO_VALUE < 80.42) {
                if (RANGE_MACRO_VALUE < 99.5) {
                    if (AVG_COL < 13.59) {
                        if (VARIANCE < 1194.9) {
                            if (Q2CENT_AVGDIFF < 38.9) {
                                oneCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 38.9) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 1194.9) {
                            if (SUM_COL < 1241.5) {
                                oneCount++;
                            }
                            else if (SUM_COL >= 1241.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_COL >= 13.59) {
                        if (MIN_MACRO_VALUE < 38.5) {
                            if (AVG_ROW < 5.07) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 5.07) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 38.5) {
                            zeroCount++;
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 99.5) {
                    if (Q1CENT_AVGDIFF < 6.94) {
                        if (AVG_COL < 12.35) {
                            if (AVG_MACRO_VALUE < 25.51) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 25.51) {
                                oneCount++;
                            }
                        }
                        else if (AVG_COL >= 12.35) {
                            if (VARIANCE < 1053.76) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 1053.76) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 6.94) {
                        if (MAX_MACRO_VALUE < 119.5) {
                            if (VARIANCE < 1312.32) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 1312.32) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 119.5) {
                            if (Q2CENT_AVGDIFF < 5.24) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 5.24) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (AVG_MACRO_VALUE >= 80.42) {
                if (MIN_MACRO_VALUE < 17.5) {
                    if (SUM_COL < 1036.5) {
                        if (AVG_ROW < 17.19) {
                            if (Q1CENT_AVGDIFF < 24.43) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 24.43) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_ROW >= 17.19) {
                            if (Q3CENT_AVGDIFF < 47.43) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 47.43) {
                                oneCount++;
                            }
                        }
                    }
                    else if (SUM_COL >= 1036.5) {
                        if (RANGE_MACRO_VALUE < 160.5) {
                            if (MIN_MACRO_VALUE < 15.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 15.5) {
                                oneCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 160.5) {
                            if (AVG_MACRO_VALUE < 145.93) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 145.93) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 17.5) {
                    if (SUM_ROW_COL < 6227.5) {
                        if (AVG_ROW < 14.07) {
                            if (SUM_ROW < 3187.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW >= 3187.5) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_ROW >= 14.07) {
                            if (SUM_ROW < 5154.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW >= 5154.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 6227.5) {
                        if (Q4CENT_AVGDIFF < 19.06) {
                            if (RANGE_MACRO_VALUE < 113.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 113.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 19.06) {
                            if (RANGE_MACRO_VALUE < 140.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 140.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 10
    if (SUM_ROW < 705.5) {
            if (VARIANCE < 0.02) {
                if (MIN_MACRO_VALUE < 23) {
                    if (RANGE_MACRO_VALUE < 1.5) {
                        if (Q1CENT_AVGDIFF < 0.07) {
                            if (SUM_COL < 4.5) {
                                oneCount++;
                            }
                            else if (SUM_COL >= 4.5) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 0.07) {
                            zeroCount++;
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 1.5) {
                        zeroCount++;
                    }
                }
                else if (MIN_MACRO_VALUE >= 23) {
                    if (AVG_MACRO_VALUE < 28) {
                        zeroCount++;
                    }
                    else if (AVG_MACRO_VALUE >= 28) {
                        if (RANGE_MACRO_VALUE < 0.5) {
                            if (MAX_MACRO_VALUE < 34) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 34) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 0.5) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (VARIANCE >= 0.02) {
                if (VARIANCE < 174.8) {
                    if (Q2CENT_AVGDIFF < 20.18) {
                        if (Q1CENT_AVGDIFF < 19.9) {
                            if (Q4CENT_AVGDIFF < 19.01) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 19.01) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 19.9) {
                            if (Q2CENT_AVGDIFF < 16.89) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 16.89) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 20.18) {
                        if (Q3CENT_AVGDIFF < 17.19) {
                            if (MAX_MACRO_VALUE < 59.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 59.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 17.19) {
                            if (Q1CENT_AVGDIFF < 15.72) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 15.72) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (VARIANCE >= 174.8) {
                    if (SUM_COL < 2034) {
                        if (SUM_COL < 407.5) {
                            if (AVG_COL < 0.99) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 0.99) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_COL >= 407.5) {
                            if (MIN_MACRO_VALUE < 28.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 28.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (SUM_COL >= 2034) {
                        if (SUM_ROW_COL < 2534) {
                            zeroCount++;
                        }
                        else if (SUM_ROW_COL >= 2534) {
                            if (SUM_ROW_COL < 2572) {
                                oneCount++;
                            }
                            else if (SUM_ROW_COL >= 2572) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (SUM_ROW >= 705.5) {
            if (MIN_MACRO_VALUE < 55.5) {
                if (SUM_COL < 4436.5) {
                    if (Q2CENT_AVGDIFF < 49.63) {
                        if (Q1CENT_AVGDIFF < 44.29) {
                            if (Q3CENT_AVGDIFF < 34.32) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 34.32) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 44.29) {
                            if (Q2CENT_AVGDIFF < 22.15) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 22.15) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 49.63) {
                        if (Q4CENT_AVGDIFF < 0.47) {
                            if (MAX_MACRO_VALUE < 124) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 124) {
                                oneCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 0.47) {
                            if (Q1CENT_AVGDIFF < 36.18) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 36.18) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (SUM_COL >= 4436.5) {
                    if (MAX_MACRO_VALUE < 235.5) {
                        if (VARIANCE < 2041.13) {
                            if (MAX_MACRO_VALUE < 161.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 161.5) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 2041.13) {
                            if (RANGE_MACRO_VALUE < 177.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 177.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 235.5) {
                        if (RANGE_MACRO_VALUE < 220) {
                            if (AVG_COL < 35.27) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 35.27) {
                                oneCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 220) {
                            oneCount++;
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 55.5) {
                if (SUM_ROW < 1459.5) {
                    if (VARIANCE < 20.85) {
                        if (Q2CENT_AVGDIFF < 4.82) {
                            zeroCount++;
                        }
                        else if (Q2CENT_AVGDIFF >= 4.82) {
                            if (VARIANCE < 16.94) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 16.94) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 20.85) {
                        if (Q4CENT_AVGDIFF < 52.11) {
                            if (SUM_COL < 224) {
                                zeroCount++;
                            }
                            else if (SUM_COL >= 224) {
                                oneCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 52.11) {
                            if (AVG_ROW < 5.23) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 5.23) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (SUM_ROW >= 1459.5) {
                    if (VARIANCE < 906.67) {
                        if (Q2CENT_AVGDIFF < 8.63) {
                            if (MIN_MACRO_VALUE < 130.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 130.5) {
                                oneCount++;
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 8.63) {
                            if (SUM_COL < 4054.5) {
                                zeroCount++;
                            }
                            else if (SUM_COL >= 4054.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 906.67) {
                        if (AVG_MACRO_VALUE < 120.09) {
                            if (SUM_ROW < 4311) {
                                oneCount++;
                            }
                            else if (SUM_ROW >= 4311) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 120.09) {
                            if (VARIANCE < 1927.25) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 1927.25) {
                                zeroCount++;
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

__kernel void dtc_10T_V1_5(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
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
    
    //TREE 1
    if (RANGE_MACRO_VALUE < 35.5) {
            if (Q12SUM_DIFF < 548.5) {
                if (X < 1272) {
                    if (X < 1208) {
                        if (Y < 104) {
                            if (X < 184) {
                                oneCount++;
                            }
                            else if (X >= 184) {
                                oneCount++;
                            }
                        }
                        else if (Y >= 104) {
                            if (Q2SUM < 2913.5) {
                                zeroCount++;
                            }
                            else if (Q2SUM >= 2913.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (X >= 1208) {
                        if (Q2AVG < 18.25) {
                            if (Q2AVG < 17.46) {
                                zeroCount++;
                            }
                            else if (Q2AVG >= 17.46) {
                                oneCount++;
                            }
                        }
                        else if (Q2AVG >= 18.25) {
                            if (Q12SUM_DIFF < 50.5) {
                                zeroCount++;
                            }
                            else if (Q12SUM_DIFF >= 50.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (X >= 1272) {
                    if (Y < 56) {
                        zeroCount++;
                    }
                    else if (Y >= 56) {
                        if (Q4CENT_AVGDIFF < 14.51) {
                            if (Q2SUM < 5939.5) {
                                oneCount++;
                            }
                            else if (Q2SUM >= 5939.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 14.51) {
                            if (Y < 272) {
                                zeroCount++;
                            }
                            else if (Y >= 272) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Q12SUM_DIFF >= 548.5) {
                zeroCount++;
            }
        }
        else if (RANGE_MACRO_VALUE >= 35.5) {
            if (Y < 56) {
                if (Q1CENT_AVGDIFF < 12.64) {
                    if (VARIANCE < 279.81) {
                        if (Q12SUM_DIFF < 82) {
                            if (X < 144) {
                                oneCount++;
                            }
                            else if (X >= 144) {
                                zeroCount++;
                            }
                        }
                        else if (Q12SUM_DIFF >= 82) {
                            if (Q24SUM_DIFF < 245) {
                                zeroCount++;
                            }
                            else if (Q24SUM_DIFF >= 245) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 279.81) {
                        if (VARIANCE < 1064.63) {
                            if (Q4AVG < 174.69) {
                                oneCount++;
                            }
                            else if (Q4AVG >= 174.69) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 1064.63) {
                            if (Q34SUM_DIFF < 142) {
                                zeroCount++;
                            }
                            else if (Q34SUM_DIFF >= 142) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Q1CENT_AVGDIFF >= 12.64) {
                    if (AVG_COL < 9.8) {
                        if (Q12SUM_DIFF < 591.5) {
                            if (VARIANCE < 187.51) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 187.51) {
                                zeroCount++;
                            }
                        }
                        else if (Q12SUM_DIFF >= 591.5) {
                            if (X < 1208) {
                                zeroCount++;
                            }
                            else if (X >= 1208) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (AVG_COL >= 9.8) {
                        if (Q4AVG < 49.31) {
                            if (Q24SUM_DIFF < 1907.5) {
                                oneCount++;
                            }
                            else if (Q24SUM_DIFF >= 1907.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q4AVG >= 49.31) {
                            if (Q34SUM_DIFF < 3012) {
                                zeroCount++;
                            }
                            else if (Q34SUM_DIFF >= 3012) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (Y >= 56) {
                if (Y < 312) {
                    if (X < 264) {
                        if (SUM_ROW_COL < 3414.5) {
                            if (AVG_ROW < 2.91) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 2.91) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 3414.5) {
                            if (AVG_MACRO_VALUE < 101.5) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 101.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (X >= 264) {
                        if (RANGE_MACRO_VALUE < 77.5) {
                            if (Q3AVG < 148.61) {
                                oneCount++;
                            }
                            else if (Q3AVG >= 148.61) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 77.5) {
                            if (QCENTERAVG < 92.39) {
                                oneCount++;
                            }
                            else if (QCENTERAVG >= 92.39) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Y >= 312) {
                    if (RANGE_MACRO_VALUE < 52.5) {
                        if (X < 216) {
                            if (AVG_ROW < 3.17) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 3.17) {
                                oneCount++;
                            }
                        }
                        else if (X >= 216) {
                            if (Q24SUM_DIFF < 406.5) {
                                oneCount++;
                            }
                            else if (Q24SUM_DIFF >= 406.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 52.5) {
                        if (SUM_ROW < 132) {
                            if (AVG_COL < 0.36) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 0.36) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW >= 132) {
                            if (Q12SUM_DIFF < 2888) {
                                oneCount++;
                            }
                            else if (Q12SUM_DIFF >= 2888) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 2
    if (VARIANCE < 54.44) {
            if (SUM_COL < 911.5) {
                if (Q2CENT_AVGDIFF < 7.31) {
                    if (Q14SUM_DIFF < 534.5) {
                        if (X < 472) {
                            if (AVG_ROW < 0.46) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 0.46) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 472) {
                            if (Y < 568) {
                                oneCount++;
                            }
                            else if (Y >= 568) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q14SUM_DIFF >= 534.5) {
                        zeroCount++;
                    }
                }
                else if (Q2CENT_AVGDIFF >= 7.31) {
                    if (SUM_COL < 498.5) {
                        if (Q23SUM_DIFF < 291.5) {
                            if (Q23SUM_DIFF < 242.5) {
                                oneCount++;
                            }
                            else if (Q23SUM_DIFF >= 242.5) {
                                oneCount++;
                            }
                        }
                        else if (Q23SUM_DIFF >= 291.5) {
                            if (Q34SUM_DIFF < 33.5) {
                                oneCount++;
                            }
                            else if (Q34SUM_DIFF >= 33.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_COL >= 498.5) {
                        if (Q14SUM_DIFF < 209.5) {
                            if (MAX_MACRO_VALUE < 86.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 86.5) {
                                oneCount++;
                            }
                        }
                        else if (Q14SUM_DIFF >= 209.5) {
                            if (Q1AVG < 50.14) {
                                zeroCount++;
                            }
                            else if (Q1AVG >= 50.14) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (SUM_COL >= 911.5) {
                if (VARIANCE < 34.46) {
                    if (Q4AVG < 60.92) {
                        zeroCount++;
                    }
                    else if (Q4AVG >= 60.92) {
                        if (Q4CENT_AVGDIFF < 3.46) {
                            zeroCount++;
                        }
                        else if (Q4CENT_AVGDIFF >= 3.46) {
                            if (Q23SUM_DIFF < 103) {
                                oneCount++;
                            }
                            else if (Q23SUM_DIFF >= 103) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (VARIANCE >= 34.46) {
                    zeroCount++;
                }
            }
        }
        else if (VARIANCE >= 54.44) {
            if (QCENTERAVG < 39.72) {
                if (VARIANCE < 509.4) {
                    if (AVG_COL < 0.17) {
                        if (Q4AVG < 28.46) {
                            if (X < 568) {
                                oneCount++;
                            }
                            else if (X >= 568) {
                                zeroCount++;
                            }
                        }
                        else if (Q4AVG >= 28.46) {
                            if (Q13SUM_DIFF < 328.5) {
                                oneCount++;
                            }
                            else if (Q13SUM_DIFF >= 328.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (AVG_COL >= 0.17) {
                        if (Q24SUM_DIFF < 438.5) {
                            if (X < 1176) {
                                oneCount++;
                            }
                            else if (X >= 1176) {
                                zeroCount++;
                            }
                        }
                        else if (Q24SUM_DIFF >= 438.5) {
                            if (X < 936) {
                                zeroCount++;
                            }
                            else if (X >= 936) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (VARIANCE >= 509.4) {
                    if (MIN_MACRO_VALUE < 23.5) {
                        if (Q4AVG < 71.85) {
                            if (Q3CENT_AVGDIFF < 40.58) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 40.58) {
                                zeroCount++;
                            }
                        }
                        else if (Q4AVG >= 71.85) {
                            if (AVG_COL < 21.74) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 21.74) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 23.5) {
                        if (QCENTERAVG < 32.28) {
                            if (AVG_COL < 2.86) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 2.86) {
                                oneCount++;
                            }
                        }
                        else if (QCENTERAVG >= 32.28) {
                            if (AVG_COL < 4.45) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 4.45) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (QCENTERAVG >= 39.72) {
                if (Y < 56) {
                    if (SUM_ROW < 2001.5) {
                        if (Q12SUM_DIFF < 364) {
                            if (Q3CENT_AVGDIFF < 7.71) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 7.71) {
                                oneCount++;
                            }
                        }
                        else if (Q12SUM_DIFF >= 364) {
                            if (SUM_ROW_COL < 3662.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 3662.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW >= 2001.5) {
                        if (AVG_ROW < 30.56) {
                            if (VARIANCE < 1064.63) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 1064.63) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_ROW >= 30.56) {
                            if (Q1AVG < 57.21) {
                                oneCount++;
                            }
                            else if (Q1AVG >= 57.21) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Y >= 56) {
                    if (X < 24) {
                        if (Q34SUM_DIFF < 264.5) {
                            if (Q12SUM_DIFF < 1082) {
                                zeroCount++;
                            }
                            else if (Q12SUM_DIFF >= 1082) {
                                zeroCount++;
                            }
                        }
                        else if (Q34SUM_DIFF >= 264.5) {
                            if (SUM_ROW_COL < 3020) {
                                oneCount++;
                            }
                            else if (SUM_ROW_COL >= 3020) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (X >= 24) {
                        if (Y < 456) {
                            if (X < 568) {
                                oneCount++;
                            }
                            else if (X >= 568) {
                                oneCount++;
                            }
                        }
                        else if (Y >= 456) {
                            if (Y < 520) {
                                zeroCount++;
                            }
                            else if (Y >= 520) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 3
    if (RANGE_MACRO_VALUE < 35.5) {
            if (Q4CENT_AVGDIFF < 3.22) {
                if (AVG_ROW < 3.2) {
                    if (X < 456) {
                        if (SUM_ROW_COL < 201.5) {
                            if (Q2CENT_AVGDIFF < 0.03) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 0.03) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 201.5) {
                            if (Y < 88) {
                                oneCount++;
                            }
                            else if (Y >= 88) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (X >= 456) {
                        if (SUM_COL < 513.5) {
                            if (SUM_ROW_COL < 1067) {
                                oneCount++;
                            }
                            else if (SUM_ROW_COL >= 1067) {
                                oneCount++;
                            }
                        }
                        else if (SUM_COL >= 513.5) {
                            if (Q14SUM_DIFF < 116) {
                                zeroCount++;
                            }
                            else if (Q14SUM_DIFF >= 116) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (AVG_ROW >= 3.2) {
                    if (Q34SUM_DIFF < 93) {
                        if (X < 568) {
                            if (Q24SUM_DIFF < 630.5) {
                                oneCount++;
                            }
                            else if (Q24SUM_DIFF >= 630.5) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 568) {
                            if (AVG_COL < 2.59) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 2.59) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q34SUM_DIFF >= 93) {
                        if (Q14SUM_DIFF < 367) {
                            zeroCount++;
                        }
                        else if (Q14SUM_DIFF >= 367) {
                            if (Q4SUM < 2001.5) {
                                oneCount++;
                            }
                            else if (Q4SUM >= 2001.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (Q4CENT_AVGDIFF >= 3.22) {
                if (Q12SUM_DIFF < 550) {
                    if (Q1CENT_AVGDIFF < 13.9) {
                        if (Q1CENT_AVGDIFF < 7.85) {
                            if (X < 1672) {
                                oneCount++;
                            }
                            else if (X >= 1672) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 7.85) {
                            if (MAX_MACRO_VALUE < 59.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 59.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 13.9) {
                        if (Q1CENT_AVGDIFF < 16.96) {
                            if (Q2AVG < 65.74) {
                                oneCount++;
                            }
                            else if (Q2AVG >= 65.74) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 16.96) {
                            if (Q23SUM_DIFF < 489) {
                                zeroCount++;
                            }
                            else if (Q23SUM_DIFF >= 489) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Q12SUM_DIFF >= 550) {
                    zeroCount++;
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 35.5) {
            if (Y < 56) {
                if (AVG_ROW < 8.79) {
                    if (Q12SUM_DIFF < 641.5) {
                        if (Q1CENT_AVGDIFF < 18.99) {
                            if (VARIANCE < 381.6) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 381.6) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 18.99) {
                            if (RANGE_MACRO_VALUE < 156.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 156.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q12SUM_DIFF >= 641.5) {
                        if (X < 96) {
                            if (X < 40) {
                                zeroCount++;
                            }
                            else if (X >= 40) {
                                oneCount++;
                            }
                        }
                        else if (X >= 96) {
                            if (Q4CENT_AVGDIFF < 0.15) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 0.15) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (AVG_ROW >= 8.79) {
                    if (MIN_MACRO_VALUE < 33.5) {
                        if (AVG_ROW < 15.16) {
                            if (Q2SUM < 3423.5) {
                                zeroCount++;
                            }
                            else if (Q2SUM >= 3423.5) {
                                oneCount++;
                            }
                        }
                        else if (AVG_ROW >= 15.16) {
                            if (QCENTERAVG < 78.39) {
                                zeroCount++;
                            }
                            else if (QCENTERAVG >= 78.39) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 33.5) {
                        if (Q13SUM_DIFF < 984) {
                            if (AVG_COL < 19.46) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 19.46) {
                                zeroCount++;
                            }
                        }
                        else if (Q13SUM_DIFF >= 984) {
                            if (SUM_COL < 2382.5) {
                                zeroCount++;
                            }
                            else if (SUM_COL >= 2382.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Y >= 56) {
                if (Y < 328) {
                    if (X < 264) {
                        if (AVG_COL < 3.67) {
                            if (Q2CENT_AVGDIFF < 33.76) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 33.76) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_COL >= 3.67) {
                            if (Y < 280) {
                                zeroCount++;
                            }
                            else if (Y >= 280) {
                                oneCount++;
                            }
                        }
                    }
                    else if (X >= 264) {
                        if (MAX_MACRO_VALUE < 129.5) {
                            if (AVG_MACRO_VALUE < 75.61) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 75.61) {
                                oneCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 129.5) {
                            if (QCENTERAVG < 98.83) {
                                oneCount++;
                            }
                            else if (QCENTERAVG >= 98.83) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Y >= 328) {
                    if (MAX_MACRO_VALUE < 60.5) {
                        if (Q1SUM < 618) {
                            zeroCount++;
                        }
                        else if (Q1SUM >= 618) {
                            if (Y < 344) {
                                oneCount++;
                            }
                            else if (Y >= 344) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 60.5) {
                        if (X < 1880) {
                            if (VARIANCE < 102.97) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 102.97) {
                                oneCount++;
                            }
                        }
                        else if (X >= 1880) {
                            if (QCENTERAVG < 81.11) {
                                zeroCount++;
                            }
                            else if (QCENTERAVG >= 81.11) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 4
    if (RANGE_MACRO_VALUE < 35.5) {
            if (Q12SUM_DIFF < 548.5) {
                if (Q4CENT_AVGDIFF < 3.21) {
                    if (AVG_ROW < 3.2) {
                        if (X < 472) {
                            if (SUM_ROW_COL < 208.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 208.5) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 472) {
                            if (Q2CENT_AVGDIFF < 2.6) {
                                oneCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 2.6) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (AVG_ROW >= 3.2) {
                        if (Q14SUM_DIFF < 96.5) {
                            if (AVG_ROW < 3.27) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 3.27) {
                                zeroCount++;
                            }
                        }
                        else if (Q14SUM_DIFF >= 96.5) {
                            if (Q3AVG < 19.63) {
                                oneCount++;
                            }
                            else if (Q3AVG >= 19.63) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Q4CENT_AVGDIFF >= 3.21) {
                    if (VARIANCE < 85.71) {
                        if (AVG_ROW < 0.74) {
                            if (SUM_ROW_COL < 237) {
                                oneCount++;
                            }
                            else if (SUM_ROW_COL >= 237) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_ROW >= 0.74) {
                            if (Q34SUM_DIFF < 283.5) {
                                oneCount++;
                            }
                            else if (Q34SUM_DIFF >= 283.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 85.71) {
                        if (Q2SUM < 2413) {
                            if (AVG_MACRO_VALUE < 37.91) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 37.91) {
                                oneCount++;
                            }
                        }
                        else if (Q2SUM >= 2413) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (Q12SUM_DIFF >= 548.5) {
                zeroCount++;
            }
        }
        else if (RANGE_MACRO_VALUE >= 35.5) {
            if (X < 1896) {
                if (Y < 56) {
                    if (AVG_ROW < 8.79) {
                        if (Q2CENT_AVGDIFF < 32.28) {
                            if (AVG_ROW < 3.04) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 3.04) {
                                zeroCount++;
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 32.28) {
                            if (AVG_COL < 19.96) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 19.96) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (AVG_ROW >= 8.79) {
                        if (AVG_ROW < 12.7) {
                            if (Q13SUM_DIFF < 1125) {
                                oneCount++;
                            }
                            else if (Q13SUM_DIFF >= 1125) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_ROW >= 12.7) {
                            if (Y < 8) {
                                zeroCount++;
                            }
                            else if (Y >= 8) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Y >= 56) {
                    if (Y < 328) {
                        if (MAX_MACRO_VALUE < 145.5) {
                            if (X < 264) {
                                zeroCount++;
                            }
                            else if (X >= 264) {
                                oneCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 145.5) {
                            if (SUM_COL < 304.5) {
                                zeroCount++;
                            }
                            else if (SUM_COL >= 304.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Y >= 328) {
                        if (MAX_MACRO_VALUE < 105.5) {
                            if (Q1AVG < 84.97) {
                                oneCount++;
                            }
                            else if (Q1AVG >= 84.97) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 105.5) {
                            if (QCENTERAVG < 31.5) {
                                oneCount++;
                            }
                            else if (QCENTERAVG >= 31.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (X >= 1896) {
                if (Q24SUM_DIFF < 29.5) {
                    if (Q2AVG < 41.14) {
                        oneCount++;
                    }
                    else if (Q2AVG >= 41.14) {
                        zeroCount++;
                    }
                }
                else if (Q24SUM_DIFF >= 29.5) {
                    if (MIN_MACRO_VALUE < 15.5) {
                        if (Q2CENT_AVGDIFF < 16.21) {
                            oneCount++;
                        }
                        else if (Q2CENT_AVGDIFF >= 16.21) {
                            zeroCount++;
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 15.5) {
                        zeroCount++;
                    }
                }
            }
        }

    //TREE 5
    if (RANGE_MACRO_VALUE < 35.5) {
            if (Q12SUM_DIFF < 549) {
                if (Q12SUM_DIFF < 9.5) {
                    if (Q14SUM_DIFF < 10.5) {
                        if (MAX_MACRO_VALUE < 41.5) {
                            if (X < 296) {
                                zeroCount++;
                            }
                            else if (X >= 296) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 41.5) {
                            if (Q23SUM_DIFF < 1.5) {
                                oneCount++;
                            }
                            else if (Q23SUM_DIFF >= 1.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q14SUM_DIFF >= 10.5) {
                        if (QCENTERAVG < 53.28) {
                            if (Q4AVG < 47.69) {
                                zeroCount++;
                            }
                            else if (Q4AVG >= 47.69) {
                                oneCount++;
                            }
                        }
                        else if (QCENTERAVG >= 53.28) {
                            if (Q1CENT_AVGDIFF < 0.64) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 0.64) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Q12SUM_DIFF >= 9.5) {
                    if (VARIANCE < 54.5) {
                        if (AVG_COL < 2.06) {
                            if (Q2CENT_AVGDIFF < 7.38) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 7.38) {
                                oneCount++;
                            }
                        }
                        else if (AVG_COL >= 2.06) {
                            if (Q1AVG < 57.54) {
                                zeroCount++;
                            }
                            else if (Q1AVG >= 57.54) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 54.5) {
                        if (Q3AVG < 88.71) {
                            if (AVG_ROW < 3.62) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 3.62) {
                                zeroCount++;
                            }
                        }
                        else if (Q3AVG >= 88.71) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (Q12SUM_DIFF >= 549) {
                zeroCount++;
            }
        }
        else if (RANGE_MACRO_VALUE >= 35.5) {
            if (Y < 56) {
                if (SUM_ROW < 2001.5) {
                    if (Q2CENT_AVGDIFF < 20.13) {
                        if (QCENTERAVG < 48.17) {
                            if (MAX_MACRO_VALUE < 119.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 119.5) {
                                oneCount++;
                            }
                        }
                        else if (QCENTERAVG >= 48.17) {
                            if (AVG_MACRO_VALUE < 78.21) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 78.21) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 20.13) {
                        if (RANGE_MACRO_VALUE < 160) {
                            if (X < 32) {
                                oneCount++;
                            }
                            else if (X >= 32) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 160) {
                            if (MAX_MACRO_VALUE < 204) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 204) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (SUM_ROW >= 2001.5) {
                    if (VARIANCE < 1057.47) {
                        if (X < 1304) {
                            if (MAX_MACRO_VALUE < 104.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 104.5) {
                                oneCount++;
                            }
                        }
                        else if (X >= 1304) {
                            if (Q2AVG < 46.85) {
                                oneCount++;
                            }
                            else if (Q2AVG >= 46.85) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 1057.47) {
                        if (X < 856) {
                            if (X < 168) {
                                oneCount++;
                            }
                            else if (X >= 168) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 856) {
                            if (AVG_COL < 10.46) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 10.46) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Y >= 56) {
                if (X < 1896) {
                    if (Y < 328) {
                        if (AVG_ROW < 5.19) {
                            if (X < 344) {
                                zeroCount++;
                            }
                            else if (X >= 344) {
                                oneCount++;
                            }
                        }
                        else if (AVG_ROW >= 5.19) {
                            if (AVG_COL < 5.57) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 5.57) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Y >= 328) {
                        if (MAX_MACRO_VALUE < 60.5) {
                            if (Q3CENT_AVGDIFF < 0.4) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 0.4) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 60.5) {
                            if (VARIANCE < 970.94) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 970.94) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (X >= 1896) {
                    if (Y < 384) {
                        if (Q4AVG < 44.53) {
                            oneCount++;
                        }
                        else if (Q4AVG >= 44.53) {
                            if (Y < 360) {
                                zeroCount++;
                            }
                            else if (Y >= 360) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Y >= 384) {
                        zeroCount++;
                    }
                }
            }
        }

    //TREE 6
    if (VARIANCE < 36.81) {
            if (X < 1800) {
                if (Y < 424) {
                    if (X < 1528) {
                        if (Q1AVG < 44.85) {
                            if (Q2AVG < 43.5) {
                                zeroCount++;
                            }
                            else if (Q2AVG >= 43.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q1AVG >= 44.85) {
                            if (Q1AVG < 45.31) {
                                oneCount++;
                            }
                            else if (Q1AVG >= 45.31) {
                                oneCount++;
                            }
                        }
                    }
                    else if (X >= 1528) {
                        if (Y < 72) {
                            if (Y < 56) {
                                zeroCount++;
                            }
                            else if (Y >= 56) {
                                oneCount++;
                            }
                        }
                        else if (Y >= 72) {
                            zeroCount++;
                        }
                    }
                }
                else if (Y >= 424) {
                    if (SUM_ROW_COL < 898.5) {
                        if (Y < 472) {
                            if (QCENTERAVG < 59.06) {
                                zeroCount++;
                            }
                            else if (QCENTERAVG >= 59.06) {
                                oneCount++;
                            }
                        }
                        else if (Y >= 472) {
                            if (X < 8) {
                                zeroCount++;
                            }
                            else if (X >= 8) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 898.5) {
                        if (X < 664) {
                            if (Y < 568) {
                                zeroCount++;
                            }
                            else if (Y >= 568) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 664) {
                            if (AVG_COL < 1.61) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 1.61) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (X >= 1800) {
                if (Q2CENT_AVGDIFF < 0.76) {
                    if (Q3CENT_AVGDIFF < 0.01) {
                        if (Y < 1016) {
                            zeroCount++;
                        }
                        else if (Y >= 1016) {
                            oneCount++;
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 0.01) {
                        zeroCount++;
                    }
                }
                else if (Q2CENT_AVGDIFF >= 0.76) {
                    if (AVG_COL < 2.21) {
                        if (AVG_ROW < 1.93) {
                            if (Q23SUM_DIFF < 210) {
                                oneCount++;
                            }
                            else if (Q23SUM_DIFF >= 210) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_ROW >= 1.93) {
                            if (Y < 552) {
                                zeroCount++;
                            }
                            else if (Y >= 552) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_COL >= 2.21) {
                        zeroCount++;
                    }
                }
            }
        }
        else if (VARIANCE >= 36.81) {
            if (AVG_COL < 0.17) {
                if (Q4AVG < 33.74) {
                    if (X < 1616) {
                        if (X < 1240) {
                            if (AVG_MACRO_VALUE < 34.24) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 34.24) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 1240) {
                            if (AVG_ROW < 5.4) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 5.4) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (X >= 1616) {
                        zeroCount++;
                    }
                }
                else if (Q4AVG >= 33.74) {
                    zeroCount++;
                }
            }
            else if (AVG_COL >= 0.17) {
                if (X < 1896) {
                    if (MIN_MACRO_VALUE < 129.5) {
                        if (Y < 456) {
                            if (Y < 56) {
                                zeroCount++;
                            }
                            else if (Y >= 56) {
                                oneCount++;
                            }
                        }
                        else if (Y >= 456) {
                            if (AVG_ROW < 0.46) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 0.46) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 129.5) {
                        if (X < 1096) {
                            if (MAX_MACRO_VALUE < 217.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 217.5) {
                                oneCount++;
                            }
                        }
                        else if (X >= 1096) {
                            if (Q23SUM_DIFF < 1693.5) {
                                zeroCount++;
                            }
                            else if (Q23SUM_DIFF >= 1693.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (X >= 1896) {
                    if (AVG_MACRO_VALUE < 43.94) {
                        if (Q2AVG < 40.42) {
                            if (Q3AVG < 52.54) {
                                oneCount++;
                            }
                            else if (Q3AVG >= 52.54) {
                                zeroCount++;
                            }
                        }
                        else if (Q2AVG >= 40.42) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 43.94) {
                        if (Q1CENT_AVGDIFF < 0.15) {
                            if (Y < 232) {
                                zeroCount++;
                            }
                            else if (Y >= 232) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 0.15) {
                            if (MIN_MACRO_VALUE < 32) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 32) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 7
    if (RANGE_MACRO_VALUE < 35.5) {
            if (Q12SUM_DIFF < 548.5) {
                if (Q4CENT_AVGDIFF < 3.21) {
                    if (SUM_ROW < 768.5) {
                        if (X < 472) {
                            if (SUM_ROW < 80.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW >= 80.5) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 472) {
                            if (Q2CENT_AVGDIFF < 2.6) {
                                oneCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 2.6) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW >= 768.5) {
                        if (Q14SUM_DIFF < 96.5) {
                            if (Q1CENT_AVGDIFF < 0.15) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 0.15) {
                                zeroCount++;
                            }
                        }
                        else if (Q14SUM_DIFF >= 96.5) {
                            if (VARIANCE < 137.56) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 137.56) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Q4CENT_AVGDIFF >= 3.21) {
                    if (X < 1496) {
                        if (Q1AVG < 82.4) {
                            if (Q4CENT_AVGDIFF < 7.69) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 7.69) {
                                zeroCount++;
                            }
                        }
                        else if (Q1AVG >= 82.4) {
                            if (QCENTERAVG < 105.06) {
                                zeroCount++;
                            }
                            else if (QCENTERAVG >= 105.06) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (X >= 1496) {
                        if (Q3CENT_AVGDIFF < 8.03) {
                            if (VARIANCE < 90.15) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 90.15) {
                                oneCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 8.03) {
                            if (Q4CENT_AVGDIFF < 14.53) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 14.53) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Q12SUM_DIFF >= 548.5) {
                zeroCount++;
            }
        }
        else if (RANGE_MACRO_VALUE >= 35.5) {
            if (Y < 56) {
                if (AVG_ROW < 8.34) {
                    if (Q23SUM_DIFF < 580.5) {
                        if (Q1CENT_AVGDIFF < 19.43) {
                            if (AVG_ROW < 2.95) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 2.95) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 19.43) {
                            if (MAX_MACRO_VALUE < 191.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 191.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q23SUM_DIFF >= 580.5) {
                        if (Q2CENT_AVGDIFF < 11.76) {
                            if (SUM_ROW < 786) {
                                zeroCount++;
                            }
                            else if (SUM_ROW >= 786) {
                                oneCount++;
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 11.76) {
                            if (AVG_COL < 8.84) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 8.84) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (AVG_ROW >= 8.34) {
                    if (VARIANCE < 1056.35) {
                        if (Q34SUM_DIFF < 1003) {
                            if (MAX_MACRO_VALUE < 127.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 127.5) {
                                oneCount++;
                            }
                        }
                        else if (Q34SUM_DIFF >= 1003) {
                            if (Y < 40) {
                                zeroCount++;
                            }
                            else if (Y >= 40) {
                                oneCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 1056.35) {
                        if (MAX_MACRO_VALUE < 233.5) {
                            if (AVG_ROW < 19.12) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 19.12) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 233.5) {
                            if (Q2AVG < 143.03) {
                                oneCount++;
                            }
                            else if (Q2AVG >= 143.03) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (Y >= 56) {
                if (Y < 312) {
                    if (Q34SUM_DIFF < 1576.5) {
                        if (X < 264) {
                            if (AVG_COL < 5.87) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 5.87) {
                                oneCount++;
                            }
                        }
                        else if (X >= 264) {
                            if (X < 824) {
                                oneCount++;
                            }
                            else if (X >= 824) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q34SUM_DIFF >= 1576.5) {
                        if (Q3SUM < 6157) {
                            if (QCENTERAVG < 82.5) {
                                zeroCount++;
                            }
                            else if (QCENTERAVG >= 82.5) {
                                oneCount++;
                            }
                        }
                        else if (Q3SUM >= 6157) {
                            if (RANGE_MACRO_VALUE < 195.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 195.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Y >= 312) {
                    if (VARIANCE < 929.23) {
                        if (AVG_ROW < 9.42) {
                            if (MAX_MACRO_VALUE < 176.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 176.5) {
                                oneCount++;
                            }
                        }
                        else if (AVG_ROW >= 9.42) {
                            if (SUM_ROW_COL < 7613.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 7613.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 929.23) {
                        if (RANGE_MACRO_VALUE < 121.5) {
                            if (Q14SUM_DIFF < 2684) {
                                oneCount++;
                            }
                            else if (Q14SUM_DIFF >= 2684) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 121.5) {
                            if (Q12SUM_DIFF < 2870.5) {
                                oneCount++;
                            }
                            else if (Q12SUM_DIFF >= 2870.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 8
    if (RANGE_MACRO_VALUE < 35.5) {
            if (Y < 424) {
                if (Q34SUM_DIFF < 353.5) {
                    if (Q14SUM_DIFF < 421.5) {
                        if (SUM_ROW < 829.5) {
                            if (Q12SUM_DIFF < 108.5) {
                                zeroCount++;
                            }
                            else if (Q12SUM_DIFF >= 108.5) {
                                oneCount++;
                            }
                        }
                        else if (SUM_ROW >= 829.5) {
                            if (X < 872) {
                                zeroCount++;
                            }
                            else if (X >= 872) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q14SUM_DIFF >= 421.5) {
                        if (AVG_MACRO_VALUE < 60.64) {
                            if (Q2CENT_AVGDIFF < 1.07) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 1.07) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 60.64) {
                            if (Q3AVG < 80.33) {
                                zeroCount++;
                            }
                            else if (Q3AVG >= 80.33) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Q34SUM_DIFF >= 353.5) {
                    if (Q24SUM_DIFF < 730) {
                        if (AVG_COL < 1.78) {
                            if (Q34SUM_DIFF < 442) {
                                zeroCount++;
                            }
                            else if (Q34SUM_DIFF >= 442) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_COL >= 1.78) {
                            zeroCount++;
                        }
                    }
                    else if (Q24SUM_DIFF >= 730) {
                        oneCount++;
                    }
                }
            }
            else if (Y >= 424) {
                if (X < 1800) {
                    if (Y < 472) {
                        if (QCENTERAVG < 59.22) {
                            if (Q3SUM < 668.5) {
                                zeroCount++;
                            }
                            else if (Q3SUM >= 668.5) {
                                zeroCount++;
                            }
                        }
                        else if (QCENTERAVG >= 59.22) {
                            if (Q12SUM_DIFF < 77.5) {
                                oneCount++;
                            }
                            else if (Q12SUM_DIFF >= 77.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Y >= 472) {
                        if (Q1AVG < 32.99) {
                            if (Y < 552) {
                                oneCount++;
                            }
                            else if (Y >= 552) {
                                zeroCount++;
                            }
                        }
                        else if (Q1AVG >= 32.99) {
                            if (X < 632) {
                                zeroCount++;
                            }
                            else if (X >= 632) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (X >= 1800) {
                    if (AVG_COL < 0.99) {
                        if (Y < 1000) {
                            zeroCount++;
                        }
                        else if (Y >= 1000) {
                            if (X < 1816) {
                                oneCount++;
                            }
                            else if (X >= 1816) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (AVG_COL >= 0.99) {
                        if (AVG_COL < 2.19) {
                            if (Q1CENT_AVGDIFF < 5.9) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 5.9) {
                                oneCount++;
                            }
                        }
                        else if (AVG_COL >= 2.19) {
                            zeroCount++;
                        }
                    }
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 35.5) {
            if (Y < 56) {
                if (AVG_ROW < 8.34) {
                    if (Q12SUM_DIFF < 503.5) {
                        if (RANGE_MACRO_VALUE < 150) {
                            if (X < 40) {
                                oneCount++;
                            }
                            else if (X >= 40) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 150) {
                            if (X < 552) {
                                zeroCount++;
                            }
                            else if (X >= 552) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q12SUM_DIFF >= 503.5) {
                        if (Q4AVG < 35.19) {
                            if (Q4CENT_AVGDIFF < 5.03) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 5.03) {
                                zeroCount++;
                            }
                        }
                        else if (Q4AVG >= 35.19) {
                            if (Q3CENT_AVGDIFF < 54.19) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 54.19) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (AVG_ROW >= 8.34) {
                    if (VARIANCE < 1064.63) {
                        if (Q34SUM_DIFF < 1002) {
                            if (RANGE_MACRO_VALUE < 70.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 70.5) {
                                oneCount++;
                            }
                        }
                        else if (Q34SUM_DIFF >= 1002) {
                            if (Q23SUM_DIFF < 147.5) {
                                oneCount++;
                            }
                            else if (Q23SUM_DIFF >= 147.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 1064.63) {
                        if (X < 776) {
                            if (RANGE_MACRO_VALUE < 131.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 131.5) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 776) {
                            if (AVG_COL < 4.53) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 4.53) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Y >= 56) {
                if (Y < 312) {
                    if (X < 264) {
                        if (AVG_COL < 5.87) {
                            if (Q4SUM < 3781) {
                                zeroCount++;
                            }
                            else if (Q4SUM >= 3781) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_COL >= 5.87) {
                            if (X < 24) {
                                zeroCount++;
                            }
                            else if (X >= 24) {
                                oneCount++;
                            }
                        }
                    }
                    else if (X >= 264) {
                        if (RANGE_MACRO_VALUE < 77.5) {
                            if (Q3SUM < 4161.5) {
                                oneCount++;
                            }
                            else if (Q3SUM >= 4161.5) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 77.5) {
                            if (QCENTERAVG < 92.39) {
                                zeroCount++;
                            }
                            else if (QCENTERAVG >= 92.39) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Y >= 312) {
                    if (RANGE_MACRO_VALUE < 52.5) {
                        if (Q24SUM_DIFF < 406.5) {
                            if (Q4AVG < 78.79) {
                                oneCount++;
                            }
                            else if (Q4AVG >= 78.79) {
                                zeroCount++;
                            }
                        }
                        else if (Q24SUM_DIFF >= 406.5) {
                            if (AVG_ROW < 3.11) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 3.11) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 52.5) {
                        if (Q12SUM_DIFF < 2967.5) {
                            if (VARIANCE < 3228.51) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 3228.51) {
                                oneCount++;
                            }
                        }
                        else if (Q12SUM_DIFF >= 2967.5) {
                            if (MIN_MACRO_VALUE < 27.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 27.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 9
    if (RANGE_MACRO_VALUE < 35.5) {
            if (Q12SUM_DIFF < 548.5) {
                if (Q4CENT_AVGDIFF < 3.21) {
                    if (SUM_ROW_COL < 1163.5) {
                        if (SUM_ROW_COL < 1082.5) {
                            if (X < 472) {
                                zeroCount++;
                            }
                            else if (X >= 472) {
                                oneCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 1082.5) {
                            if (Q23SUM_DIFF < 82.5) {
                                zeroCount++;
                            }
                            else if (Q23SUM_DIFF >= 82.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 1163.5) {
                        if (Y < 632) {
                            if (Y < 168) {
                                zeroCount++;
                            }
                            else if (Y >= 168) {
                                zeroCount++;
                            }
                        }
                        else if (Y >= 632) {
                            if (SUM_ROW_COL < 1373) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 1373) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Q4CENT_AVGDIFF >= 3.21) {
                    if (SUM_ROW < 178.5) {
                        if (SUM_ROW_COL < 236) {
                            if (Q12SUM_DIFF < 34.5) {
                                oneCount++;
                            }
                            else if (Q12SUM_DIFF >= 34.5) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 236) {
                            if (MIN_MACRO_VALUE < 18.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 18.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW >= 178.5) {
                        if (Q24SUM_DIFF < 702) {
                            if (X < 1672) {
                                oneCount++;
                            }
                            else if (X >= 1672) {
                                oneCount++;
                            }
                        }
                        else if (Q24SUM_DIFF >= 702) {
                            if (Q3AVG < 56.68) {
                                oneCount++;
                            }
                            else if (Q3AVG >= 56.68) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (Q12SUM_DIFF >= 548.5) {
                zeroCount++;
            }
        }
        else if (RANGE_MACRO_VALUE >= 35.5) {
            if (Q3AVG < 16.74) {
                if (Y < 464) {
                    if (Q14SUM_DIFF < 1) {
                        if (X < 1128) {
                            oneCount++;
                        }
                        else if (X >= 1128) {
                            zeroCount++;
                        }
                    }
                    else if (Q14SUM_DIFF >= 1) {
                        if (AVG_COL < 10.87) {
                            zeroCount++;
                        }
                        else if (AVG_COL >= 10.87) {
                            oneCount++;
                        }
                    }
                }
                else if (Y >= 464) {
                    if (X < 1128) {
                        if (Q1AVG < 16.78) {
                            zeroCount++;
                        }
                        else if (Q1AVG >= 16.78) {
                            oneCount++;
                        }
                    }
                    else if (X >= 1128) {
                        zeroCount++;
                    }
                }
            }
            else if (Q3AVG >= 16.74) {
                if (MIN_MACRO_VALUE < 123.5) {
                    if (Q14SUM_DIFF < 3263) {
                        if (Y < 56) {
                            if (AVG_ROW < 8.34) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 8.34) {
                                oneCount++;
                            }
                        }
                        else if (Y >= 56) {
                            if (Y < 328) {
                                oneCount++;
                            }
                            else if (Y >= 328) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q14SUM_DIFF >= 3263) {
                        if (RANGE_MACRO_VALUE < 125.5) {
                            zeroCount++;
                        }
                        else if (RANGE_MACRO_VALUE >= 125.5) {
                            if (SUM_ROW_COL < 3863.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 3863.5) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 123.5) {
                    if (MAX_MACRO_VALUE < 227.5) {
                        if (Q3AVG < 148.21) {
                            if (Q12SUM_DIFF < 233.5) {
                                oneCount++;
                            }
                            else if (Q12SUM_DIFF >= 233.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q3AVG >= 148.21) {
                            if (Q4AVG < 183.69) {
                                zeroCount++;
                            }
                            else if (Q4AVG >= 183.69) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 227.5) {
                        if (X < 984) {
                            if (QCENTERAVG < 222.22) {
                                oneCount++;
                            }
                            else if (QCENTERAVG >= 222.22) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 984) {
                            zeroCount++;
                        }
                    }
                }
            }
        }

    //TREE 10
    if (SUM_ROW_COL < 1123.5) {
            if (RANGE_MACRO_VALUE < 52.5) {
                if (AVG_MACRO_VALUE < 166.48) {
                    if (AVG_MACRO_VALUE < 165.15) {
                        if (MAX_MACRO_VALUE < 161.5) {
                            if (Q2SUM < 5052) {
                                zeroCount++;
                            }
                            else if (Q2SUM >= 5052) {
                                oneCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 161.5) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 165.15) {
                        if (Y < 216) {
                            if (Q2AVG < 163.71) {
                                zeroCount++;
                            }
                            else if (Q2AVG >= 163.71) {
                                oneCount++;
                            }
                        }
                        else if (Y >= 216) {
                            zeroCount++;
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 166.48) {
                    if (Q2AVG < 182.63) {
                        zeroCount++;
                    }
                    else if (Q2AVG >= 182.63) {
                        if (X < 888) {
                            zeroCount++;
                        }
                        else if (X >= 888) {
                            if (X < 1160) {
                                oneCount++;
                            }
                            else if (X >= 1160) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 52.5) {
                if (Q1AVG < 34.56) {
                    if (Q34SUM_DIFF < 631.5) {
                        if (MAX_MACRO_VALUE < 118.5) {
                            if (X < 928) {
                                zeroCount++;
                            }
                            else if (X >= 928) {
                                oneCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 118.5) {
                            if (Q23SUM_DIFF < 52) {
                                zeroCount++;
                            }
                            else if (Q23SUM_DIFF >= 52) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q34SUM_DIFF >= 631.5) {
                        if (Q13SUM_DIFF < 2) {
                            if (Y < 224) {
                                zeroCount++;
                            }
                            else if (Y >= 224) {
                                oneCount++;
                            }
                        }
                        else if (Q13SUM_DIFF >= 2) {
                            zeroCount++;
                        }
                    }
                }
                else if (Q1AVG >= 34.56) {
                    if (Q24SUM_DIFF < 75) {
                        if (Q1CENT_AVGDIFF < 29.04) {
                            if (VARIANCE < 141.93) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 141.93) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 29.04) {
                            if (Q13SUM_DIFF < 1323.5) {
                                oneCount++;
                            }
                            else if (Q13SUM_DIFF >= 1323.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q24SUM_DIFF >= 75) {
                        if (Q12SUM_DIFF < 854) {
                            if (MIN_MACRO_VALUE < 22.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 22.5) {
                                oneCount++;
                            }
                        }
                        else if (Q12SUM_DIFF >= 854) {
                            if (Q3SUM < 1427.5) {
                                oneCount++;
                            }
                            else if (Q3SUM >= 1427.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (SUM_ROW_COL >= 1123.5) {
            if (X < 24) {
                if (MIN_MACRO_VALUE < 54.5) {
                    if (Q1CENT_AVGDIFF < 3.51) {
                        if (Q24SUM_DIFF < 338.5) {
                            zeroCount++;
                        }
                        else if (Q24SUM_DIFF >= 338.5) {
                            if (Q23SUM_DIFF < 476) {
                                oneCount++;
                            }
                            else if (Q23SUM_DIFF >= 476) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 3.51) {
                        if (RANGE_MACRO_VALUE < 188) {
                            if (Y < 40) {
                                zeroCount++;
                            }
                            else if (Y >= 40) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 188) {
                            if (MIN_MACRO_VALUE < 19) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 19) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 54.5) {
                    if (Q2AVG < 143.56) {
                        if (AVG_COL < 3.51) {
                            zeroCount++;
                        }
                        else if (AVG_COL >= 3.51) {
                            if (Q1CENT_AVGDIFF < 24.88) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 24.88) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q2AVG >= 143.56) {
                        zeroCount++;
                    }
                }
            }
            else if (X >= 24) {
                if (VARIANCE < 161.98) {
                    if (SUM_ROW_COL < 1129.5) {
                        if (Q1CENT_AVGDIFF < 3.63) {
                            if (Q2CENT_AVGDIFF < 7.89) {
                                oneCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 7.89) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 3.63) {
                            if (Q1CENT_AVGDIFF < 20.46) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 20.46) {
                                oneCount++;
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 1129.5) {
                        if (Y < 360) {
                            if (X < 568) {
                                zeroCount++;
                            }
                            else if (X >= 568) {
                                oneCount++;
                            }
                        }
                        else if (Y >= 360) {
                            if (Y < 632) {
                                zeroCount++;
                            }
                            else if (Y >= 632) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (VARIANCE >= 161.98) {
                    if (MIN_MACRO_VALUE < 121.5) {
                        if (RANGE_MACRO_VALUE < 77.5) {
                            if (MIN_MACRO_VALUE < 18.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 18.5) {
                                oneCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 77.5) {
                            if (VARIANCE < 873.38) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 873.38) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 121.5) {
                        if (X < 984) {
                            if (VARIANCE < 477.58) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 477.58) {
                                oneCount++;
                            }
                        }
                        else if (X >= 984) {
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

    if(zeroCount > oneCount)
        binMap[i] = 0;
    else
        binMap[i] = 1;
}

__kernel void dtc_10T_V1(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
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
    
    //TREE 1
    if (Y < 808) {
            if (Y < 104) {
                if (MIN_MACRO_VALUE < 15.5) {
                    if (VARIANCE < 2195.35) {
                        zeroCount++;
                    }
                    else if (VARIANCE >= 2195.35) {
                        if (Q1CENT_AVGDIFF < 31.89) {
                            if (X < 744) {
                                oneCount++;
                            }
                            else if (X >= 744) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 31.89) {
                            if (Y < 40) {
                                zeroCount++;
                            }
                            else if (Y >= 40) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 15.5) {
                    if (Q1CENT_AVGDIFF < 22.32) {
                        if (RANGE_MACRO_VALUE < 10.5) {
                            if (Q1CENT_AVGDIFF < 1.13) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 1.13) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 10.5) {
                            if (X < 1256) {
                                oneCount++;
                            }
                            else if (X >= 1256) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 22.32) {
                        if (Q1AVG < 113.39) {
                            if (SUM_ROW_COL < 2635) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 2635) {
                                oneCount++;
                            }
                        }
                        else if (Q1AVG >= 113.39) {
                            if (AVG_COL < 5.32) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 5.32) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (Y >= 104) {
                if (MIN_MACRO_VALUE < 182.5) {
                    if (X < 1272) {
                        if (X < 1128) {
                            if (RANGE_MACRO_VALUE < 87.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 87.5) {
                                oneCount++;
                            }
                        }
                        else if (X >= 1128) {
                            if (Q1AVG < 47.99) {
                                oneCount++;
                            }
                            else if (Q1AVG >= 47.99) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (X >= 1272) {
                        if (Q1CENT_AVGDIFF < 15.25) {
                            if (Y < 456) {
                                oneCount++;
                            }
                            else if (Y >= 456) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 15.25) {
                            if (X < 1480) {
                                zeroCount++;
                            }
                            else if (X >= 1480) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 182.5) {
                    zeroCount++;
                }
            }
        }
        else if (Y >= 808) {
            if (Q3AVG < 79.21) {
                if (Q34SUM_DIFF < 7.5) {
                    if (RANGE_MACRO_VALUE < 159.5) {
                        if (Y < 920) {
                            if (AVG_ROW < 0.69) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 0.69) {
                                zeroCount++;
                            }
                        }
                        else if (Y >= 920) {
                            if (X < 360) {
                                zeroCount++;
                            }
                            else if (X >= 360) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 159.5) {
                        if (Q2AVG < 46.83) {
                            if (Q1AVG < 58.06) {
                                oneCount++;
                            }
                            else if (Q1AVG >= 58.06) {
                                zeroCount++;
                            }
                        }
                        else if (Q2AVG >= 46.83) {
                            oneCount++;
                        }
                    }
                }
                else if (Q34SUM_DIFF >= 7.5) {
                    if (Q2SUM < 2496.5) {
                        if (MIN_MACRO_VALUE < 16.5) {
                            if (AVG_COL < 4.8) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 4.8) {
                                zeroCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 16.5) {
                            if (X < 632) {
                                oneCount++;
                            }
                            else if (X >= 632) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q2SUM >= 2496.5) {
                        if (RANGE_MACRO_VALUE < 39.5) {
                            if (Q1SUM < 2778) {
                                zeroCount++;
                            }
                            else if (Q1SUM >= 2778) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 39.5) {
                            if (MAX_MACRO_VALUE < 176.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 176.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Q3AVG >= 79.21) {
                if (Q2AVG < 76.08) {
                    if (Q1SUM < 1721) {
                        if (MIN_MACRO_VALUE < 17.5) {
                            if (QCENTERAVG < 76.72) {
                                oneCount++;
                            }
                            else if (QCENTERAVG >= 76.72) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 17.5) {
                            if (Y < 984) {
                                oneCount++;
                            }
                            else if (Y >= 984) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q1SUM >= 1721) {
                        if (MIN_MACRO_VALUE < 51.5) {
                            if (AVG_COL < 10.84) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 10.84) {
                                zeroCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 51.5) {
                            if (Q34SUM_DIFF < 1171) {
                                zeroCount++;
                            }
                            else if (Q34SUM_DIFF >= 1171) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Q2AVG >= 76.08) {
                    if (Q3CENT_AVGDIFF < 2.93) {
                        if (Q1CENT_AVGDIFF < 41.35) {
                            if (MAX_MACRO_VALUE < 151.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 151.5) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 41.35) {
                            if (Q4CENT_AVGDIFF < 2.31) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 2.31) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 2.93) {
                        if (Q13SUM_DIFF < 127.5) {
                            if (Q23SUM_DIFF < 316.5) {
                                zeroCount++;
                            }
                            else if (Q23SUM_DIFF >= 316.5) {
                                oneCount++;
                            }
                        }
                        else if (Q13SUM_DIFF >= 127.5) {
                            if (X < 1224) {
                                zeroCount++;
                            }
                            else if (X >= 1224) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 2
    if (Y < 808) {
            if (Y < 104) {
                if (X < 1256) {
                    if (X < 744) {
                        if (AVG_MACRO_VALUE < 159.66) {
                            if (X < 472) {
                                oneCount++;
                            }
                            else if (X >= 472) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 159.66) {
                            zeroCount++;
                        }
                    }
                    else if (X >= 744) {
                        if (Q3AVG < 34.24) {
                            if (Q1AVG < 18.24) {
                                oneCount++;
                            }
                            else if (Q1AVG >= 18.24) {
                                zeroCount++;
                            }
                        }
                        else if (Q3AVG >= 34.24) {
                            if (MAX_MACRO_VALUE < 111) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 111) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (X >= 1256) {
                    if (X < 1592) {
                        if (Q24SUM_DIFF < 126.5) {
                            zeroCount++;
                        }
                        else if (Q24SUM_DIFF >= 126.5) {
                            if (Q24SUM_DIFF < 139.5) {
                                oneCount++;
                            }
                            else if (Q24SUM_DIFF >= 139.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (X >= 1592) {
                        if (Q2AVG < 48.24) {
                            if (AVG_COL < 0.91) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 0.91) {
                                oneCount++;
                            }
                        }
                        else if (Q2AVG >= 48.24) {
                            if (Q3AVG < 35.38) {
                                oneCount++;
                            }
                            else if (Q3AVG >= 35.38) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (Y >= 104) {
                if (Y < 184) {
                    if (MAX_MACRO_VALUE < 55.5) {
                        if (Q2SUM < 790.5) {
                            if (X < 1304) {
                                zeroCount++;
                            }
                            else if (X >= 1304) {
                                oneCount++;
                            }
                        }
                        else if (Q2SUM >= 790.5) {
                            if (Q1CENT_AVGDIFF < 0.6) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 0.6) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 55.5) {
                        if (X < 216) {
                            if (Q2CENT_AVGDIFF < 34.9) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 34.9) {
                                oneCount++;
                            }
                        }
                        else if (X >= 216) {
                            if (Q1CENT_AVGDIFF < 14.64) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 14.64) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Y >= 184) {
                    if (X < 1272) {
                        if (X < 1128) {
                            if (Q4AVG < 49.21) {
                                oneCount++;
                            }
                            else if (Q4AVG >= 49.21) {
                                oneCount++;
                            }
                        }
                        else if (X >= 1128) {
                            if (QCENTERAVG < 82.72) {
                                zeroCount++;
                            }
                            else if (QCENTERAVG >= 82.72) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (X >= 1272) {
                        if (Y < 456) {
                            if (X < 1560) {
                                oneCount++;
                            }
                            else if (X >= 1560) {
                                zeroCount++;
                            }
                        }
                        else if (Y >= 456) {
                            if (Y < 664) {
                                zeroCount++;
                            }
                            else if (Y >= 664) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (Y >= 808) {
            if (AVG_COL < 8.73) {
                if (Q34SUM_DIFF < 6.5) {
                    if (Q2AVG < 144.86) {
                        if (X < 1272) {
                            if (X < 1160) {
                                zeroCount++;
                            }
                            else if (X >= 1160) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 1272) {
                            if (Q4CENT_AVGDIFF < 0.82) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 0.82) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q2AVG >= 144.86) {
                        if (AVG_MACRO_VALUE < 151.15) {
                            if (Q12SUM_DIFF < 10.5) {
                                zeroCount++;
                            }
                            else if (Q12SUM_DIFF >= 10.5) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 151.15) {
                            zeroCount++;
                        }
                    }
                }
                else if (Q34SUM_DIFF >= 6.5) {
                    if (Q4CENT_AVGDIFF < 41.65) {
                        if (Y < 824) {
                            if (AVG_ROW < 11.14) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 11.14) {
                                oneCount++;
                            }
                        }
                        else if (Y >= 824) {
                            if (Y < 1016) {
                                oneCount++;
                            }
                            else if (Y >= 1016) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 41.65) {
                        if (MAX_MACRO_VALUE < 193.5) {
                            if (QCENTERAVG < 88.94) {
                                zeroCount++;
                            }
                            else if (QCENTERAVG >= 88.94) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 193.5) {
                            if (Q4AVG < 176.85) {
                                oneCount++;
                            }
                            else if (Q4AVG >= 176.85) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (AVG_COL >= 8.73) {
                if (AVG_MACRO_VALUE < 33.82) {
                    oneCount++;
                }
                else if (AVG_MACRO_VALUE >= 33.82) {
                    if (MIN_MACRO_VALUE < 15.5) {
                        if (Q13SUM_DIFF < 1578.5) {
                            if (AVG_ROW < 40.41) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 40.41) {
                                oneCount++;
                            }
                        }
                        else if (Q13SUM_DIFF >= 1578.5) {
                            if (X < 568) {
                                zeroCount++;
                            }
                            else if (X >= 568) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 15.5) {
                        if (AVG_COL < 20.13) {
                            if (AVG_ROW < 2.74) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 2.74) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_COL >= 20.13) {
                            if (X < 40) {
                                zeroCount++;
                            }
                            else if (X >= 40) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 3
    if (Y < 808) {
            if (Q34SUM_DIFF < 120.5) {
                if (RANGE_MACRO_VALUE < 19.5) {
                    if (Q2AVG < 47.35) {
                        if (Q2AVG < 42.85) {
                            if (AVG_COL < 1.6) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 1.6) {
                                zeroCount++;
                            }
                        }
                        else if (Q2AVG >= 42.85) {
                            if (AVG_ROW < 1.82) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 1.82) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q2AVG >= 47.35) {
                        if (Q2AVG < 48.81) {
                            if (Q3AVG < 36.99) {
                                oneCount++;
                            }
                            else if (Q3AVG >= 36.99) {
                                zeroCount++;
                            }
                        }
                        else if (Q2AVG >= 48.81) {
                            if (Y < 72) {
                                oneCount++;
                            }
                            else if (Y >= 72) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 19.5) {
                    if (AVG_COL < 0.08) {
                        if (AVG_MACRO_VALUE < 29.86) {
                            zeroCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 29.86) {
                            if (Q24SUM_DIFF < 348) {
                                oneCount++;
                            }
                            else if (Q24SUM_DIFF >= 348) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (AVG_COL >= 0.08) {
                        if (Q1CENT_AVGDIFF < 2.51) {
                            if (Q1CENT_AVGDIFF < 2.21) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 2.21) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 2.51) {
                            if (X < 280) {
                                zeroCount++;
                            }
                            else if (X >= 280) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Q34SUM_DIFF >= 120.5) {
                if (MAX_MACRO_VALUE < 46.5) {
                    if (Q1SUM < 1019) {
                        if (X < 160) {
                            if (Q1AVG < 24.93) {
                                oneCount++;
                            }
                            else if (Q1AVG >= 24.93) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 160) {
                            if (SUM_ROW_COL < 193) {
                                oneCount++;
                            }
                            else if (SUM_ROW_COL >= 193) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q1SUM >= 1019) {
                        zeroCount++;
                    }
                }
                else if (MAX_MACRO_VALUE >= 46.5) {
                    if (Q12SUM_DIFF < 15.5) {
                        if (X < 1448) {
                            if (Q1AVG < 63.65) {
                                oneCount++;
                            }
                            else if (Q1AVG >= 63.65) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 1448) {
                            if (Q1AVG < 43.33) {
                                zeroCount++;
                            }
                            else if (Q1AVG >= 43.33) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q12SUM_DIFF >= 15.5) {
                        if (MIN_MACRO_VALUE < 16.5) {
                            if (QCENTERAVG < 42.39) {
                                zeroCount++;
                            }
                            else if (QCENTERAVG >= 42.39) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 16.5) {
                            if (Q1SUM < 1676.5) {
                                zeroCount++;
                            }
                            else if (Q1SUM >= 1676.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (Y >= 808) {
            if (X < 8) {
                zeroCount++;
            }
            else if (X >= 8) {
                if (Q23SUM_DIFF < 1469.5) {
                    if (Q34SUM_DIFF < 7.5) {
                        if (Y < 920) {
                            if (AVG_ROW < 0.69) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 0.69) {
                                zeroCount++;
                            }
                        }
                        else if (Y >= 920) {
                            if (Q2AVG < 144.76) {
                                zeroCount++;
                            }
                            else if (Q2AVG >= 144.76) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q34SUM_DIFF >= 7.5) {
                        if (SUM_COL < 2068.5) {
                            if (Q4CENT_AVGDIFF < 41.38) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 41.38) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_COL >= 2068.5) {
                            if (VARIANCE < 1179.11) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 1179.11) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Q23SUM_DIFF >= 1469.5) {
                    if (Q3SUM < 3181.5) {
                        if (SUM_ROW_COL < 4429) {
                            if (Y < 1016) {
                                zeroCount++;
                            }
                            else if (Y >= 1016) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 4429) {
                            if (Q1AVG < 59.96) {
                                zeroCount++;
                            }
                            else if (Q1AVG >= 59.96) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q3SUM >= 3181.5) {
                        if (Q12SUM_DIFF < 187.5) {
                            if (RANGE_MACRO_VALUE < 180.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 180.5) {
                                oneCount++;
                            }
                        }
                        else if (Q12SUM_DIFF >= 187.5) {
                            if (Q2CENT_AVGDIFF < 56.92) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 56.92) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 4
    if (Y < 760) {
            if (AVG_MACRO_VALUE < 212.7) {
                if (Y < 104) {
                    if (MIN_MACRO_VALUE < 15.5) {
                        if (AVG_COL < 13.26) {
                            zeroCount++;
                        }
                        else if (AVG_COL >= 13.26) {
                            if (Y < 72) {
                                zeroCount++;
                            }
                            else if (Y >= 72) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 15.5) {
                        if (X < 1256) {
                            if (X < 744) {
                                oneCount++;
                            }
                            else if (X >= 744) {
                                oneCount++;
                            }
                        }
                        else if (X >= 1256) {
                            if (RANGE_MACRO_VALUE < 127.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 127.5) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Y >= 104) {
                    if (X < 1272) {
                        if (Y < 568) {
                            if (X < 1128) {
                                oneCount++;
                            }
                            else if (X >= 1128) {
                                zeroCount++;
                            }
                        }
                        else if (Y >= 568) {
                            if (Q1AVG < 51.54) {
                                oneCount++;
                            }
                            else if (Q1AVG >= 51.54) {
                                oneCount++;
                            }
                        }
                    }
                    else if (X >= 1272) {
                        if (Q1CENT_AVGDIFF < 14.6) {
                            if (Q4CENT_AVGDIFF < 0.03) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 0.03) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 14.6) {
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
            else if (AVG_MACRO_VALUE >= 212.7) {
                if (Q23SUM_DIFF < 6.5) {
                    if (Q1AVG < 231.32) {
                        if (X < 800) {
                            oneCount++;
                        }
                        else if (X >= 800) {
                            zeroCount++;
                        }
                    }
                    else if (Q1AVG >= 231.32) {
                        oneCount++;
                    }
                }
                else if (Q23SUM_DIFF >= 6.5) {
                    if (Q4CENT_AVGDIFF < 22.74) {
                        zeroCount++;
                    }
                    else if (Q4CENT_AVGDIFF >= 22.74) {
                        if (X < 608) {
                            oneCount++;
                        }
                        else if (X >= 608) {
                            zeroCount++;
                        }
                    }
                }
            }
        }
        else if (Y >= 760) {
            if (AVG_COL < 8.84) {
                if (Q4CENT_AVGDIFF < 38.69) {
                    if (Q2CENT_AVGDIFF < 5.03) {
                        if (Q3AVG < 36.88) {
                            if (X < 104) {
                                oneCount++;
                            }
                            else if (X >= 104) {
                                oneCount++;
                            }
                        }
                        else if (Q3AVG >= 36.88) {
                            if (Q14SUM_DIFF < 539.5) {
                                zeroCount++;
                            }
                            else if (Q14SUM_DIFF >= 539.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 5.03) {
                        if (Q24SUM_DIFF < 157.5) {
                            if (Q3CENT_AVGDIFF < 3.65) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 3.65) {
                                oneCount++;
                            }
                        }
                        else if (Q24SUM_DIFF >= 157.5) {
                            if (Y < 1048) {
                                oneCount++;
                            }
                            else if (Y >= 1048) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Q4CENT_AVGDIFF >= 38.69) {
                    if (Q2AVG < 92.89) {
                        if (Q13SUM_DIFF < 1227) {
                            if (Y < 872) {
                                zeroCount++;
                            }
                            else if (Y >= 872) {
                                zeroCount++;
                            }
                        }
                        else if (Q13SUM_DIFF >= 1227) {
                            if (Q1CENT_AVGDIFF < 0.72) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 0.72) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q2AVG >= 92.89) {
                        if (MIN_MACRO_VALUE < 70) {
                            if (Q2AVG < 101.64) {
                                oneCount++;
                            }
                            else if (Q2AVG >= 101.64) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 70) {
                            if (Q1CENT_AVGDIFF < 85.26) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 85.26) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (AVG_COL >= 8.84) {
                if (VARIANCE < 872.58) {
                    if (AVG_MACRO_VALUE < 34.92) {
                        if (X < 1432) {
                            oneCount++;
                        }
                        else if (X >= 1432) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 34.92) {
                        if (QCENTERAVG < 75.78) {
                            if (Q1AVG < 38.08) {
                                zeroCount++;
                            }
                            else if (Q1AVG >= 38.08) {
                                zeroCount++;
                            }
                        }
                        else if (QCENTERAVG >= 75.78) {
                            if (Y < 1016) {
                                zeroCount++;
                            }
                            else if (Y >= 1016) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (VARIANCE >= 872.58) {
                    if (RANGE_MACRO_VALUE < 114.5) {
                        if (Y < 1000) {
                            if (MIN_MACRO_VALUE < 15.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 15.5) {
                                oneCount++;
                            }
                        }
                        else if (Y >= 1000) {
                            zeroCount++;
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 114.5) {
                        if (AVG_MACRO_VALUE < 142.4) {
                            if (MAX_MACRO_VALUE < 227.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 227.5) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 142.4) {
                            if (MIN_MACRO_VALUE < 25.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 25.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 5
    if (Q34SUM_DIFF < 120.5) {
            if (Y < 1000) {
                if (MAX_MACRO_VALUE < 182.5) {
                    if (Q3AVG < 94.04) {
                        if (RANGE_MACRO_VALUE < 11.5) {
                            if (SUM_ROW_COL < 392) {
                                oneCount++;
                            }
                            else if (SUM_ROW_COL >= 392) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 11.5) {
                            if (Y < 568) {
                                oneCount++;
                            }
                            else if (Y >= 568) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q3AVG >= 94.04) {
                        if (Q24SUM_DIFF < 128.5) {
                            if (Y < 216) {
                                oneCount++;
                            }
                            else if (Y >= 216) {
                                zeroCount++;
                            }
                        }
                        else if (Q24SUM_DIFF >= 128.5) {
                            if (VARIANCE < 25.67) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 25.67) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 182.5) {
                    if (Q3CENT_AVGDIFF < 2.71) {
                        if (Q3AVG < 180.33) {
                            if (X < 248) {
                                zeroCount++;
                            }
                            else if (X >= 248) {
                                oneCount++;
                            }
                        }
                        else if (Q3AVG >= 180.33) {
                            if (MAX_MACRO_VALUE < 203.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 203.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 2.71) {
                        if (RANGE_MACRO_VALUE < 76) {
                            if (Q12SUM_DIFF < 10) {
                                oneCount++;
                            }
                            else if (Q12SUM_DIFF >= 10) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 76) {
                            if (AVG_ROW < 9.22) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 9.22) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Y >= 1000) {
                if (VARIANCE < 7.08) {
                    if (VARIANCE < 0.16) {
                        if (SUM_ROW_COL < 70.5) {
                            zeroCount++;
                        }
                        else if (SUM_ROW_COL >= 70.5) {
                            if (X < 728) {
                                zeroCount++;
                            }
                            else if (X >= 728) {
                                oneCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 0.16) {
                        zeroCount++;
                    }
                }
                else if (VARIANCE >= 7.08) {
                    if (Q24SUM_DIFF < 464) {
                        if (MAX_MACRO_VALUE < 52) {
                            if (Q4CENT_AVGDIFF < 3.72) {
                                oneCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 3.72) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 52) {
                            if (AVG_COL < 1.21) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 1.21) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q24SUM_DIFF >= 464) {
                        if (Q1SUM < 1995.5) {
                            if (AVG_COL < 14.93) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 14.93) {
                                oneCount++;
                            }
                        }
                        else if (Q1SUM >= 1995.5) {
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
        else if (Q34SUM_DIFF >= 120.5) {
            if (MAX_MACRO_VALUE < 46.5) {
                if (Q1SUM < 946) {
                    if (X < 176) {
                        if (Y < 552) {
                            oneCount++;
                        }
                        else if (Y >= 552) {
                            zeroCount++;
                        }
                    }
                    else if (X >= 176) {
                        if (MAX_MACRO_VALUE < 30.5) {
                            if (Q3SUM < 895.5) {
                                zeroCount++;
                            }
                            else if (Q3SUM >= 895.5) {
                                oneCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 30.5) {
                            zeroCount++;
                        }
                    }
                }
                else if (Q1SUM >= 946) {
                    if (Q3SUM < 989.5) {
                        if (AVG_ROW < 0.34) {
                            oneCount++;
                        }
                        else if (AVG_ROW >= 0.34) {
                            zeroCount++;
                        }
                    }
                    else if (Q3SUM >= 989.5) {
                        zeroCount++;
                    }
                }
            }
            else if (MAX_MACRO_VALUE >= 46.5) {
                if (Y < 776) {
                    if (X < 1432) {
                        if (RANGE_MACRO_VALUE < 64.5) {
                            if (AVG_ROW < 5.19) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 5.19) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 64.5) {
                            if (MAX_MACRO_VALUE < 100.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 100.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (X >= 1432) {
                        if (AVG_ROW < 3.38) {
                            if (MIN_MACRO_VALUE < 116) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 116) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_ROW >= 3.38) {
                            if (MAX_MACRO_VALUE < 77.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 77.5) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Y >= 776) {
                    if (AVG_COL < 8.63) {
                        if (AVG_ROW < 4.96) {
                            if (SUM_ROW_COL < 1341.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW_COL >= 1341.5) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_ROW >= 4.96) {
                            if (Q12SUM_DIFF < 169.5) {
                                zeroCount++;
                            }
                            else if (Q12SUM_DIFF >= 169.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_COL >= 8.63) {
                        if (VARIANCE < 1641.65) {
                            if (MAX_MACRO_VALUE < 231.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 231.5) {
                                oneCount++;
                            }
                        }
                        else if (VARIANCE >= 1641.65) {
                            if (RANGE_MACRO_VALUE < 118) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 118) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 6
    if (Y < 808) {
            if (Y < 104) {
                if (MIN_MACRO_VALUE < 15.5) {
                    if (QCENTERAVG < 161.56) {
                        zeroCount++;
                    }
                    else if (QCENTERAVG >= 161.56) {
                        oneCount++;
                    }
                }
                else if (MIN_MACRO_VALUE >= 15.5) {
                    if (Q2AVG < 150.53) {
                        if (MIN_MACRO_VALUE < 139.5) {
                            if (X < 1256) {
                                oneCount++;
                            }
                            else if (X >= 1256) {
                                zeroCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 139.5) {
                            if (Q12SUM_DIFF < 21.5) {
                                zeroCount++;
                            }
                            else if (Q12SUM_DIFF >= 21.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q2AVG >= 150.53) {
                        if (Y < 24) {
                            if (Q1CENT_AVGDIFF < 119.85) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 119.85) {
                                oneCount++;
                            }
                        }
                        else if (Y >= 24) {
                            if (X < 456) {
                                zeroCount++;
                            }
                            else if (X >= 456) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Y >= 104) {
                if (Y < 536) {
                    if (MIN_MACRO_VALUE < 123.5) {
                        if (X < 1272) {
                            if (VARIANCE < 148.74) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 148.74) {
                                oneCount++;
                            }
                        }
                        else if (X >= 1272) {
                            if (X < 1560) {
                                oneCount++;
                            }
                            else if (X >= 1560) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 123.5) {
                        if (Q3AVG < 154.86) {
                            zeroCount++;
                        }
                        else if (Q3AVG >= 154.86) {
                            if (MIN_MACRO_VALUE < 177.5) {
                                zeroCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 177.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Y >= 536) {
                    if (AVG_MACRO_VALUE < 50.84) {
                        if (AVG_MACRO_VALUE < 41.49) {
                            if (X < 456) {
                                zeroCount++;
                            }
                            else if (X >= 456) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 41.49) {
                            if (Q12SUM_DIFF < 653) {
                                oneCount++;
                            }
                            else if (Q12SUM_DIFF >= 653) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 50.84) {
                        if (MAX_MACRO_VALUE < 61.5) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 61.5) {
                            if (Q3AVG < 178.9) {
                                oneCount++;
                            }
                            else if (Q3AVG >= 178.9) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (Y >= 808) {
            if (SUM_ROW < 1929) {
                if (Y < 824) {
                    if (MAX_MACRO_VALUE < 87.5) {
                        zeroCount++;
                    }
                    else if (MAX_MACRO_VALUE >= 87.5) {
                        if (MAX_MACRO_VALUE < 105.5) {
                            if (Q13SUM_DIFF < 222.5) {
                                oneCount++;
                            }
                            else if (Q13SUM_DIFF >= 222.5) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 105.5) {
                            if (Q1AVG < 121.83) {
                                zeroCount++;
                            }
                            else if (Q1AVG >= 121.83) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Y >= 824) {
                    if (AVG_ROW < 5.08) {
                        if (X < 408) {
                            if (Q3AVG < 67.26) {
                                oneCount++;
                            }
                            else if (Q3AVG >= 67.26) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 408) {
                            if (X < 824) {
                                zeroCount++;
                            }
                            else if (X >= 824) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_ROW >= 5.08) {
                        if (Q24SUM_DIFF < 1895.5) {
                            if (Q24SUM_DIFF < 542) {
                                oneCount++;
                            }
                            else if (Q24SUM_DIFF >= 542) {
                                oneCount++;
                            }
                        }
                        else if (Q24SUM_DIFF >= 1895.5) {
                            if (Q3CENT_AVGDIFF < 1.36) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 1.36) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (SUM_ROW >= 1929) {
                if (Q13SUM_DIFF < 126.5) {
                    if (Q13SUM_DIFF < 17.5) {
                        if (Q13SUM_DIFF < 6.5) {
                            if (RANGE_MACRO_VALUE < 190.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 190.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q13SUM_DIFF >= 6.5) {
                            if (QCENTERAVG < 62.22) {
                                zeroCount++;
                            }
                            else if (QCENTERAVG >= 62.22) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q13SUM_DIFF >= 17.5) {
                        if (MIN_MACRO_VALUE < 61.5) {
                            if (AVG_MACRO_VALUE < 109.83) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 109.83) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 61.5) {
                            if (QCENTERAVG < 132) {
                                zeroCount++;
                            }
                            else if (QCENTERAVG >= 132) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Q13SUM_DIFF >= 126.5) {
                    if (AVG_COL < 0.94) {
                        if (SUM_COL < 121.5) {
                            if (X < 992) {
                                oneCount++;
                            }
                            else if (X >= 992) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_COL >= 121.5) {
                            if (Q2AVG < 50.67) {
                                zeroCount++;
                            }
                            else if (Q2AVG >= 50.67) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (AVG_COL >= 0.94) {
                        if (MAX_MACRO_VALUE < 85.5) {
                            if (Q3CENT_AVGDIFF < 15.17) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 15.17) {
                                oneCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 85.5) {
                            if (VARIANCE < 1643.47) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 1643.47) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 7
    if (AVG_ROW < 19.22) {
            if (Y < 808) {
                if (Q34SUM_DIFF < 87.5) {
                    if (MAX_MACRO_VALUE < 182.5) {
                        if (MIN_MACRO_VALUE < 68.5) {
                            if (AVG_MACRO_VALUE < 67.37) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 67.37) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 68.5) {
                            if (AVG_COL < 1.21) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 1.21) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 182.5) {
                        if (Q3AVG < 181.32) {
                            if (SUM_ROW_COL < 3882.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW_COL >= 3882.5) {
                                oneCount++;
                            }
                        }
                        else if (Q3AVG >= 181.32) {
                            if (Q1AVG < 202.01) {
                                zeroCount++;
                            }
                            else if (Q1AVG >= 202.01) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Q34SUM_DIFF >= 87.5) {
                    if (X < 1432) {
                        if (VARIANCE < 170.81) {
                            if (Y < 104) {
                                oneCount++;
                            }
                            else if (Y >= 104) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 170.81) {
                            if (MAX_MACRO_VALUE < 61.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 61.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (X >= 1432) {
                        if (SUM_ROW < 610) {
                            if (Q14SUM_DIFF < 228) {
                                oneCount++;
                            }
                            else if (Q14SUM_DIFF >= 228) {
                                oneCount++;
                            }
                        }
                        else if (SUM_ROW >= 610) {
                            if (MAX_MACRO_VALUE < 71.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 71.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Y >= 808) {
                if (X < 8) {
                    zeroCount++;
                }
                else if (X >= 8) {
                    if (Q1AVG < 17.57) {
                        if (MAX_MACRO_VALUE < 86) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 86) {
                            if (X < 832) {
                                zeroCount++;
                            }
                            else if (X >= 832) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q1AVG >= 17.57) {
                        if (Q3AVG < 80.71) {
                            if (MAX_MACRO_VALUE < 176.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 176.5) {
                                oneCount++;
                            }
                        }
                        else if (Q3AVG >= 80.71) {
                            if (Q13SUM_DIFF < 128.5) {
                                oneCount++;
                            }
                            else if (Q13SUM_DIFF >= 128.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (AVG_ROW >= 19.22) {
            if (VARIANCE < 2067.69) {
                if (Q3SUM < 3873.5) {
                    if (Y < 216) {
                        if (MIN_MACRO_VALUE < 31.5) {
                            if (Y < 40) {
                                zeroCount++;
                            }
                            else if (Y >= 40) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 31.5) {
                            if (Q23SUM_DIFF < 1930) {
                                oneCount++;
                            }
                            else if (Q23SUM_DIFF >= 1930) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Y >= 216) {
                        if (Q14SUM_DIFF < 1811.5) {
                            if (MIN_MACRO_VALUE < 16.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 16.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q14SUM_DIFF >= 1811.5) {
                            if (Q1CENT_AVGDIFF < 65.35) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 65.35) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Q3SUM >= 3873.5) {
                    if (VARIANCE < 848.19) {
                        zeroCount++;
                    }
                    else if (VARIANCE >= 848.19) {
                        if (RANGE_MACRO_VALUE < 175) {
                            if (Q1CENT_AVGDIFF < 4.39) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 4.39) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 175) {
                            if (AVG_MACRO_VALUE < 126.73) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 126.73) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (VARIANCE >= 2067.69) {
                if (MIN_MACRO_VALUE < 68.5) {
                    if (Q3SUM < 2456) {
                        if (Q23SUM_DIFF < 884.5) {
                            if (RANGE_MACRO_VALUE < 211.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 211.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q23SUM_DIFF >= 884.5) {
                            if (Q23SUM_DIFF < 5020.5) {
                                oneCount++;
                            }
                            else if (Q23SUM_DIFF >= 5020.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q3SUM >= 2456) {
                        if (AVG_COL < 5.01) {
                            if (Q2CENT_AVGDIFF < 3.68) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 3.68) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_COL >= 5.01) {
                            if (AVG_COL < 5.8) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 5.8) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 68.5) {
                    if (Q4SUM < 3812) {
                        zeroCount++;
                    }
                    else if (Q4SUM >= 3812) {
                        oneCount++;
                    }
                }
            }
        }

    //TREE 8
    if (Y < 808) {
            if (Q34SUM_DIFF < 120.5) {
                if (Q23SUM_DIFF < 68.5) {
                    if (Q4AVG < 47.99) {
                        if (X < 360) {
                            if (Q2CENT_AVGDIFF < 0.06) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 0.06) {
                                oneCount++;
                            }
                        }
                        else if (X >= 360) {
                            if (Y < 56) {
                                zeroCount++;
                            }
                            else if (Y >= 56) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q4AVG >= 47.99) {
                        if (Y < 72) {
                            if (X < 1208) {
                                oneCount++;
                            }
                            else if (X >= 1208) {
                                zeroCount++;
                            }
                        }
                        else if (Y >= 72) {
                            if (Q1CENT_AVGDIFF < 0.94) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 0.94) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Q23SUM_DIFF >= 68.5) {
                    if (SUM_COL < 18.5) {
                        if (Q2CENT_AVGDIFF < 22.14) {
                            zeroCount++;
                        }
                        else if (Q2CENT_AVGDIFF >= 22.14) {
                            if (AVG_ROW < 4.87) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 4.87) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_COL >= 18.5) {
                        if (MAX_MACRO_VALUE < 26.5) {
                            if (Q13SUM_DIFF < 6.5) {
                                oneCount++;
                            }
                            else if (Q13SUM_DIFF >= 6.5) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 26.5) {
                            if (Q34SUM_DIFF < 16.5) {
                                oneCount++;
                            }
                            else if (Q34SUM_DIFF >= 16.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Q34SUM_DIFF >= 120.5) {
                if (X < 1432) {
                    if (Q1AVG < 136.33) {
                        if (Q1SUM < 4443.5) {
                            if (MIN_MACRO_VALUE < 83.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 83.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q1SUM >= 4443.5) {
                            if (AVG_ROW < 13.25) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 13.25) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q1AVG >= 136.33) {
                        if (RANGE_MACRO_VALUE < 85.5) {
                            if (AVG_ROW < 2.99) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 2.99) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 85.5) {
                            if (VARIANCE < 1329.57) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 1329.57) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (X >= 1432) {
                    if (SUM_ROW < 610) {
                        if (Q13SUM_DIFF < 95) {
                            if (MAX_MACRO_VALUE < 68.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 68.5) {
                                oneCount++;
                            }
                        }
                        else if (Q13SUM_DIFF >= 95) {
                            if (Q14SUM_DIFF < 219) {
                                oneCount++;
                            }
                            else if (Q14SUM_DIFF >= 219) {
                                oneCount++;
                            }
                        }
                    }
                    else if (SUM_ROW >= 610) {
                        if (SUM_ROW_COL < 1035.5) {
                            if (Q1AVG < 60.04) {
                                oneCount++;
                            }
                            else if (Q1AVG >= 60.04) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_ROW_COL >= 1035.5) {
                            if (MAX_MACRO_VALUE < 75.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 75.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (Y >= 808) {
            if (Q3AVG < 79.15) {
                if (SUM_COL < 283.5) {
                    if (Y < 904) {
                        if (X < 1016) {
                            zeroCount++;
                        }
                        else if (X >= 1016) {
                            if (Q24SUM_DIFF < 5.5) {
                                zeroCount++;
                            }
                            else if (Q24SUM_DIFF >= 5.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Y >= 904) {
                        if (Y < 1000) {
                            if (X < 1608) {
                                oneCount++;
                            }
                            else if (X >= 1608) {
                                zeroCount++;
                            }
                        }
                        else if (Y >= 1000) {
                            if (RANGE_MACRO_VALUE < 12.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 12.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (SUM_COL >= 283.5) {
                    if (Q34SUM_DIFF < 67.5) {
                        if (MAX_MACRO_VALUE < 52.5) {
                            if (Y < 1032) {
                                zeroCount++;
                            }
                            else if (Y >= 1032) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 52.5) {
                            if (AVG_MACRO_VALUE < 50.41) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 50.41) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q34SUM_DIFF >= 67.5) {
                        if (MIN_MACRO_VALUE < 15.5) {
                            if (Q1SUM < 2890.5) {
                                zeroCount++;
                            }
                            else if (Q1SUM >= 2890.5) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 15.5) {
                            if (MAX_MACRO_VALUE < 58.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 58.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (Q3AVG >= 79.15) {
                if (Q23SUM_DIFF < 866.5) {
                    if (Q13SUM_DIFF < 128.5) {
                        if (Q14SUM_DIFF < 620.5) {
                            if (Q2AVG < 192.53) {
                                zeroCount++;
                            }
                            else if (Q2AVG >= 192.53) {
                                oneCount++;
                            }
                        }
                        else if (Q14SUM_DIFF >= 620.5) {
                            if (Q4AVG < 114.1) {
                                oneCount++;
                            }
                            else if (Q4AVG >= 114.1) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q13SUM_DIFF >= 128.5) {
                        if (Q2AVG < 73.72) {
                            if (X < 592) {
                                zeroCount++;
                            }
                            else if (X >= 592) {
                                zeroCount++;
                            }
                        }
                        else if (Q2AVG >= 73.72) {
                            if (X < 1736) {
                                zeroCount++;
                            }
                            else if (X >= 1736) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (Q23SUM_DIFF >= 866.5) {
                    if (Q1AVG < 45.93) {
                        if (MIN_MACRO_VALUE < 17.5) {
                            if (Q1SUM < 1220.5) {
                                zeroCount++;
                            }
                            else if (Q1SUM >= 1220.5) {
                                oneCount++;
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 17.5) {
                            if (Q4CENT_AVGDIFF < 5.24) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 5.24) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q1AVG >= 45.93) {
                        if (Q3CENT_AVGDIFF < 1.11) {
                            if (Q3AVG < 135.67) {
                                zeroCount++;
                            }
                            else if (Q3AVG >= 135.67) {
                                oneCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 1.11) {
                            if (VARIANCE < 287.71) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 287.71) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 9
    if (Y < 808) {
            if (Q34SUM_DIFF < 119.5) {
                if (MAX_MACRO_VALUE < 182.5) {
                    if (MIN_MACRO_VALUE < 69.5) {
                        if (AVG_MACRO_VALUE < 67.37) {
                            if (Y < 584) {
                                oneCount++;
                            }
                            else if (Y >= 584) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 67.37) {
                            if (Y < 424) {
                                oneCount++;
                            }
                            else if (Y >= 424) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 69.5) {
                        if (MAX_MACRO_VALUE < 121.5) {
                            if (Y < 376) {
                                zeroCount++;
                            }
                            else if (Y >= 376) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 121.5) {
                            if (SUM_ROW_COL < 2019.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW_COL >= 2019.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 182.5) {
                    if (AVG_COL < 0.33) {
                        zeroCount++;
                    }
                    else if (AVG_COL >= 0.33) {
                        if (MAX_MACRO_VALUE < 193.5) {
                            if (Q3AVG < 180.15) {
                                oneCount++;
                            }
                            else if (Q3AVG >= 180.15) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 193.5) {
                            if (SUM_ROW < 3029) {
                                oneCount++;
                            }
                            else if (SUM_ROW >= 3029) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (Q34SUM_DIFF >= 119.5) {
                if (X < 1432) {
                    if (VARIANCE < 170.8) {
                        if (QCENTERAVG < 39.94) {
                            if (Q2AVG < 32.89) {
                                zeroCount++;
                            }
                            else if (Q2AVG >= 32.89) {
                                zeroCount++;
                            }
                        }
                        else if (QCENTERAVG >= 39.94) {
                            if (Q4SUM < 1661.5) {
                                oneCount++;
                            }
                            else if (Q4SUM >= 1661.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (VARIANCE >= 170.8) {
                        if (X < 1176) {
                            if (MAX_MACRO_VALUE < 61.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 61.5) {
                                oneCount++;
                            }
                        }
                        else if (X >= 1176) {
                            if (Q1CENT_AVGDIFF < 9.47) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 9.47) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (X >= 1432) {
                    if (AVG_ROW < 3.38) {
                        if (VARIANCE < 24.05) {
                            if (X < 1512) {
                                zeroCount++;
                            }
                            else if (X >= 1512) {
                                oneCount++;
                            }
                        }
                        else if (VARIANCE >= 24.05) {
                            if (SUM_COL < 327.5) {
                                oneCount++;
                            }
                            else if (SUM_COL >= 327.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_ROW >= 3.38) {
                        if (MAX_MACRO_VALUE < 77.5) {
                            zeroCount++;
                        }
                        else if (MAX_MACRO_VALUE >= 77.5) {
                            if (Q1CENT_AVGDIFF < 3.9) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 3.9) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (Y >= 808) {
            if (Q3AVG < 118.06) {
                if (Q12SUM_DIFF < 3358) {
                    if (X < 8) {
                        zeroCount++;
                    }
                    else if (X >= 8) {
                        if (Q34SUM_DIFF < 7.5) {
                            if (AVG_COL < 5.31) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 5.31) {
                                oneCount++;
                            }
                        }
                        else if (Q34SUM_DIFF >= 7.5) {
                            if (Q3CENT_AVGDIFF < 31.85) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 31.85) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (Q12SUM_DIFF >= 3358) {
                    if (X < 168) {
                        oneCount++;
                    }
                    else if (X >= 168) {
                        if (Q34SUM_DIFF < 1457) {
                            if (Q34SUM_DIFF < 1290.5) {
                                zeroCount++;
                            }
                            else if (Q34SUM_DIFF >= 1290.5) {
                                oneCount++;
                            }
                        }
                        else if (Q34SUM_DIFF >= 1457) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (Q3AVG >= 118.06) {
                if (AVG_COL < 2.55) {
                    if (Q1AVG < 92.14) {
                        zeroCount++;
                    }
                    else if (Q1AVG >= 92.14) {
                        if (Q1CENT_AVGDIFF < 5.86) {
                            if (Q24SUM_DIFF < 37.5) {
                                oneCount++;
                            }
                            else if (Q24SUM_DIFF >= 37.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 5.86) {
                            if (X < 1472) {
                                oneCount++;
                            }
                            else if (X >= 1472) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (AVG_COL >= 2.55) {
                    if (Q14SUM_DIFF < 159.5) {
                        if (Q4CENT_AVGDIFF < 5.14) {
                            if (Q34SUM_DIFF < 19) {
                                oneCount++;
                            }
                            else if (Q34SUM_DIFF >= 19) {
                                zeroCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 5.14) {
                            if (AVG_ROW < 16.68) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 16.68) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q14SUM_DIFF >= 159.5) {
                        if (VARIANCE < 3161.31) {
                            if (Q13SUM_DIFF < 128) {
                                oneCount++;
                            }
                            else if (Q13SUM_DIFF >= 128) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 3161.31) {
                            if (Y < 1016) {
                                zeroCount++;
                            }
                            else if (Y >= 1016) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }

    //TREE 10
    if (Q34SUM_DIFF < 120.5) {
            if (X < 584) {
                if (QCENTERAVG < 50.5) {
                    if (Q4AVG < 41.79) {
                        if (Y < 248) {
                            if (AVG_MACRO_VALUE < 27.1) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 27.1) {
                                zeroCount++;
                            }
                        }
                        else if (Y >= 248) {
                            if (Q2SUM < 783.5) {
                                zeroCount++;
                            }
                            else if (Q2SUM >= 783.5) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q4AVG >= 41.79) {
                        if (AVG_ROW < 1.75) {
                            if (Y < 552) {
                                oneCount++;
                            }
                            else if (Y >= 552) {
                                oneCount++;
                            }
                        }
                        else if (AVG_ROW >= 1.75) {
                            if (Y < 328) {
                                zeroCount++;
                            }
                            else if (Y >= 328) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (QCENTERAVG >= 50.5) {
                    if (SUM_ROW_COL < 209.5) {
                        if (Q14SUM_DIFF < 79.5) {
                            if (Q34SUM_DIFF < 11.5) {
                                zeroCount++;
                            }
                            else if (Q34SUM_DIFF >= 11.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q14SUM_DIFF >= 79.5) {
                            if (VARIANCE < 1.41) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 1.41) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 209.5) {
                        if (QCENTERAVG < 138.33) {
                            if (Y < 632) {
                                zeroCount++;
                            }
                            else if (Y >= 632) {
                                oneCount++;
                            }
                        }
                        else if (QCENTERAVG >= 138.33) {
                            if (MAX_MACRO_VALUE < 158.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 158.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (X >= 584) {
                if (MAX_MACRO_VALUE < 182.5) {
                    if (Q3AVG < 94.04) {
                        if (Q23SUM_DIFF < 58.5) {
                            if (AVG_COL < 0.64) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 0.64) {
                                zeroCount++;
                            }
                        }
                        else if (Q23SUM_DIFF >= 58.5) {
                            if (AVG_COL < 0.2) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 0.2) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q3AVG >= 94.04) {
                        if (Q23SUM_DIFF < 113.5) {
                            if (Y < 216) {
                                oneCount++;
                            }
                            else if (Y >= 216) {
                                zeroCount++;
                            }
                        }
                        else if (Q23SUM_DIFF >= 113.5) {
                            if (Q13SUM_DIFF < 1158) {
                                zeroCount++;
                            }
                            else if (Q13SUM_DIFF >= 1158) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 182.5) {
                    if (Y < 1016) {
                        if (X < 696) {
                            if (MIN_MACRO_VALUE < 20.5) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 20.5) {
                                zeroCount++;
                            }
                        }
                        else if (X >= 696) {
                            if (AVG_COL < 0.33) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 0.33) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Y >= 1016) {
                        if (Q2AVG < 19.61) {
                            oneCount++;
                        }
                        else if (Q2AVG >= 19.61) {
                            if (MAX_MACRO_VALUE < 232.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 232.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (Q34SUM_DIFF >= 120.5) {
            if (Q12SUM_DIFF < 15.5) {
                if (MIN_MACRO_VALUE < 48.5) {
                    if (MIN_MACRO_VALUE < 17.5) {
                        if (Q1CENT_AVGDIFF < 22.01) {
                            if (RANGE_MACRO_VALUE < 53.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 53.5) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 22.01) {
                            if (Q3CENT_AVGDIFF < 3.74) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 3.74) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 17.5) {
                        if (Q1CENT_AVGDIFF < 4.18) {
                            if (AVG_COL < 6.24) {
                                oneCount++;
                            }
                            else if (AVG_COL >= 6.24) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 4.18) {
                            if (AVG_ROW < 1.46) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 1.46) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 48.5) {
                    if (X < 1440) {
                        if (Q14SUM_DIFF < 871.5) {
                            if (VARIANCE < 1729.75) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 1729.75) {
                                oneCount++;
                            }
                        }
                        else if (Q14SUM_DIFF >= 871.5) {
                            if (AVG_MACRO_VALUE < 79.26) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 79.26) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (X >= 1440) {
                        if (X < 1512) {
                            if (Y < 152) {
                                zeroCount++;
                            }
                            else if (Y >= 152) {
                                oneCount++;
                            }
                        }
                        else if (X >= 1512) {
                            if (MAX_MACRO_VALUE < 141.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 141.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (Q12SUM_DIFF >= 15.5) {
                if (MAX_MACRO_VALUE < 52.5) {
                    if (RANGE_MACRO_VALUE < 29.5) {
                        if (AVG_COL < 1.04) {
                            if (Q14SUM_DIFF < 45.5) {
                                oneCount++;
                            }
                            else if (Q14SUM_DIFF >= 45.5) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_COL >= 1.04) {
                            if (Q1CENT_AVGDIFF < 16.92) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 16.92) {
                                oneCount++;
                            }
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 29.5) {
                        if (AVG_ROW < 1.83) {
                            zeroCount++;
                        }
                        else if (AVG_ROW >= 1.83) {
                            if (RANGE_MACRO_VALUE < 31.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 31.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 52.5) {
                    if (Y < 712) {
                        if (X < 1432) {
                            if (Q1AVG < 136.35) {
                                oneCount++;
                            }
                            else if (Q1AVG >= 136.35) {
                                oneCount++;
                            }
                        }
                        else if (X >= 1432) {
                            if (AVG_ROW < 3.38) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 3.38) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Y >= 712) {
                        if (AVG_COL < 8.63) {
                            if (Q1CENT_AVGDIFF < 5.51) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 5.51) {
                                oneCount++;
                            }
                        }
                        else if (AVG_COL >= 8.63) {
                            if (VARIANCE < 1641.65) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 1641.65) {
                                zeroCount++;
                            }
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