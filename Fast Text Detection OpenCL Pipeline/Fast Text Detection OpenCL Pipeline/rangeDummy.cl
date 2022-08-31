// TODO: Add OpenCL kernel code here.
__kernel void rangeThresh(__global unsigned char* frame,__global bool* threshArr, const int width, const int thresh)	//16x16 ONLY
{
	int i = get_global_id(0);
	int x = i * 16 % width;
	int y = (int)((i / (width / 16)) * 16);

	int min = 256;	//Maximum 255 Value for Luma.
	int max = -1;

	int offset = y * width + x;

	for (int j = 0; j < 16; j++)			//over every x value
	{
		for (int i = 0; i < 16; i++)		//over every y value
		{
			if(frame[offset + (i * width + j)] < min)
				min = frame[offset + (i * width + j)];
			if(frame[offset + (i * width + j)] > max)
				max = frame[offset + (i * width + j)];
		}
	}

	int range = max - min;

	if(range >= thresh)
		threshArr[i] = true;
}