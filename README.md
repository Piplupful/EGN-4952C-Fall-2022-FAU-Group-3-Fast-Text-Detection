# EGN 4952C Fall 2022 FAU Group 3 Fast Text Detection

Sponsor: Sebastian Possos, Intel
sebastian.possos@intel.com

Student Developers:

- Leonardo Martinez:
    - Leos32111@gmail.com, leonardomart2020@fau.edu
- Nelson Mendez:
    - nmendez2019@fau.edu
- Jared Klein:
    - kleinjared12@gmail.com, kleinj2020@fau.edu
- Mykyta Palamarchuk:
    - palamarchuk.mykyta@gmail.com, mpalamarchuk2019@fau.edu
- Leonardo Osorio:
    - losorio2019@fau.edu

External Tools/Libraries used:
- OpenCL, Intel SDK. For data parallelism.
    - https://www.intel.com/content/www/us/en/developer/tools/opencl-sdk/choose-download.html
    
- EasyOCR, which requires Python and Pandas. Used for ground truth classification through easyClassify.py script.
    - https://github.com/JaidedAI/EasyOCR
    - pip install easyocr
    
- OpenCV, latest version. Used for Simple Threshold functionality, which is used as a preprocessing step in one of our pipelines.
    - https://opencv.org/
    
- FFMPEG. For video format conversion.
    - https://ffmpeg.org/
    - FFMPEG COMMANDS TO NOTE:
    convert .y4m to .yuv: ffmpeg -i CSGO.y4m -pix_fmt yuv420p CSGO.yuv
    convert .yuv to .mp4: ffmpeg -f rawvideo -pix_fmt yuv420p -video_size 1920x1080 -framerate 60 -i CSGO.yuv -f mp4 CSGO_Output.mp4

- WEKA, for ML Model creation. Dataset developed by the end of the semester available in our repo in a .zip file.
Available in both .CSV and .ARFF formats.
    - https://www.cs.waikato.ac.nz/ml/index.html

Repository for Group 3 Fast Text Detection, Fall 2022, at FAU.

- August 21, 2022: First commit is code from Engineering Design 1 (EGN 4950C Summer 2022), which includes basic YUV 4:2:0 operations,
and manipulation of YUV video using OpenCL for Data Parallelization. To learn how to use OpenCL and YUV, we created some basic functionality
which writes a new YUV file, where each 8x8 block of pixel's Y value is now equal to the average of the original, creating a pseudo
compressed image. This code will serve as the basis of our OpenCL based pipeline, to test out text detection solutions.

- September 1, 2022: First major merge into main. Improved input, created OpenCL based pipeline and template, enhanced QoL for testing and runtime
analysis down the road.

- September 17, 2022: Merged Optimization experimentation into main, new utility functions, improved OpenCL code, etc. Removed Visual Studio folders.

- October 27, 2022: Actual Text Detection is now being developed. Using a script provided by our sponsor, we can convert WEKA text output into usable C++ code. This can me modified slightly to fit OpenCL kernel functionality. Latest version of dataset creation code added, including Python scripts for utilizing EasyOCR to set ground truth, and to combine the final CSV files. Implementations of ML Kernel Functions are in dtc.cl. New dataset being worked on by two of our members, one is using the old dataset to see if certain techniques can improve accuracy, we are experimenting with having Simple Thresholding be a pre-processing step in our text detection, and our Optimization goals have been met using an Intel IRIS 580, with our early ML implementation having a runtime of about 0.5ms per frame of YUV video.

- November 7, 2022: Implementation testing in full swing. New features being added to dataset, namely the sum and average of the difference in luma values between subsequent pixels by row and by columns, the sum of those sums, and variance. Added to help improve accuracy. Simple Threshold route setup finalized, moving to implementing a proper pipeline and model testing.

NOTE FROM LEONARDO MARTINEZ (Nov 7, 2022): As we are getting closer to the end of the semester, I want to acknowledge that this team has gone far from when we first started. At the start of ED1, we didn't know what YUV was, we messed around with a google colab with OCR Deep Learning solutions and FFMPEG. Now, we are actually implementing machine learning models that we developed, off a dataset that we built, running our code on powerful dedicated hardware using OpenCL. Our goal is to improve the accuracy as much as possible before the end of the semester, as our runtime (thanks to our optimization efforts) is extremely well, so much so that an incredibly strange bug that affects only our runtime is mitigated by the raw power of the remote machine that has a ARC 750 in it for testing. We have genuinely learned a lot from this experience, and I hope by the time I write the last part of this README that we will have satisfactory accuracy for our Intel sponsor.

- November 23, 2022: Wrapping up project as our semester comes to an end. Simple Threshold pipeline fully implemented into it's respective branch. Model testing for both routes have resulted in accuracy improvements with some models, but not where we want it to be. Model creation, testing, and implementation will continue until the end of the project. Code cleanup underway to make code more presentable and useable for future work. Repo will be set to public when complete. MIT License added, since this is Open Source.
