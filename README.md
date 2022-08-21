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