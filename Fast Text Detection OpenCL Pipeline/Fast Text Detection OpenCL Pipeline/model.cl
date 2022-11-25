__kernel void DTC_15F_9D_RD(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
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
    if (VARIANCE < 150.93) {
            if (SUM_COL < 81.5) {
                if (SUM_ROW < 102.5) {
                    if (AVG_COL < 0.02) {
                        if (AVG_COL < 0.01) {
                            if (Q2CENT_AVGDIFF < 0.01) {
                                if (RANGE_MACRO_VALUE < 0.5) {
                                    if (MIN_MACRO_VALUE < 26.5) {
                                        if (MIN_MACRO_VALUE < 17.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 17.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 26.5) {
                                        if (AVG_MACRO_VALUE < 28.5) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 28.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 0.5) {
                                    zeroCount++;
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 0.01) {
                                if (MAX_MACRO_VALUE < 21.5) {
                                    zeroCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 21.5) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (AVG_COL >= 0.01) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_COL >= 0.02) {
                        if (SUM_COL < 8.5) {
                            if (MAX_MACRO_VALUE < 23.5) {
                                if (AVG_MACRO_VALUE < 18.94) {
                                    if (Q3CENT_AVGDIFF < 0.11) {
                                        zeroCount++;
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.11) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 18.94) {
                                    if (Q2CENT_AVGDIFF < 0.65) {
                                        if (Q1CENT_AVGDIFF < 0.29) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.29) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 0.65) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 23.5) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_COL >= 8.5) {
                            if (SUM_ROW_COL < 175.5) {
                                if (RANGE_MACRO_VALUE < 6.5) {
                                    if (AVG_ROW < 0.39) {
                                        if (AVG_MACRO_VALUE < 129.89) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 129.89) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 0.39) {
                                        if (Q4CENT_AVGDIFF < 0.1) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.1) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 6.5) {
                                    if (SUM_ROW_COL < 173.5) {
                                        if (SUM_ROW_COL < 155) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 155) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 173.5) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (SUM_ROW_COL >= 175.5) {
                                if (VARIANCE < 0.33) {
                                    zeroCount++;
                                }
                                else if (VARIANCE >= 0.33) {
                                    if (AVG_MACRO_VALUE < 52.32) {
                                        if (SUM_COL < 76.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 76.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 52.32) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (SUM_ROW >= 102.5) {
                    if (SUM_ROW_COL < 169.5) {
                        if (MIN_MACRO_VALUE < 17.5) {
                            oneCount++;
                        }
                        else if (MIN_MACRO_VALUE >= 17.5) {
                            zeroCount++;
                        }
                    }
                    else if (SUM_ROW_COL >= 169.5) {
                        if (AVG_COL < 0.08) {
                            if (SUM_COL < 8.5) {
                                if (AVG_MACRO_VALUE < 34.24) {
                                    if (MAX_MACRO_VALUE < 58.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 58.5) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 34.24) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_COL >= 8.5) {
                                if (SUM_COL < 10.5) {
                                    zeroCount++;
                                }
                                else if (SUM_COL >= 10.5) {
                                    if (AVG_COL < 0.05) {
                                        if (Q1CENT_AVGDIFF < 16.49) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 16.49) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 0.05) {
                                        if (AVG_COL < 0.06) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 0.06) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_COL >= 0.08) {
                            if (Q2CENT_AVGDIFF < 0.07) {
                                if (SUM_ROW < 254) {
                                    if (Q1CENT_AVGDIFF < 0.18) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 0.18) {
                                        if (VARIANCE < 8.12) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 8.12) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 254) {
                                    if (AVG_ROW < 1.7) {
                                        oneCount++;
                                    }
                                    else if (AVG_ROW >= 1.7) {
                                        if (VARIANCE < 85.03) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 85.03) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 0.07) {
                                if (Q2CENT_AVGDIFF < 0.18) {
                                    if (SUM_ROW < 108.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW >= 108.5) {
                                        if (SUM_ROW_COL < 412) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 412) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 0.18) {
                                    if (Q3CENT_AVGDIFF < 9.86) {
                                        if (Q3CENT_AVGDIFF < 9.21) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 9.21) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 9.86) {
                                        if (SUM_ROW_COL < 1235.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1235.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (SUM_COL >= 81.5) {
                if (RANGE_MACRO_VALUE < 52.5) {
                    if (Q3CENT_AVGDIFF < 0.03) {
                        if (Q2CENT_AVGDIFF < 0.38) {
                            if (SUM_ROW < 468) {
                                if (Q2CENT_AVGDIFF < 0.35) {
                                    if (Q2CENT_AVGDIFF < 0.15) {
                                        if (VARIANCE < 0.25) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 0.25) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 0.15) {
                                        if (SUM_ROW_COL < 151) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 151) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 0.35) {
                                    oneCount++;
                                }
                            }
                            else if (SUM_ROW >= 468) {
                                if (VARIANCE < 9.54) {
                                    oneCount++;
                                }
                                else if (VARIANCE >= 9.54) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 0.38) {
                            if (AVG_COL < 1.03) {
                                if (Q4CENT_AVGDIFF < 0.58) {
                                    if (SUM_ROW_COL < 1226) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW_COL >= 1226) {
                                        if (Q1CENT_AVGDIFF < 17.83) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 17.83) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 0.58) {
                                    if (MIN_MACRO_VALUE < 42) {
                                        if (AVG_MACRO_VALUE < 32.33) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 32.33) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 42) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (AVG_COL >= 1.03) {
                                if (VARIANCE < 85.85) {
                                    zeroCount++;
                                }
                                else if (VARIANCE >= 85.85) {
                                    if (AVG_ROW < 0.94) {
                                        zeroCount++;
                                    }
                                    else if (AVG_ROW >= 0.94) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 0.03) {
                        if (AVG_ROW < 0.42) {
                            if (Q4CENT_AVGDIFF < 0.04) {
                                if (SUM_ROW < 100.5) {
                                    if (AVG_ROW < 0.39) {
                                        if (AVG_ROW < 0.31) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 0.31) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 0.39) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_ROW >= 100.5) {
                                    if (AVG_COL < 0.4) {
                                        zeroCount++;
                                    }
                                    else if (AVG_COL >= 0.4) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 0.04) {
                                if (MAX_MACRO_VALUE < 91.5) {
                                    if (Q2CENT_AVGDIFF < 4.06) {
                                        if (AVG_COL < 2.77) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 2.77) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 4.06) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 91.5) {
                                    if (RANGE_MACRO_VALUE < 1.5) {
                                        oneCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 1.5) {
                                        if (MIN_MACRO_VALUE < 86.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 86.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_ROW >= 0.42) {
                            if (AVG_ROW < 0.43) {
                                if (MAX_MACRO_VALUE < 39.5) {
                                    zeroCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 39.5) {
                                    if (Q3CENT_AVGDIFF < 0.35) {
                                        if (MIN_MACRO_VALUE < 99.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 99.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.35) {
                                        if (AVG_MACRO_VALUE < 19.63) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 19.63) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_ROW >= 0.43) {
                                if (Q3CENT_AVGDIFF < 31.07) {
                                    if (MAX_MACRO_VALUE < 82.5) {
                                        if (MAX_MACRO_VALUE < 81.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 81.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 82.5) {
                                        if (AVG_MACRO_VALUE < 66.86) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 66.86) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 31.07) {
                                    if (AVG_ROW < 4.39) {
                                        oneCount++;
                                    }
                                    else if (AVG_ROW >= 4.39) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 52.5) {
                    if (Q3CENT_AVGDIFF < 23.54) {
                        if (Q4CENT_AVGDIFF < 1.04) {
                            if (SUM_ROW < 798) {
                                if (MAX_MACRO_VALUE < 135.5) {
                                    if (AVG_ROW < 0.61) {
                                        if (Q3CENT_AVGDIFF < 1.49) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 1.49) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 0.61) {
                                        if (Q3CENT_AVGDIFF < 14.54) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 14.54) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 135.5) {
                                    if (SUM_COL < 515) {
                                        if (Q2CENT_AVGDIFF < 5.96) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 5.96) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 515) {
                                        if (MAX_MACRO_VALUE < 146) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 146) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW >= 798) {
                                if (AVG_MACRO_VALUE < 61.21) {
                                    if (AVG_MACRO_VALUE < 61.18) {
                                        if (SUM_COL < 693.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 693.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 61.18) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 61.21) {
                                    if (Q2CENT_AVGDIFF < 0.07) {
                                        oneCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 0.07) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 1.04) {
                            if (Q4CENT_AVGDIFF < 18.79) {
                                if (Q1CENT_AVGDIFF < 4.44) {
                                    if (MAX_MACRO_VALUE < 153.5) {
                                        if (MIN_MACRO_VALUE < 75.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 75.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 153.5) {
                                        if (Q4CENT_AVGDIFF < 2.79) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 2.79) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 4.44) {
                                    if (Q4CENT_AVGDIFF < 8.63) {
                                        if (AVG_COL < 3.56) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 3.56) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 8.63) {
                                        if (VARIANCE < 70.2) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 70.2) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 18.79) {
                                if (Q1CENT_AVGDIFF < 19.36) {
                                    if (SUM_ROW < 392) {
                                        if (VARIANCE < 124.26) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 124.26) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 392) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 19.36) {
                                    if (AVG_MACRO_VALUE < 73.34) {
                                        if (SUM_COL < 1248.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 1248.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 73.34) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 23.54) {
                        zeroCount++;
                    }
                }
            }
        }
        else if (VARIANCE >= 150.93) {
            if (SUM_COL < 76.5) {
                if (Q1CENT_AVGDIFF < 20.38) {
                    if (Q1CENT_AVGDIFF < 18.29) {
                        if (SUM_COL < 45) {
                            if (AVG_ROW < 4.5) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 4.5) {
                                if (VARIANCE < 184.96) {
                                    oneCount++;
                                }
                                else if (VARIANCE >= 184.96) {
                                    if (Q4CENT_AVGDIFF < 20.94) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 20.94) {
                                        if (VARIANCE < 364.74) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 364.74) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_COL >= 45) {
                            if (Q4CENT_AVGDIFF < 23.15) {
                                if (Q3CENT_AVGDIFF < 0.22) {
                                    zeroCount++;
                                }
                                else if (Q3CENT_AVGDIFF >= 0.22) {
                                    if (Q3CENT_AVGDIFF < 0.46) {
                                        oneCount++;
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.46) {
                                        if (Q2CENT_AVGDIFF < 18.96) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 18.96) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 23.15) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 18.29) {
                        if (VARIANCE < 166.64) {
                            if (VARIANCE < 155.5) {
                                oneCount++;
                            }
                            else if (VARIANCE >= 155.5) {
                                if (AVG_COL < 0.08) {
                                    if (VARIANCE < 160.68) {
                                        zeroCount++;
                                    }
                                    else if (VARIANCE >= 160.68) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_COL >= 0.08) {
                                    if (SUM_ROW < 1218.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW >= 1218.5) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                        else if (VARIANCE >= 166.64) {
                            if (VARIANCE < 173.11) {
                                if (SUM_COL < 31) {
                                    zeroCount++;
                                }
                                else if (SUM_COL >= 31) {
                                    if (SUM_ROW < 1200.5) {
                                        if (AVG_ROW < 4.83) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 4.83) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 1200.5) {
                                        if (Q3CENT_AVGDIFF < 0.11) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.11) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (VARIANCE >= 173.11) {
                                if (SUM_ROW_COL < 1429) {
                                    if (Q4CENT_AVGDIFF < 0.01) {
                                        if (Q3CENT_AVGDIFF < 0.18) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.18) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.01) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_ROW_COL >= 1429) {
                                    if (SUM_ROW < 1389) {
                                        if (AVG_MACRO_VALUE < 25.63) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 25.63) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 1389) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (Q1CENT_AVGDIFF >= 20.38) {
                    if (Q2CENT_AVGDIFF < 20.79) {
                        if (VARIANCE < 224.97) {
                            if (SUM_ROW_COL < 1391.5) {
                                if (AVG_COL < 0.15) {
                                    zeroCount++;
                                }
                                else if (AVG_COL >= 0.15) {
                                    oneCount++;
                                }
                            }
                            else if (SUM_ROW_COL >= 1391.5) {
                                if (AVG_COL < 0.28) {
                                    if (Q3CENT_AVGDIFF < 0.22) {
                                        zeroCount++;
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.22) {
                                        if (AVG_COL < 0.14) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 0.14) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_COL >= 0.28) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (VARIANCE >= 224.97) {
                            oneCount++;
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 20.79) {
                        if (SUM_ROW < 1444.5) {
                            if (VARIANCE < 163.53) {
                                if (MIN_MACRO_VALUE < 22.5) {
                                    zeroCount++;
                                }
                                else if (MIN_MACRO_VALUE >= 22.5) {
                                    if (AVG_COL < 0.21) {
                                        if (SUM_ROW_COL < 1204.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1204.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 0.21) {
                                        if (VARIANCE < 156.23) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 156.23) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (VARIANCE >= 163.53) {
                                if (Q4CENT_AVGDIFF < 11.21) {
                                    if (Q2CENT_AVGDIFF < 24.01) {
                                        if (AVG_MACRO_VALUE < 31.18) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 31.18) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 24.01) {
                                        if (Q1CENT_AVGDIFF < 36.14) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 36.14) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 11.21) {
                                    if (Q2CENT_AVGDIFF < 25.33) {
                                        if (AVG_MACRO_VALUE < 30.61) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 30.61) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 25.33) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW >= 1444.5) {
                            if (SUM_ROW_COL < 4764.5) {
                                zeroCount++;
                            }
                            else if (SUM_ROW_COL >= 4764.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
            else if (SUM_COL >= 76.5) {
                if (SUM_COL < 125.5) {
                    if (SUM_ROW_COL < 3018.5) {
                        if (SUM_ROW < 2741.5) {
                            if (Q2CENT_AVGDIFF < 20.04) {
                                if (AVG_MACRO_VALUE < 26.98) {
                                    if (RANGE_MACRO_VALUE < 79.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 79.5) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 26.98) {
                                    if (Q3CENT_AVGDIFF < 12.64) {
                                        if (RANGE_MACRO_VALUE < 84) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 84) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 12.64) {
                                        if (MAX_MACRO_VALUE < 72.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 72.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 20.04) {
                                if (Q4CENT_AVGDIFF < 2.63) {
                                    if (AVG_ROW < 7.77) {
                                        if (RANGE_MACRO_VALUE < 90) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 90) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 7.77) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 2.63) {
                                    if (Q4CENT_AVGDIFF < 4.89) {
                                        if (VARIANCE < 238.45) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 238.45) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 4.89) {
                                        if (SUM_ROW_COL < 2814.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 2814.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW >= 2741.5) {
                            zeroCount++;
                        }
                    }
                    else if (SUM_ROW_COL >= 3018.5) {
                        if (AVG_MACRO_VALUE < 94.68) {
                            if (Q2CENT_AVGDIFF < 28.96) {
                                if (SUM_ROW_COL < 3025) {
                                    oneCount++;
                                }
                                else if (SUM_ROW_COL >= 3025) {
                                    if (SUM_ROW_COL < 3066.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW_COL >= 3066.5) {
                                        if (SUM_ROW_COL < 3125.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 3125.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 28.96) {
                                if (MIN_MACRO_VALUE < 21) {
                                    oneCount++;
                                }
                                else if (MIN_MACRO_VALUE >= 21) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 94.68) {
                            if (Q2CENT_AVGDIFF < 37.1) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 37.1) {
                                if (Q3CENT_AVGDIFF < 51) {
                                    oneCount++;
                                }
                                else if (Q3CENT_AVGDIFF >= 51) {
                                    if (VARIANCE < 3658.84) {
                                        oneCount++;
                                    }
                                    else if (VARIANCE >= 3658.84) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (SUM_COL >= 125.5) {
                    if (VARIANCE < 633) {
                        if (VARIANCE < 572.84) {
                            if (VARIANCE < 572.55) {
                                if (Q4CENT_AVGDIFF < 29.68) {
                                    if (Q3CENT_AVGDIFF < 22.43) {
                                        if (Q3CENT_AVGDIFF < 21.9) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 21.9) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 22.43) {
                                        if (AVG_COL < 12.61) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 12.61) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 29.68) {
                                    if (Q3CENT_AVGDIFF < 24.81) {
                                        if (Q3CENT_AVGDIFF < 2.53) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 2.53) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 24.81) {
                                        if (SUM_ROW_COL < 4238) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 4238) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (VARIANCE >= 572.55) {
                                if (MAX_MACRO_VALUE < 140) {
                                    zeroCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 140) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (VARIANCE >= 572.84) {
                            if (SUM_ROW < 2142) {
                                if (AVG_MACRO_VALUE < 39.29) {
                                    if (Q1CENT_AVGDIFF < 5.79) {
                                        if (Q4CENT_AVGDIFF < 40.63) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 40.63) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 5.79) {
                                        if (MAX_MACRO_VALUE < 127.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 127.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 39.29) {
                                    if (RANGE_MACRO_VALUE < 95.5) {
                                        if (VARIANCE < 624.7) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 624.7) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 95.5) {
                                        if (VARIANCE < 577.16) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 577.16) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW >= 2142) {
                                if (Q2CENT_AVGDIFF < 14.57) {
                                    if (RANGE_MACRO_VALUE < 122.5) {
                                        if (AVG_COL < 7.53) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 7.53) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 122.5) {
                                        if (SUM_ROW_COL < 3515.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 3515.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 14.57) {
                                    if (Q2CENT_AVGDIFF < 26.53) {
                                        if (MIN_MACRO_VALUE < 45.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 45.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 26.53) {
                                        if (VARIANCE < 583.73) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 583.73) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (VARIANCE >= 633) {
                        if (VARIANCE < 634.18) {
                            if (AVG_ROW < 6.85) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 6.85) {
                                if (SUM_ROW < 2664) {
                                    if (Q4CENT_AVGDIFF < 21.93) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 21.93) {
                                        if (VARIANCE < 633.34) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 633.34) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 2664) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (VARIANCE >= 634.18) {
                            if (SUM_ROW < 3638.5) {
                                if (AVG_COL < 1.23) {
                                    if (AVG_ROW < 6.23) {
                                        if (AVG_MACRO_VALUE < 62.4) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 62.4) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 6.23) {
                                        if (AVG_ROW < 9.32) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 9.32) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_COL >= 1.23) {
                                    if (MIN_MACRO_VALUE < 15.5) {
                                        if (SUM_ROW_COL < 4281) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 4281) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 15.5) {
                                        if (MAX_MACRO_VALUE < 101.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 101.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW >= 3638.5) {
                                if (SUM_COL < 2548) {
                                    if (RANGE_MACRO_VALUE < 128.5) {
                                        if (AVG_ROW < 15.98) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 15.98) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 128.5) {
                                        if (Q1CENT_AVGDIFF < 9.65) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 9.65) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 2548) {
                                    if (RANGE_MACRO_VALUE < 125.5) {
                                        if (AVG_MACRO_VALUE < 169.23) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 169.23) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 125.5) {
                                        if (VARIANCE < 1416.74) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 1416.74) {
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
        
    //TREE 2
    if (VARIANCE < 150.92) {
            if (SUM_ROW_COL < 191.5) {
                if (RANGE_MACRO_VALUE < 2.5) {
                    if (SUM_ROW < 0.5) {
                        if (AVG_MACRO_VALUE < 17.5) {
                            oneCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 17.5) {
                            if (MAX_MACRO_VALUE < 26.5) {
                                if (MAX_MACRO_VALUE < 20.5) {
                                    zeroCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 20.5) {
                                    zeroCount++;
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 26.5) {
                                if (MAX_MACRO_VALUE < 32.5) {
                                    oneCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 32.5) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (SUM_ROW >= 0.5) {
                        if (AVG_MACRO_VALUE < 23.91) {
                            if (Q1CENT_AVGDIFF < 0.96) {
                                if (MAX_MACRO_VALUE < 24.5) {
                                    if (Q1CENT_AVGDIFF < 0.9) {
                                        if (Q2CENT_AVGDIFF < 0.28) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.28) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 0.9) {
                                        if (AVG_COL < 0.14) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 0.14) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 24.5) {
                                    if (SUM_ROW_COL < 184.5) {
                                        if (Q4CENT_AVGDIFF < 0.75) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.75) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 184.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (Q1CENT_AVGDIFF >= 0.96) {
                                if (Q4CENT_AVGDIFF < 0.28) {
                                    if (SUM_COL < 22.5) {
                                        if (Q2CENT_AVGDIFF < 0.39) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.39) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 22.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 0.28) {
                                    if (Q2CENT_AVGDIFF < 0.68) {
                                        zeroCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 0.68) {
                                        if (Q3CENT_AVGDIFF < 0.25) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.25) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 23.91) {
                            if (AVG_MACRO_VALUE < 27.85) {
                                if (SUM_ROW_COL < 78.5) {
                                    zeroCount++;
                                }
                                else if (SUM_ROW_COL >= 78.5) {
                                    if (AVG_MACRO_VALUE < 24.14) {
                                        if (SUM_ROW < 84.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 84.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 24.14) {
                                        if (SUM_ROW_COL < 107.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 107.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 27.85) {
                                if (VARIANCE < 0.08) {
                                    zeroCount++;
                                }
                                else if (VARIANCE >= 0.08) {
                                    if (SUM_ROW < 20.5) {
                                        if (Q2CENT_AVGDIFF < 0.01) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.01) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 20.5) {
                                        if (Q3CENT_AVGDIFF < 0.03) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.03) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 2.5) {
                    if (AVG_MACRO_VALUE < 44.1) {
                        if (AVG_MACRO_VALUE < 20.06) {
                            if (Q1CENT_AVGDIFF < 0.92) {
                                if (Q2CENT_AVGDIFF < 0.82) {
                                    if (SUM_ROW < 64.5) {
                                        if (SUM_COL < 34) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 34) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 64.5) {
                                        if (SUM_COL < 78.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 78.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 0.82) {
                                    if (SUM_COL < 98.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_COL >= 98.5) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (Q1CENT_AVGDIFF >= 0.92) {
                                if (Q3CENT_AVGDIFF < 0.01) {
                                    if (VARIANCE < 4.44) {
                                        if (SUM_ROW < 82.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 82.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 4.44) {
                                        oneCount++;
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 0.01) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 20.06) {
                            if (Q3CENT_AVGDIFF < 0.11) {
                                if (Q4CENT_AVGDIFF < 0.85) {
                                    if (RANGE_MACRO_VALUE < 11) {
                                        if (SUM_ROW_COL < 171.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 171.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 11) {
                                        if (RANGE_MACRO_VALUE < 16) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 16) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 0.85) {
                                    if (SUM_COL < 83.5) {
                                        if (VARIANCE < 0.9) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 0.9) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 83.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 0.11) {
                                if (Q2CENT_AVGDIFF < 0.44) {
                                    if (AVG_COL < 0.17) {
                                        if (SUM_ROW < 40.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 40.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 0.17) {
                                        if (VARIANCE < 0.23) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 0.23) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 0.44) {
                                    if (SUM_COL < 46.5) {
                                        if (RANGE_MACRO_VALUE < 4.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 4.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 46.5) {
                                        if (Q2CENT_AVGDIFF < 1.01) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 1.01) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 44.1) {
                        if (Q2CENT_AVGDIFF < 0.22) {
                            if (VARIANCE < 0.27) {
                                if (SUM_ROW_COL < 119) {
                                    if (SUM_COL < 38.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_COL >= 38.5) {
                                        if (SUM_COL < 41.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 41.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 119) {
                                    oneCount++;
                                }
                            }
                            else if (VARIANCE >= 0.27) {
                                if (SUM_ROW_COL < 128.5) {
                                    if (SUM_ROW_COL < 120.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW_COL >= 120.5) {
                                        if (SUM_COL < 62.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 62.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 128.5) {
                                    if (Q2CENT_AVGDIFF < 0.21) {
                                        if (Q1CENT_AVGDIFF < 0.07) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.07) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 0.21) {
                                        if (SUM_COL < 82) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 82) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 0.22) {
                            if (SUM_ROW < 67.5) {
                                if (Q2CENT_AVGDIFF < 0.71) {
                                    if (MIN_MACRO_VALUE < 63) {
                                        if (SUM_ROW_COL < 96.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 96.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 63) {
                                        if (Q3CENT_AVGDIFF < 0.24) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.24) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 0.71) {
                                    if (AVG_MACRO_VALUE < 229.57) {
                                        if (SUM_ROW_COL < 92) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 92) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 229.57) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (SUM_ROW >= 67.5) {
                                if (AVG_MACRO_VALUE < 45.07) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 45.07) {
                                    if (AVG_ROW < 0.33) {
                                        if (Q2CENT_AVGDIFF < 1.15) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 1.15) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 0.33) {
                                        if (MAX_MACRO_VALUE < 169.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 169.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (SUM_ROW_COL >= 191.5) {
                if (VARIANCE < 84.31) {
                    if (SUM_COL < 1163) {
                        if (Q4CENT_AVGDIFF < 13.63) {
                            if (RANGE_MACRO_VALUE < 49.5) {
                                if (Q3CENT_AVGDIFF < 4.38) {
                                    if (Q4CENT_AVGDIFF < 12.21) {
                                        if (AVG_MACRO_VALUE < 43.19) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 43.19) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 12.21) {
                                        if (SUM_ROW < 747) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 747) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 4.38) {
                                    if (Q3CENT_AVGDIFF < 4.47) {
                                        if (MIN_MACRO_VALUE < 28.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 28.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 4.47) {
                                        if (Q4CENT_AVGDIFF < 12.96) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 12.96) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 49.5) {
                                if (RANGE_MACRO_VALUE < 50.5) {
                                    if (Q4CENT_AVGDIFF < 5.24) {
                                        if (AVG_COL < 3.5) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 3.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 5.24) {
                                        if (MAX_MACRO_VALUE < 168) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 168) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 50.5) {
                                    if (SUM_COL < 906) {
                                        if (RANGE_MACRO_VALUE < 100.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 100.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 906) {
                                        if (Q3CENT_AVGDIFF < 13.21) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 13.21) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 13.63) {
                            if (Q2CENT_AVGDIFF < 2.79) {
                                if (SUM_COL < 399.5) {
                                    zeroCount++;
                                }
                                else if (SUM_COL >= 399.5) {
                                    if (SUM_ROW_COL < 960) {
                                        if (Q1CENT_AVGDIFF < 1.28) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 1.28) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 960) {
                                        if (VARIANCE < 71.68) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 71.68) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 2.79) {
                                if (SUM_ROW_COL < 1092) {
                                    if (SUM_ROW_COL < 780.5) {
                                        if (Q3CENT_AVGDIFF < 0.36) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.36) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 780.5) {
                                        if (Q2CENT_AVGDIFF < 4.26) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 4.26) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 1092) {
                                    if (Q3CENT_AVGDIFF < 3.65) {
                                        zeroCount++;
                                    }
                                    else if (Q3CENT_AVGDIFF >= 3.65) {
                                        if (Q3CENT_AVGDIFF < 3.76) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 3.76) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (SUM_COL >= 1163) {
                        if (AVG_MACRO_VALUE < 51.97) {
                            if (Q1CENT_AVGDIFF < 1.9) {
                                if (RANGE_MACRO_VALUE < 37.5) {
                                    if (AVG_ROW < 1.72) {
                                        zeroCount++;
                                    }
                                    else if (AVG_ROW >= 1.72) {
                                        oneCount++;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 37.5) {
                                    zeroCount++;
                                }
                            }
                            else if (Q1CENT_AVGDIFF >= 1.9) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 51.97) {
                            zeroCount++;
                        }
                    }
                }
                else if (VARIANCE >= 84.31) {
                    if (Q4CENT_AVGDIFF < 0.9) {
                        if (Q3CENT_AVGDIFF < 14.69) {
                            if (Q2CENT_AVGDIFF < 20.75) {
                                if (AVG_MACRO_VALUE < 65.65) {
                                    if (Q3CENT_AVGDIFF < 0.93) {
                                        if (Q1CENT_AVGDIFF < 19.15) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 19.15) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.93) {
                                        if (RANGE_MACRO_VALUE < 96.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 96.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 65.65) {
                                    if (RANGE_MACRO_VALUE < 47.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 47.5) {
                                        if (AVG_MACRO_VALUE < 88.47) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 88.47) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 20.75) {
                                zeroCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 14.69) {
                            zeroCount++;
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 0.9) {
                        if (Q4CENT_AVGDIFF < 25.64) {
                            if (VARIANCE < 85.34) {
                                if (MAX_MACRO_VALUE < 75.5) {
                                    if (MAX_MACRO_VALUE < 62) {
                                        if (SUM_ROW_COL < 999.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 999.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 62) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 75.5) {
                                    if (Q3CENT_AVGDIFF < 7.94) {
                                        if (SUM_COL < 764) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 764) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 7.94) {
                                        if (Q1CENT_AVGDIFF < 5.35) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 5.35) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (VARIANCE >= 85.34) {
                                if (RANGE_MACRO_VALUE < 52.5) {
                                    if (SUM_ROW_COL < 873.5) {
                                        if (RANGE_MACRO_VALUE < 45.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 45.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 873.5) {
                                        if (Q1CENT_AVGDIFF < 0.65) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.65) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 52.5) {
                                    if (MIN_MACRO_VALUE < 60.5) {
                                        if (Q4CENT_AVGDIFF < 18.82) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 18.82) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 60.5) {
                                        if (MAX_MACRO_VALUE < 135.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 135.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 25.64) {
                            if (SUM_ROW < 397.5) {
                                oneCount++;
                            }
                            else if (SUM_ROW >= 397.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (VARIANCE >= 150.92) {
            if (AVG_COL < 0.27) {
                if (AVG_MACRO_VALUE < 29.13) {
                    if (AVG_MACRO_VALUE < 28.3) {
                        if (SUM_COL < 64.5) {
                            if (Q2CENT_AVGDIFF < 15.76) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 15.76) {
                                if (AVG_MACRO_VALUE < 25.97) {
                                    if (VARIANCE < 224.97) {
                                        if (SUM_ROW < 1368.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 1368.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 224.97) {
                                        if (Q2CENT_AVGDIFF < 22.85) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 22.85) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 25.97) {
                                    if (SUM_ROW < 1280.5) {
                                        if (RANGE_MACRO_VALUE < 42.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 42.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 1280.5) {
                                        if (Q1CENT_AVGDIFF < 24.1) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 24.1) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_COL >= 64.5) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 28.3) {
                        if (VARIANCE < 185.74) {
                            if (SUM_COL < 21.5) {
                                if (Q2CENT_AVGDIFF < 20.63) {
                                    zeroCount++;
                                }
                                else if (Q2CENT_AVGDIFF >= 20.63) {
                                    oneCount++;
                                }
                            }
                            else if (SUM_COL >= 21.5) {
                                if (AVG_COL < 0.24) {
                                    zeroCount++;
                                }
                                else if (AVG_COL >= 0.24) {
                                    if (Q1CENT_AVGDIFF < 22.88) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 22.88) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                        else if (VARIANCE >= 185.74) {
                            if (AVG_ROW < 5.71) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 5.71) {
                                zeroCount++;
                            }
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 29.13) {
                    if (AVG_ROW < 4.93) {
                        if (Q1CENT_AVGDIFF < 18.38) {
                            if (SUM_ROW_COL < 1209) {
                                if (Q4CENT_AVGDIFF < 14.86) {
                                    oneCount++;
                                }
                                else if (Q4CENT_AVGDIFF >= 14.86) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_ROW_COL >= 1209) {
                                if (VARIANCE < 156.96) {
                                    oneCount++;
                                }
                                else if (VARIANCE >= 156.96) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 18.38) {
                            if (Q4CENT_AVGDIFF < 0.17) {
                                if (AVG_COL < 0.21) {
                                    zeroCount++;
                                }
                                else if (AVG_COL >= 0.21) {
                                    if (VARIANCE < 327.24) {
                                        if (Q3CENT_AVGDIFF < 0.19) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.19) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 327.24) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 0.17) {
                                if (Q1CENT_AVGDIFF < 21.01) {
                                    if (SUM_ROW_COL < 1210) {
                                        if (VARIANCE < 164.9) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 164.9) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 1210) {
                                        oneCount++;
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 21.01) {
                                    if (SUM_ROW_COL < 1234.5) {
                                        if (VARIANCE < 163.67) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 163.67) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 1234.5) {
                                        if (AVG_ROW < 4.9) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 4.9) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (AVG_ROW >= 4.93) {
                        if (Q1CENT_AVGDIFF < 22.68) {
                            if (SUM_ROW_COL < 2772.5) {
                                if (Q3CENT_AVGDIFF < 28.43) {
                                    if (VARIANCE < 166.28) {
                                        if (VARIANCE < 165.44) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 165.44) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 166.28) {
                                        if (RANGE_MACRO_VALUE < 38.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 38.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 28.43) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_ROW_COL >= 2772.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 22.68) {
                            if (Q2CENT_AVGDIFF < 22.78) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 22.78) {
                                if (AVG_ROW < 4.99) {
                                    zeroCount++;
                                }
                                else if (AVG_ROW >= 4.99) {
                                    if (Q1CENT_AVGDIFF < 38) {
                                        if (VARIANCE < 184.51) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 184.51) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 38) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (AVG_COL >= 0.27) {
                if (AVG_MACRO_VALUE < 33.73) {
                    if (SUM_ROW_COL < 3388) {
                        if (VARIANCE < 190.35) {
                            if (AVG_COL < 6.4) {
                                if (SUM_ROW < 1287) {
                                    if (Q4CENT_AVGDIFF < 19.21) {
                                        if (MAX_MACRO_VALUE < 116.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 116.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 19.21) {
                                        if (AVG_COL < 4.04) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 4.04) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 1287) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_COL >= 6.4) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 190.35) {
                            if (RANGE_MACRO_VALUE < 180) {
                                if (Q2CENT_AVGDIFF < 26.71) {
                                    if (MAX_MACRO_VALUE < 177.5) {
                                        if (RANGE_MACRO_VALUE < 120) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 120) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 177.5) {
                                        oneCount++;
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 26.71) {
                                    if (Q2CENT_AVGDIFF < 27.4) {
                                        if (VARIANCE < 619.03) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 619.03) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 27.4) {
                                        if (AVG_MACRO_VALUE < 32.45) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 32.45) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 180) {
                                if (AVG_ROW < 3.77) {
                                    zeroCount++;
                                }
                                else if (AVG_ROW >= 3.77) {
                                    oneCount++;
                                }
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 3388) {
                        if (RANGE_MACRO_VALUE < 145) {
                            if (SUM_ROW < 3552.5) {
                                if (SUM_ROW_COL < 3924.5) {
                                    if (SUM_ROW < 2535.5) {
                                        if (MIN_MACRO_VALUE < 22.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 22.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 2535.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_ROW_COL >= 3924.5) {
                                    if (VARIANCE < 684.27) {
                                        if (Q4CENT_AVGDIFF < 42.35) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 42.35) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 684.27) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (SUM_ROW >= 3552.5) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 145) {
                            if (RANGE_MACRO_VALUE < 162.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 162.5) {
                                if (Q1CENT_AVGDIFF < 0.04) {
                                    zeroCount++;
                                }
                                else if (Q1CENT_AVGDIFF >= 0.04) {
                                    if (AVG_COL < 21.18) {
                                        oneCount++;
                                    }
                                    else if (AVG_COL >= 21.18) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 33.73) {
                    if (Q4CENT_AVGDIFF < 31.15) {
                        if (VARIANCE < 151.05) {
                            if (AVG_MACRO_VALUE < 74.96) {
                                oneCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 74.96) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 151.05) {
                            if (Q3CENT_AVGDIFF < 27.93) {
                                if (SUM_COL < 620.5) {
                                    if (Q1CENT_AVGDIFF < 29.46) {
                                        if (Q2CENT_AVGDIFF < 31.15) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 31.15) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 29.46) {
                                        if (VARIANCE < 301.82) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 301.82) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 620.5) {
                                    if (Q1CENT_AVGDIFF < 0.26) {
                                        if (Q1CENT_AVGDIFF < 0.17) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.17) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 0.26) {
                                        if (AVG_MACRO_VALUE < 34.81) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 34.81) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 27.93) {
                                if (AVG_COL < 5.26) {
                                    if (RANGE_MACRO_VALUE < 200.5) {
                                        if (Q2CENT_AVGDIFF < 62.26) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 62.26) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 200.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_COL >= 5.26) {
                                    if (SUM_COL < 1554.5) {
                                        if (VARIANCE < 653.76) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 653.76) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 1554.5) {
                                        if (MAX_MACRO_VALUE < 200.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 200.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 31.15) {
                        if (SUM_ROW_COL < 2773) {
                            if (Q4CENT_AVGDIFF < 48.86) {
                                if (SUM_COL < 1544.5) {
                                    if (AVG_COL < 1.77) {
                                        if (RANGE_MACRO_VALUE < 81.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 81.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 1.77) {
                                        if (VARIANCE < 475.31) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 475.31) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 1544.5) {
                                    if (VARIANCE < 678.46) {
                                        zeroCount++;
                                    }
                                    else if (VARIANCE >= 678.46) {
                                        if (Q1CENT_AVGDIFF < 3.1) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 3.1) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 48.86) {
                                if (MAX_MACRO_VALUE < 196.5) {
                                    if (AVG_COL < 2.41) {
                                        zeroCount++;
                                    }
                                    else if (AVG_COL >= 2.41) {
                                        if (AVG_COL < 2.63) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 2.63) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 196.5) {
                                    if (Q2CENT_AVGDIFF < 4.29) {
                                        if (SUM_COL < 1706.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 1706.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 4.29) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW_COL >= 2773) {
                            if (Q3CENT_AVGDIFF < 31.1) {
                                if (AVG_ROW < 10.33) {
                                    if (Q4CENT_AVGDIFF < 36.36) {
                                        if (VARIANCE < 486.37) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 486.37) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 36.36) {
                                        if (Q3CENT_AVGDIFF < 12.49) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 12.49) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 10.33) {
                                    if (MAX_MACRO_VALUE < 149.5) {
                                        if (Q3CENT_AVGDIFF < 7.33) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 7.33) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 149.5) {
                                        if (SUM_ROW < 2599.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 2599.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 31.1) {
                                if (RANGE_MACRO_VALUE < 115.5) {
                                    if (MAX_MACRO_VALUE < 100.5) {
                                        if (SUM_ROW_COL < 2972) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 2972) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 100.5) {
                                        if (SUM_COL < 3403.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 3403.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 115.5) {
                                    if (MIN_MACRO_VALUE < 21.5) {
                                        if (Q4CENT_AVGDIFF < 51.46) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 51.46) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 21.5) {
                                        if (AVG_COL < 11.04) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 11.04) {
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
        
    //TREE 3
    if (SUM_ROW < 1034.5) {
            if (AVG_ROW < 0.39) {
                if (MAX_MACRO_VALUE < 66.5) {
                    if (Q2CENT_AVGDIFF < 0.68) {
                        if (Q4CENT_AVGDIFF < 0.22) {
                            if (SUM_COL < 1211) {
                                if (Q3CENT_AVGDIFF < 1.15) {
                                    if (Q3CENT_AVGDIFF < 1.1) {
                                        if (MAX_MACRO_VALUE < 46.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 46.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 1.1) {
                                        if (AVG_COL < 0.21) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 0.21) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 1.15) {
                                    if (Q3CENT_AVGDIFF < 6.76) {
                                        if (AVG_COL < 0.41) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 0.41) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 6.76) {
                                        if (VARIANCE < 81.52) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 81.52) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_COL >= 1211) {
                                if (AVG_MACRO_VALUE < 24.33) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 24.33) {
                                    if (VARIANCE < 241.8) {
                                        oneCount++;
                                    }
                                    else if (VARIANCE >= 241.8) {
                                        if (AVG_ROW < 0.07) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 0.07) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 0.22) {
                            if (SUM_COL < 103.5) {
                                if (Q2CENT_AVGDIFF < 0.46) {
                                    if (Q1CENT_AVGDIFF < 0.72) {
                                        if (SUM_COL < 65.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 65.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 0.72) {
                                        if (RANGE_MACRO_VALUE < 5.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 5.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 0.46) {
                                    if (AVG_MACRO_VALUE < 24.33) {
                                        if (Q3CENT_AVGDIFF < 0.86) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.86) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 24.33) {
                                        if (MAX_MACRO_VALUE < 28.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 28.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_COL >= 103.5) {
                                if (SUM_COL < 675) {
                                    if (Q4CENT_AVGDIFF < 2.68) {
                                        if (Q3CENT_AVGDIFF < 0.75) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.75) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 2.68) {
                                        oneCount++;
                                    }
                                }
                                else if (SUM_COL >= 675) {
                                    oneCount++;
                                }
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 0.68) {
                        if (RANGE_MACRO_VALUE < 2.5) {
                            if (Q4CENT_AVGDIFF < 0.38) {
                                if (Q1CENT_AVGDIFF < 0.18) {
                                    if (SUM_COL < 18.5) {
                                        if (SUM_ROW_COL < 23.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 23.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 18.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 0.18) {
                                    if (MAX_MACRO_VALUE < 23.5) {
                                        if (Q1CENT_AVGDIFF < 0.67) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.67) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 23.5) {
                                        if (MIN_MACRO_VALUE < 36) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 36) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 0.38) {
                                if (Q4CENT_AVGDIFF < 0.76) {
                                    if (SUM_ROW < 81.5) {
                                        if (AVG_MACRO_VALUE < 23.82) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 23.82) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 81.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 0.76) {
                                    if (VARIANCE < 0.22) {
                                        oneCount++;
                                    }
                                    else if (VARIANCE >= 0.22) {
                                        if (MAX_MACRO_VALUE < 42.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 42.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 2.5) {
                            if (AVG_ROW < 0.31) {
                                if (AVG_MACRO_VALUE < 26.69) {
                                    if (Q3CENT_AVGDIFF < 0.14) {
                                        if (VARIANCE < 165.87) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 165.87) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.14) {
                                        if (MIN_MACRO_VALUE < 22.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 22.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 26.69) {
                                    if (AVG_MACRO_VALUE < 30.97) {
                                        if (Q1CENT_AVGDIFF < 0.43) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.43) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 30.97) {
                                        if (RANGE_MACRO_VALUE < 3.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 3.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_ROW >= 0.31) {
                                if (SUM_ROW_COL < 136.5) {
                                    if (Q2CENT_AVGDIFF < 1.01) {
                                        zeroCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 1.01) {
                                        if (SUM_ROW < 82) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 82) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 136.5) {
                                    if (VARIANCE < 0.58) {
                                        if (Q4CENT_AVGDIFF < 0.17) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.17) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 0.58) {
                                        if (AVG_ROW < 0.39) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 0.39) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 66.5) {
                    if (AVG_MACRO_VALUE < 64.73) {
                        if (AVG_MACRO_VALUE < 17.86) {
                            oneCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 17.86) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 64.73) {
                        if (Q1CENT_AVGDIFF < 0.28) {
                            if (SUM_COL < 88.5) {
                                if (Q1CENT_AVGDIFF < 0.26) {
                                    if (Q4CENT_AVGDIFF < 0.08) {
                                        if (MAX_MACRO_VALUE < 69) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 69) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.08) {
                                        if (AVG_COL < 0.27) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 0.27) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 0.26) {
                                    if (SUM_COL < 60) {
                                        oneCount++;
                                    }
                                    else if (SUM_COL >= 60) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (SUM_COL >= 88.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 0.28) {
                            if (AVG_ROW < 0.19) {
                                if (MAX_MACRO_VALUE < 130) {
                                    oneCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 130) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_ROW >= 0.19) {
                                if (Q2CENT_AVGDIFF < 0.28) {
                                    if (Q4CENT_AVGDIFF < 1.08) {
                                        if (Q1CENT_AVGDIFF < 0.29) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.29) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 1.08) {
                                        if (RANGE_MACRO_VALUE < 4.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 4.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 0.28) {
                                    if (AVG_COL < 0.57) {
                                        if (Q3CENT_AVGDIFF < 3.12) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 3.12) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 0.57) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (AVG_ROW >= 0.39) {
                if (RANGE_MACRO_VALUE < 49.5) {
                    if (RANGE_MACRO_VALUE < 48.5) {
                        if (VARIANCE < 127.85) {
                            if (Q2CENT_AVGDIFF < 26.46) {
                                if (AVG_ROW < 0.4) {
                                    if (Q1CENT_AVGDIFF < 0.4) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 0.4) {
                                        if (Q1CENT_AVGDIFF < 1.07) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 1.07) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 0.4) {
                                    if (MAX_MACRO_VALUE < 53.5) {
                                        if (SUM_COL < 166.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 166.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 53.5) {
                                        if (RANGE_MACRO_VALUE < 28.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 28.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 26.46) {
                                if (Q3CENT_AVGDIFF < 15.54) {
                                    zeroCount++;
                                }
                                else if (Q3CENT_AVGDIFF >= 15.54) {
                                    if (SUM_COL < 596.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_COL >= 596.5) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                        else if (VARIANCE >= 127.85) {
                            if (MIN_MACRO_VALUE < 65.5) {
                                if (SUM_ROW_COL < 1792.5) {
                                    if (RANGE_MACRO_VALUE < 47.5) {
                                        if (Q2CENT_AVGDIFF < 0.1) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.1) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 47.5) {
                                        if (MAX_MACRO_VALUE < 98.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 98.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 1792.5) {
                                    if (Q1CENT_AVGDIFF < 23.24) {
                                        if (AVG_MACRO_VALUE < 42.14) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.14) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 23.24) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 65.5) {
                                if (SUM_COL < 1436.5) {
                                    if (SUM_COL < 144.5) {
                                        if (VARIANCE < 199.71) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 199.71) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 144.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_COL >= 1436.5) {
                                    if (SUM_COL < 1523) {
                                        oneCount++;
                                    }
                                    else if (SUM_COL >= 1523) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 48.5) {
                        if (VARIANCE < 22.17) {
                            oneCount++;
                        }
                        else if (VARIANCE >= 22.17) {
                            if (SUM_ROW < 608.5) {
                                if (AVG_ROW < 2.51) {
                                    if (SUM_COL < 185) {
                                        if (Q1CENT_AVGDIFF < 3.65) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 3.65) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 185) {
                                        if (MIN_MACRO_VALUE < 16.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 16.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 2.51) {
                                    oneCount++;
                                }
                            }
                            else if (SUM_ROW >= 608.5) {
                                if (Q4CENT_AVGDIFF < 18.89) {
                                    if (AVG_MACRO_VALUE < 102.4) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 102.4) {
                                        if (MAX_MACRO_VALUE < 125.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 125.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 18.89) {
                                    if (Q4CENT_AVGDIFF < 19.14) {
                                        oneCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 19.14) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 49.5) {
                    if (SUM_ROW < 1025.5) {
                        if (SUM_COL < 310.5) {
                            if (MAX_MACRO_VALUE < 68.5) {
                                if (Q1CENT_AVGDIFF < 5) {
                                    zeroCount++;
                                }
                                else if (Q1CENT_AVGDIFF >= 5) {
                                    oneCount++;
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 68.5) {
                                if (VARIANCE < 136.13) {
                                    if (Q1CENT_AVGDIFF < 10.47) {
                                        if (Q1CENT_AVGDIFF < 5.26) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 5.26) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 10.47) {
                                        if (SUM_ROW < 905) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 905) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 136.13) {
                                    if (Q4CENT_AVGDIFF < 16.75) {
                                        if (Q4CENT_AVGDIFF < 13.75) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 13.75) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 16.75) {
                                        if (MIN_MACRO_VALUE < 82) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 82) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_COL >= 310.5) {
                            if (AVG_MACRO_VALUE < 26.43) {
                                if (Q3CENT_AVGDIFF < 17.28) {
                                    if (MIN_MACRO_VALUE < 17.5) {
                                        if (AVG_COL < 1.6) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 1.6) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 17.5) {
                                        if (AVG_MACRO_VALUE < 23.22) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 23.22) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 17.28) {
                                    if (SUM_ROW_COL < 1520) {
                                        if (SUM_ROW < 361.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 361.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 1520) {
                                        if (Q2CENT_AVGDIFF < 0.21) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.21) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 26.43) {
                                if (SUM_ROW < 125.5) {
                                    if (AVG_COL < 15.63) {
                                        zeroCount++;
                                    }
                                    else if (AVG_COL >= 15.63) {
                                        oneCount++;
                                    }
                                }
                                else if (SUM_ROW >= 125.5) {
                                    if (AVG_COL < 24.41) {
                                        if (Q4CENT_AVGDIFF < 31.68) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 31.68) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 24.41) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (SUM_ROW >= 1025.5) {
                        if (Q2CENT_AVGDIFF < 1.76) {
                            zeroCount++;
                        }
                        else if (Q2CENT_AVGDIFF >= 1.76) {
                            if (SUM_COL < 1737) {
                                if (VARIANCE < 230.47) {
                                    zeroCount++;
                                }
                                else if (VARIANCE >= 230.47) {
                                    if (AVG_COL < 4.68) {
                                        if (VARIANCE < 255.9) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 255.9) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 4.68) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (SUM_COL >= 1737) {
                                if (Q4CENT_AVGDIFF < 36.42) {
                                    if (SUM_ROW_COL < 3461) {
                                        if (VARIANCE < 368.08) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 368.08) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 3461) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 36.42) {
                                    oneCount++;
                                }
                            }
                        }
                    }
                }
            }
        }
        else if (SUM_ROW >= 1034.5) {
            if (VARIANCE < 117.04) {
                if (SUM_ROW < 2220.5) {
                    if (AVG_MACRO_VALUE < 64.58) {
                        if (AVG_MACRO_VALUE < 53.02) {
                            if (Q1CENT_AVGDIFF < 3.04) {
                                if (MAX_MACRO_VALUE < 70.5) {
                                    zeroCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 70.5) {
                                    if (Q4CENT_AVGDIFF < 2.31) {
                                        if (SUM_COL < 423) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 423) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 2.31) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (Q1CENT_AVGDIFF >= 3.04) {
                                if (Q4CENT_AVGDIFF < 10.29) {
                                    if (AVG_MACRO_VALUE < 49.33) {
                                        if (Q1CENT_AVGDIFF < 4.38) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 4.38) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 49.33) {
                                        if (SUM_COL < 1564.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 1564.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 10.29) {
                                    if (AVG_MACRO_VALUE < 34.26) {
                                        if (SUM_COL < 186.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 186.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 34.26) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 53.02) {
                            if (SUM_COL < 1093) {
                                if (MIN_MACRO_VALUE < 37.5) {
                                    if (RANGE_MACRO_VALUE < 41.5) {
                                        if (AVG_MACRO_VALUE < 53.27) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 53.27) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 41.5) {
                                        if (Q1CENT_AVGDIFF < 3.36) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 3.36) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 37.5) {
                                    if (Q4CENT_AVGDIFF < 1.21) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 1.21) {
                                        if (SUM_COL < 638.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 638.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_COL >= 1093) {
                                if (Q1CENT_AVGDIFF < 1.03) {
                                    if (MAX_MACRO_VALUE < 92) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 92) {
                                        oneCount++;
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 1.03) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 64.58) {
                        if (SUM_ROW_COL < 3089) {
                            if (Q1CENT_AVGDIFF < 3.79) {
                                if (AVG_MACRO_VALUE < 74.02) {
                                    if (RANGE_MACRO_VALUE < 43.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 43.5) {
                                        if (SUM_ROW < 1897) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 1897) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 74.02) {
                                    if (Q4CENT_AVGDIFF < 0.42) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.42) {
                                        if (Q2CENT_AVGDIFF < 12.42) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 12.42) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q1CENT_AVGDIFF >= 3.79) {
                                if (Q4CENT_AVGDIFF < 5.99) {
                                    if (RANGE_MACRO_VALUE < 50.5) {
                                        if (Q4CENT_AVGDIFF < 0.33) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.33) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 50.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 5.99) {
                                    if (MIN_MACRO_VALUE < 53.5) {
                                        if (Q4CENT_AVGDIFF < 13.19) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 13.19) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 53.5) {
                                        if (AVG_MACRO_VALUE < 102.66) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 102.66) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW_COL >= 3089) {
                            zeroCount++;
                        }
                    }
                }
                else if (SUM_ROW >= 2220.5) {
                    if (SUM_COL < 726.5) {
                        zeroCount++;
                    }
                    else if (SUM_COL >= 726.5) {
                        if (Q4CENT_AVGDIFF < 2.19) {
                            zeroCount++;
                        }
                        else if (Q4CENT_AVGDIFF >= 2.19) {
                            if (MAX_MACRO_VALUE < 91.5) {
                                zeroCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 91.5) {
                                if (Q1CENT_AVGDIFF < 16.07) {
                                    oneCount++;
                                }
                                else if (Q1CENT_AVGDIFF >= 16.07) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                }
            }
            else if (VARIANCE >= 117.04) {
                if (MIN_MACRO_VALUE < 157.5) {
                    if (VARIANCE < 117.71) {
                        if (RANGE_MACRO_VALUE < 47.5) {
                            zeroCount++;
                        }
                        else if (RANGE_MACRO_VALUE >= 47.5) {
                            if (Q3CENT_AVGDIFF < 2.57) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 2.57) {
                                if (SUM_ROW_COL < 3140.5) {
                                    if (AVG_MACRO_VALUE < 79.48) {
                                        if (MAX_MACRO_VALUE < 94.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 94.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 79.48) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_ROW_COL >= 3140.5) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (VARIANCE >= 117.71) {
                        if (VARIANCE < 121.7) {
                            if (Q4CENT_AVGDIFF < 2.82) {
                                if (MAX_MACRO_VALUE < 82.5) {
                                    zeroCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 82.5) {
                                    if (Q4CENT_AVGDIFF < 1.65) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 1.65) {
                                        if (RANGE_MACRO_VALUE < 61) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 61) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 2.82) {
                                if (RANGE_MACRO_VALUE < 41.5) {
                                    if (RANGE_MACRO_VALUE < 40.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 40.5) {
                                        if (AVG_COL < 3.49) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 3.49) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 41.5) {
                                    if (Q4CENT_AVGDIFF < 24.99) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 24.99) {
                                        if (SUM_ROW < 1703) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 1703) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (VARIANCE >= 121.7) {
                            if (VARIANCE < 123.28) {
                                if (AVG_MACRO_VALUE < 69.6) {
                                    if (MAX_MACRO_VALUE < 80.5) {
                                        if (SUM_ROW_COL < 2809) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 2809) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 80.5) {
                                        if (SUM_ROW < 1601.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 1601.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 69.6) {
                                    if (MAX_MACRO_VALUE < 129) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 129) {
                                        if (SUM_COL < 1134) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 1134) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (VARIANCE >= 123.28) {
                                if (SUM_ROW < 3682.5) {
                                    if (VARIANCE < 736.84) {
                                        if (SUM_ROW_COL < 6426.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 6426.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 736.84) {
                                        if (AVG_MACRO_VALUE < 190.92) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 190.92) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 3682.5) {
                                    if (AVG_ROW < 15.63) {
                                        if (SUM_ROW < 3744.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 3744.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 15.63) {
                                        if (MAX_MACRO_VALUE < 228.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 228.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 157.5) {
                    zeroCount++;
                }
            }
        }
        
    //TREE 4
    if (SUM_ROW < 1035.5) {
            if (SUM_ROW < 94.5) {
                if (MAX_MACRO_VALUE < 66.5) {
                    if (SUM_ROW_COL < 747.5) {
                        if (Q1CENT_AVGDIFF < 2.85) {
                            if (SUM_COL < 4.5) {
                                if (SUM_ROW_COL < 2.5) {
                                    if (SUM_COL < 0.5) {
                                        if (MIN_MACRO_VALUE < 17.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 17.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 0.5) {
                                        if (Q1CENT_AVGDIFF < 0.01) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.01) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 2.5) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_COL >= 4.5) {
                                if (AVG_MACRO_VALUE < 16.94) {
                                    if (MIN_MACRO_VALUE < 15.5) {
                                        oneCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 15.5) {
                                        if (VARIANCE < 0.17) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 0.17) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 16.94) {
                                    if (AVG_MACRO_VALUE < 23.91) {
                                        if (SUM_ROW_COL < 59.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 59.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 23.91) {
                                        if (Q1CENT_AVGDIFF < 0.49) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.49) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 2.85) {
                            if (AVG_MACRO_VALUE < 26.99) {
                                if (VARIANCE < 142.79) {
                                    if (SUM_COL < 595.5) {
                                        if (Q1CENT_AVGDIFF < 6.78) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 6.78) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 595.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (VARIANCE >= 142.79) {
                                    oneCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 26.99) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 747.5) {
                        if (Q2CENT_AVGDIFF < 2.53) {
                            if (VARIANCE < 241.8) {
                                if (SUM_ROW < 84) {
                                    oneCount++;
                                }
                                else if (SUM_ROW >= 84) {
                                    if (AVG_COL < 2.85) {
                                        oneCount++;
                                    }
                                    else if (AVG_COL >= 2.85) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (VARIANCE >= 241.8) {
                                if (VARIANCE < 249.61) {
                                    if (VARIANCE < 247.81) {
                                        if (SUM_COL < 1345) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 1345) {
                                            oneCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 247.81) {
                                        zeroCount++;
                                    }
                                }
                                else if (VARIANCE >= 249.61) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 2.53) {
                            if (Q2CENT_AVGDIFF < 5.13) {
                                zeroCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 5.13) {
                                if (AVG_ROW < 0.31) {
                                    if (AVG_MACRO_VALUE < 32.79) {
                                        if (Q4CENT_AVGDIFF < 17.69) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 17.69) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 32.79) {
                                        if (Q1CENT_AVGDIFF < 5.46) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 5.46) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 0.31) {
                                    if (SUM_ROW < 74.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW >= 74.5) {
                                        if (AVG_MACRO_VALUE < 26.01) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 26.01) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 66.5) {
                    if (Q3CENT_AVGDIFF < 0.32) {
                        if (Q1CENT_AVGDIFF < 0.29) {
                            if (AVG_MACRO_VALUE < 168.3) {
                                if (SUM_COL < 78.5) {
                                    if (SUM_ROW < 78) {
                                        if (SUM_COL < 64.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 64.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 78) {
                                        if (SUM_COL < 71) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 71) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 78.5) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 168.3) {
                                if (AVG_MACRO_VALUE < 233.05) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 233.05) {
                                    if (SUM_ROW_COL < 173.5) {
                                        oneCount++;
                                    }
                                    else if (SUM_ROW_COL >= 173.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 0.29) {
                            if (AVG_COL < 0.26) {
                                if (SUM_ROW_COL < 138.5) {
                                    if (RANGE_MACRO_VALUE < 4.5) {
                                        if (SUM_COL < 42) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 42) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 4.5) {
                                        oneCount++;
                                    }
                                }
                                else if (SUM_ROW_COL >= 138.5) {
                                    oneCount++;
                                }
                            }
                            else if (AVG_COL >= 0.26) {
                                if (SUM_ROW_COL < 165.5) {
                                    if (SUM_COL < 66.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_COL >= 66.5) {
                                        if (SUM_ROW_COL < 124) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 124) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 165.5) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 0.32) {
                        if (AVG_MACRO_VALUE < 64.75) {
                            if (MIN_MACRO_VALUE < 17) {
                                oneCount++;
                            }
                            else if (MIN_MACRO_VALUE >= 17) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 64.75) {
                            if (AVG_MACRO_VALUE < 65.43) {
                                if (SUM_ROW < 92.5) {
                                    if (Q2CENT_AVGDIFF < 1.74) {
                                        zeroCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 1.74) {
                                        if (SUM_COL < 131) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 131) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 92.5) {
                                    oneCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 65.43) {
                                if (VARIANCE < 1.03) {
                                    if (SUM_COL < 69.5) {
                                        if (VARIANCE < 0.47) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 0.47) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 69.5) {
                                        if (MAX_MACRO_VALUE < 156.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 156.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 1.03) {
                                    if (AVG_ROW < 0.38) {
                                        if (SUM_ROW < 89.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 89.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 0.38) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (SUM_ROW >= 94.5) {
                if (RANGE_MACRO_VALUE < 45.5) {
                    if (VARIANCE < 300.35) {
                        if (SUM_COL < 898.5) {
                            if (Q3CENT_AVGDIFF < 4.38) {
                                if (Q3CENT_AVGDIFF < 3.92) {
                                    if (AVG_MACRO_VALUE < 43.19) {
                                        if (SUM_ROW_COL < 1566) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1566) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 43.19) {
                                        if (Q4CENT_AVGDIFF < 0.22) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.22) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 3.92) {
                                    if (SUM_ROW_COL < 1144.5) {
                                        if (MIN_MACRO_VALUE < 62.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 62.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 1144.5) {
                                        if (SUM_ROW < 972.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 972.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 4.38) {
                                if (Q3CENT_AVGDIFF < 4.46) {
                                    if (AVG_MACRO_VALUE < 35.05) {
                                        if (SUM_COL < 208) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 208) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 35.05) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 4.46) {
                                    if (SUM_ROW_COL < 1700.5) {
                                        if (SUM_COL < 847.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 847.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 1700.5) {
                                        if (MAX_MACRO_VALUE < 86) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 86) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_COL >= 898.5) {
                            if (SUM_COL < 904.5) {
                                if (RANGE_MACRO_VALUE < 28.5) {
                                    zeroCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 28.5) {
                                    if (Q1CENT_AVGDIFF < 2.46) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 2.46) {
                                        if (Q2CENT_AVGDIFF < 3.62) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 3.62) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_COL >= 904.5) {
                                if (SUM_ROW < 893) {
                                    if (VARIANCE < 52.79) {
                                        if (MIN_MACRO_VALUE < 48.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 48.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 52.79) {
                                        if (SUM_ROW < 890.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 890.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 893) {
                                    if (MAX_MACRO_VALUE < 70.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 70.5) {
                                        if (AVG_ROW < 4.12) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 4.12) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (VARIANCE >= 300.35) {
                        if (AVG_MACRO_VALUE < 47.71) {
                            if (Q3CENT_AVGDIFF < 31.88) {
                                oneCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 31.88) {
                                if (MIN_MACRO_VALUE < 17) {
                                    if (AVG_ROW < 1.81) {
                                        oneCount++;
                                    }
                                    else if (AVG_ROW >= 1.81) {
                                        zeroCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 17) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 47.71) {
                            zeroCount++;
                        }
                    }
                }
                else if (RANGE_MACRO_VALUE >= 45.5) {
                    if (AVG_COL < 2.56) {
                        if (SUM_COL < 605.5) {
                            if (AVG_ROW < 0.64) {
                                if (Q1CENT_AVGDIFF < 0.04) {
                                    oneCount++;
                                }
                                else if (Q1CENT_AVGDIFF >= 0.04) {
                                    if (RANGE_MACRO_VALUE < 63) {
                                        if (AVG_MACRO_VALUE < 64.28) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 64.28) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 63) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (AVG_ROW >= 0.64) {
                                if (SUM_ROW < 335.5) {
                                    if (MAX_MACRO_VALUE < 118.5) {
                                        if (Q4CENT_AVGDIFF < 0.13) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.13) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 118.5) {
                                        if (AVG_ROW < 0.95) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 0.95) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 335.5) {
                                    if (RANGE_MACRO_VALUE < 55.5) {
                                        if (Q4CENT_AVGDIFF < 1.51) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 1.51) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 55.5) {
                                        if (Q2CENT_AVGDIFF < 20.32) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 20.32) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_COL >= 605.5) {
                            if (Q2CENT_AVGDIFF < 0.83) {
                                if (MIN_MACRO_VALUE < 39) {
                                    zeroCount++;
                                }
                                else if (MIN_MACRO_VALUE >= 39) {
                                    if (RANGE_MACRO_VALUE < 69) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 69) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 0.83) {
                                if (SUM_ROW_COL < 1004) {
                                    if (SUM_COL < 608.5) {
                                        oneCount++;
                                    }
                                    else if (SUM_COL >= 608.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_ROW_COL >= 1004) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (AVG_COL >= 2.56) {
                        if (VARIANCE < 70.39) {
                            if (AVG_COL < 3.66) {
                                if (SUM_COL < 832) {
                                    if (Q4CENT_AVGDIFF < 1.19) {
                                        if (AVG_MACRO_VALUE < 81.32) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 81.32) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 1.19) {
                                        if (MAX_MACRO_VALUE < 135.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 135.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 832) {
                                    if (AVG_ROW < 3.29) {
                                        if (SUM_ROW < 647.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 647.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 3.29) {
                                        if (SUM_COL < 877) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 877) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_COL >= 3.66) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 70.39) {
                            if (AVG_COL < 2.61) {
                                if (Q3CENT_AVGDIFF < 10.18) {
                                    if (Q1CENT_AVGDIFF < 0.63) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 0.63) {
                                        if (VARIANCE < 156.74) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 156.74) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 10.18) {
                                    if (RANGE_MACRO_VALUE < 58.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 58.5) {
                                        if (AVG_MACRO_VALUE < 94.44) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 94.44) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_COL >= 2.61) {
                                if (VARIANCE < 70.9) {
                                    if (AVG_ROW < 3.11) {
                                        zeroCount++;
                                    }
                                    else if (AVG_ROW >= 3.11) {
                                        if (SUM_ROW < 941) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 941) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 70.9) {
                                    if (SUM_COL < 634.5) {
                                        if (MIN_MACRO_VALUE < 42.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 42.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 634.5) {
                                        if (AVG_MACRO_VALUE < 84.12) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 84.12) {
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
        else if (SUM_ROW >= 1035.5) {
            if (RANGE_MACRO_VALUE < 52.5) {
                if (VARIANCE < 215) {
                    if (MAX_MACRO_VALUE < 124.5) {
                        if (SUM_ROW < 1910.5) {
                            if (RANGE_MACRO_VALUE < 28.5) {
                                if (SUM_ROW_COL < 1236) {
                                    oneCount++;
                                }
                                else if (SUM_ROW_COL >= 1236) {
                                    zeroCount++;
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 28.5) {
                                if (SUM_COL < 951.5) {
                                    if (Q3CENT_AVGDIFF < 19.88) {
                                        if (Q2CENT_AVGDIFF < 25.72) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 25.72) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 19.88) {
                                        if (SUM_COL < 661.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 661.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 951.5) {
                                    if (SUM_COL < 1050) {
                                        if (SUM_ROW_COL < 2210.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 2210.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 1050) {
                                        if (VARIANCE < 70.17) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 70.17) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW >= 1910.5) {
                            if (MAX_MACRO_VALUE < 111.5) {
                                if (MAX_MACRO_VALUE < 99.5) {
                                    if (AVG_MACRO_VALUE < 72.58) {
                                        if (Q4CENT_AVGDIFF < 4.18) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 4.18) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 72.58) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 99.5) {
                                    zeroCount++;
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 111.5) {
                                if (SUM_COL < 1279.5) {
                                    if (AVG_ROW < 8.05) {
                                        zeroCount++;
                                    }
                                    else if (AVG_ROW >= 8.05) {
                                        if (VARIANCE < 160.15) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 160.15) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 1279.5) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 124.5) {
                        if (VARIANCE < 46.37) {
                            if (Q2CENT_AVGDIFF < 0.65) {
                                oneCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 0.65) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 46.37) {
                            zeroCount++;
                        }
                    }
                }
                else if (VARIANCE >= 215) {
                    if (AVG_ROW < 4.75) {
                        if (AVG_MACRO_VALUE < 49.51) {
                            if (Q4CENT_AVGDIFF < 19.44) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 19.44) {
                                if (SUM_COL < 513.5) {
                                    oneCount++;
                                }
                                else if (SUM_COL >= 513.5) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 49.51) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_ROW >= 4.75) {
                        if (AVG_ROW < 4.99) {
                            if (AVG_MACRO_VALUE < 115.34) {
                                if (Q4CENT_AVGDIFF < 13.22) {
                                    if (Q2CENT_AVGDIFF < 15.03) {
                                        oneCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 15.03) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 13.22) {
                                    oneCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 115.34) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_ROW >= 4.99) {
                            if (SUM_ROW_COL < 2875.5) {
                                if (Q2CENT_AVGDIFF < 25.18) {
                                    if (SUM_COL < 748) {
                                        if (Q3CENT_AVGDIFF < 15.01) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 15.01) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 748) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 25.18) {
                                    if (Q3CENT_AVGDIFF < 13.83) {
                                        zeroCount++;
                                    }
                                    else if (Q3CENT_AVGDIFF >= 13.83) {
                                        if (Q2CENT_AVGDIFF < 25.33) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 25.33) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW_COL >= 2875.5) {
                                if (SUM_ROW_COL < 4037.5) {
                                    oneCount++;
                                }
                                else if (SUM_ROW_COL >= 4037.5) {
                                    if (Q1CENT_AVGDIFF < 4.06) {
                                        oneCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 4.06) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 52.5) {
                if (SUM_ROW < 3638.5) {
                    if (AVG_ROW < 4.32) {
                        if (AVG_MACRO_VALUE < 62.13) {
                            if (AVG_ROW < 4.32) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 4.32) {
                                if (SUM_COL < 1234) {
                                    zeroCount++;
                                }
                                else if (SUM_COL >= 1234) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 62.13) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_ROW >= 4.32) {
                        if (SUM_ROW_COL < 1385.5) {
                            if (Q4CENT_AVGDIFF < 3.76) {
                                if (SUM_ROW < 1128.5) {
                                    oneCount++;
                                }
                                else if (SUM_ROW >= 1128.5) {
                                    if (SUM_ROW < 1191.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW >= 1191.5) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 3.76) {
                                if (AVG_ROW < 4.58) {
                                    if (MAX_MACRO_VALUE < 94) {
                                        if (VARIANCE < 254.79) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 254.79) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 94) {
                                        if (Q1CENT_AVGDIFF < 18.19) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 18.19) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 4.58) {
                                    if (AVG_ROW < 4.75) {
                                        if (Q4CENT_AVGDIFF < 35.63) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 35.63) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 4.75) {
                                        if (SUM_COL < 154.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 154.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW_COL >= 1385.5) {
                            if (MAX_MACRO_VALUE < 78.5) {
                                if (VARIANCE < 284.8) {
                                    if (SUM_ROW < 1451.5) {
                                        if (Q1CENT_AVGDIFF < 12.94) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 12.94) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 1451.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (VARIANCE >= 284.8) {
                                    if (SUM_COL < 479) {
                                        if (Q1CENT_AVGDIFF < 27.65) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 27.65) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 479) {
                                        if (SUM_COL < 2632) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 2632) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 78.5) {
                                if (AVG_MACRO_VALUE < 78.81) {
                                    if (VARIANCE < 665.26) {
                                        if (AVG_COL < 8.12) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 8.12) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 665.26) {
                                        if (MIN_MACRO_VALUE < 36.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 36.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 78.81) {
                                    if (SUM_COL < 1010.5) {
                                        if (Q2CENT_AVGDIFF < 1.57) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 1.57) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 1010.5) {
                                        if (AVG_COL < 4.35) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 4.35) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (SUM_ROW >= 3638.5) {
                    if (AVG_ROW < 15.63) {
                        if (RANGE_MACRO_VALUE < 88.5) {
                            if (Q3CENT_AVGDIFF < 45.32) {
                                if (Q1CENT_AVGDIFF < 7.9) {
                                    zeroCount++;
                                }
                                else if (Q1CENT_AVGDIFF >= 7.9) {
                                    oneCount++;
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 45.32) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 88.5) {
                            if (Q4CENT_AVGDIFF < 48.43) {
                                if (VARIANCE < 720.36) {
                                    if (SUM_ROW < 3684.5) {
                                        if (Q2CENT_AVGDIFF < 24.68) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 24.68) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 3684.5) {
                                        if (MAX_MACRO_VALUE < 118) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 118) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 720.36) {
                                    if (VARIANCE < 984) {
                                        if (SUM_COL < 1808.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 1808.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 984) {
                                        if (SUM_COL < 3777) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 3777) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 48.43) {
                                if (SUM_ROW < 3729) {
                                    if (MIN_MACRO_VALUE < 21.5) {
                                        if (AVG_ROW < 15.5) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 15.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 21.5) {
                                        if (MAX_MACRO_VALUE < 210) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 210) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 3729) {
                                    if (RANGE_MACRO_VALUE < 158) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 158) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (AVG_ROW >= 15.63) {
                        if (Q1CENT_AVGDIFF < 47.32) {
                            if (AVG_MACRO_VALUE < 82.12) {
                                if (VARIANCE < 446.05) {
                                    if (RANGE_MACRO_VALUE < 81.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 81.5) {
                                        oneCount++;
                                    }
                                }
                                else if (VARIANCE >= 446.05) {
                                    if (MIN_MACRO_VALUE < 15.5) {
                                        if (RANGE_MACRO_VALUE < 194.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 194.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 15.5) {
                                        if (RANGE_MACRO_VALUE < 196.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 196.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 82.12) {
                                if (Q3CENT_AVGDIFF < 55.61) {
                                    if (Q2CENT_AVGDIFF < 62.68) {
                                        if (Q4CENT_AVGDIFF < 27.9) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 27.9) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 62.68) {
                                        if (VARIANCE < 1805.72) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 1805.72) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 55.61) {
                                    if (MIN_MACRO_VALUE < 63.5) {
                                        if (VARIANCE < 6026.56) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 6026.56) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 63.5) {
                                        if (Q1CENT_AVGDIFF < 16.13) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 16.13) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 47.32) {
                            if (SUM_ROW_COL < 6990) {
                                if (AVG_COL < 6.13) {
                                    if (AVG_MACRO_VALUE < 160.13) {
                                        if (MIN_MACRO_VALUE < 65.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 65.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 160.13) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_COL >= 6.13) {
                                    if (SUM_ROW_COL < 5705.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW_COL >= 5705.5) {
                                        if (MIN_MACRO_VALUE < 17.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 17.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW_COL >= 6990) {
                                if (Q2CENT_AVGDIFF < 58.29) {
                                    if (MIN_MACRO_VALUE < 84.5) {
                                        if (SUM_ROW_COL < 7155.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 7155.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 84.5) {
                                        if (AVG_ROW < 18.85) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 18.85) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 58.29) {
                                    if (Q4CENT_AVGDIFF < 2.79) {
                                        if (MIN_MACRO_VALUE < 20) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 20) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 2.79) {
                                        if (Q2CENT_AVGDIFF < 87.85) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 87.85) {
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
        
    //TREE 5
    if (RANGE_MACRO_VALUE < 52.5) {
            if (AVG_ROW < 0.39) {
                if (MIN_MACRO_VALUE < 50.5) {
                    if (SUM_COL < 4.5) {
                        if (AVG_ROW < 0.01) {
                            if (MAX_MACRO_VALUE < 22.5) {
                                if (MAX_MACRO_VALUE < 17.5) {
                                    oneCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 17.5) {
                                    if (AVG_MACRO_VALUE < 19) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 19) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 22.5) {
                                if (Q2CENT_AVGDIFF < 0.01) {
                                    if (AVG_MACRO_VALUE < 26.5) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 26.5) {
                                        if (VARIANCE < 0) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 0) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 0.01) {
                                    if (AVG_MACRO_VALUE < 23.5) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 23.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (AVG_ROW >= 0.01) {
                            zeroCount++;
                        }
                    }
                    else if (SUM_COL >= 4.5) {
                        if (AVG_ROW < 0.07) {
                            if (VARIANCE < 0.1) {
                                if (VARIANCE < 0.08) {
                                    if (AVG_MACRO_VALUE < 23.99) {
                                        if (Q1CENT_AVGDIFF < 0.13) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.13) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 23.99) {
                                        zeroCount++;
                                    }
                                }
                                else if (VARIANCE >= 0.08) {
                                    zeroCount++;
                                }
                            }
                            else if (VARIANCE >= 0.1) {
                                if (VARIANCE < 0.14) {
                                    if (Q4CENT_AVGDIFF < 0.5) {
                                        if (Q2CENT_AVGDIFF < 0.19) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.19) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (VARIANCE >= 0.14) {
                                    if (VARIANCE < 0.17) {
                                        zeroCount++;
                                    }
                                    else if (VARIANCE >= 0.17) {
                                        if (Q1CENT_AVGDIFF < 0.96) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.96) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_ROW >= 0.07) {
                            if (Q2CENT_AVGDIFF < 0.68) {
                                if (MAX_MACRO_VALUE < 59.5) {
                                    if (Q4CENT_AVGDIFF < 0.22) {
                                        if (MIN_MACRO_VALUE < 24.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 24.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.22) {
                                        if (AVG_MACRO_VALUE < 45.44) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 45.44) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 59.5) {
                                    if (VARIANCE < 245.24) {
                                        if (Q1CENT_AVGDIFF < 7.31) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 7.31) {
                                            oneCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 245.24) {
                                        if (VARIANCE < 249.61) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 249.61) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 0.68) {
                                if (AVG_MACRO_VALUE < 26.68) {
                                    if (AVG_MACRO_VALUE < 20.73) {
                                        if (Q2CENT_AVGDIFF < 1.01) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 1.01) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 20.73) {
                                        if (MAX_MACRO_VALUE < 22.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 22.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 26.68) {
                                    if (AVG_ROW < 0.31) {
                                        if (AVG_MACRO_VALUE < 26.79) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 26.79) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 0.31) {
                                        if (SUM_COL < 80.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 80.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 50.5) {
                    if (SUM_ROW < 42.5) {
                        if (Q2CENT_AVGDIFF < 0.08) {
                            zeroCount++;
                        }
                        else if (Q2CENT_AVGDIFF >= 0.08) {
                            if (Q1CENT_AVGDIFF < 0.54) {
                                oneCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 0.54) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW >= 42.5) {
                        if (AVG_MACRO_VALUE < 54.04) {
                            zeroCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 54.04) {
                            if (MAX_MACRO_VALUE < 59.5) {
                                if (Q2CENT_AVGDIFF < 0.93) {
                                    if (Q3CENT_AVGDIFF < 1.5) {
                                        zeroCount++;
                                    }
                                    else if (Q3CENT_AVGDIFF >= 1.5) {
                                        if (Q2CENT_AVGDIFF < 0.72) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.72) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 0.93) {
                                    zeroCount++;
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 59.5) {
                                if (Q4CENT_AVGDIFF < 0.96) {
                                    if (Q1CENT_AVGDIFF < 0.22) {
                                        if (Q1CENT_AVGDIFF < 0.21) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.21) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 0.22) {
                                        if (Q2CENT_AVGDIFF < 1.9) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 1.9) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 0.96) {
                                    if (Q2CENT_AVGDIFF < 1.08) {
                                        if (Q3CENT_AVGDIFF < 1.76) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 1.76) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 1.08) {
                                        if (VARIANCE < 1.7) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 1.7) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (AVG_ROW >= 0.39) {
                if (VARIANCE < 241.4) {
                    if (AVG_ROW < 2.95) {
                        if (MAX_MACRO_VALUE < 83.5) {
                            if (SUM_ROW < 370.5) {
                                if (RANGE_MACRO_VALUE < 25.5) {
                                    if (SUM_ROW_COL < 663.5) {
                                        if (VARIANCE < 28.64) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 28.64) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 663.5) {
                                        if (SUM_ROW < 296.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 296.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 25.5) {
                                    if (SUM_ROW < 246.5) {
                                        if (Q3CENT_AVGDIFF < 2.89) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 2.89) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 246.5) {
                                        if (Q1CENT_AVGDIFF < 14.74) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 14.74) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW >= 370.5) {
                                if (MAX_MACRO_VALUE < 54.5) {
                                    if (Q2CENT_AVGDIFF < 0.39) {
                                        if (MIN_MACRO_VALUE < 28.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 28.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 0.39) {
                                        if (AVG_MACRO_VALUE < 45.28) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 45.28) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 54.5) {
                                    if (Q4CENT_AVGDIFF < 0.49) {
                                        if (Q4CENT_AVGDIFF < 0.04) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.04) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.49) {
                                        if (SUM_ROW_COL < 1587.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1587.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 83.5) {
                            if (AVG_ROW < 2.91) {
                                if (AVG_MACRO_VALUE < 63.37) {
                                    if (MAX_MACRO_VALUE < 89.5) {
                                        if (VARIANCE < 26.05) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 26.05) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 89.5) {
                                        if (SUM_ROW_COL < 631.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 631.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 63.37) {
                                    if (MIN_MACRO_VALUE < 53.5) {
                                        if (AVG_COL < 5.72) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 5.72) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 53.5) {
                                        if (RANGE_MACRO_VALUE < 29.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 29.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_ROW >= 2.91) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (AVG_ROW >= 2.95) {
                        if (Q2CENT_AVGDIFF < 0.46) {
                            if (Q1CENT_AVGDIFF < 2.67) {
                                if (Q3CENT_AVGDIFF < 6.01) {
                                    if (Q3CENT_AVGDIFF < 0.65) {
                                        if (SUM_ROW_COL < 1460) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1460) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.65) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 6.01) {
                                    if (MAX_MACRO_VALUE < 71.5) {
                                        if (VARIANCE < 100.07) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 100.07) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 71.5) {
                                        if (AVG_COL < 2.91) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 2.91) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q1CENT_AVGDIFF >= 2.67) {
                                if (RANGE_MACRO_VALUE < 37.5) {
                                    zeroCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 37.5) {
                                    if (SUM_ROW < 1741) {
                                        if (SUM_COL < 605.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 605.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 1741) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 0.46) {
                            if (RANGE_MACRO_VALUE < 31.5) {
                                if (AVG_MACRO_VALUE < 77.47) {
                                    if (SUM_COL < 848) {
                                        if (Q3CENT_AVGDIFF < 0.26) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.26) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 848) {
                                        if (AVG_ROW < 3.07) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 3.07) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 77.47) {
                                    if (SUM_COL < 441.5) {
                                        if (Q2CENT_AVGDIFF < 13.79) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 13.79) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 441.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 31.5) {
                                if (Q1CENT_AVGDIFF < 25.6) {
                                    if (Q1CENT_AVGDIFF < 20.38) {
                                        if (Q4CENT_AVGDIFF < 15.93) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 15.93) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 20.38) {
                                        if (Q4CENT_AVGDIFF < 4.43) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 4.43) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 25.6) {
                                    if (AVG_ROW < 5.28) {
                                        zeroCount++;
                                    }
                                    else if (AVG_ROW >= 5.28) {
                                        if (SUM_ROW < 1382.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 1382.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (VARIANCE >= 241.4) {
                    if (Q4CENT_AVGDIFF < 0.72) {
                        if (Q1CENT_AVGDIFF < 14.85) {
                            if (Q1CENT_AVGDIFF < 4.01) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 4.01) {
                                oneCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 14.85) {
                            zeroCount++;
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 0.72) {
                        if (AVG_COL < 4) {
                            if (MIN_MACRO_VALUE < 33.5) {
                                if (VARIANCE < 278.11) {
                                    if (Q2CENT_AVGDIFF < 28.03) {
                                        if (VARIANCE < 264.86) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 264.86) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 28.03) {
                                        zeroCount++;
                                    }
                                }
                                else if (VARIANCE >= 278.11) {
                                    if (Q2CENT_AVGDIFF < 3.72) {
                                        if (RANGE_MACRO_VALUE < 42.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 42.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 3.72) {
                                        if (SUM_COL < 94.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 94.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 33.5) {
                                if (Q2CENT_AVGDIFF < 23.15) {
                                    if (SUM_ROW < 1152.5) {
                                        if (AVG_COL < 3.29) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 3.29) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 1152.5) {
                                        if (RANGE_MACRO_VALUE < 43.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 43.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 23.15) {
                                    if (SUM_ROW_COL < 783.5) {
                                        oneCount++;
                                    }
                                    else if (SUM_ROW_COL >= 783.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (AVG_COL >= 4) {
                            if (SUM_COL < 2871) {
                                if (MAX_MACRO_VALUE < 116) {
                                    if (Q1CENT_AVGDIFF < 3.97) {
                                        oneCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 3.97) {
                                        if (AVG_MACRO_VALUE < 66.69) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 66.69) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 116) {
                                    if (AVG_COL < 6.23) {
                                        oneCount++;
                                    }
                                    else if (AVG_COL >= 6.23) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (SUM_COL >= 2871) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 52.5) {
            if (AVG_ROW < 2.92) {
                if (MAX_MACRO_VALUE < 89.5) {
                    if (SUM_COL < 1178.5) {
                        if (Q2CENT_AVGDIFF < 6.6) {
                            if (MIN_MACRO_VALUE < 16.5) {
                                if (Q1CENT_AVGDIFF < 0.57) {
                                    if (RANGE_MACRO_VALUE < 64.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 64.5) {
                                        oneCount++;
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 0.57) {
                                    oneCount++;
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 16.5) {
                                if (Q3CENT_AVGDIFF < 10.46) {
                                    if (AVG_ROW < 2.55) {
                                        if (Q3CENT_AVGDIFF < 8.28) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 8.28) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 2.55) {
                                        if (Q3CENT_AVGDIFF < 7.61) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 7.61) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 10.46) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 6.6) {
                            if (RANGE_MACRO_VALUE < 66.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 66.5) {
                                if (MIN_MACRO_VALUE < 18) {
                                    if (Q1CENT_AVGDIFF < 14.6) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 14.6) {
                                        oneCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 18) {
                                    oneCount++;
                                }
                            }
                        }
                    }
                    else if (SUM_COL >= 1178.5) {
                        if (Q4CENT_AVGDIFF < 0.65) {
                            oneCount++;
                        }
                        else if (Q4CENT_AVGDIFF >= 0.65) {
                            zeroCount++;
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 89.5) {
                    if (MIN_MACRO_VALUE < 30.5) {
                        if (SUM_COL < 455.5) {
                            if (AVG_COL < 1.66) {
                                if (VARIANCE < 224.63) {
                                    if (AVG_ROW < 2.44) {
                                        if (AVG_COL < 1.1) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 1.1) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 2.44) {
                                        oneCount++;
                                    }
                                }
                                else if (VARIANCE >= 224.63) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_COL >= 1.66) {
                                if (MIN_MACRO_VALUE < 21.5) {
                                    if (Q3CENT_AVGDIFF < 0.19) {
                                        oneCount++;
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.19) {
                                        if (Q4CENT_AVGDIFF < 0.07) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.07) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 21.5) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (SUM_COL >= 455.5) {
                            if (RANGE_MACRO_VALUE < 204.5) {
                                if (Q4CENT_AVGDIFF < 19) {
                                    if (RANGE_MACRO_VALUE < 100.5) {
                                        if (SUM_COL < 2149) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 2149) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 100.5) {
                                        if (Q4CENT_AVGDIFF < 3.9) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 3.9) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 19) {
                                    if (RANGE_MACRO_VALUE < 104.5) {
                                        if (RANGE_MACRO_VALUE < 88.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 88.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 104.5) {
                                        if (SUM_ROW_COL < 5942.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 5942.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 204.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MIN_MACRO_VALUE >= 30.5) {
                        if (Q2CENT_AVGDIFF < 5.74) {
                            if (RANGE_MACRO_VALUE < 80.5) {
                                if (AVG_ROW < 2.6) {
                                    if (Q4CENT_AVGDIFF < 17.18) {
                                        if (Q1CENT_AVGDIFF < 33.64) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 33.64) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 17.18) {
                                        if (AVG_COL < 2.29) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 2.29) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 2.6) {
                                    if (SUM_COL < 792) {
                                        if (SUM_ROW_COL < 830.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 830.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 792) {
                                        if (AVG_ROW < 2.91) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 2.91) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 80.5) {
                                if (MIN_MACRO_VALUE < 42.5) {
                                    if (Q1CENT_AVGDIFF < 8.76) {
                                        if (AVG_COL < 1.03) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 1.03) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 8.76) {
                                        if (Q1CENT_AVGDIFF < 20.71) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 20.71) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 42.5) {
                                    if (RANGE_MACRO_VALUE < 168) {
                                        if (MAX_MACRO_VALUE < 177.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 177.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 168) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 5.74) {
                            if (Q2CENT_AVGDIFF < 6.65) {
                                if (VARIANCE < 190.54) {
                                    if (Q3CENT_AVGDIFF < 2.57) {
                                        if (Q1CENT_AVGDIFF < 2.94) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 2.94) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 2.57) {
                                        if (MAX_MACRO_VALUE < 92) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 92) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 190.54) {
                                    if (Q2CENT_AVGDIFF < 5.78) {
                                        oneCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 5.78) {
                                        if (AVG_COL < 2.58) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 2.58) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 6.65) {
                                if (Q2CENT_AVGDIFF < 7.04) {
                                    zeroCount++;
                                }
                                else if (Q2CENT_AVGDIFF >= 7.04) {
                                    if (SUM_ROW < 687.5) {
                                        if (SUM_COL < 903.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 903.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 687.5) {
                                        if (RANGE_MACRO_VALUE < 62.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 62.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (AVG_ROW >= 2.92) {
                if (SUM_ROW < 800.5) {
                    if (Q4CENT_AVGDIFF < 14.47) {
                        if (SUM_ROW_COL < 1833) {
                            if (AVG_COL < 3.97) {
                                if (VARIANCE < 117.09) {
                                    if (AVG_COL < 3.47) {
                                        if (SUM_ROW_COL < 1440.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1440.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 3.47) {
                                        if (MIN_MACRO_VALUE < 25) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 25) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 117.09) {
                                    if (SUM_COL < 914.5) {
                                        if (Q2CENT_AVGDIFF < 0.82) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.82) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 914.5) {
                                        if (Q2CENT_AVGDIFF < 12.26) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 12.26) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_COL >= 3.97) {
                                if (Q2CENT_AVGDIFF < 0.47) {
                                    oneCount++;
                                }
                                else if (Q2CENT_AVGDIFF >= 0.47) {
                                    if (MAX_MACRO_VALUE < 199.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 199.5) {
                                        if (MIN_MACRO_VALUE < 55.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 55.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW_COL >= 1833) {
                            if (AVG_COL < 6.81) {
                                if (MIN_MACRO_VALUE < 111) {
                                    if (RANGE_MACRO_VALUE < 66.5) {
                                        if (AVG_MACRO_VALUE < 57.42) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 57.42) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 66.5) {
                                        if (SUM_ROW_COL < 2356) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 2356) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 111) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_COL >= 6.81) {
                                if (VARIANCE < 488.65) {
                                    zeroCount++;
                                }
                                else if (VARIANCE >= 488.65) {
                                    if (SUM_COL < 1902.5) {
                                        if (Q4CENT_AVGDIFF < 0.26) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.26) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 1902.5) {
                                        if (AVG_MACRO_VALUE < 55.64) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 55.64) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 14.47) {
                        if (SUM_ROW_COL < 2223.5) {
                            if (AVG_MACRO_VALUE < 88.65) {
                                if (Q2CENT_AVGDIFF < 7.47) {
                                    if (RANGE_MACRO_VALUE < 77.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 77.5) {
                                        if (AVG_MACRO_VALUE < 25.46) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 25.46) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 7.47) {
                                    if (AVG_COL < 4.54) {
                                        if (MIN_MACRO_VALUE < 22.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 22.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 4.54) {
                                        if (SUM_COL < 1352) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 1352) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 88.65) {
                                if (VARIANCE < 510.37) {
                                    zeroCount++;
                                }
                                else if (VARIANCE >= 510.37) {
                                    if (RANGE_MACRO_VALUE < 72) {
                                        oneCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 72) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW_COL >= 2223.5) {
                            if (AVG_MACRO_VALUE < 56.5) {
                                if (MIN_MACRO_VALUE < 24) {
                                    if (Q3CENT_AVGDIFF < 12.36) {
                                        if (Q1CENT_AVGDIFF < 0.33) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.33) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 12.36) {
                                        if (SUM_COL < 3137) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 3137) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 24) {
                                    oneCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 56.5) {
                                if (SUM_COL < 5143) {
                                    if (VARIANCE < 494.89) {
                                        zeroCount++;
                                    }
                                    else if (VARIANCE >= 494.89) {
                                        if (MAX_MACRO_VALUE < 127) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 127) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 5143) {
                                    oneCount++;
                                }
                            }
                        }
                    }
                }
                else if (SUM_ROW >= 800.5) {
                    if (Q1CENT_AVGDIFF < 5.13) {
                        if (AVG_MACRO_VALUE < 26.96) {
                            if (Q4CENT_AVGDIFF < 35.19) {
                                if (VARIANCE < 238.55) {
                                    if (AVG_ROW < 3.71) {
                                        if (SUM_COL < 474) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 474) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 3.71) {
                                        if (RANGE_MACRO_VALUE < 82) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 82) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 238.55) {
                                    if (Q4CENT_AVGDIFF < 6.85) {
                                        if (Q3CENT_AVGDIFF < 38.82) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 38.82) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 6.85) {
                                        if (Q4CENT_AVGDIFF < 31.46) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 31.46) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 35.19) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 26.96) {
                            if (Q4CENT_AVGDIFF < 101.54) {
                                if (Q1CENT_AVGDIFF < 4.64) {
                                    if (AVG_COL < 6.11) {
                                        if (Q2CENT_AVGDIFF < 0.11) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.11) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 6.11) {
                                        if (Q3CENT_AVGDIFF < 4.74) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 4.74) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 4.64) {
                                    if (SUM_ROW < 1057) {
                                        if (RANGE_MACRO_VALUE < 131.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 131.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 1057) {
                                        if (SUM_ROW_COL < 2492.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 2492.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 101.54) {
                                if (Q3CENT_AVGDIFF < 82.64) {
                                    if (SUM_ROW < 2442.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW >= 2442.5) {
                                        if (AVG_COL < 9.79) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 9.79) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 82.64) {
                                    if (SUM_COL < 2779) {
                                        zeroCount++;
                                    }
                                    else if (SUM_COL >= 2779) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 5.13) {
                        if (AVG_MACRO_VALUE < 36.77) {
                            if (Q3CENT_AVGDIFF < 14.44) {
                                if (RANGE_MACRO_VALUE < 164.5) {
                                    if (Q2CENT_AVGDIFF < 16.35) {
                                        if (Q4CENT_AVGDIFF < 1.33) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 1.33) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 16.35) {
                                        if (AVG_MACRO_VALUE < 34.89) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 34.89) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 164.5) {
                                    if (MIN_MACRO_VALUE < 18.5) {
                                        if (SUM_ROW_COL < 3337.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 3337.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 18.5) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 14.44) {
                                if (AVG_MACRO_VALUE < 32) {
                                    if (VARIANCE < 513.11) {
                                        if (SUM_COL < 364.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 364.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 513.11) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 32) {
                                    if (RANGE_MACRO_VALUE < 212) {
                                        if (SUM_ROW < 1207) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 1207) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 212) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 36.77) {
                            if (VARIANCE < 5411.16) {
                                if (AVG_ROW < 20.05) {
                                    if (MIN_MACRO_VALUE < 157.5) {
                                        if (AVG_ROW < 19.96) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 19.96) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 157.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_ROW >= 20.05) {
                                    if (Q1CENT_AVGDIFF < 33.21) {
                                        if (SUM_ROW_COL < 8082.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 8082.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 33.21) {
                                        if (AVG_ROW < 20.95) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 20.95) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (VARIANCE >= 5411.16) {
                                if (AVG_COL < 22.73) {
                                    if (RANGE_MACRO_VALUE < 181.5) {
                                        oneCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 181.5) {
                                        if (Q2CENT_AVGDIFF < 6.07) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 6.07) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_COL >= 22.73) {
                                    if (Q1CENT_AVGDIFF < 8.51) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 8.51) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    //TREE 6
    if (RANGE_MACRO_VALUE < 52.5) {
            if (SUM_COL < 85.5) {
                if (AVG_ROW < 0.4) {
                    if (SUM_COL < 4.5) {
                        if (VARIANCE < 0.01) {
                            if (MAX_MACRO_VALUE < 17.5) {
                                oneCount++;
                            }
                            else if (MAX_MACRO_VALUE >= 17.5) {
                                if (MAX_MACRO_VALUE < 22.5) {
                                    if (MIN_MACRO_VALUE < 20.5) {
                                        if (SUM_COL < 0.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 0.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 20.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 22.5) {
                                    if (VARIANCE < 0) {
                                        if (AVG_MACRO_VALUE < 26.5) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 26.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 0) {
                                        if (AVG_MACRO_VALUE < 23.5) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 23.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (VARIANCE >= 0.01) {
                            zeroCount++;
                        }
                    }
                    else if (SUM_COL >= 4.5) {
                        if (AVG_COL < 0.06) {
                            if (SUM_ROW < 30) {
                                if (AVG_ROW < 0.1) {
                                    if (VARIANCE < 0.22) {
                                        if (SUM_ROW < 21.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 21.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 0.22) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_ROW >= 0.1) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_ROW >= 30) {
                                if (Q4CENT_AVGDIFF < 0.68) {
                                    if (Q2CENT_AVGDIFF < 1.03) {
                                        if (VARIANCE < 0.49) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 0.49) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 1.03) {
                                        oneCount++;
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 0.68) {
                                    if (SUM_ROW < 37.5) {
                                        oneCount++;
                                    }
                                    else if (SUM_ROW >= 37.5) {
                                        if (Q4CENT_AVGDIFF < 0.9) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.9) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_COL >= 0.06) {
                            if (VARIANCE < 0.43) {
                                if (Q1CENT_AVGDIFF < 0.22) {
                                    if (AVG_ROW < 0.39) {
                                        if (Q4CENT_AVGDIFF < 0.54) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.54) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 0.39) {
                                        if (AVG_MACRO_VALUE < 38.12) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 38.12) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 0.22) {
                                    if (MIN_MACRO_VALUE < 43.5) {
                                        if (MIN_MACRO_VALUE < 35.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 35.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 43.5) {
                                        if (Q4CENT_AVGDIFF < 1.19) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 1.19) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (VARIANCE >= 0.43) {
                                if (MIN_MACRO_VALUE < 18.5) {
                                    if (SUM_ROW < 68.5) {
                                        if (Q4CENT_AVGDIFF < 0.44) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.44) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 68.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 18.5) {
                                    if (VARIANCE < 0.75) {
                                        if (MAX_MACRO_VALUE < 23.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 23.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 0.75) {
                                        if (AVG_ROW < 0.39) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 0.39) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (AVG_ROW >= 0.4) {
                    if (MAX_MACRO_VALUE < 135.5) {
                        if (AVG_ROW < 4.93) {
                            if (MAX_MACRO_VALUE < 29.5) {
                                if (AVG_COL < 0.35) {
                                    if (Q4CENT_AVGDIFF < 0.54) {
                                        if (MAX_MACRO_VALUE < 24.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 24.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.54) {
                                        if (MAX_MACRO_VALUE < 21.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 21.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_COL >= 0.35) {
                                    if (MAX_MACRO_VALUE < 28.5) {
                                        if (MAX_MACRO_VALUE < 20) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 20) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 28.5) {
                                        if (SUM_ROW_COL < 206.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 206.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 29.5) {
                                if (AVG_MACRO_VALUE < 36.2) {
                                    if (SUM_ROW < 133.5) {
                                        if (RANGE_MACRO_VALUE < 1.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 1.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 133.5) {
                                        if (VARIANCE < 4.69) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 4.69) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 36.2) {
                                    if (VARIANCE < 111.08) {
                                        if (AVG_MACRO_VALUE < 37.06) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 37.06) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 111.08) {
                                        if (SUM_ROW_COL < 818.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 818.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_ROW >= 4.93) {
                            if (Q1CENT_AVGDIFF < 22.21) {
                                if (Q3CENT_AVGDIFF < 0.24) {
                                    if (Q1CENT_AVGDIFF < 20.58) {
                                        if (SUM_ROW < 1267) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 1267) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 20.58) {
                                        if (SUM_ROW_COL < 1407.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1407.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 0.24) {
                                    if (Q4CENT_AVGDIFF < 23.68) {
                                        if (Q4CENT_AVGDIFF < 0.32) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.32) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 23.68) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (Q1CENT_AVGDIFF >= 22.21) {
                                if (MIN_MACRO_VALUE < 21.5) {
                                    if (Q2CENT_AVGDIFF < 22.79) {
                                        if (RANGE_MACRO_VALUE < 42) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 42) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 22.79) {
                                        if (Q4CENT_AVGDIFF < 16.42) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 16.42) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 21.5) {
                                    oneCount++;
                                }
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 135.5) {
                        zeroCount++;
                    }
                }
            }
            else if (SUM_COL >= 85.5) {
                if (VARIANCE < 231.53) {
                    if (MAX_MACRO_VALUE < 53.5) {
                        if (AVG_MACRO_VALUE < 46.77) {
                            if (MAX_MACRO_VALUE < 51.5) {
                                if (MIN_MACRO_VALUE < 44.5) {
                                    if (AVG_ROW < 0.39) {
                                        if (AVG_MACRO_VALUE < 39.53) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 39.53) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 0.39) {
                                        if (Q4CENT_AVGDIFF < 2.68) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 2.68) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 44.5) {
                                    if (AVG_ROW < 0.48) {
                                        zeroCount++;
                                    }
                                    else if (AVG_ROW >= 0.48) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 51.5) {
                                if (RANGE_MACRO_VALUE < 17.5) {
                                    if (SUM_COL < 191.5) {
                                        if (Q1CENT_AVGDIFF < 3.33) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 3.33) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 191.5) {
                                        if (Q2CENT_AVGDIFF < 4.31) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 4.31) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 17.5) {
                                    if (VARIANCE < 16.66) {
                                        if (Q4CENT_AVGDIFF < 0.61) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.61) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 16.66) {
                                        if (AVG_MACRO_VALUE < 42.03) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.03) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 46.77) {
                            if (SUM_COL < 167.5) {
                                if (Q3CENT_AVGDIFF < 1.71) {
                                    if (SUM_ROW < 140) {
                                        if (Q1CENT_AVGDIFF < 0.04) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.04) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 140) {
                                        if (VARIANCE < 1.07) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 1.07) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 1.71) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_COL >= 167.5) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 53.5) {
                        if (SUM_COL < 366.5) {
                            if (SUM_ROW < 804.5) {
                                if (AVG_MACRO_VALUE < 67.84) {
                                    if (SUM_ROW_COL < 698.5) {
                                        if (Q3CENT_AVGDIFF < 1.6) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 1.6) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 698.5) {
                                        if (MAX_MACRO_VALUE < 62.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 62.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 67.84) {
                                    if (SUM_COL < 357.5) {
                                        if (SUM_ROW < 363.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 363.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 357.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (SUM_ROW >= 804.5) {
                                if (SUM_ROW < 807.5) {
                                    if (Q4CENT_AVGDIFF < 0.83) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.83) {
                                        oneCount++;
                                    }
                                }
                                else if (SUM_ROW >= 807.5) {
                                    if (AVG_MACRO_VALUE < 60.65) {
                                        if (VARIANCE < 53.28) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 53.28) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 60.65) {
                                        if (RANGE_MACRO_VALUE < 34.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 34.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_COL >= 366.5) {
                            if (SUM_COL < 375.5) {
                                if (Q3CENT_AVGDIFF < 0.76) {
                                    zeroCount++;
                                }
                                else if (Q3CENT_AVGDIFF >= 0.76) {
                                    if (AVG_MACRO_VALUE < 63.13) {
                                        if (SUM_ROW_COL < 662.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 662.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 63.13) {
                                        if (MIN_MACRO_VALUE < 73.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 73.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_COL >= 375.5) {
                                if (MAX_MACRO_VALUE < 75.5) {
                                    if (Q2CENT_AVGDIFF < 1.1) {
                                        if (Q1CENT_AVGDIFF < 1.6) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 1.6) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 1.1) {
                                        if (Q2CENT_AVGDIFF < 1.29) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 1.29) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 75.5) {
                                    if (Q4CENT_AVGDIFF < 0.04) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.04) {
                                        if (RANGE_MACRO_VALUE < 15.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 15.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (VARIANCE >= 231.53) {
                    if (Q4CENT_AVGDIFF < 19.64) {
                        if (SUM_COL < 1211) {
                            if (AVG_MACRO_VALUE < 46.26) {
                                if (MIN_MACRO_VALUE < 16.5) {
                                    if (Q4CENT_AVGDIFF < 10.88) {
                                        if (SUM_ROW_COL < 1219) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1219) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 10.88) {
                                        zeroCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 16.5) {
                                    if (AVG_ROW < 4.25) {
                                        if (Q1CENT_AVGDIFF < 21.86) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 21.86) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 4.25) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 46.26) {
                                if (MAX_MACRO_VALUE < 87) {
                                    zeroCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 87) {
                                    if (Q2CENT_AVGDIFF < 12.93) {
                                        if (Q1CENT_AVGDIFF < 12.81) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 12.81) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 12.93) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (SUM_COL >= 1211) {
                            if (AVG_MACRO_VALUE < 24.33) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 24.33) {
                                if (AVG_COL < 8.15) {
                                    if (Q4CENT_AVGDIFF < 13.83) {
                                        if (VARIANCE < 249.24) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 249.24) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 13.83) {
                                        if (Q1CENT_AVGDIFF < 16.99) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 16.99) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_COL >= 8.15) {
                                    if (Q3CENT_AVGDIFF < 6.03) {
                                        if (SUM_COL < 2439) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 2439) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 6.03) {
                                        if (SUM_COL < 2662.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 2662.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 19.64) {
                        if (AVG_COL < 3.3) {
                            if (MIN_MACRO_VALUE < 21.5) {
                                if (Q2CENT_AVGDIFF < 3.71) {
                                    zeroCount++;
                                }
                                else if (Q2CENT_AVGDIFF >= 3.71) {
                                    if (AVG_ROW < 5.46) {
                                        if (Q3CENT_AVGDIFF < 0.76) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.76) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 5.46) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 21.5) {
                                if (Q1CENT_AVGDIFF < 1.13) {
                                    if (VARIANCE < 249.41) {
                                        oneCount++;
                                    }
                                    else if (VARIANCE >= 249.41) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 1.13) {
                                    if (VARIANCE < 272.89) {
                                        zeroCount++;
                                    }
                                    else if (VARIANCE >= 272.89) {
                                        if (SUM_ROW_COL < 1500.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1500.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_COL >= 3.3) {
                            if (Q1CENT_AVGDIFF < 3.33) {
                                if (MIN_MACRO_VALUE < 38) {
                                    if (Q2CENT_AVGDIFF < 21.88) {
                                        zeroCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 21.88) {
                                        if (VARIANCE < 355) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 355) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 38) {
                                    if (Q2CENT_AVGDIFF < 17.03) {
                                        zeroCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 17.03) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (Q1CENT_AVGDIFF >= 3.33) {
                                if (Q1CENT_AVGDIFF < 6.33) {
                                    oneCount++;
                                }
                                else if (Q1CENT_AVGDIFF >= 6.33) {
                                    if (Q4CENT_AVGDIFF < 22.49) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 22.49) {
                                        if (Q1CENT_AVGDIFF < 7.46) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 7.46) {
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
        else if (RANGE_MACRO_VALUE >= 52.5) {
            if (AVG_ROW < 2.92) {
                if (SUM_ROW < 667.5) {
                    if (Q2CENT_AVGDIFF < 5.97) {
                        if (Q2CENT_AVGDIFF < 4.94) {
                            if (Q3CENT_AVGDIFF < 1.54) {
                                if (RANGE_MACRO_VALUE < 53.5) {
                                    oneCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 53.5) {
                                    if (Q3CENT_AVGDIFF < 0.64) {
                                        if (Q1CENT_AVGDIFF < 22.11) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 22.11) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.64) {
                                        if (AVG_COL < 4.39) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 4.39) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 1.54) {
                                if (VARIANCE < 567.5) {
                                    if (Q1CENT_AVGDIFF < 29.61) {
                                        if (Q1CENT_AVGDIFF < 16.33) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 16.33) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 29.61) {
                                        if (Q1CENT_AVGDIFF < 38.31) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 38.31) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 567.5) {
                                    if (SUM_COL < 2387.5) {
                                        if (AVG_MACRO_VALUE < 29.36) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 29.36) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 2387.5) {
                                        if (SUM_ROW < 470.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 470.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 4.94) {
                            if (Q4CENT_AVGDIFF < 14.67) {
                                if (Q1CENT_AVGDIFF < 2.19) {
                                    if (Q1CENT_AVGDIFF < 1.53) {
                                        if (AVG_MACRO_VALUE < 19.4) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 19.4) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 1.53) {
                                        oneCount++;
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 2.19) {
                                    if (AVG_COL < 12.41) {
                                        zeroCount++;
                                    }
                                    else if (AVG_COL >= 12.41) {
                                        if (VARIANCE < 1614.97) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 1614.97) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 14.67) {
                                if (AVG_COL < 4.35) {
                                    zeroCount++;
                                }
                                else if (AVG_COL >= 4.35) {
                                    oneCount++;
                                }
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 5.97) {
                        if (MAX_MACRO_VALUE < 90.5) {
                            if (SUM_ROW_COL < 1227) {
                                if (Q1CENT_AVGDIFF < 12.01) {
                                    if (RANGE_MACRO_VALUE < 64.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 64.5) {
                                        if (Q3CENT_AVGDIFF < 0.81) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.81) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 12.01) {
                                    if (AVG_ROW < 1.27) {
                                        oneCount++;
                                    }
                                    else if (AVG_ROW >= 1.27) {
                                        if (VARIANCE < 122.63) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 122.63) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW_COL >= 1227) {
                                zeroCount++;
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 90.5) {
                            if (Q2CENT_AVGDIFF < 6.65) {
                                if (VARIANCE < 190.54) {
                                    if (Q4CENT_AVGDIFF < 8.37) {
                                        if (VARIANCE < 77.03) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 77.03) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 8.37) {
                                        oneCount++;
                                    }
                                }
                                else if (VARIANCE >= 190.54) {
                                    if (Q4CENT_AVGDIFF < 1.99) {
                                        oneCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 1.99) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 6.65) {
                                if (Q4CENT_AVGDIFF < 16.4) {
                                    if (MAX_MACRO_VALUE < 214) {
                                        if (SUM_COL < 1790) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 1790) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 214) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 16.4) {
                                    if (AVG_COL < 4.57) {
                                        if (SUM_ROW_COL < 1122) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1122) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 4.57) {
                                        if (MAX_MACRO_VALUE < 112.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 112.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (SUM_ROW >= 667.5) {
                    if (AVG_COL < 14.25) {
                        if (Q2CENT_AVGDIFF < 0.46) {
                            if (AVG_COL < 9.14) {
                                if (Q1CENT_AVGDIFF < 0.15) {
                                    oneCount++;
                                }
                                else if (Q1CENT_AVGDIFF >= 0.15) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_COL >= 9.14) {
                                oneCount++;
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 0.46) {
                            if (AVG_COL < 8) {
                                if (SUM_COL < 1875) {
                                    if (RANGE_MACRO_VALUE < 58.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 58.5) {
                                        if (AVG_MACRO_VALUE < 36.07) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 36.07) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 1875) {
                                    oneCount++;
                                }
                            }
                            else if (AVG_COL >= 8) {
                                if (RANGE_MACRO_VALUE < 60) {
                                    oneCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 60) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (AVG_COL >= 14.25) {
                        if (Q3CENT_AVGDIFF < 7.29) {
                            if (RANGE_MACRO_VALUE < 135.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 135.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 7.29) {
                            if (SUM_COL < 3491.5) {
                                oneCount++;
                            }
                            else if (SUM_COL >= 3491.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
            else if (AVG_ROW >= 2.92) {
                if (Q1CENT_AVGDIFF < 5.13) {
                    if (SUM_ROW < 706.5) {
                        if (RANGE_MACRO_VALUE < 78.5) {
                            if (RANGE_MACRO_VALUE < 55.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 55.5) {
                                zeroCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 78.5) {
                            if (AVG_COL < 7.28) {
                                if (Q3CENT_AVGDIFF < 0.86) {
                                    zeroCount++;
                                }
                                else if (Q3CENT_AVGDIFF >= 0.86) {
                                    if (MIN_MACRO_VALUE < 50.5) {
                                        oneCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 50.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (AVG_COL >= 7.28) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW >= 706.5) {
                        if (Q2CENT_AVGDIFF < 2.71) {
                            if (VARIANCE < 114.63) {
                                if (MAX_MACRO_VALUE < 123) {
                                    if (SUM_ROW_COL < 1449.5) {
                                        if (AVG_COL < 0.79) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 0.79) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 1449.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 123) {
                                    if (MIN_MACRO_VALUE < 39) {
                                        zeroCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 39) {
                                        if (SUM_COL < 701.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 701.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (VARIANCE >= 114.63) {
                                if (SUM_COL < 531.5) {
                                    if (AVG_MACRO_VALUE < 33.09) {
                                        if (MAX_MACRO_VALUE < 89.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 89.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 33.09) {
                                        if (Q4CENT_AVGDIFF < 12.39) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 12.39) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 531.5) {
                                    if (AVG_COL < 15.06) {
                                        if (MAX_MACRO_VALUE < 185.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 185.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 15.06) {
                                        if (VARIANCE < 3102.47) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 3102.47) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 2.71) {
                            if (Q3CENT_AVGDIFF < 25.42) {
                                if (Q4CENT_AVGDIFF < 30.07) {
                                    if (Q3CENT_AVGDIFF < 24.03) {
                                        if (AVG_COL < 10.57) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 10.57) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 24.03) {
                                        if (MAX_MACRO_VALUE < 97) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 97) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 30.07) {
                                    if (MAX_MACRO_VALUE < 161.5) {
                                        if (SUM_ROW < 772.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 772.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 161.5) {
                                        if (AVG_MACRO_VALUE < 78.57) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 78.57) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 25.42) {
                                if (Q1CENT_AVGDIFF < 1.38) {
                                    if (MAX_MACRO_VALUE < 135.5) {
                                        if (SUM_ROW < 1508.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 1508.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 135.5) {
                                        if (Q4CENT_AVGDIFF < 19.6) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 19.6) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 1.38) {
                                    if (AVG_COL < 8.12) {
                                        if (Q2CENT_AVGDIFF < 25.96) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 25.96) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 8.12) {
                                        if (MIN_MACRO_VALUE < 43.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 43.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (Q1CENT_AVGDIFF >= 5.13) {
                    if (VARIANCE < 5207.06) {
                        if (Q1CENT_AVGDIFF < 7.58) {
                            if (Q2CENT_AVGDIFF < 16.13) {
                                if (MIN_MACRO_VALUE < 74.5) {
                                    if (Q4CENT_AVGDIFF < 28.85) {
                                        if (MIN_MACRO_VALUE < 69.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 69.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 28.85) {
                                        if (MIN_MACRO_VALUE < 36.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 36.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 74.5) {
                                    if (VARIANCE < 194.18) {
                                        if (AVG_ROW < 4.51) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 4.51) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 194.18) {
                                        if (Q2CENT_AVGDIFF < 1.74) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 1.74) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 16.13) {
                                if (MIN_MACRO_VALUE < 82.5) {
                                    if (Q2CENT_AVGDIFF < 22.88) {
                                        if (SUM_ROW_COL < 3348.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 3348.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 22.88) {
                                        if (MAX_MACRO_VALUE < 106.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 106.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 82.5) {
                                    if (AVG_COL < 26.97) {
                                        zeroCount++;
                                    }
                                    else if (AVG_COL >= 26.97) {
                                        oneCount++;
                                    }
                                }
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 7.58) {
                            if (Q2CENT_AVGDIFF < 4.22) {
                                if (Q4CENT_AVGDIFF < 9.33) {
                                    if (Q3CENT_AVGDIFF < 21.67) {
                                        if (SUM_COL < 1368) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 1368) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 21.67) {
                                        if (AVG_MACRO_VALUE < 36.55) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 36.55) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 9.33) {
                                    if (RANGE_MACRO_VALUE < 71.5) {
                                        if (SUM_ROW < 1340.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 1340.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 71.5) {
                                        if (Q4CENT_AVGDIFF < 17.57) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 17.57) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 4.22) {
                                if (Q4CENT_AVGDIFF < 0.71) {
                                    if (Q4CENT_AVGDIFF < 0.61) {
                                        if (VARIANCE < 128.06) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 128.06) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.61) {
                                        if (RANGE_MACRO_VALUE < 75.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 75.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 0.71) {
                                    if (Q4CENT_AVGDIFF < 1.33) {
                                        if (Q2CENT_AVGDIFF < 73.78) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 73.78) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 1.33) {
                                        if (Q1CENT_AVGDIFF < 7.74) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 7.74) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (VARIANCE >= 5207.06) {
                        if (AVG_MACRO_VALUE < 86.21) {
                            oneCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 86.21) {
                            if (AVG_COL < 22.61) {
                                if (SUM_ROW_COL < 9610) {
                                    if (SUM_ROW < 1236.5) {
                                        oneCount++;
                                    }
                                    else if (SUM_ROW >= 1236.5) {
                                        if (Q1CENT_AVGDIFF < 168.86) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 168.86) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 9610) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_COL >= 22.61) {
                                if (MAX_MACRO_VALUE < 233) {
                                    oneCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 233) {
                                    if (VARIANCE < 5404.93) {
                                        zeroCount++;
                                    }
                                    else if (VARIANCE >= 5404.93) {
                                        if (AVG_ROW < 31.06) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 31.06) {
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
        
    //TREE 7
    if (RANGE_MACRO_VALUE < 52.5) {
            if (SUM_ROW < 94.5) {
                if (AVG_MACRO_VALUE < 43.9) {
                    if (SUM_COL < 4.5) {
                        if (SUM_ROW < 1.5) {
                            if (Q2CENT_AVGDIFF < 0.01) {
                                if (MIN_MACRO_VALUE < 26.5) {
                                    if (MIN_MACRO_VALUE < 17) {
                                        oneCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 17) {
                                        if (VARIANCE < 0) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 0) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 26.5) {
                                    oneCount++;
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 0.01) {
                                if (SUM_ROW_COL < 2.5) {
                                    oneCount++;
                                }
                                else if (SUM_ROW_COL >= 2.5) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (SUM_ROW >= 1.5) {
                            zeroCount++;
                        }
                    }
                    else if (SUM_COL >= 4.5) {
                        if (AVG_MACRO_VALUE < 27.54) {
                            if (MIN_MACRO_VALUE < 26.5) {
                                if (MIN_MACRO_VALUE < 23.5) {
                                    if (AVG_MACRO_VALUE < 16.94) {
                                        if (VARIANCE < 0.17) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 0.17) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 16.94) {
                                        if (Q2CENT_AVGDIFF < 0.71) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.71) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 23.5) {
                                    if (RANGE_MACRO_VALUE < 1.5) {
                                        if (SUM_ROW_COL < 102.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 102.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 1.5) {
                                        if (SUM_ROW < 65.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 65.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 26.5) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 27.54) {
                            if (VARIANCE < 0.1) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 0.1) {
                                if (MAX_MACRO_VALUE < 32.5) {
                                    if (AVG_COL < 0.26) {
                                        if (SUM_ROW < 66.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 66.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 0.26) {
                                        if (AVG_ROW < 0.29) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 0.29) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 32.5) {
                                    if (Q4CENT_AVGDIFF < 0.46) {
                                        if (MAX_MACRO_VALUE < 41.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 41.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.46) {
                                        if (Q2CENT_AVGDIFF < 0.54) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.54) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 43.9) {
                    if (SUM_COL < 83.5) {
                        if (Q1CENT_AVGDIFF < 0.03) {
                            if (Q4CENT_AVGDIFF < 0.33) {
                                zeroCount++;
                            }
                            else if (Q4CENT_AVGDIFF >= 0.33) {
                                if (Q3CENT_AVGDIFF < 0.67) {
                                    if (SUM_COL < 54.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_COL >= 54.5) {
                                        oneCount++;
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 0.67) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 0.03) {
                            if (SUM_ROW < 67.5) {
                                if (Q3CENT_AVGDIFF < 1.26) {
                                    if (MIN_MACRO_VALUE < 128.5) {
                                        if (Q3CENT_AVGDIFF < 0.63) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.63) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 128.5) {
                                        if (MAX_MACRO_VALUE < 229.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 229.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 1.26) {
                                    if (MAX_MACRO_VALUE < 66.5) {
                                        if (AVG_COL < 0.33) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 0.33) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 66.5) {
                                        if (VARIANCE < 1.56) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 1.56) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW >= 67.5) {
                                if (RANGE_MACRO_VALUE < 3.5) {
                                    if (RANGE_MACRO_VALUE < 2.5) {
                                        if (AVG_ROW < 0.33) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 0.33) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 2.5) {
                                        if (Q1CENT_AVGDIFF < 0.58) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.58) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 3.5) {
                                    if (AVG_MACRO_VALUE < 48.96) {
                                        zeroCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 48.96) {
                                        if (SUM_ROW_COL < 172.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 172.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (SUM_COL >= 83.5) {
                        if (VARIANCE < 1.1) {
                            zeroCount++;
                        }
                        else if (VARIANCE >= 1.1) {
                            if (Q4CENT_AVGDIFF < 0.51) {
                                if (Q1CENT_AVGDIFF < 0.11) {
                                    oneCount++;
                                }
                                else if (Q1CENT_AVGDIFF >= 0.11) {
                                    zeroCount++;
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 0.51) {
                                if (MAX_MACRO_VALUE < 91.5) {
                                    if (SUM_ROW < 93.5) {
                                        if (Q3CENT_AVGDIFF < 0.68) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.68) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 93.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 91.5) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                }
            }
            else if (SUM_ROW >= 94.5) {
                if (VARIANCE < 141.51) {
                    if (Q4CENT_AVGDIFF < 13.63) {
                        if (AVG_ROW < 1.61) {
                            if (SUM_ROW_COL < 663.5) {
                                if (Q3CENT_AVGDIFF < 4.67) {
                                    if (SUM_ROW_COL < 649.5) {
                                        if (Q1CENT_AVGDIFF < 4.83) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 4.83) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 649.5) {
                                        if (Q3CENT_AVGDIFF < 1.93) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 1.93) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 4.67) {
                                    if (Q1CENT_AVGDIFF < 5.82) {
                                        if (SUM_ROW_COL < 541) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 541) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 5.82) {
                                        if (Q4CENT_AVGDIFF < 7.56) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 7.56) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW_COL >= 663.5) {
                                if (SUM_ROW_COL < 667.5) {
                                    if (Q4CENT_AVGDIFF < 4.13) {
                                        if (AVG_ROW < 1.49) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 1.49) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 4.13) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_ROW_COL >= 667.5) {
                                    if (SUM_COL < 840.5) {
                                        if (Q3CENT_AVGDIFF < 2.81) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 2.81) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 840.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (AVG_ROW >= 1.61) {
                            if (SUM_COL < 346.5) {
                                if (MIN_MACRO_VALUE < 32.5) {
                                    if (Q4CENT_AVGDIFF < 1.63) {
                                        if (AVG_COL < 1.36) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 1.36) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 1.63) {
                                        if (Q4CENT_AVGDIFF < 11.04) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 11.04) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 32.5) {
                                    if (VARIANCE < 47.67) {
                                        if (SUM_ROW < 406.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 406.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 47.67) {
                                        if (MIN_MACRO_VALUE < 34.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 34.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_COL >= 346.5) {
                                if (AVG_ROW < 1.66) {
                                    if (SUM_ROW < 393.5) {
                                        if (SUM_COL < 390.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 390.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 393.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_ROW >= 1.66) {
                                    if (Q1CENT_AVGDIFF < 18.85) {
                                        if (Q1CENT_AVGDIFF < 12.79) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 12.79) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 18.85) {
                                        if (AVG_COL < 2.31) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 2.31) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 13.63) {
                        if (Q3CENT_AVGDIFF < 3.65) {
                            if (AVG_MACRO_VALUE < 51.72) {
                                if (Q1CENT_AVGDIFF < 15.63) {
                                    if (Q4CENT_AVGDIFF < 14.63) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 14.63) {
                                        if (Q4CENT_AVGDIFF < 14.65) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 14.65) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 15.63) {
                                    if (AVG_MACRO_VALUE < 45.09) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 45.09) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 51.72) {
                                if (MAX_MACRO_VALUE < 123.5) {
                                    zeroCount++;
                                }
                                else if (MAX_MACRO_VALUE >= 123.5) {
                                    if (SUM_ROW < 747.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW >= 747.5) {
                                        if (AVG_COL < 1.71) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 1.71) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 3.65) {
                            if (Q3CENT_AVGDIFF < 6.79) {
                                if (AVG_ROW < 1.7) {
                                    zeroCount++;
                                }
                                else if (AVG_ROW >= 1.7) {
                                    if (MAX_MACRO_VALUE < 69.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 69.5) {
                                        if (SUM_COL < 252.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 252.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 6.79) {
                                if (Q3CENT_AVGDIFF < 23.33) {
                                    if (AVG_ROW < 4.72) {
                                        if (SUM_COL < 901.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 901.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 4.72) {
                                        if (SUM_COL < 1468) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 1468) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 23.33) {
                                    if (SUM_ROW < 1090.5) {
                                        if (Q1CENT_AVGDIFF < 9.4) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 9.4) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 1090.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (VARIANCE >= 141.51) {
                    if (Q4CENT_AVGDIFF < 25.18) {
                        if (AVG_MACRO_VALUE < 156.04) {
                            if (Q1CENT_AVGDIFF < 24.67) {
                                if (Q2CENT_AVGDIFF < 25.29) {
                                    if (RANGE_MACRO_VALUE < 39.5) {
                                        if (Q2CENT_AVGDIFF < 22.68) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 22.68) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 39.5) {
                                        if (SUM_ROW_COL < 971.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 971.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 25.29) {
                                    if (MIN_MACRO_VALUE < 20) {
                                        if (AVG_MACRO_VALUE < 34.35) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 34.35) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 20) {
                                        if (Q4CENT_AVGDIFF < 22.71) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 22.71) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q1CENT_AVGDIFF >= 24.67) {
                                if (Q4CENT_AVGDIFF < 0.06) {
                                    zeroCount++;
                                }
                                else if (Q4CENT_AVGDIFF >= 0.06) {
                                    if (SUM_ROW_COL < 1401.5) {
                                        if (AVG_MACRO_VALUE < 46.31) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 46.31) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 1401.5) {
                                        if (RANGE_MACRO_VALUE < 45.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 45.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 156.04) {
                            zeroCount++;
                        }
                    }
                    else if (Q4CENT_AVGDIFF >= 25.18) {
                        if (Q2CENT_AVGDIFF < 31.93) {
                            if (SUM_ROW < 1249) {
                                if (AVG_COL < 0.86) {
                                    if (Q1CENT_AVGDIFF < 4.99) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 4.99) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_COL >= 0.86) {
                                    if (RANGE_MACRO_VALUE < 48.5) {
                                        if (VARIANCE < 268.4) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 268.4) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 48.5) {
                                        if (Q1CENT_AVGDIFF < 3.4) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 3.4) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW >= 1249) {
                                zeroCount++;
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 31.93) {
                            if (RANGE_MACRO_VALUE < 51.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 51.5) {
                                zeroCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (RANGE_MACRO_VALUE >= 52.5) {
            if (Q1CENT_AVGDIFF < 4.94) {
                if (MIN_MACRO_VALUE < 20.5) {
                    if (RANGE_MACRO_VALUE < 58.5) {
                        if (Q3CENT_AVGDIFF < 5.83) {
                            if (RANGE_MACRO_VALUE < 56.5) {
                                if (Q4CENT_AVGDIFF < 4.76) {
                                    oneCount++;
                                }
                                else if (Q4CENT_AVGDIFF >= 4.76) {
                                    zeroCount++;
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 56.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 5.83) {
                            zeroCount++;
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 58.5) {
                        if (Q2CENT_AVGDIFF < 66.24) {
                            if (Q2CENT_AVGDIFF < 58.26) {
                                if (SUM_COL < 994.5) {
                                    if (AVG_MACRO_VALUE < 79.05) {
                                        if (VARIANCE < 304.05) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 304.05) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 79.05) {
                                        if (AVG_ROW < 6.62) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 6.62) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 994.5) {
                                    if (RANGE_MACRO_VALUE < 212.5) {
                                        if (SUM_ROW_COL < 5536) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 5536) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 212.5) {
                                        if (SUM_ROW < 4763.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 4763.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 58.26) {
                                if (VARIANCE < 833.64) {
                                    oneCount++;
                                }
                                else if (VARIANCE >= 833.64) {
                                    if (SUM_COL < 2001) {
                                        if (AVG_ROW < 9.06) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 9.06) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 2001) {
                                        if (VARIANCE < 1547.07) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 1547.07) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 66.24) {
                            if (VARIANCE < 1382.15) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 1382.15) {
                                if (VARIANCE < 2999.32) {
                                    if (MAX_MACRO_VALUE < 187) {
                                        if (Q2CENT_AVGDIFF < 83.72) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 83.72) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 187) {
                                        oneCount++;
                                    }
                                }
                                else if (VARIANCE >= 2999.32) {
                                    if (AVG_MACRO_VALUE < 47.51) {
                                        if (SUM_COL < 2469.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 2469.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 47.51) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (MIN_MACRO_VALUE >= 20.5) {
                    if (SUM_COL < 610.5) {
                        if (VARIANCE < 682.63) {
                            if (SUM_ROW < 1551.5) {
                                if (AVG_COL < 2.52) {
                                    if (Q4CENT_AVGDIFF < 26.94) {
                                        if (SUM_COL < 140.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 140.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 26.94) {
                                        if (AVG_MACRO_VALUE < 96.42) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 96.42) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_COL >= 2.52) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_ROW >= 1551.5) {
                                if (AVG_MACRO_VALUE < 84.3) {
                                    if (MAX_MACRO_VALUE < 98.5) {
                                        if (Q4CENT_AVGDIFF < 30.89) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 30.89) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 98.5) {
                                        if (AVG_MACRO_VALUE < 62.83) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 62.83) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 84.3) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (VARIANCE >= 682.63) {
                            if (RANGE_MACRO_VALUE < 116) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 116) {
                                if (RANGE_MACRO_VALUE < 194.5) {
                                    if (AVG_COL < 2.15) {
                                        if (Q4CENT_AVGDIFF < 85.56) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 85.56) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 2.15) {
                                        if (AVG_ROW < 5.44) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 5.44) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 194.5) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (SUM_COL >= 610.5) {
                        if (Q2CENT_AVGDIFF < 3.35) {
                            if (AVG_MACRO_VALUE < 145) {
                                if (Q4CENT_AVGDIFF < 6.26) {
                                    if (Q3CENT_AVGDIFF < 7.42) {
                                        if (SUM_COL < 4110.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 4110.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 7.42) {
                                        if (SUM_COL < 883.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 883.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 6.26) {
                                    if (MAX_MACRO_VALUE < 103.5) {
                                        if (SUM_ROW < 1383) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 1383) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 103.5) {
                                        if (Q3CENT_AVGDIFF < 3.67) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 3.67) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 145) {
                                if (MAX_MACRO_VALUE < 211.5) {
                                    if (AVG_ROW < 3.26) {
                                        if (SUM_ROW < 763.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 763.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 3.26) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 211.5) {
                                    if (Q3CENT_AVGDIFF < 0.69) {
                                        oneCount++;
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.69) {
                                        if (Q4CENT_AVGDIFF < 11.97) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 11.97) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 3.35) {
                            if (SUM_ROW_COL < 1281.5) {
                                if (MAX_MACRO_VALUE < 196.5) {
                                    if (Q1CENT_AVGDIFF < 1.85) {
                                        if (AVG_COL < 3.66) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 3.66) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 1.85) {
                                        if (Q3CENT_AVGDIFF < 2.69) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 2.69) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 196.5) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_ROW_COL >= 1281.5) {
                                if (Q1CENT_AVGDIFF < 4.79) {
                                    if (Q4CENT_AVGDIFF < 56.32) {
                                        if (Q4CENT_AVGDIFF < 52.61) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 52.61) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 56.32) {
                                        if (RANGE_MACRO_VALUE < 127.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 127.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 4.79) {
                                    if (SUM_COL < 1956.5) {
                                        if (AVG_ROW < 9.34) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 9.34) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 1956.5) {
                                        if (Q3CENT_AVGDIFF < 2.04) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 2.04) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (Q1CENT_AVGDIFF >= 4.94) {
                if (Q1CENT_AVGDIFF < 7.53) {
                    if (Q2CENT_AVGDIFF < 16.13) {
                        if (MIN_MACRO_VALUE < 74.5) {
                            if (SUM_COL < 731.5) {
                                if (SUM_ROW < 3846) {
                                    if (AVG_ROW < 4.29) {
                                        if (SUM_ROW < 958) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 958) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 4.29) {
                                        if (Q2CENT_AVGDIFF < 3.18) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 3.18) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 3846) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_COL >= 731.5) {
                                if (MIN_MACRO_VALUE < 67.5) {
                                    if (Q1CENT_AVGDIFF < 7.46) {
                                        if (MAX_MACRO_VALUE < 158.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 158.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 7.46) {
                                        zeroCount++;
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 67.5) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (MIN_MACRO_VALUE >= 74.5) {
                            if (RANGE_MACRO_VALUE < 85.5) {
                                if (SUM_COL < 1220) {
                                    if (MAX_MACRO_VALUE < 148.5) {
                                        if (Q4CENT_AVGDIFF < 8.1) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 8.1) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 148.5) {
                                        if (AVG_COL < 4.74) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 4.74) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 1220) {
                                    if (Q3CENT_AVGDIFF < 34.04) {
                                        zeroCount++;
                                    }
                                    else if (Q3CENT_AVGDIFF >= 34.04) {
                                        if (VARIANCE < 428.57) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 428.57) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 85.5) {
                                if (AVG_ROW < 3.86) {
                                    zeroCount++;
                                }
                                else if (AVG_ROW >= 3.86) {
                                    if (Q1CENT_AVGDIFF < 5.14) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 5.14) {
                                        if (VARIANCE < 364.35) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 364.35) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 16.13) {
                        if (RANGE_MACRO_VALUE < 79.5) {
                            if (Q2CENT_AVGDIFF < 47.17) {
                                if (SUM_ROW < 1130.5) {
                                    if (Q1CENT_AVGDIFF < 7.29) {
                                        if (Q2CENT_AVGDIFF < 17.96) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 17.96) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 7.29) {
                                        if (SUM_ROW < 1064) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 1064) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 1130.5) {
                                    if (Q4CENT_AVGDIFF < 44.71) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 44.71) {
                                        oneCount++;
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 47.17) {
                                if (VARIANCE < 498.96) {
                                    oneCount++;
                                }
                                else if (VARIANCE >= 498.96) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 79.5) {
                            if (SUM_ROW < 1654.5) {
                                if (MIN_MACRO_VALUE < 61.5) {
                                    if (VARIANCE < 791.4) {
                                        if (Q1CENT_AVGDIFF < 7.32) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 7.32) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 791.4) {
                                        if (Q1CENT_AVGDIFF < 6.15) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 6.15) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 61.5) {
                                    if (SUM_ROW_COL < 3280.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW_COL >= 3280.5) {
                                        if (Q3CENT_AVGDIFF < 19.5) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 19.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW >= 1654.5) {
                                if (Q1CENT_AVGDIFF < 7.46) {
                                    if (Q3CENT_AVGDIFF < 6.26) {
                                        if (Q3CENT_AVGDIFF < 3.72) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 3.72) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 6.26) {
                                        if (MAX_MACRO_VALUE < 201.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 201.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 7.46) {
                                    if (VARIANCE < 457.35) {
                                        oneCount++;
                                    }
                                    else if (VARIANCE >= 457.35) {
                                        if (SUM_ROW < 3924) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 3924) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (Q1CENT_AVGDIFF >= 7.53) {
                    if (Q1CENT_AVGDIFF < 7.82) {
                        if (AVG_MACRO_VALUE < 135.25) {
                            if (SUM_ROW < 771.5) {
                                if (MAX_MACRO_VALUE < 173) {
                                    if (RANGE_MACRO_VALUE < 137.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 137.5) {
                                        oneCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 173) {
                                    oneCount++;
                                }
                            }
                            else if (SUM_ROW >= 771.5) {
                                if (Q4CENT_AVGDIFF < 28.15) {
                                    if (SUM_COL < 1853.5) {
                                        if (SUM_COL < 1212.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 1212.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 1853.5) {
                                        if (Q2CENT_AVGDIFF < 50.31) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 50.31) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 28.15) {
                                    if (SUM_COL < 1802.5) {
                                        if (RANGE_MACRO_VALUE < 87.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 87.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 1802.5) {
                                        if (SUM_ROW < 4641.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 4641.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 135.25) {
                            if (AVG_COL < 24.39) {
                                zeroCount++;
                            }
                            else if (AVG_COL >= 24.39) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 7.82) {
                        if (Q2CENT_AVGDIFF < 4.22) {
                            if (Q1CENT_AVGDIFF < 7.86) {
                                if (RANGE_MACRO_VALUE < 89) {
                                    if (AVG_COL < 2.05) {
                                        oneCount++;
                                    }
                                    else if (AVG_COL >= 2.05) {
                                        zeroCount++;
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 89) {
                                    oneCount++;
                                }
                            }
                            else if (Q1CENT_AVGDIFF >= 7.86) {
                                if (VARIANCE < 334.11) {
                                    if (AVG_ROW < 8.47) {
                                        if (VARIANCE < 144) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 144) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 8.47) {
                                        if (AVG_ROW < 9.93) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 9.93) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 334.11) {
                                    if (Q2CENT_AVGDIFF < 3.97) {
                                        if (AVG_COL < 7.01) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 7.01) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 3.97) {
                                        if (AVG_MACRO_VALUE < 52.18) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 52.18) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 4.22) {
                            if (Q2CENT_AVGDIFF < 58.31) {
                                if (AVG_ROW < 20.05) {
                                    if (AVG_MACRO_VALUE < 64.22) {
                                        if (MIN_MACRO_VALUE < 43.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 43.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 64.22) {
                                        if (Q2CENT_AVGDIFF < 57.06) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 57.06) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 20.05) {
                                    if (Q3CENT_AVGDIFF < 0.54) {
                                        if (SUM_ROW < 5002) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 5002) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.54) {
                                        if (SUM_COL < 3894) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 3894) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 58.31) {
                                if (Q1CENT_AVGDIFF < 35.11) {
                                    if (AVG_COL < 4.97) {
                                        zeroCount++;
                                    }
                                    else if (AVG_COL >= 4.97) {
                                        if (RANGE_MACRO_VALUE < 112.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 112.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 35.11) {
                                    if (Q1CENT_AVGDIFF < 36.74) {
                                        if (SUM_ROW < 3957.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 3957.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 36.74) {
                                        if (AVG_COL < 7.4) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 7.4) {
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
        
    //TREE 8
    if (SUM_ROW_COL < 1588.5) {
            if (AVG_ROW < 0.39) {
                if (SUM_COL < 1211) {
                    if (AVG_COL < 0.44) {
                        if (MAX_MACRO_VALUE < 46.5) {
                            if (SUM_ROW_COL < 11.5) {
                                if (AVG_ROW < 0.01) {
                                    if (AVG_MACRO_VALUE < 22) {
                                        if (MIN_MACRO_VALUE < 17) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 17) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 22) {
                                        if (MAX_MACRO_VALUE < 24) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 24) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 0.01) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_ROW_COL >= 11.5) {
                                if (SUM_ROW_COL < 29.5) {
                                    if (AVG_COL < 0.06) {
                                        if (Q1CENT_AVGDIFF < 0.13) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.13) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 0.06) {
                                        if (VARIANCE < 0.03) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 0.03) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 29.5) {
                                    if (Q4CENT_AVGDIFF < 0.22) {
                                        if (VARIANCE < 0.04) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 0.04) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.22) {
                                        if (RANGE_MACRO_VALUE < 2.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 2.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (MAX_MACRO_VALUE >= 46.5) {
                            if (Q4CENT_AVGDIFF < 1.42) {
                                if (SUM_COL < 73.5) {
                                    if (Q2CENT_AVGDIFF < 1.43) {
                                        if (SUM_ROW_COL < 159.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 159.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 1.43) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_COL >= 73.5) {
                                    if (AVG_ROW < 0.37) {
                                        if (MIN_MACRO_VALUE < 71.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 71.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 0.37) {
                                        if (AVG_COL < 0.32) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 0.32) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 1.42) {
                                if (MAX_MACRO_VALUE < 69.5) {
                                    if (AVG_COL < 0.34) {
                                        if (SUM_COL < 78.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 78.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 0.34) {
                                        if (AVG_COL < 0.4) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 0.4) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 69.5) {
                                    if (Q1CENT_AVGDIFF < 1.21) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 1.21) {
                                        if (AVG_COL < 0.4) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 0.4) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (AVG_COL >= 0.44) {
                        if (VARIANCE < 2.41) {
                            if (AVG_ROW < 0.35) {
                                zeroCount++;
                            }
                            else if (AVG_ROW >= 0.35) {
                                if (Q3CENT_AVGDIFF < 1.11) {
                                    if (AVG_ROW < 0.38) {
                                        if (VARIANCE < 0.91) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 0.91) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 0.38) {
                                        if (SUM_COL < 113) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 113) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 1.11) {
                                    if (MAX_MACRO_VALUE < 86.5) {
                                        if (Q4CENT_AVGDIFF < 1.21) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 1.21) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 86.5) {
                                        if (Q1CENT_AVGDIFF < 1.64) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 1.64) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (VARIANCE >= 2.41) {
                            if (Q3CENT_AVGDIFF < 1.9) {
                                if (SUM_COL < 125.5) {
                                    if (SUM_COL < 112.5) {
                                        if (Q2CENT_AVGDIFF < 1.14) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 1.14) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 112.5) {
                                        if (MIN_MACRO_VALUE < 25.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 25.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 125.5) {
                                    if (RANGE_MACRO_VALUE < 12.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 12.5) {
                                        if (SUM_ROW_COL < 351) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 351) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 1.9) {
                                if (AVG_ROW < 0.39) {
                                    if (MAX_MACRO_VALUE < 57.5) {
                                        if (Q3CENT_AVGDIFF < 6.76) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 6.76) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 57.5) {
                                        if (MAX_MACRO_VALUE < 59.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 59.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 0.39) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                }
                else if (SUM_COL >= 1211) {
                    if (Q3CENT_AVGDIFF < 21.69) {
                        if (RANGE_MACRO_VALUE < 39) {
                            if (Q1CENT_AVGDIFF < 21.88) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 21.88) {
                                oneCount++;
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 39) {
                            if (SUM_COL < 1406) {
                                if (VARIANCE < 301.97) {
                                    zeroCount++;
                                }
                                else if (VARIANCE >= 301.97) {
                                    oneCount++;
                                }
                            }
                            else if (SUM_COL >= 1406) {
                                oneCount++;
                            }
                        }
                    }
                    else if (Q3CENT_AVGDIFF >= 21.69) {
                        if (SUM_ROW < 16.5) {
                            if (SUM_COL < 1312.5) {
                                zeroCount++;
                            }
                            else if (SUM_COL >= 1312.5) {
                                if (AVG_ROW < 0.06) {
                                    zeroCount++;
                                }
                                else if (AVG_ROW >= 0.06) {
                                    oneCount++;
                                }
                            }
                        }
                        else if (SUM_ROW >= 16.5) {
                            if (AVG_MACRO_VALUE < 33.78) {
                                if (Q2CENT_AVGDIFF < 11.67) {
                                    oneCount++;
                                }
                                else if (Q2CENT_AVGDIFF >= 11.67) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 33.78) {
                                if (RANGE_MACRO_VALUE < 39.5) {
                                    zeroCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 39.5) {
                                    oneCount++;
                                }
                            }
                        }
                    }
                }
            }
            else if (AVG_ROW >= 0.39) {
                if (MAX_MACRO_VALUE < 83.5) {
                    if (SUM_ROW_COL < 1575.5) {
                        if (VARIANCE < 190.13) {
                            if (AVG_MACRO_VALUE < 43.81) {
                                if (SUM_ROW_COL < 1278.5) {
                                    if (AVG_MACRO_VALUE < 43.69) {
                                        if (AVG_MACRO_VALUE < 43.52) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 43.52) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 43.69) {
                                        if (RANGE_MACRO_VALUE < 25) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 25) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 1278.5) {
                                    if (AVG_COL < 2.43) {
                                        if (SUM_COL < 579.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 579.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 2.43) {
                                        if (AVG_COL < 3.04) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 3.04) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 43.81) {
                                if (VARIANCE < 0.65) {
                                    if (SUM_ROW < 114.5) {
                                        if (SUM_ROW < 98.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 98.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 114.5) {
                                        if (Q1CENT_AVGDIFF < 0.11) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.11) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 0.65) {
                                    if (Q4CENT_AVGDIFF < 9.9) {
                                        if (Q4CENT_AVGDIFF < 0.11) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.11) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 9.9) {
                                        if (MIN_MACRO_VALUE < 34.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 34.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (VARIANCE >= 190.13) {
                            if (SUM_ROW < 256.5) {
                                if (MAX_MACRO_VALUE < 60.5) {
                                    if (VARIANCE < 195.33) {
                                        zeroCount++;
                                    }
                                    else if (VARIANCE >= 195.33) {
                                        if (Q2CENT_AVGDIFF < 0.61) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.61) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 60.5) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_ROW >= 256.5) {
                                if (MIN_MACRO_VALUE < 16.5) {
                                    if (SUM_ROW < 929) {
                                        if (SUM_COL < 1058.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 1058.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 929) {
                                        if (SUM_ROW_COL < 1455.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1455.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 16.5) {
                                    if (AVG_ROW < 2.31) {
                                        if (MIN_MACRO_VALUE < 28.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 28.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 2.31) {
                                        if (Q2CENT_AVGDIFF < 4.14) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 4.14) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 1575.5) {
                        if (Q4CENT_AVGDIFF < 22.01) {
                            if (VARIANCE < 55.51) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 55.51) {
                                if (Q2CENT_AVGDIFF < 6.74) {
                                    if (VARIANCE < 67.48) {
                                        oneCount++;
                                    }
                                    else if (VARIANCE >= 67.48) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q2CENT_AVGDIFF >= 6.74) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 22.01) {
                            if (Q3CENT_AVGDIFF < 18.85) {
                                zeroCount++;
                            }
                            else if (Q3CENT_AVGDIFF >= 18.85) {
                                oneCount++;
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 83.5) {
                    if (AVG_MACRO_VALUE < 64.1) {
                        if (RANGE_MACRO_VALUE < 37.5) {
                            if (SUM_ROW < 746) {
                                if (SUM_ROW_COL < 514.5) {
                                    oneCount++;
                                }
                                else if (SUM_ROW_COL >= 514.5) {
                                    if (SUM_COL < 281) {
                                        if (Q3CENT_AVGDIFF < 2.42) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 2.42) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 281) {
                                        if (MIN_MACRO_VALUE < 47.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 47.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW >= 746) {
                                if (Q1CENT_AVGDIFF < 6.03) {
                                    zeroCount++;
                                }
                                else if (Q1CENT_AVGDIFF >= 6.03) {
                                    if (SUM_COL < 105.5) {
                                        oneCount++;
                                    }
                                    else if (SUM_COL >= 105.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (RANGE_MACRO_VALUE >= 37.5) {
                            if (Q4CENT_AVGDIFF < 26.75) {
                                if (Q4CENT_AVGDIFF < 3.81) {
                                    if (MAX_MACRO_VALUE < 95.5) {
                                        if (AVG_ROW < 4.51) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 4.51) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 95.5) {
                                        if (AVG_MACRO_VALUE < 62.56) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 62.56) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 3.81) {
                                    if (SUM_ROW < 160) {
                                        if (RANGE_MACRO_VALUE < 47) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 47) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 160) {
                                        if (Q4CENT_AVGDIFF < 4.26) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 4.26) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 26.75) {
                                if (SUM_ROW < 387) {
                                    if (Q1CENT_AVGDIFF < 10.75) {
                                        if (VARIANCE < 597.94) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 597.94) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 10.75) {
                                        oneCount++;
                                    }
                                }
                                else if (SUM_ROW >= 387) {
                                    if (Q1CENT_AVGDIFF < 10.72) {
                                        if (Q4CENT_AVGDIFF < 30.24) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 30.24) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 10.72) {
                                        if (MAX_MACRO_VALUE < 97.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 97.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 64.1) {
                        if (SUM_ROW < 393.5) {
                            if (VARIANCE < 3.98) {
                                if (AVG_MACRO_VALUE < 94.78) {
                                    zeroCount++;
                                }
                                else if (AVG_MACRO_VALUE >= 94.78) {
                                    if (AVG_MACRO_VALUE < 147.22) {
                                        if (MAX_MACRO_VALUE < 147.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 147.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 147.22) {
                                        if (AVG_MACRO_VALUE < 180.8) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 180.8) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (VARIANCE >= 3.98) {
                                if (Q3CENT_AVGDIFF < 2.01) {
                                    if (Q4CENT_AVGDIFF < 0.38) {
                                        zeroCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.38) {
                                        if (Q3CENT_AVGDIFF < 0.38) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.38) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 2.01) {
                                    if (MAX_MACRO_VALUE < 84.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 84.5) {
                                        if (AVG_COL < 2.28) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 2.28) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW >= 393.5) {
                            if (RANGE_MACRO_VALUE < 15.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 15.5) {
                                if (MAX_MACRO_VALUE < 122.5) {
                                    if (AVG_MACRO_VALUE < 97.97) {
                                        if (SUM_ROW < 452.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 452.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 97.97) {
                                        if (VARIANCE < 80.7) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 80.7) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 122.5) {
                                    if (SUM_ROW < 1050) {
                                        if (VARIANCE < 29.5) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 29.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 1050) {
                                        if (Q4CENT_AVGDIFF < 2.85) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 2.85) {
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
        else if (SUM_ROW_COL >= 1588.5) {
            if (RANGE_MACRO_VALUE < 49.5) {
                if (SUM_ROW_COL < 1634.5) {
                    if (SUM_ROW < 850.5) {
                        if (SUM_ROW < 762.5) {
                            if (MIN_MACRO_VALUE < 34.5) {
                                if (Q1CENT_AVGDIFF < 31.89) {
                                    zeroCount++;
                                }
                                else if (Q1CENT_AVGDIFF >= 31.89) {
                                    oneCount++;
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 34.5) {
                                if (Q4CENT_AVGDIFF < 1.9) {
                                    if (Q2CENT_AVGDIFF < 4.33) {
                                        zeroCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 4.33) {
                                        if (SUM_COL < 982.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 982.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 1.9) {
                                    if (Q2CENT_AVGDIFF < 5.9) {
                                        if (Q1CENT_AVGDIFF < 0.83) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.83) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 5.9) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW >= 762.5) {
                            zeroCount++;
                        }
                    }
                    else if (SUM_ROW >= 850.5) {
                        if (VARIANCE < 136.13) {
                            if (RANGE_MACRO_VALUE < 32.5) {
                                if (AVG_COL < 2.71) {
                                    zeroCount++;
                                }
                                else if (AVG_COL >= 2.71) {
                                    if (Q3CENT_AVGDIFF < 6.29) {
                                        if (SUM_COL < 703.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 703.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 6.29) {
                                        if (SUM_COL < 691.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 691.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 32.5) {
                                if (AVG_MACRO_VALUE < 78.03) {
                                    if (AVG_MACRO_VALUE < 53.58) {
                                        if (RANGE_MACRO_VALUE < 37.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 37.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 53.58) {
                                        if (AVG_ROW < 4.75) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 4.75) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 78.03) {
                                    if (VARIANCE < 72.8) {
                                        if (VARIANCE < 42.6) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 42.6) {
                                            oneCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 72.8) {
                                        if (MAX_MACRO_VALUE < 118) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 118) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (VARIANCE >= 136.13) {
                            if (SUM_COL < 466.5) {
                                zeroCount++;
                            }
                            else if (SUM_COL >= 466.5) {
                                if (VARIANCE < 161.29) {
                                    oneCount++;
                                }
                                else if (VARIANCE >= 161.29) {
                                    if (RANGE_MACRO_VALUE < 46.5) {
                                        if (RANGE_MACRO_VALUE < 40) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 40) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 46.5) {
                                        if (MAX_MACRO_VALUE < 90) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 90) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (SUM_ROW_COL >= 1634.5) {
                    if (VARIANCE < 25.68) {
                        zeroCount++;
                    }
                    else if (VARIANCE >= 25.68) {
                        if (Q4CENT_AVGDIFF < 15.82) {
                            if (Q4CENT_AVGDIFF < 2.78) {
                                if (SUM_ROW < 745) {
                                    if (MAX_MACRO_VALUE < 75.5) {
                                        if (SUM_ROW_COL < 1743.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1743.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 75.5) {
                                        if (Q4CENT_AVGDIFF < 1.33) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 1.33) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 745) {
                                    if (Q2CENT_AVGDIFF < 18.93) {
                                        if (Q4CENT_AVGDIFF < 2.42) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 2.42) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 18.93) {
                                        if (SUM_ROW_COL < 1853.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1853.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 2.78) {
                                if (VARIANCE < 39.6) {
                                    if (AVG_ROW < 3.56) {
                                        if (AVG_COL < 4.5) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 4.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 3.56) {
                                        if (RANGE_MACRO_VALUE < 35.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 35.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 39.6) {
                                    if (Q2CENT_AVGDIFF < 14.32) {
                                        if (Q2CENT_AVGDIFF < 9.76) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 9.76) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 14.32) {
                                        if (Q3CENT_AVGDIFF < 3.24) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 3.24) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 15.82) {
                            if (RANGE_MACRO_VALUE < 42.5) {
                                if (Q4CENT_AVGDIFF < 16.13) {
                                    if (Q1CENT_AVGDIFF < 7.56) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 7.56) {
                                        oneCount++;
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 16.13) {
                                    if (MIN_MACRO_VALUE < 24.5) {
                                        if (SUM_ROW < 1087) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 1087) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 24.5) {
                                        if (Q1CENT_AVGDIFF < 6.64) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 6.64) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 42.5) {
                                if (AVG_MACRO_VALUE < 79.66) {
                                    if (Q1CENT_AVGDIFF < 21.13) {
                                        if (Q4CENT_AVGDIFF < 23.11) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 23.11) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 21.13) {
                                        if (Q2CENT_AVGDIFF < 15.07) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 15.07) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 79.66) {
                                    if (MAX_MACRO_VALUE < 111.5) {
                                        if (AVG_ROW < 5.34) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 5.34) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 111.5) {
                                        if (Q4CENT_AVGDIFF < 24.88) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 24.88) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (RANGE_MACRO_VALUE >= 49.5) {
                if (AVG_MACRO_VALUE < 24.77) {
                    if (Q1CENT_AVGDIFF < 0.46) {
                        if (VARIANCE < 185.68) {
                            zeroCount++;
                        }
                        else if (VARIANCE >= 185.68) {
                            oneCount++;
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 0.46) {
                        if (SUM_COL < 1024.5) {
                            if (RANGE_MACRO_VALUE < 131) {
                                if (MAX_MACRO_VALUE < 116) {
                                    if (MIN_MACRO_VALUE < 17.5) {
                                        zeroCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 17.5) {
                                        oneCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 116) {
                                    zeroCount++;
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 131) {
                                oneCount++;
                            }
                        }
                        else if (SUM_COL >= 1024.5) {
                            if (RANGE_MACRO_VALUE < 100.5) {
                                oneCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 100.5) {
                                if (Q1CENT_AVGDIFF < 21.67) {
                                    if (Q4CENT_AVGDIFF < 8.81) {
                                        oneCount++;
                                    }
                                    else if (Q4CENT_AVGDIFF >= 8.81) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 21.67) {
                                    if (Q1CENT_AVGDIFF < 23.39) {
                                        zeroCount++;
                                    }
                                    else if (Q1CENT_AVGDIFF >= 23.39) {
                                        if (RANGE_MACRO_VALUE < 113.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 113.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 24.77) {
                    if (SUM_ROW < 4811.5) {
                        if (Q1CENT_AVGDIFF < 4.15) {
                            if (SUM_COL < 1758.5) {
                                if (SUM_ROW_COL < 2663.5) {
                                    if (VARIANCE < 224.9) {
                                        if (Q2CENT_AVGDIFF < 4.56) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 4.56) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 224.9) {
                                        if (SUM_ROW_COL < 2495.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 2495.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 2663.5) {
                                    if (SUM_COL < 1275.5) {
                                        if (AVG_MACRO_VALUE < 45.15) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 45.15) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 1275.5) {
                                        if (Q1CENT_AVGDIFF < 1.35) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 1.35) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_COL >= 1758.5) {
                                if (SUM_COL < 1766.5) {
                                    if (VARIANCE < 334.05) {
                                        zeroCount++;
                                    }
                                    else if (VARIANCE >= 334.05) {
                                        if (Q1CENT_AVGDIFF < 3.07) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 3.07) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 1766.5) {
                                    if (MIN_MACRO_VALUE < 118.5) {
                                        if (Q4CENT_AVGDIFF < 105.36) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 105.36) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 118.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 4.15) {
                            if (SUM_ROW_COL < 2881.5) {
                                if (AVG_MACRO_VALUE < 69.23) {
                                    if (MAX_MACRO_VALUE < 228.5) {
                                        if (VARIANCE < 77.58) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 77.58) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 228.5) {
                                        if (SUM_ROW < 724.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 724.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 69.23) {
                                    if (SUM_ROW < 848.5) {
                                        if (SUM_ROW < 840) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 840) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 848.5) {
                                        if (SUM_ROW_COL < 1768.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1768.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW_COL >= 2881.5) {
                                if (SUM_ROW_COL < 2882.5) {
                                    if (SUM_COL < 1548.5) {
                                        if (RANGE_MACRO_VALUE < 76.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 76.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 1548.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_ROW_COL >= 2882.5) {
                                    if (AVG_MACRO_VALUE < 33.81) {
                                        if (SUM_ROW_COL < 4928) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 4928) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 33.81) {
                                        if (Q4CENT_AVGDIFF < 0.69) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.69) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (SUM_ROW >= 4811.5) {
                        if (Q4CENT_AVGDIFF < 7.88) {
                            if (AVG_ROW < 21.7) {
                                if (SUM_COL < 1326) {
                                    zeroCount++;
                                }
                                else if (SUM_COL >= 1326) {
                                    if (RANGE_MACRO_VALUE < 164.5) {
                                        if (Q2CENT_AVGDIFF < 23.49) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 23.49) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 164.5) {
                                        if (SUM_COL < 3268.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 3268.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_ROW >= 21.7) {
                                if (AVG_MACRO_VALUE < 97.66) {
                                    if (SUM_COL < 1286) {
                                        oneCount++;
                                    }
                                    else if (SUM_COL >= 1286) {
                                        if (MAX_MACRO_VALUE < 161) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 161) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 97.66) {
                                    if (SUM_COL < 7323.5) {
                                        if (Q2CENT_AVGDIFF < 75.9) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 75.9) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 7323.5) {
                                        if (Q4CENT_AVGDIFF < 5.78) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 5.78) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 7.88) {
                            if (SUM_ROW_COL < 5773) {
                                if (AVG_COL < 0.78) {
                                    if (AVG_COL < 0.57) {
                                        zeroCount++;
                                    }
                                    else if (AVG_COL >= 0.57) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_COL >= 0.78) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_ROW_COL >= 5773) {
                                if (Q4CENT_AVGDIFF < 10.88) {
                                    if (AVG_MACRO_VALUE < 135.01) {
                                        if (Q4CENT_AVGDIFF < 10.1) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 10.1) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 135.01) {
                                        if (VARIANCE < 2477.1) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 2477.1) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 10.88) {
                                    if (SUM_ROW < 4883) {
                                        if (RANGE_MACRO_VALUE < 199) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 199) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 4883) {
                                        if (AVG_ROW < 21.3) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 21.3) {
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
        
    //TREE 9
    if (VARIANCE < 141.54) {
            if (SUM_COL < 82.5) {
                if (MAX_MACRO_VALUE < 58.5) {
                    if (SUM_ROW_COL < 153.5) {
                        if (AVG_COL < 0.23) {
                            if (VARIANCE < 0.91) {
                                if (VARIANCE < 0.41) {
                                    if (SUM_COL < 46.5) {
                                        if (SUM_COL < 40.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 40.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 46.5) {
                                        if (Q1CENT_AVGDIFF < 0.28) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.28) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 0.41) {
                                    if (AVG_MACRO_VALUE < 30.54) {
                                        if (VARIANCE < 0.43) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 0.43) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 30.54) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (VARIANCE >= 0.91) {
                                if (Q1CENT_AVGDIFF < 1.01) {
                                    if (VARIANCE < 1.14) {
                                        zeroCount++;
                                    }
                                    else if (VARIANCE >= 1.14) {
                                        if (AVG_MACRO_VALUE < 27.16) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 27.16) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 1.01) {
                                    if (SUM_COL < 48.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_COL >= 48.5) {
                                        if (AVG_MACRO_VALUE < 25.88) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 25.88) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_COL >= 0.23) {
                            if (SUM_COL < 55.5) {
                                if (SUM_ROW_COL < 104.5) {
                                    zeroCount++;
                                }
                                else if (SUM_ROW_COL >= 104.5) {
                                    if (AVG_ROW < 0.21) {
                                        if (SUM_ROW_COL < 105.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 105.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 0.21) {
                                        if (VARIANCE < 0.14) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 0.14) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_COL >= 55.5) {
                                if (SUM_COL < 74.5) {
                                    if (Q4CENT_AVGDIFF < 0.17) {
                                        if (MAX_MACRO_VALUE < 20.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 20.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.17) {
                                        if (Q2CENT_AVGDIFF < 1.68) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 1.68) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 74.5) {
                                    if (MIN_MACRO_VALUE < 18.5) {
                                        if (AVG_ROW < 0.32) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 0.32) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 18.5) {
                                        if (SUM_ROW < 69.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 69.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 153.5) {
                        if (AVG_ROW < 0.33) {
                            zeroCount++;
                        }
                        else if (AVG_ROW >= 0.33) {
                            if (VARIANCE < 0.22) {
                                if (SUM_COL < 68.5) {
                                    if (Q2CENT_AVGDIFF < 0.21) {
                                        zeroCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 0.21) {
                                        if (Q4CENT_AVGDIFF < 0.29) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.29) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 68.5) {
                                    if (Q2CENT_AVGDIFF < 0.33) {
                                        zeroCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 0.33) {
                                        if (AVG_COL < 0.34) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 0.34) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (VARIANCE >= 0.22) {
                                if (SUM_ROW_COL < 154.5) {
                                    zeroCount++;
                                }
                                else if (SUM_ROW_COL >= 154.5) {
                                    if (SUM_COL < 63.5) {
                                        if (AVG_MACRO_VALUE < 45.13) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 45.13) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 63.5) {
                                        if (MIN_MACRO_VALUE < 30.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 30.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else if (MAX_MACRO_VALUE >= 58.5) {
                    if (Q2CENT_AVGDIFF < 16.85) {
                        if (Q1CENT_AVGDIFF < 0.29) {
                            if (MIN_MACRO_VALUE < 164.5) {
                                if (Q3CENT_AVGDIFF < 0.6) {
                                    if (RANGE_MACRO_VALUE < 2.5) {
                                        if (MAX_MACRO_VALUE < 128.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 128.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 2.5) {
                                        if (AVG_MACRO_VALUE < 101.87) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 101.87) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 0.6) {
                                    if (MIN_MACRO_VALUE < 30.5) {
                                        if (Q4CENT_AVGDIFF < 8.29) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 8.29) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 30.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 164.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q1CENT_AVGDIFF >= 0.29) {
                            if (AVG_COL < 0.32) {
                                if (SUM_COL < 70.5) {
                                    if (SUM_COL < 64.5) {
                                        if (AVG_ROW < 0.2) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 0.2) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 64.5) {
                                        if (Q1CENT_AVGDIFF < 3.99) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 3.99) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 70.5) {
                                    if (SUM_ROW_COL < 143.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW_COL >= 143.5) {
                                        if (AVG_ROW < 0.28) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 0.28) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_COL >= 0.32) {
                                if (VARIANCE < 43.89) {
                                    if (MAX_MACRO_VALUE < 71.5) {
                                        zeroCount++;
                                    }
                                    else if (MAX_MACRO_VALUE >= 71.5) {
                                        if (VARIANCE < 1.64) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 1.64) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 43.89) {
                                    if (VARIANCE < 125.76) {
                                        oneCount++;
                                    }
                                    else if (VARIANCE >= 125.76) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 16.85) {
                        if (SUM_ROW_COL < 1120.5) {
                            if (AVG_ROW < 3.81) {
                                oneCount++;
                            }
                            else if (AVG_ROW >= 3.81) {
                                if (VARIANCE < 113.6) {
                                    zeroCount++;
                                }
                                else if (VARIANCE >= 113.6) {
                                    if (Q1CENT_AVGDIFF < 17.47) {
                                        if (SUM_ROW_COL < 1008) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1008) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 17.47) {
                                        if (Q2CENT_AVGDIFF < 18.54) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 18.54) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW_COL >= 1120.5) {
                            zeroCount++;
                        }
                    }
                }
            }
            else if (SUM_COL >= 82.5) {
                if (AVG_ROW < 8.59) {
                    if (MAX_MACRO_VALUE < 83.5) {
                        if (VARIANCE < 138.27) {
                            if (MIN_MACRO_VALUE < 32.5) {
                                if (AVG_ROW < 0.39) {
                                    if (AVG_MACRO_VALUE < 20.68) {
                                        if (SUM_ROW < 81.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 81.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 20.68) {
                                        if (MAX_MACRO_VALUE < 25.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 25.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 0.39) {
                                    if (RANGE_MACRO_VALUE < 49.5) {
                                        if (SUM_ROW_COL < 1275.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1275.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 49.5) {
                                        if (SUM_ROW_COL < 2090) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 2090) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 32.5) {
                                if (SUM_ROW < 676.5) {
                                    if (SUM_ROW < 370.5) {
                                        if (SUM_COL < 315.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 315.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 370.5) {
                                        if (SUM_ROW_COL < 848.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 848.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 676.5) {
                                    if (Q2CENT_AVGDIFF < 0.19) {
                                        zeroCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 0.19) {
                                        if (VARIANCE < 49.97) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 49.97) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (VARIANCE >= 138.27) {
                            if (AVG_ROW < 7.04) {
                                if (SUM_ROW_COL < 1063.5) {
                                    if (AVG_COL < 0.61) {
                                        oneCount++;
                                    }
                                    else if (AVG_COL >= 0.61) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_ROW_COL >= 1063.5) {
                                    zeroCount++;
                                }
                            }
                            else if (AVG_ROW >= 7.04) {
                                oneCount++;
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 83.5) {
                        if (AVG_MACRO_VALUE < 63.37) {
                            if (RANGE_MACRO_VALUE < 37.5) {
                                if (SUM_ROW < 227) {
                                    if (VARIANCE < 7.96) {
                                        if (SUM_COL < 174) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 174) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 7.96) {
                                        oneCount++;
                                    }
                                }
                                else if (SUM_ROW >= 227) {
                                    if (Q2CENT_AVGDIFF < 11.47) {
                                        if (Q1CENT_AVGDIFF < 14.46) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 14.46) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 11.47) {
                                        if (SUM_COL < 908.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 908.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 37.5) {
                                if (MAX_MACRO_VALUE < 84.5) {
                                    if (AVG_COL < 1.55) {
                                        if (SUM_COL < 347.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 347.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 1.55) {
                                        if (Q2CENT_AVGDIFF < 1.33) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 1.33) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 84.5) {
                                    if (Q1CENT_AVGDIFF < 3.43) {
                                        if (SUM_COL < 475.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 475.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 3.43) {
                                        if (Q1CENT_AVGDIFF < 22.51) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 22.51) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 63.37) {
                            if (AVG_MACRO_VALUE < 63.61) {
                                zeroCount++;
                            }
                            else if (AVG_MACRO_VALUE >= 63.61) {
                                if (SUM_ROW_COL < 3087.5) {
                                    if (Q2CENT_AVGDIFF < 27.82) {
                                        if (RANGE_MACRO_VALUE < 66.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 66.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 27.82) {
                                        if (RANGE_MACRO_VALUE < 58.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 58.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 3087.5) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                }
                else if (AVG_ROW >= 8.59) {
                    if (MAX_MACRO_VALUE < 103.5) {
                        if (SUM_ROW < 2068) {
                            oneCount++;
                        }
                        else if (SUM_ROW >= 2068) {
                            if (SUM_ROW < 2216.5) {
                                if (RANGE_MACRO_VALUE < 40.5) {
                                    oneCount++;
                                }
                                else if (RANGE_MACRO_VALUE >= 40.5) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_ROW >= 2216.5) {
                                if (Q4CENT_AVGDIFF < 5.56) {
                                    if (SUM_COL < 1193.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_COL >= 1193.5) {
                                        oneCount++;
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 5.56) {
                                    if (SUM_ROW_COL < 2960.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW_COL >= 2960.5) {
                                        if (Q3CENT_AVGDIFF < 6.25) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 6.25) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 103.5) {
                        if (AVG_COL < 5.63) {
                            if (Q2CENT_AVGDIFF < 3.14) {
                                oneCount++;
                            }
                            else if (Q2CENT_AVGDIFF >= 3.14) {
                                if (AVG_ROW < 9.93) {
                                    if (MIN_MACRO_VALUE < 64.5) {
                                        if (AVG_MACRO_VALUE < 72.04) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 72.04) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 64.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (AVG_ROW >= 9.93) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (AVG_COL >= 5.63) {
                            zeroCount++;
                        }
                    }
                }
            }
        }
        else if (VARIANCE >= 141.54) {
            if (MIN_MACRO_VALUE < 163.5) {
                if (VARIANCE < 141.94) {
                    if (Q2CENT_AVGDIFF < 7.1) {
                        if (AVG_MACRO_VALUE < 65.88) {
                            zeroCount++;
                        }
                        else if (AVG_MACRO_VALUE >= 65.88) {
                            oneCount++;
                        }
                    }
                    else if (Q2CENT_AVGDIFF >= 7.1) {
                        if (AVG_MACRO_VALUE < 32) {
                            if (VARIANCE < 141.81) {
                                zeroCount++;
                            }
                            else if (VARIANCE >= 141.81) {
                                oneCount++;
                            }
                        }
                        else if (AVG_MACRO_VALUE >= 32) {
                            zeroCount++;
                        }
                    }
                }
                else if (VARIANCE >= 141.94) {
                    if (VARIANCE < 624.76) {
                        if (Q4CENT_AVGDIFF < 31.15) {
                            if (SUM_ROW_COL < 7543.5) {
                                if (Q3CENT_AVGDIFF < 22.54) {
                                    if (Q2CENT_AVGDIFF < 41.11) {
                                        if (VARIANCE < 615.12) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 615.12) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 41.11) {
                                        if (AVG_MACRO_VALUE < 72.9) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 72.9) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 22.54) {
                                    if (Q4CENT_AVGDIFF < 24.35) {
                                        if (Q1CENT_AVGDIFF < 38.94) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 38.94) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 24.35) {
                                        if (MIN_MACRO_VALUE < 35.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 35.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (SUM_ROW_COL >= 7543.5) {
                                zeroCount++;
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 31.15) {
                            if (AVG_MACRO_VALUE < 104.57) {
                                if (Q3CENT_AVGDIFF < 13.01) {
                                    if (SUM_ROW < 3889) {
                                        if (Q2CENT_AVGDIFF < 25.13) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 25.13) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 3889) {
                                        if (SUM_COL < 1562.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 1562.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 13.01) {
                                    if (VARIANCE < 232.1) {
                                        zeroCount++;
                                    }
                                    else if (VARIANCE >= 232.1) {
                                        if (Q1CENT_AVGDIFF < 6.22) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 6.22) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 104.57) {
                                if (AVG_ROW < 9.82) {
                                    if (MIN_MACRO_VALUE < 96.5) {
                                        if (MIN_MACRO_VALUE < 57.5) {
                                            zeroCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 57.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 96.5) {
                                        if (Q4CENT_AVGDIFF < 33.69) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 33.69) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 9.82) {
                                    zeroCount++;
                                }
                            }
                        }
                    }
                    else if (VARIANCE >= 624.76) {
                        if (Q4CENT_AVGDIFF < 0.81) {
                            if (AVG_COL < 8.87) {
                                if (RANGE_MACRO_VALUE < 106.5) {
                                    if (SUM_ROW < 965.5) {
                                        if (Q3CENT_AVGDIFF < 5.47) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 5.47) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 965.5) {
                                        if (AVG_MACRO_VALUE < 65.42) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 65.42) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 106.5) {
                                    if (RANGE_MACRO_VALUE < 165.5) {
                                        if (SUM_ROW < 4383) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 4383) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 165.5) {
                                        if (SUM_ROW < 1207.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 1207.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_COL >= 8.87) {
                                if (Q3CENT_AVGDIFF < 2.76) {
                                    if (MIN_MACRO_VALUE < 41) {
                                        oneCount++;
                                    }
                                    else if (MIN_MACRO_VALUE >= 41) {
                                        if (RANGE_MACRO_VALUE < 165) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 165) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 2.76) {
                                    if (AVG_MACRO_VALUE < 44.17) {
                                        if (MIN_MACRO_VALUE < 16.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 16.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 44.17) {
                                        if (RANGE_MACRO_VALUE < 97) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 97) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 0.81) {
                            if (RANGE_MACRO_VALUE < 86.5) {
                                if (Q4CENT_AVGDIFF < 7.78) {
                                    if (Q1CENT_AVGDIFF < 5.46) {
                                        if (AVG_COL < 15.86) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 15.86) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 5.46) {
                                        if (Q4CENT_AVGDIFF < 5.03) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 5.03) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 7.78) {
                                    if (MIN_MACRO_VALUE < 119.5) {
                                        if (SUM_ROW_COL < 2172) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 2172) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 119.5) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 86.5) {
                                if (AVG_ROW < 12.04) {
                                    if (SUM_COL < 593.5) {
                                        if (SUM_ROW < 2283) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW >= 2283) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 593.5) {
                                        if (Q3CENT_AVGDIFF < 35.76) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 35.76) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 12.04) {
                                    if (Q2CENT_AVGDIFF < 6.92) {
                                        if (Q1CENT_AVGDIFF < 33.24) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 33.24) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 6.92) {
                                        if (VARIANCE < 882.41) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 882.41) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 163.5) {
                zeroCount++;
            }
        }
        
    //TREE 10
    if (SUM_ROW_COL < 2074.5) {
            if (AVG_ROW < 0.39) {
                if (VARIANCE < 0.55) {
                    if (AVG_COL < 0.02) {
                        if (SUM_ROW_COL < 2.5) {
                            if (RANGE_MACRO_VALUE < 0.5) {
                                if (MAX_MACRO_VALUE < 26.5) {
                                    if (AVG_MACRO_VALUE < 20.5) {
                                        if (MAX_MACRO_VALUE < 17.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 17.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 20.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 26.5) {
                                    oneCount++;
                                }
                            }
                            else if (RANGE_MACRO_VALUE >= 0.5) {
                                if (MIN_MACRO_VALUE < 20.5) {
                                    zeroCount++;
                                }
                                else if (MIN_MACRO_VALUE >= 20.5) {
                                    if (AVG_MACRO_VALUE < 25) {
                                        oneCount++;
                                    }
                                    else if (AVG_MACRO_VALUE >= 25) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                        else if (SUM_ROW_COL >= 2.5) {
                            zeroCount++;
                        }
                    }
                    else if (AVG_COL >= 0.02) {
                        if (Q2CENT_AVGDIFF < 1.19) {
                            if (VARIANCE < 0.53) {
                                if (SUM_ROW_COL < 29.5) {
                                    if (SUM_COL < 19.5) {
                                        if (SUM_COL < 13.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 13.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 19.5) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_ROW_COL >= 29.5) {
                                    if (Q4CENT_AVGDIFF < 0.28) {
                                        if (VARIANCE < 0.52) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 0.52) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.28) {
                                        if (MAX_MACRO_VALUE < 46.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 46.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (VARIANCE >= 0.53) {
                                if (SUM_ROW < 40.5) {
                                    zeroCount++;
                                }
                                else if (SUM_ROW >= 40.5) {
                                    if (Q2CENT_AVGDIFF < 0.64) {
                                        if (SUM_ROW < 87.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 87.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 0.64) {
                                        if (Q1CENT_AVGDIFF < 0.81) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.81) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q2CENT_AVGDIFF >= 1.19) {
                            zeroCount++;
                        }
                    }
                }
                else if (VARIANCE >= 0.55) {
                    if (AVG_MACRO_VALUE < 33.48) {
                        if (AVG_ROW < 0.39) {
                            if (Q2CENT_AVGDIFF < 0.4) {
                                if (RANGE_MACRO_VALUE < 3.5) {
                                    if (SUM_COL < 41) {
                                        if (Q1CENT_AVGDIFF < 0.42) {
                                            oneCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.42) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 41) {
                                        if (Q3CENT_AVGDIFF < 0.04) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.04) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (RANGE_MACRO_VALUE >= 3.5) {
                                    if (MIN_MACRO_VALUE < 28.5) {
                                        if (Q4CENT_AVGDIFF < 1.43) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 1.43) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 28.5) {
                                        if (AVG_ROW < 0.32) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 0.32) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 0.4) {
                                if (MIN_MACRO_VALUE < 25.5) {
                                    if (Q3CENT_AVGDIFF < 0.37) {
                                        if (MAX_MACRO_VALUE < 24.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 24.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.37) {
                                        if (Q4CENT_AVGDIFF < 0.35) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 0.35) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (MIN_MACRO_VALUE >= 25.5) {
                                    if (SUM_COL < 47) {
                                        zeroCount++;
                                    }
                                    else if (SUM_COL >= 47) {
                                        if (SUM_ROW_COL < 127.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 127.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_ROW >= 0.39) {
                            if (Q1CENT_AVGDIFF < 2.36) {
                                zeroCount++;
                            }
                            else if (Q1CENT_AVGDIFF >= 2.36) {
                                oneCount++;
                            }
                        }
                    }
                    else if (AVG_MACRO_VALUE >= 33.48) {
                        if (AVG_COL < 0.35) {
                            if (Q4CENT_AVGDIFF < 1.64) {
                                if (MIN_MACRO_VALUE < 33.5) {
                                    zeroCount++;
                                }
                                else if (MIN_MACRO_VALUE >= 33.5) {
                                    if (Q1CENT_AVGDIFF < 0.43) {
                                        if (Q1CENT_AVGDIFF < 0.07) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 0.07) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 0.43) {
                                        if (VARIANCE < 1.69) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 1.69) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q4CENT_AVGDIFF >= 1.64) {
                                zeroCount++;
                            }
                        }
                        else if (AVG_COL >= 0.35) {
                            if (VARIANCE < 1.1) {
                                if (Q4CENT_AVGDIFF < 1.03) {
                                    zeroCount++;
                                }
                                else if (Q4CENT_AVGDIFF >= 1.03) {
                                    if (AVG_MACRO_VALUE < 39.52) {
                                        if (Q3CENT_AVGDIFF < 0.28) {
                                            zeroCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.28) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 39.52) {
                                        zeroCount++;
                                    }
                                }
                            }
                            else if (VARIANCE >= 1.1) {
                                if (SUM_ROW_COL < 159) {
                                    if (SUM_ROW < 58.5) {
                                        zeroCount++;
                                    }
                                    else if (SUM_ROW >= 58.5) {
                                        if (MAX_MACRO_VALUE < 83.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 83.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 159) {
                                    if (SUM_COL < 95.5) {
                                        if (SUM_COL < 90.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 90.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 95.5) {
                                        if (Q2CENT_AVGDIFF < 0.71) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.71) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (AVG_ROW >= 0.39) {
                if (SUM_ROW_COL < 1072.5) {
                    if (RANGE_MACRO_VALUE < 50.5) {
                        if (SUM_ROW_COL < 997.5) {
                            if (Q3CENT_AVGDIFF < 10.35) {
                                if (Q3CENT_AVGDIFF < 7.01) {
                                    if (SUM_ROW < 943.5) {
                                        if (SUM_COL < 567.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 567.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 943.5) {
                                        oneCount++;
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 7.01) {
                                    if (AVG_MACRO_VALUE < 60.96) {
                                        if (SUM_ROW_COL < 980.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 980.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 60.96) {
                                        if (MAX_MACRO_VALUE < 175.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 175.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 10.35) {
                                if (Q1CENT_AVGDIFF < 16.74) {
                                    if (AVG_MACRO_VALUE < 53.94) {
                                        if (VARIANCE < 46.37) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 46.37) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 53.94) {
                                        if (AVG_ROW < 1.35) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 1.35) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q1CENT_AVGDIFF >= 16.74) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (SUM_ROW_COL >= 997.5) {
                            if (AVG_MACRO_VALUE < 57.33) {
                                if (AVG_COL < 1.94) {
                                    if (Q2CENT_AVGDIFF < 0.69) {
                                        zeroCount++;
                                    }
                                    else if (Q2CENT_AVGDIFF >= 0.69) {
                                        if (AVG_MACRO_VALUE < 49.21) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 49.21) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_COL >= 1.94) {
                                    if (MAX_MACRO_VALUE < 58.5) {
                                        if (SUM_ROW_COL < 1036.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1036.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 58.5) {
                                        if (MIN_MACRO_VALUE < 19.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 19.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 57.33) {
                                if (SUM_COL < 510.5) {
                                    if (MAX_MACRO_VALUE < 69.5) {
                                        if (Q2CENT_AVGDIFF < 3.92) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 3.92) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 69.5) {
                                        if (Q1CENT_AVGDIFF < 2.89) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 2.89) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_COL >= 510.5) {
                                    if (SUM_COL < 512.5) {
                                        if (MAX_MACRO_VALUE < 77.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 77.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_COL >= 512.5) {
                                        if (MAX_MACRO_VALUE < 100.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 100.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (RANGE_MACRO_VALUE >= 50.5) {
                        if (Q3CENT_AVGDIFF < 18.25) {
                            if (AVG_COL < 2.86) {
                                if (Q4CENT_AVGDIFF < 16.26) {
                                    if (Q3CENT_AVGDIFF < 16.63) {
                                        if (Q3CENT_AVGDIFF < 9.38) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 9.38) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 16.63) {
                                        if (SUM_COL < 354) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 354) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 16.26) {
                                    if (SUM_ROW < 564) {
                                        if (Q2CENT_AVGDIFF < 1.07) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 1.07) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW >= 564) {
                                        if (SUM_COL < 306.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_COL >= 306.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_COL >= 2.86) {
                                if (MAX_MACRO_VALUE < 194.5) {
                                    if (MIN_MACRO_VALUE < 34) {
                                        if (MAX_MACRO_VALUE < 138) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 138) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MIN_MACRO_VALUE >= 34) {
                                        if (Q4CENT_AVGDIFF < 6.81) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 6.81) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (MAX_MACRO_VALUE >= 194.5) {
                                    zeroCount++;
                                }
                            }
                        }
                        else if (Q3CENT_AVGDIFF >= 18.25) {
                            if (SUM_ROW < 696) {
                                if (AVG_MACRO_VALUE < 28.21) {
                                    if (SUM_COL < 606) {
                                        zeroCount++;
                                    }
                                    else if (SUM_COL >= 606) {
                                        oneCount++;
                                    }
                                }
                                else if (AVG_MACRO_VALUE >= 28.21) {
                                    zeroCount++;
                                }
                            }
                            else if (SUM_ROW >= 696) {
                                if (Q2CENT_AVGDIFF < 2.65) {
                                    zeroCount++;
                                }
                                else if (Q2CENT_AVGDIFF >= 2.65) {
                                    if (VARIANCE < 225.79) {
                                        oneCount++;
                                    }
                                    else if (VARIANCE >= 225.79) {
                                        zeroCount++;
                                    }
                                }
                            }
                        }
                    }
                }
                else if (SUM_ROW_COL >= 1072.5) {
                    if (MAX_MACRO_VALUE < 121.5) {
                        if (VARIANCE < 164.84) {
                            if (MIN_MACRO_VALUE < 81.5) {
                                if (VARIANCE < 10.42) {
                                    if (MAX_MACRO_VALUE < 83.5) {
                                        if (RANGE_MACRO_VALUE < 21.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 21.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 83.5) {
                                        if (AVG_COL < 1.97) {
                                            zeroCount++;
                                        }
                                        else if (AVG_COL >= 1.97) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 10.42) {
                                    if (RANGE_MACRO_VALUE < 17.5) {
                                        zeroCount++;
                                    }
                                    else if (RANGE_MACRO_VALUE >= 17.5) {
                                        if (SUM_ROW_COL < 1082.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1082.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (MIN_MACRO_VALUE >= 81.5) {
                                zeroCount++;
                            }
                        }
                        else if (VARIANCE >= 164.84) {
                            if (Q2CENT_AVGDIFF < 4.04) {
                                if (SUM_ROW < 1068.5) {
                                    if (Q4CENT_AVGDIFF < 24.86) {
                                        if (MIN_MACRO_VALUE < 53.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 53.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 24.86) {
                                        if (SUM_ROW < 495.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW >= 495.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW >= 1068.5) {
                                    if (RANGE_MACRO_VALUE < 84.5) {
                                        if (AVG_ROW < 6.74) {
                                            zeroCount++;
                                        }
                                        else if (AVG_ROW >= 6.74) {
                                            oneCount++;
                                        }
                                    }
                                    else if (RANGE_MACRO_VALUE >= 84.5) {
                                        if (Q2CENT_AVGDIFF < 0.86) {
                                            oneCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 0.86) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q2CENT_AVGDIFF >= 4.04) {
                                if (SUM_ROW_COL < 2058) {
                                    if (Q4CENT_AVGDIFF < 17.67) {
                                        if (AVG_COL < 5.75) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 5.75) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 17.67) {
                                        if (AVG_MACRO_VALUE < 44.67) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 44.67) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (SUM_ROW_COL >= 2058) {
                                    if (AVG_ROW < 3) {
                                        oneCount++;
                                    }
                                    else if (AVG_ROW >= 3) {
                                        if (Q4CENT_AVGDIFF < 52.26) {
                                            zeroCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 52.26) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if (MAX_MACRO_VALUE >= 121.5) {
                        if (AVG_ROW < 6.45) {
                            if (AVG_MACRO_VALUE < 64) {
                                if (AVG_ROW < 2.9) {
                                    if (Q1CENT_AVGDIFF < 20.28) {
                                        if (Q3CENT_AVGDIFF < 0.93) {
                                            oneCount++;
                                        }
                                        else if (Q3CENT_AVGDIFF >= 0.93) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q1CENT_AVGDIFF >= 20.28) {
                                        if (AVG_MACRO_VALUE < 36.59) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 36.59) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (AVG_ROW >= 2.9) {
                                    if (AVG_ROW < 3.39) {
                                        if (SUM_ROW_COL < 1674.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 1674.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 3.39) {
                                        if (AVG_MACRO_VALUE < 29.09) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 29.09) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 64) {
                                if (AVG_COL < 4.54) {
                                    if (SUM_ROW_COL < 1117.5) {
                                        if (Q1CENT_AVGDIFF < 1.61) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 1.61) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 1117.5) {
                                        if (SUM_COL < 334.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_COL >= 334.5) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (AVG_COL >= 4.54) {
                                    if (Q4CENT_AVGDIFF < 0.78) {
                                        if (RANGE_MACRO_VALUE < 176.5) {
                                            zeroCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 176.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 0.78) {
                                        if (MAX_MACRO_VALUE < 145.5) {
                                            oneCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 145.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (AVG_ROW >= 6.45) {
                            if (RANGE_MACRO_VALUE < 131.5) {
                                zeroCount++;
                            }
                            else if (RANGE_MACRO_VALUE >= 131.5) {
                                oneCount++;
                            }
                        }
                    }
                }
            }
        }
        else if (SUM_ROW_COL >= 2074.5) {
            if (MIN_MACRO_VALUE < 157.5) {
                if (AVG_MACRO_VALUE < 25.06) {
                    if (Q1CENT_AVGDIFF < 28.33) {
                        if (SUM_COL < 1007.5) {
                            if (SUM_COL < 1001) {
                                oneCount++;
                            }
                            else if (SUM_COL >= 1001) {
                                zeroCount++;
                            }
                        }
                        else if (SUM_COL >= 1007.5) {
                            oneCount++;
                        }
                    }
                    else if (Q1CENT_AVGDIFF >= 28.33) {
                        if (AVG_COL < 5.59) {
                            zeroCount++;
                        }
                        else if (AVG_COL >= 5.59) {
                            oneCount++;
                        }
                    }
                }
                else if (AVG_MACRO_VALUE >= 25.06) {
                    if (SUM_ROW_COL < 2099.5) {
                        if (Q4CENT_AVGDIFF < 24.9) {
                            if (Q1CENT_AVGDIFF < 0.81) {
                                if (Q4CENT_AVGDIFF < 17.81) {
                                    if (Q2CENT_AVGDIFF < 2) {
                                        if (RANGE_MACRO_VALUE < 42.5) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 42.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q2CENT_AVGDIFF >= 2) {
                                        oneCount++;
                                    }
                                }
                                else if (Q4CENT_AVGDIFF >= 17.81) {
                                    zeroCount++;
                                }
                            }
                            else if (Q1CENT_AVGDIFF >= 0.81) {
                                if (VARIANCE < 102.48) {
                                    if (Q4CENT_AVGDIFF < 10.63) {
                                        if (SUM_ROW_COL < 2098.5) {
                                            zeroCount++;
                                        }
                                        else if (SUM_ROW_COL >= 2098.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 10.63) {
                                        if (Q2CENT_AVGDIFF < 6.22) {
                                            zeroCount++;
                                        }
                                        else if (Q2CENT_AVGDIFF >= 6.22) {
                                            oneCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 102.48) {
                                    if (VARIANCE < 745.98) {
                                        if (MIN_MACRO_VALUE < 63.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 63.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 745.98) {
                                        if (RANGE_MACRO_VALUE < 122) {
                                            oneCount++;
                                        }
                                        else if (RANGE_MACRO_VALUE >= 122) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (Q4CENT_AVGDIFF >= 24.9) {
                            if (MAX_MACRO_VALUE < 102) {
                                if (SUM_ROW_COL < 2080) {
                                    oneCount++;
                                }
                                else if (SUM_ROW_COL >= 2080) {
                                    zeroCount++;
                                }
                            }
                            else if (MAX_MACRO_VALUE >= 102) {
                                zeroCount++;
                            }
                        }
                    }
                    else if (SUM_ROW_COL >= 2099.5) {
                        if (SUM_COL < 1362.5) {
                            if (Q3CENT_AVGDIFF < 2.44) {
                                if (Q3CENT_AVGDIFF < 1.44) {
                                    if (AVG_MACRO_VALUE < 143.55) {
                                        if (MAX_MACRO_VALUE < 164.5) {
                                            zeroCount++;
                                        }
                                        else if (MAX_MACRO_VALUE >= 164.5) {
                                            oneCount++;
                                        }
                                    }
                                    else if (AVG_MACRO_VALUE >= 143.55) {
                                        zeroCount++;
                                    }
                                }
                                else if (Q3CENT_AVGDIFF >= 1.44) {
                                    if (SUM_ROW_COL < 2395) {
                                        if (AVG_MACRO_VALUE < 63.66) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 63.66) {
                                            oneCount++;
                                        }
                                    }
                                    else if (SUM_ROW_COL >= 2395) {
                                        if (AVG_MACRO_VALUE < 91.63) {
                                            zeroCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 91.63) {
                                            zeroCount++;
                                        }
                                    }
                                }
                            }
                            else if (Q3CENT_AVGDIFF >= 2.44) {
                                if (VARIANCE < 84.43) {
                                    if (Q4CENT_AVGDIFF < 13.03) {
                                        if (AVG_COL < 3.73) {
                                            oneCount++;
                                        }
                                        else if (AVG_COL >= 3.73) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q4CENT_AVGDIFF >= 13.03) {
                                        if (VARIANCE < 78.73) {
                                            oneCount++;
                                        }
                                        else if (VARIANCE >= 78.73) {
                                            zeroCount++;
                                        }
                                    }
                                }
                                else if (VARIANCE >= 84.43) {
                                    if (AVG_ROW < 9.06) {
                                        if (AVG_MACRO_VALUE < 76.35) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 76.35) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_ROW >= 9.06) {
                                        if (AVG_MACRO_VALUE < 42.7) {
                                            oneCount++;
                                        }
                                        else if (AVG_MACRO_VALUE >= 42.7) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                        else if (SUM_COL >= 1362.5) {
                            if (AVG_MACRO_VALUE < 32.47) {
                                if (SUM_ROW < 712.5) {
                                    if (AVG_COL < 8.78) {
                                        if (AVG_ROW < 2.71) {
                                            oneCount++;
                                        }
                                        else if (AVG_ROW >= 2.71) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (AVG_COL >= 8.78) {
                                        zeroCount++;
                                    }
                                }
                                else if (SUM_ROW >= 712.5) {
                                    if (MAX_MACRO_VALUE < 161) {
                                        if (VARIANCE < 234.65) {
                                            zeroCount++;
                                        }
                                        else if (VARIANCE >= 234.65) {
                                            oneCount++;
                                        }
                                    }
                                    else if (MAX_MACRO_VALUE >= 161) {
                                        if (Q1CENT_AVGDIFF < 16.92) {
                                            zeroCount++;
                                        }
                                        else if (Q1CENT_AVGDIFF >= 16.92) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                            else if (AVG_MACRO_VALUE >= 32.47) {
                                if (VARIANCE < 88.33) {
                                    if (Q3CENT_AVGDIFF < 0.33) {
                                        if (Q4CENT_AVGDIFF < 1.89) {
                                            oneCount++;
                                        }
                                        else if (Q4CENT_AVGDIFF >= 1.89) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (Q3CENT_AVGDIFF >= 0.33) {
                                        zeroCount++;
                                    }
                                }
                                else if (VARIANCE >= 88.33) {
                                    if (VARIANCE < 313.69) {
                                        if (SUM_ROW_COL < 5149.5) {
                                            oneCount++;
                                        }
                                        else if (SUM_ROW_COL >= 5149.5) {
                                            zeroCount++;
                                        }
                                    }
                                    else if (VARIANCE >= 313.69) {
                                        if (MIN_MACRO_VALUE < 35.5) {
                                            oneCount++;
                                        }
                                        else if (MIN_MACRO_VALUE >= 35.5) {
                                            oneCount++;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else if (MIN_MACRO_VALUE >= 157.5) {
                zeroCount++;
            }
        }
        

    //VOTE
    if(zeroCount > oneCount)
        binMap[i] = 0;
    else
        binMap[i] = 1;
}

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