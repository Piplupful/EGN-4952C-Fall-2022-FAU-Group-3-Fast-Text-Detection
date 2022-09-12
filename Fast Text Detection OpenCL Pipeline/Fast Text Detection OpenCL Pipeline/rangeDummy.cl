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
	{
		threshArr[i] = 1;
	}
}

__kernel void rangeThresh2D(__global unsigned char* frame,__global bool* threshArr, const int width, const int thresh)	//16x16 ONLY
{
	int x = get_global_id(0) * 16;
	int y = get_global_id(1) * 16;
	int blockNum = (x / 16) + ((int)(y / 16) * (width / 16));	//Optimize with just get global id?

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
	{
		threshArr[blockNum] = true;
	}
}

//EXPERIMENTAL OPTIMIZATION ATTEMPTS BELOW, TOP TWO KERNEL FUNCTIONS WORK JUST FINE AND SEE GOOD PERFORMANCE
//Conclusions included as comments underneath functions

//USE BUILT IN MIN MAX FROM OPENCL
//Best of experiments as of September 12 2022.
__kernel void rangeThresh2DVectV1(__global unsigned char* frame,__global bool* threshArr, const int width, const int thresh)	//16x16 ONLY
{
	int x = get_global_id(0) * 16;
	int y = get_global_id(1) * 16;
	int blockNum = (x / 16) + ((int)(y / 16) * (width / 16));	//Optimize with just get global id?

	int minY = 256;	//Maximum 255 Value for Luma.
	int maxY = -1;

	int offset = y * width + x;

	for (int j = 0; j < 16; j++)			//over every x value
	{
		for (int i = 0; i < 16; i++)		//over every y value
		{
			minY = min(minY, (int)(frame[offset + (i * width + j)]));
			maxY = max(maxY, (int)(frame[offset + (i * width + j)]));
		}
	}

	int range = maxY - minY;

	if(range >= thresh)
	{
		threshArr[blockNum] = true;
	}
}
//I believed that using the built in min max functions within OpenCL that there would be a minor performance boost. However in my analysis, it was about 1% worse, which
//seems negligible. So, I assume this version and the original 2D work more or less the same runtime wise.

//USE BUILT IN MIN MAX FROM OPENCL, AND PRECACHE BEFORE MIN MAX
__kernel void rangeThresh2DVectV2(__global unsigned char* frame,__global bool* threshArr, const int width, const int thresh)	//16x16 ONLY
{
	int x = get_global_id(0) * 16;
	int y = get_global_id(1) * 16;
	int blockNum = (x / 16) + ((int)(y / 16) * (width / 16));	//Optimize with just get global id?

	int minY = 256;	//Maximum 255 Value for Luma.
	int maxY = -1;

	int offset = y * width + x;

	int blockArr[256];

	for (int j = 0; j < 16; j++)			//over every x value
	{
		for (int i = 0; i < 16; i++)		//over every y value
		{
			blockArr[i * 16 + j] = (frame + offset)[i * width + j];
		}
	}

	for (int i = 0; i < 256; i++)
	{
		minY = min(minY, blockArr[i]);
		maxY = max(maxY, blockArr[i]);
	}

	int range = maxY - minY;

	if(range >= thresh)
	{
		threshArr[blockNum] = true;
	}
}
//Attempt to cache before analysis. Putting these values in the GPU core's memory might improve runtime performance. While this may still be in the case
//I believe doing 2 operations, caching and then min max, adds too much overhead to be worth doing. This might be because of how we are handling the frame
//buffer, being 1 uchar* array.

//USE BUILT IN MIN MAX FROM OPENCL, USE VECTOR DATATYPES FOR INTS
//NOT GOOD, DOESNT UTILIZE X,Y,Z,W IN INT4.
__kernel void rangeThresh2DVectV3(__global unsigned char * frame,__global bool* threshArr, const int width, const int4 thresh)	//16x16 ONLY
{
	int x = get_global_id(0) * 16;
	int y = get_global_id(1) * 16;
	int blockNum = (x / 16) + ((int)(y / 16) * (width / 16));	//Optimize with just get global id?

	int4 minY = 256;	//Maximum 255 Value for Luma.
	int4 maxY = -1;

	int offset = y * width + x;

	for (int j = 0; j < 16; j++)			//over every x value
	{
		for (int i = 0; i < 16; i++)		//over every y value
		{
			minY = min(minY, (int)(frame[offset + (i * width + j)]));
			maxY = max(maxY, (int)(frame[offset + (i * width + j)]));
		}
	}

	int4 range = maxY - minY;

	if(range.x >= thresh.x)
	{
		threshArr[blockNum] = true;
	}
}
//Rough attempt to incorporate vector data types. This was helpful for me to figure out how to use the components (each datatype4 has 4 components: x,y,z,w)
//Performance was massively worse just at a glance, so I skipped the runtime analysis.

//USE BUILT IN MIN MAX FROM OPENCL, USE VECTOR DATATYPES FOR INTS, PRE CACHE INTO INT16 ARRAY
__kernel void rangeThresh2DVectV4(__global unsigned char * frame,__global bool* threshArr, const int width, const int thresh)	//16x16 ONLY
{
	int x = get_global_id(0) * 16;
	int y = get_global_id(1) * 16;
	int blockNum = (x / 16) + ((int)(y / 16) * (width / 16));	//Optimize with just get global id?

	int minY = 256;	//Maximum 255 Value for Luma.
	int maxY = -1;

	int offset = y * width + x;

	int16 blockArr[16];

	for (int j = 0; j < 16; j++)			//over every x value
	{
		//loop unrolled precache AND min max together
		blockArr[j].s0 = (frame + offset)[0 * width + j];
		blockArr[j].s1 = (frame + offset)[1 * width + j];
		blockArr[j].s2 = (frame + offset)[2 * width + j];
		blockArr[j].s3 = (frame + offset)[3 * width + j];
		blockArr[j].s4 = (frame + offset)[4 * width + j];
		blockArr[j].s5 = (frame + offset)[5 * width + j];
		blockArr[j].s6 = (frame + offset)[6 * width + j];
		blockArr[j].s7 = (frame + offset)[7 * width + j];
		blockArr[j].s8 = (frame + offset)[8 * width + j];
		blockArr[j].s9 = (frame + offset)[9 * width + j];
		blockArr[j].sa = (frame + offset)[10 * width + j];
		blockArr[j].sb = (frame + offset)[11 * width + j];
		blockArr[j].sc = (frame + offset)[12 * width + j];
		blockArr[j].sd = (frame + offset)[13 * width + j];
		blockArr[j].se = (frame + offset)[14 * width + j];
		blockArr[j].sf = (frame + offset)[15 * width + j];

		minY = min(minY, blockArr[j].s0);
		maxY = max(maxY, blockArr[j].s0);
		minY = min(minY, blockArr[j].s1);
		maxY = max(maxY, blockArr[j].s1);
		minY = min(minY, blockArr[j].s2);
		maxY = max(maxY, blockArr[j].s2);
		minY = min(minY, blockArr[j].s3);
		maxY = max(maxY, blockArr[j].s3);
		minY = min(minY, blockArr[j].s4);
		maxY = max(maxY, blockArr[j].s4);
		minY = min(minY, blockArr[j].s5);
		maxY = max(maxY, blockArr[j].s5);
		minY = min(minY, blockArr[j].s6);
		maxY = max(maxY, blockArr[j].s6);
		minY = min(minY, blockArr[j].s7);
		maxY = max(maxY, blockArr[j].s7);
		minY = min(minY, blockArr[j].s8);
		maxY = max(maxY, blockArr[j].s8);
		minY = min(minY, blockArr[j].s9);
		maxY = max(maxY, blockArr[j].s9);
		minY = min(minY, blockArr[j].sa);
		maxY = max(maxY, blockArr[j].sa);
		minY = min(minY, blockArr[j].sb);
		maxY = max(maxY, blockArr[j].sb);
		minY = min(minY, blockArr[j].sc);
		maxY = max(maxY, blockArr[j].sc);
		minY = min(minY, blockArr[j].sd);
		maxY = max(maxY, blockArr[j].sd);
		minY = min(minY, blockArr[j].se);
		maxY = max(maxY, blockArr[j].se);
		minY = min(minY, blockArr[j].sf);
		maxY = max(maxY, blockArr[j].sf);
	}

	int range = maxY - minY;

	if(range >= thresh)
	{
		threshArr[blockNum] = true;
	}
}
//Specifically for the Intel HD 630, INT Vector Width is preferred to be 4. Performance decrease cause be because of this.
//As well, caching like this may be more hassle than it's worth in the current implementation.
// https://man.opencl.org/integerFunctions.html
// "The vector versions of the integer functions operate component-wise."

/*
	for (int j = 0; j < 16; j++)			//over every x value
	{
		for (int i = 0; i < 16; i++)		//over every y value
		{
			
			blockArr[i * 16 + j] = (frame + offset)[i * width + j];
		}
	}

}*/