# EGN 4952C Fall 2022 FAU Group 3 Fast Text Detection

Sponsor: Sebastian Possos, Intel
sebastian.possos@intel.com

Student Developers:
Leonardo Martinez,	leonardomart2020@fau.edu
Nelson Mendez,		nmendez2019@fau.edu
Jared Klein 		kleinj2020@fau.edu
Mykyta Palamarchuk 	mpalamarchuk2019@fau.edu
Leonardo Osorio 	losorio2019@fau.edu
 
Repository for Group 3 Fast Text Detection, Fall 2022, at FAU.

- August 21, 2022: First commit is code from Engineering Design 1 (EGN 4950C Summer 2022), which includes basic YUV 4:2:0 operations,
and manipulation of YUV video using OpenCL for Data Parallelization. To learn how to use OpenCL and YUV, we created some basic functionality
which writes a new YUV file, where each 8x8 block of pixel's Y value is now equal to the average of the original, creating a pseudo
compressed image. This code will serve as the basis of our OpenCL based pipeline, to test out text detection solutions.

- September 1, 2022: First major merge into main. Improved input, created OpenCL based pipeline and template, enhanced QoL for testing and runtime
analysis down the road.

- September 17, 2022: Merged Optimization experimentation into main, new utility functions, improved OpenCL code, etc. Removed Visual Studio folders.

- October 27, 2022: Actual Text Detection is now being developed. Using a script provided by our sponsor, we can convert WEKA text output into usable C++ code. This can me modified slightly to fit OpenCL kernel functionality. Latest version of dataset creation code added, including Python scripts for utilizing EasyOCR to set ground truth, and to combine the final CSV files. Implementations of ML Kernel Functions are in dtc.cl. New dataset being worked on by two of our members, one is using the old dataset to see if certain techniques can improve accuracy, we are experimenting with having Simple Thresholding be a pre-processing step in our text detection, and our Optimization goals have been met using an Intel IRIS 580, with our early ML implementation having a runtime of about 0.5ms per frame of YUV video.