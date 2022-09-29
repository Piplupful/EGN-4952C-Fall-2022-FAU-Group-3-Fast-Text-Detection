__kernel void avgFrameWrite16_2D(__global unsigned char* frame, const int width) //16x16 ONLY
{
	int x = get_global_id(0) * 16;
	int y = get_global_id(1) * 16;

	int sum = 0;

	int offset = y * width + x;

	for (int i = 0; i < 16; i++)			//over every x value
	{
		sum += frame[offset + (i * width + 0)];
		sum += frame[offset + (i * width + 1)];
		sum += frame[offset + (i * width + 2)];
		sum += frame[offset + (i * width + 3)];
		sum += frame[offset + (i * width + 4)];
		sum += frame[offset + (i * width + 5)];
		sum += frame[offset + (i * width + 6)];
		sum += frame[offset + (i * width + 7)];
		sum += frame[offset + (i * width + 8)];
		sum += frame[offset + (i * width + 9)];
		sum += frame[offset + (i * width + 10)];
		sum += frame[offset + (i * width + 11)];
		sum += frame[offset + (i * width + 12)];
		sum += frame[offset + (i * width + 13)];
		sum += frame[offset + (i * width + 14)];
		sum += frame[offset + (i * width + 15)];
	}

	if(y != 1072)
		sum /= 256;
	else
		sum /= 128;	//1080p case, 1080/16 = 67.5

	for (int i = 0; i < 16; i++)			//over every x value
	{
		frame[offset + (i * width + 0)] = sum;
		frame[offset + (i * width + 1)] = sum;
		frame[offset + (i * width + 2)] = sum;
		frame[offset + (i * width + 3)] = sum;
		frame[offset + (i * width + 4)] = sum;
		frame[offset + (i * width + 5)] = sum;
		frame[offset + (i * width + 6)] = sum;
		frame[offset + (i * width + 7)] = sum;
		frame[offset + (i * width + 8)] = sum;
		frame[offset + (i * width + 9)] = sum;
		frame[offset + (i * width + 10)] = sum;
		frame[offset + (i * width + 11)] = sum;
		frame[offset + (i * width + 12)] = sum;
		frame[offset + (i * width + 13)] = sum;
		frame[offset + (i * width + 14)] = sum;
		frame[offset + (i * width + 15)] = sum;
	}
}

//TODO: REPORT TO SEBASTIAN ISSUE WITH ORIGINAL CODE, SETUP 16X16 (USHORT16[16])
__kernel void avgFrameWrite16_2D_Opt(__global unsigned char* frame, const int width) //16x16 ONLY
{
	int x = get_global_id(0) * 16;
	int y = get_global_id(1) * 16;
	int offset = y * width + x;

	uint avg = 0;
	
	ushort16 sum16 = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

	uchar16 * pixels = *(frame + offset);

	//sum of pixel columns

	for (int i = 0; i < 16; i++)
		sum16 += convert_ushort16(*(pixels + i * width));

	//Reduction step
	ushort8 sum8 = sum16.s01234567 + sum16.s89abcdef;

	ushort4 sum4 = sum8.s0123 + sum8.s4567;

	ushort2 sum2 = sum4.xy + sum4.zw;

	//Final accumulation
	avg += sum2.x + sum2.y;
	
	//Averaging
	avg = avg / 256;
	//avg = x % 256; 
	//Flip Queue issue caused by assinging average into frame
	for (int i = 0; i < 16; i++)			//over every x value
	{
		frame[offset + (i * width + 0)] = avg;
		frame[offset + (i * width + 1)] = avg;
		frame[offset + (i * width + 2)] = avg;
		frame[offset + (i * width + 3)] = avg;
		frame[offset + (i * width + 4)] = avg;
		frame[offset + (i * width + 5)] = avg;
		frame[offset + (i * width + 6)] = avg;
		frame[offset + (i * width + 7)] = avg;
		frame[offset + (i * width + 8)] = avg;
		frame[offset + (i * width + 9)] = avg;
		frame[offset + (i * width + 10)] = avg;
		frame[offset + (i * width + 11)] = avg;
		frame[offset + (i * width + 12)] = avg;
		frame[offset + (i * width + 13)] = avg;
		frame[offset + (i * width + 14)] = avg;
		frame[offset + (i * width + 15)] = avg;
	}
}

//Make vector 16 an array of size 16 (16 x 16 = 256)
__kernel void avgFrameWrite16_2D_Opt_v2(__global unsigned char* frame, const int width) //16x16 ONLY
{
	int x = get_global_id(0) * 16;
	int y = get_global_id(1) * 16;
	int offset = y * width + x;

	uint avg = 0;
	
	ushort16 sum16[16];

	for (int i = 0; i < 16; i++)			//over every x value
	{										//Assign all components for all 16 sum16's
		sum16[i].s0 = frame[offset + (i * width + 0)];
		sum16[i].s1 += frame[offset + (i * width + 1)];
		sum16[i].s2 += frame[offset + (i * width + 2)];
		sum16[i].s3 += frame[offset + (i * width + 3)];
		sum16[i].s4 += frame[offset + (i * width + 4)];
		sum16[i].s5 += frame[offset + (i * width + 5)];
		sum16[i].s6 += frame[offset + (i * width + 6)];
		sum16[i].s7 += frame[offset + (i * width + 7)];
		sum16[i].s8 += frame[offset + (i * width + 8)];
		sum16[i].s9 += frame[offset + (i * width + 9)];
		sum16[i].sa += frame[offset + (i * width + 10)];
		sum16[i].sb += frame[offset + (i * width + 11)];
		sum16[i].sc += frame[offset + (i * width + 12)];
		sum16[i].sd += frame[offset + (i * width + 13)];
		sum16[i].se += frame[offset + (i * width + 14)];
		sum16[i].sf += frame[offset + (i * width + 15)];
	}

	//Reduction step
	ushort8 sum8[16];
	ushort4 sum4[16];
	ushort2 sum2[16];

	for(int i = 0; i < 16; i++)
	{
		sum8[i] = sum16[i].s01234567 + sum16[i].s89abcdef;

		sum4[i] = sum8[i].s0123 + sum8[i].s4567;

		sum2[i] = sum4[i].xy + sum4[i].zw;

		avg += sum2[i].x + sum2[i].y;	//Final accumulation
	}
	
	//Averaging
	avg = avg / 256;

	for (int i = 0; i < 16; i++)			//over every x value
	{
		frame[offset + (i * width + 0)] = avg;
		frame[offset + (i * width + 1)] = avg;
		frame[offset + (i * width + 2)] = avg;
		frame[offset + (i * width + 3)] = avg;
		frame[offset + (i * width + 4)] = avg;
		frame[offset + (i * width + 5)] = avg;
		frame[offset + (i * width + 6)] = avg;
		frame[offset + (i * width + 7)] = avg;
		frame[offset + (i * width + 8)] = avg;
		frame[offset + (i * width + 9)] = avg;
		frame[offset + (i * width + 10)] = avg;
		frame[offset + (i * width + 11)] = avg;
		frame[offset + (i * width + 12)] = avg;
		frame[offset + (i * width + 13)] = avg;
		frame[offset + (i * width + 14)] = avg;
		frame[offset + (i * width + 15)] = avg;
	}
}

//BELOW IS ENGINEERING DESIGN 1 CODE
__kernel void avgFrame16(__global unsigned char* frame,__global double* avgArray, const int width)	//16x16 ONLY
{
    int b = get_global_id(0);

	int x = b * 16 % width;
	int y = (int)((b / (width / 16)) * 16);

	double sum = 0;

	int offset = y * width + x;

	for (int i = 0; i < 16; i++)			//over every x value
	{
		sum += frame[offset + (i * width + 0)];
		sum += frame[offset + (i * width + 1)];
		sum += frame[offset + (i * width + 2)];
		sum += frame[offset + (i * width + 3)];
		sum += frame[offset + (i * width + 4)];
		sum += frame[offset + (i * width + 5)];
		sum += frame[offset + (i * width + 6)];
		sum += frame[offset + (i * width + 7)];
		sum += frame[offset + (i * width + 8)];
		sum += frame[offset + (i * width + 9)];
		sum += frame[offset + (i * width + 10)];
		sum += frame[offset + (i * width + 11)];
		sum += frame[offset + (i * width + 12)];
		sum += frame[offset + (i * width + 13)];
		sum += frame[offset + (i * width + 14)];
		sum += frame[offset + (i * width + 15)];
	}

	avgArray[b] = sum / 256;
}

__kernel void avgFrameWrite16(__global unsigned char* frame, const int width) //16x16 ONLY
{
	int b = get_global_id(0);
	int x = b * 16 % width;
	int y = (int)((b / (width / 16)) * 16);

	int sum = 0;

	int offset = y * width + x;

	for (int i = 0; i < 16; i++)			//over every x value
	{
		sum += frame[offset + (i * width + 0)];
		sum += frame[offset + (i * width + 1)];
		sum += frame[offset + (i * width + 2)];
		sum += frame[offset + (i * width + 3)];
		sum += frame[offset + (i * width + 4)];
		sum += frame[offset + (i * width + 5)];
		sum += frame[offset + (i * width + 6)];
		sum += frame[offset + (i * width + 7)];
		sum += frame[offset + (i * width + 8)];
		sum += frame[offset + (i * width + 9)];
		sum += frame[offset + (i * width + 10)];
		sum += frame[offset + (i * width + 11)];
		sum += frame[offset + (i * width + 12)];
		sum += frame[offset + (i * width + 13)];
		sum += frame[offset + (i * width + 14)];
		sum += frame[offset + (i * width + 15)];
	}

	int avg = sum / 256;

	for (int i = 0; i < 16; i++)			//over every x value
	{
		frame[offset + (i * width + 0)] = avg;
		frame[offset + (i * width + 1)] = avg;
		frame[offset + (i * width + 2)] = avg;
		frame[offset + (i * width + 3)] = avg;
		frame[offset + (i * width + 4)] = avg;
		frame[offset + (i * width + 5)] = avg;
		frame[offset + (i * width + 6)] = avg;
		frame[offset + (i * width + 7)] = avg;
		frame[offset + (i * width + 8)] = avg;
		frame[offset + (i * width + 9)] = avg;
		frame[offset + (i * width + 10)] = avg;
		frame[offset + (i * width + 11)] = avg;
		frame[offset + (i * width + 12)] = avg;
		frame[offset + (i * width + 13)] = avg;
		frame[offset + (i * width + 14)] = avg;
		frame[offset + (i * width + 15)] = avg;
	}
}

__kernel void avgFrame8(__global unsigned char* frame,__global double* avgArray, const int width)	//8x8 ONLY
{
    int b = get_global_id(0);

	int x = b * 8 % width;
	int y = (int)((b / (width / 8)) * 8);

	double sum = 0;

	int offset = y * width + x;

	for (int i = 0; i < 8; i++)			//over every x value
	{
		sum += frame[offset + (i * width + 0)];
		sum += frame[offset + (i * width + 1)];
		sum += frame[offset + (i * width + 2)];
		sum += frame[offset + (i * width + 3)];
		sum += frame[offset + (i * width + 4)];
		sum += frame[offset + (i * width + 5)];
		sum += frame[offset + (i * width + 6)];
		sum += frame[offset + (i * width + 7)];
	}

	avgArray[b] = sum / 64;
}

__kernel void avgFrameWrite8(__global unsigned char* frame, const int width) //8x8 ONLY
{
	int b = get_global_id(0);
	int x = b * 8 % width;
	int y = (int)((b / (width / 8)) * 8);

	int sum = 0;

	int offset = y * width + x;

	for (int i = 0; i < 8; i++)			//over every x value
	{
		sum += frame[offset + (i * width + 0)];
		sum += frame[offset + (i * width + 1)];
		sum += frame[offset + (i * width + 2)];
		sum += frame[offset + (i * width + 3)];
		sum += frame[offset + (i * width + 4)];
		sum += frame[offset + (i * width + 5)];
		sum += frame[offset + (i * width + 6)];
		sum += frame[offset + (i * width + 7)];
	}

	int avg = sum / 64;

	for (int i = 0; i < 8; i++)			//over every x value
	{
		frame[offset + (i * width + 0)] = avg;
		frame[offset + (i * width + 1)] = avg;
		frame[offset + (i * width + 2)] = avg;
		frame[offset + (i * width + 3)] = avg;
		frame[offset + (i * width + 4)] = avg;
		frame[offset + (i * width + 5)] = avg;
		frame[offset + (i * width + 6)] = avg;
		frame[offset + (i * width + 7)] = avg;
	}
}

//Flex kernel functions, able to work with variable block sizes.
//Initial implementation, later loop unrolled and tested with various vectorization techniques for improving perofrmance.
__kernel void avgFrameFlex(__global unsigned char* frame,__global double* avgArray, const int width, const int blockSize)
{
    int i = get_global_id(0);
	int x = i * blockSize % width;
	int y = (int)((i / (width / blockSize)) * blockSize);

	double sum = 0;

	int offset = y * width + x;

	for (int j = 0; j < blockSize; j++)			//over every x value
	{
		for (int i = 0; i < blockSize; i++)		//over every y value
		{
			sum += frame[offset + (i * width + j)]; //(frameBuf + offset)[i * width + j];	//save into corresponding block position
		}
	}

	avgArray[i] = sum / (blockSize * blockSize);
}

__kernel void avgFrameWriteFlex(__global unsigned char* frame, const int width, const int blockSize)
{
	int b = get_global_id(0);

	int x = b * blockSize % width;
	int y = (int)((b / (width / blockSize)) * blockSize);

	int sum = 0;

	int offset = y * width + x;

	for (int j = 0; j < blockSize; j++)			//over every x value
	{
		for (int i = 0; i < blockSize; i++)		//over every y value
		{
			sum += frame[offset + (i * width + j)]; //(frameBuf + offset)[i * width + j];	//save into corresponding block position
		}
	}

	int avg = sum / (blockSize * blockSize);

	for (int j = 0; j < blockSize; j++)			//over every x value
	{
		for (int i = 0; i < blockSize; i++)		//over every y value
		{
			frame[offset + (i * width + j)] = avg;
		}
	}
}

//2D Functions, Requiring:
//size_t globalWork[] = { height / 8, width / 8 };
//avgFrame2D's avgArray buffer should be given number of blocks * 8 size.
//Both work correctly, however worse performance than 1D global size
__kernel void avgFrame2D8(__global unsigned char* frame,__global double* avgArray, const int width)	//8x8 ONLY
{
    int a = get_global_id(0);
	int b = get_global_id(1);

	int x = b * 8;
	int y = a * 8;

	int calculatedBlockNumber = (x / 8) + ((y / 8) * (width / 8));

	double sum = 0;

	int offset = y * width + x;

	for (int i = 0; i < 8; i++)			//over every x value
	{
		sum += frame[offset + (i * width + 0)];
		sum += frame[offset + (i * width + 1)];
		sum += frame[offset + (i * width + 2)];
		sum += frame[offset + (i * width + 3)];
		sum += frame[offset + (i * width + 4)];
		sum += frame[offset + (i * width + 5)];
		sum += frame[offset + (i * width + 6)];
		sum += frame[offset + (i * width + 7)];
	}

	avgArray[calculatedBlockNumber] = sum / 64.0;
}

__kernel void avgFrameWrite2D8(__global unsigned char* frame, const int width) //8x8 ONLY
{
	int a = get_global_id(0);
	int b = get_global_id(1);

	int x = b * 8;
	int y = a * 8;

	int sum = 0;

	int offset = y * width + x;

	for (int i = 0; i < 8; i++)			//over every x value
	{
		sum += frame[offset + (i * width + 0)];
		sum += frame[offset + (i * width + 1)];
		sum += frame[offset + (i * width + 2)];
		sum += frame[offset + (i * width + 3)];
		sum += frame[offset + (i * width + 4)];
		sum += frame[offset + (i * width + 5)];
		sum += frame[offset + (i * width + 6)];
		sum += frame[offset + (i * width + 7)];
	}

	int avg = sum / 64;

	for (int i = 0; i < 8; i++)			//over every x value
	{
		frame[offset + (i * width + 0)] = avg;
		frame[offset + (i * width + 1)] = avg;
		frame[offset + (i * width + 2)] = avg;
		frame[offset + (i * width + 3)] = avg;
		frame[offset + (i * width + 4)] = avg;
		frame[offset + (i * width + 5)] = avg;
		frame[offset + (i * width + 6)] = avg;
		frame[offset + (i * width + 7)] = avg;
	}
}

/*
//Reverse I and J for loop
__kernel void avgFrame2(__global unsigned char* frame,__global double* avgArray, const int width, const int blockSize)	//8x8
{
    int i = get_global_id(0);
	int x = i * blockSize % width;
	int y = (int)((i / (width / blockSize)) * blockSize);

	double sum = 0;

	int offset = y * width + x;

	for (int j = 0; j < blockSize; j++)			//over every x value
	{
		sum += frame[offset + (0 * width + j)];
		sum += frame[offset + (1 * width + j)];
		sum += frame[offset + (2 * width + j)];
		sum += frame[offset + (3 * width + j)];
		sum += frame[offset + (4 * width + j)];
		sum += frame[offset + (5 * width + j)];
		sum += frame[offset + (6 * width + j)];
		sum += frame[offset + (7 * width + j)];
	}

	avgArray[i] = sum / (blockSize * blockSize);
}
*/