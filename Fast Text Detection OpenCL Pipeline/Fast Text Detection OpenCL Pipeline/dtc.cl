// TODO: Add OpenCL kernel code here.

__kernel void repTest1(__global unsigned char* frame, const int width, __global bool* binMap)	//16x16 ONLY
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