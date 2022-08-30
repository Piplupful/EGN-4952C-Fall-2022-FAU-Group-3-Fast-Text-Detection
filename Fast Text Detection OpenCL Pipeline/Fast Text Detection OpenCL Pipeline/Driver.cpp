#include "averageLumaExample.h"
#include <iostream>
#include <string>

using namespace std;

int main()
{
	avgMain();

	//OpenCL Template from Intel OpenCL SDK automatically shuts down debug CMD window on completion, even if set to not do so in Debug Settings. This fixes that issue to allow for
	//	post-debug run analysis.
	std::string holdOutput;
	std::cout << "Press enter to end.";
	std::getline(std::cin, holdOutput);

	return 0;
}