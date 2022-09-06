#include "yuvStatExamples.h"
#include <iostream>
#include <string>

// File Explorer Functionality
#include "yuvFileOpenUtil.h"

using namespace std;

int main()
{
	FILE* fp = NULL;
	uint64_t width = 0;
	uint64_t height = 0;
	char fileName[2000];
	char filePath[2000];

	//File Explorer Functionality, Easier YUV File Selection, Width/Height found by filename (YUV Standard)
	openYUVFile(fp, &width, &height, fileName, filePath);
	
	//Going over 20+ runs creates memory leak issues. Apparently this is a known issue for the latest release of OpenCL in certain applications.
	//Will investigate before implementing into live server.
	for(int i = 0; i < 1; i ++)
		rangeMain(fp, width, height, fileName, filePath, 150, 1);

	std::string holdOutput;
	std::cout << "Press enter to end.";
	std::getline(std::cin, holdOutput);

	return 0;
}