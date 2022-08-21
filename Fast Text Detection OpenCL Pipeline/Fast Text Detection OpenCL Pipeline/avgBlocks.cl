// TODO: Add OpenCL kernel code here.

__kernel void avgFrame(__global unsigned char* frame,__global double* avgArray, const int width)	//8x8 ONLY
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

__kernel void avgFrameWrite(__global unsigned char* frame, const int width) //8x8 ONLY
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
__kernel void avgFrame2D(__global unsigned char* frame,__global double* avgArray, const int width)	//8x8 ONLY
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

__kernel void avgFrameWrite2D(__global unsigned char* frame, const int width) //8x8 ONLY
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