#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cmath>
#include <vector>
#include <iostream>
#include <fstream>
#include <sstream>
#include <tuple>
#include "SimpleYUV.h"
using namespace std;

int sumRowDif(unsigned char* blockData, int width, int height)
{
	int difSum = 0;

	for (int i = 0; i < height - 1; i++)
	{
		for (int j = 0; j < width; j++)
		{
			int val = blockData[i * width + j] - blockData[((i + 1) * width) + j];
			difSum += abs(val);
		}
	}
	return difSum;
}

int sumColDif(unsigned char* blockData, int width, int height)
{
	int difSum = 0;

	for (int i = 0; i < height; i++)
	{
		for (int j = 0; j < width - 1; j++)
		{
			int val = blockData[i * width + j] - blockData[i * width + (j + 1)];
			difSum += abs(val);
		}
	}
	return difSum;
}

int sumRowColDif(unsigned char* blockData, int width, int height)
{
	int difRowSum = sumRowDif(blockData, width, height);

	int difColSum = sumColDif(blockData, width, height);;

	return difRowSum + difColSum;
}

float varianceBlock(unsigned char* blockData, int width, int height)
{
	float avg = averageYValOfBlock(blockData, width);
	float var = 0;

	for (int i = 0; i < height; i++)
	{
		for (int j = 0; j < width; j++)
		{
			var += (blockData[i * width + j] - avg) * (blockData[i * width + j] - avg);
		}
	}

	return var / (width * height);
}

tuple<double, double> avgQuadrantBlock(int blocksize, unsigned char* blockData, int q_size, int x, int y)
{
	double sum = 0;
	int xlimit = x + q_size;
	int ylimit = y + q_size;
	for (int i = x; i < xlimit; i++)
	{
		for (int j = y; j < ylimit; j++)
		{
			// cout << blockData[i*blocksize+j] << " ";
			sum += blockData[i * blocksize + j];
		}
	}
	//return sum / (q_size * q_size);
	return make_tuple(sum, sum / (q_size * q_size));
}

tuple<float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float> basicCharOutput(int blocksize, unsigned char* blockData, unsigned char* frameBuffer, int width, int height)
{
	if (blocksize < 4 || ((log(blocksize) / log(2)) != int(log(blocksize) / log(2))))
	{
		cout << "Error, given block size is not compatible with function" << endl;
	}
	else
	{
		float q1Avg, q2Avg, q3Avg, q4Avg, qcenterAvg = 0;
		float q1sum, q2sum, q3sum, q4sum, qcentersum = 0;
		//int q_size = log(blocksize) / log(2);
		int q_size = 6;
		// cout << q_size << endl;
		tie(q1sum, q1Avg) = avgQuadrantBlock(blocksize, blockData, q_size, 0, 0);
		tie(q2sum, q2Avg) = avgQuadrantBlock(blocksize, blockData, q_size, 0, blocksize - q_size);
		tie(q3sum, q3Avg) = avgQuadrantBlock(blocksize, blockData, q_size, blocksize - q_size, 0);
		tie(q4sum, q4Avg) = avgQuadrantBlock(blocksize, blockData, q_size, blocksize - q_size, blocksize - q_size);
		tie(qcentersum, qcenterAvg) = avgQuadrantBlock(blocksize, blockData, 3, blocksize / 2 - 1, blocksize / 2 - 1);
		//cout << q1Avg << " " << q2Avg << " " << q3Avg << " " << q4Avg << " " << qcenterAvg << endl;
		//cout << q1sum << " " << q2sum << " " << q3sum << " " << q4sum << " " << qcentersum << endl;

		float q12sum_difference, q13sum_difference, q14sum_difference, q1center_AvgDifference = 0;
		q12sum_difference = abs(q1sum - q2sum);
		q13sum_difference = abs(q1sum - q3sum);
		q14sum_difference = abs(q1sum - q4sum);
		//cout << q12sum_difference << " " << q13sum_difference << " " << q14sum_difference << " " << q1center_AvgDifference << endl;

		float q23sum_difference, q24sum_difference, q2center_AvgDifference = 0;
		q23sum_difference = abs(q2sum - q3sum);
		q24sum_difference = abs(q2sum - q4sum);
		//cout << q23sum_difference << " " << q24sum_difference << endl;

		float q34sum_difference, q3center_AvgDifference = 0;
		q34sum_difference = abs(q3sum - q4sum);
		//cout << q34sum_difference << endl;

		float q4center_AvgDifference = 0;
		q1center_AvgDifference = abs(q1Avg - qcenterAvg);
		q2center_AvgDifference = abs(q2Avg - qcenterAvg);
		q3center_AvgDifference = abs(q3Avg - qcenterAvg);
		q4center_AvgDifference = abs(q4Avg - qcenterAvg);

		//cout << q1center_AvgDifference << " " << q2center_AvgDifference << " " << q3center_AvgDifference << " " << q4center_AvgDifference << endl;

		// Return first the absolute difference of sums between the 4 corner quadrants
		// Then return the difference between average of each corner with center quadrant of 3x3

		// Since in this implementation we have a void the return is commented 

		// Can return the average quantities of each quadrant
		// return make_tuple(q1Avg, q2Avg, q3Avg, q4Avg, qcenterAvg) 
		// or sum which I think is ideal but for this only the corners because the center quadrant is much smaller so disproportional 
		// return make_tuple(q1sum, q2sum, q3sum, q4sum)
		// or we can do both as to prevent from having to go back and simply in creating the models we can opt either concept 

		// Now return the absolute difference of sums between quadrant first and then between the center
		//return make_tuple(q12sum_difference, q13sum_difference, q14sum_difference, q23sum_difference, q24sum_difference, q34sum_difference, q1center_AvgDifference, q2center_AvgDifference, q3center_AvgDifference, q4center_AvgDifference);
		return make_tuple(q1Avg, q2Avg, q3Avg, q4Avg, qcenterAvg, q1sum, q2sum, q3sum, q4sum, q12sum_difference, q13sum_difference, q14sum_difference, q23sum_difference, q24sum_difference, q34sum_difference, q1center_AvgDifference, q2center_AvgDifference, q3center_AvgDifference, q4center_AvgDifference);
	}
}

void stats(unsigned char* frameData, int blockSize, int width, int height, int frameNum, char fileName[2000])	//LARGE PRINT OUT, IN ORDER OF TOP LEFT GOING RIGHT IN CHUNKS OF BLOCKSIZE
{
	unsigned char* blockData;	//Self contained blockData
	blockData = new unsigned char[pow(2, blockSize)];

	int x = 0; int y = 0;
	std::ofstream myfile;
	string name = "../DATA OUT/"; // change based on video
	string fileNameS = fileName;
	fileNameS = fileNameS.substr(0, fileNameS.find_last_of('.'));
	name += fileNameS;
	string str1 = to_string(frameNum);
	name += "_";
	name.append(str1);
	name += ".csv";
	myfile.open(name, std::ios::app);
	if (myfile.is_open())
	{
		//cout << "File is opened" << endl;
		myfile << "X,Y,Q1AVG,Q2AVG,Q3AVG,Q4AVG,QCENTERAVG,Q1SUM,Q2SUM,Q3SUM,Q4SUM,Q12SUM_DIFF,Q13SUM_DIFF,Q14SUM_DIFF,Q23SUM_DIFF,Q24SUM_DIFF,Q34SUM_DIFF,Q1CENT_AVGDIFF,Q2CENT_AVGDIFF,Q3CENT_AVGDIFF,Q4CENT_AVGDIFF,AVG_MACRO_VALUE,AVG_ROW,AVG_COL,VARIANCE,SUM_ROW,SUM_COL,SUM_ROW_COL,RANGE_MACRO_VALUE,MAX_MACRO_VALUE,MIN_MACRO_VALUE" << "\n";
	}
	else
	{
		cout << "Could not open";
	}

	for (y = 0; y < height; y = y + blockSize)
	{
		if (y < height - 8)
		{
			for (x = 0; x < width; x = x + blockSize)
			{
				getBlock(frameData, blockData, blockSize, x, y, width);
				float curAvg = averageYValOfBlock(blockData, blockSize);
				int minY = minYBlock(blockData, blockSize);
				int maxY = maxYBlock(blockData, blockSize);
				int range = rangeInBlock(blockData, blockSize);
				float avgRow = avgRowDif(blockData, blockSize, blockSize);
				float avgCol = avgColDif(blockData, blockSize, blockSize);
				float variance = varianceBlock(blockData, blockSize, blockSize);
				int sumRow = sumRowDif(blockData, blockSize, blockSize);
				int sumCol = sumColDif(blockData, blockSize, blockSize);
				int sumRowCol = sumRowColDif(blockData, blockSize, blockSize);
				float q1Avg, q2Avg, q3Avg, q4Avg, qcenterAvg, q1sum, q2sum, q3sum, q4sum, q12sum_difference, q13sum_difference, q14sum_difference, q23sum_difference, q24sum_difference, q34sum_difference, q1center_AvgDifference, q2center_AvgDifference, q3center_AvgDifference, q4center_AvgDifference = 0;
				tie(q1Avg, q2Avg, q3Avg, q4Avg, qcenterAvg, q1sum, q2sum, q3sum, q4sum, q12sum_difference, q13sum_difference, q14sum_difference, q23sum_difference, q24sum_difference, q34sum_difference, q1center_AvgDifference, q2center_AvgDifference, q3center_AvgDifference, q4center_AvgDifference) = basicCharOutput(blockSize, blockData, frameData, width, height);
				//printf("X = %d, Y = %d, Avg = %f, AvgRow = %f, AvgCol = %f, Variance = %f, sumRow = %d, sumCol = %d, sumRowCol = %d Range = %d, Max = %d, Min = %d\n", x, y, curAvg, avgRow, avgCol, variance, sumRow, sumCol, sumRowCol, range, maxY, minY);
				myfile << x << ", " << y << ", " << q1Avg << ", " << q2Avg << ", " << q3Avg << ", " << q4Avg << ", " << qcenterAvg << ", " << q1sum << ", " << q2sum << ", " << q3sum << ", " << q4sum << ", " << q12sum_difference << ", " << q13sum_difference << ", " << q14sum_difference << ", " << q23sum_difference << ", " << q24sum_difference << ", " << q34sum_difference << ", " << q1center_AvgDifference << ", " << q2center_AvgDifference << ", " << q3center_AvgDifference << ", " << q4center_AvgDifference << ", " << curAvg << ", " << avgRow << ", " << avgCol << ", " << variance << ", " << sumRow << ", " << sumCol << ", " << sumRowCol << ", " << range << ", " << maxY << ", " << minY << "\n";
			}
		}
	}
	myfile.close();
}

int datasetCreate(uint64_t width, uint64_t height, char fileName[2000], char filePath[2000])
{
	FILE* fp;

	uint64_t blockSize = 16; //blockSize x blockSize

	//Open File through fopen_s, filepath found through File Explorer.
	if (filePath != NULL)
		fopen_s(&fp, filePath, "rb");

	if (fp == NULL)
	{
		cout << "Error, Returned NULL fp.\n";
		return 2;
	}

	//YUV File Parameter Setup
	_fseeki64(fp, 0, SEEK_END);
	uint64_t size = _ftelli64(fp);	//Returns Byte Size of YUV input

	int frameNum = 0;

	uint64_t frameSize = (width * height * 1.5);
	uint64_t lumaSize = width * height; //Size of Y layer, without U and V (YUV 4:2:0)

	int frames = size / frameSize;
	uint64_t calculatedSize = (width * height * 1.5) * frames;	//For Error Checking

	if (size != calculatedSize)
	{
		cerr << "Wrong size of yuv read : " << (int)size << " bytes, expected " << (int)calculatedSize << " bytes\n";
		fclose(fp);
		exit(2);
	}

	const uint64_t numBlocks = lumaSize / (blockSize * blockSize);

	cout << fileName << " " << width << "x" << height << ", Frames = " << frames << endl;
	cout << "=================================================================" << endl;

	//Y,U,V	(For Full Frame info, use frameSize. For only Y (Luma), use lumaSize)
	unsigned char* frameBuffer;
	frameBuffer = new unsigned char[frameSize];

	_fseeki64(fp, frameSize * frameNum, SEEK_SET);
	int r = fread(frameBuffer, 1, frameSize, fp);

	if (r < frameSize)
	{
		cerr << "Read wrong frame size, error in reading YUV properly.";
		fclose(fp);
		exit(2);
	}

	if (size != calculatedSize)
	{
		fprintf(stderr, "Wrong size of yuv image : %d bytes, expected %d bytes\n", size, (int)calculatedSize);
		fclose(fp);
		return 2;
	}

	int num[] = { 0, 429, 527, 410, 1131, 1567, 1741, 1834, 2042, 2210, 2479, 2755, 2963, 3536, 3580 }; //Change based on Frames

	int len = sizeof(num) / sizeof(num[0]);

	for (int i = 0; i < len; i++)
	{
		int x = num[i];
		_fseeki64(fp, frameSize * x, SEEK_SET);
		int r = fread(frameBuffer, 1, (uint64_t)width * (uint64_t)height, fp);
		if (r < width * height)
		{
			printf("Error reading into buffer, r = %d, size of Y = %d\n", r, (int)lumaSize);
			fclose(fp);
			return 2;

		}
		
		int blockSize = 16;
		unsigned char* blockData;
		blockData = new unsigned char[pow(2, blockSize)];
		stats(frameBuffer, blockSize, width, height, x, fileName);
	}

	fclose(fp);
}
