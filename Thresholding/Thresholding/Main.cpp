#include <iostream>
#include <vector>
#include <fstream>
#include <assert.h>
#include <stdio.h>
#include "opencv2/opencv.hpp"
#include "opencv2/opencv_modules.hpp"
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp> 

#define LOG(x) std::cout<<x<<std::endl;

using namespace std;
using namespace cv;

int main()
{
    /*Portion 1, take in RGB Image, Grayscale, display*/
    /*********************************************************************************/
    /*Mat img = imread("C:/Personal Projects/Thresholding/CS_GO.png", IMREAD_GRAYSCALE);
    Mat thrImg;

    namedWindow("Original Grayscale", WINDOW_NORMAL);
    resizeWindow("Original Grayscale", 1280, 720);
    imshow("Original Grayscale", img);
    //moveWindow("Original Grayscale", 0, 45);
    waitKey(0);

    threshold(img, thrImg, 0, 255, THRESH_BINARY);
    namedWindow("0-255 Binary Threshold", WINDOW_NORMAL);
    resizeWindow("0-255 Binary Threshold", 1280, 720);
    imshow("0-255 Binary Threshold", thrImg);
    //moveWindow("0-255 Binary Threshold", 0, 45);
    waitKey(0);

    threshold(img, thrImg, 0, 128, THRESH_BINARY);
    namedWindow("0-128 Binary Threshold", WINDOW_NORMAL);
    resizeWindow("0-128 Binary Threshold", 1280, 720);
    imshow("0-128 Binary Threshold", thrImg);
    //moveWindow("0-128 Binary Threshold", 0, 45);
    waitKey(0);

    threshold(img, thrImg, 127, 255, THRESH_BINARY);
    namedWindow("127-255 Binary Threshold", WINDOW_NORMAL);
    resizeWindow("127-255 Binary Threshold", 1280, 720);
    imshow("127-255 Binary Threshold", thrImg);
    //moveWindow("127-255 Binary Threshold", 0, 45);
    waitKey(0);

    threshold(img, thrImg, 127, 255, THRESH_BINARY_INV);
    namedWindow("127-255 Binary Threshold Inverse", WINDOW_NORMAL);
    resizeWindow("127-255 Binary Threshold Inverse", 1280, 720);
    imshow("127-255 Binary Threshold Inverse", thrImg);
    //moveWindow("127-255 Binary Threshold Inverse", 0, 45);
    waitKey(0);

    threshold(img, thrImg, 127, 255, THRESH_TRUNC);
    namedWindow("127-255 Threshold Truncate", WINDOW_NORMAL);
    resizeWindow("127-255 Threshold Truncate", 1280, 720);
    imshow("127-255 Threshold Truncate", thrImg);
    //moveWindow("127-255 Threshold Truncate", 0, 45);
    waitKey(0);

    threshold(img, thrImg, 127, 255, THRESH_TOZERO);
    namedWindow("127-255 Threshold To Zero", WINDOW_NORMAL);
    resizeWindow("127-255 Threshold To Zero", 1280, 720);
    imshow("127-255 Threshold To Zero", thrImg);
    //moveWindow("127-255 Threshold To Zero", 0, 45);
    waitKey(0);

    threshold(img, thrImg, 127, 255, THRESH_TOZERO_INV);
    namedWindow("127-255 Threshold To Zero Inverse", WINDOW_NORMAL);
    resizeWindow("127-255 Threshold To Zero Inverse", 1280, 720);
    imshow("127-255 Threshold To Zero Inverse", thrImg);
    //moveWindow("127-255 Threshold To Zero Inverse", 0, 45);
    waitKey(0);

    destroyAllWindows();*/
    /*********************************************************************************/

    /*Portion 2, take in RGB Image, convert to YUV, display both*/
    /*********************************************************************************/
    /*Mat img = imread("C:/Personal Projects/Thresholding/CS_GO.png");
    cv::namedWindow("Output - yuv", 0);
    cv::namedWindow("Input - png", 0);
    cv::namedWindow("vChannel", 0);
    cv::namedWindow("uChannel", 0);
    cv::namedWindow("yChannel", 0);

    cv::Mat yuv;
    cv::cvtColor(img, yuv, COLOR_BGR2YUV_I420);

    imshow("Output - yuv", yuv);
    imshow("Input - png", img);
    waitKey(0);*/

    /*cv::Mat vChannel = cv::Mat::zeros(cv::Size(img.cols / 2, img.rows / 2), CV_8UC1);
    cv::Mat uChannel = cv::Mat::zeros(cv::Size(img.cols / 2, img.rows / 2), CV_8UC1);

    for (int j = img.rows; j < img.rows + img.rows / 4; j++)
    {
        for (int i = 0; i < yuv.cols; i++)
        {
            if (i < yuv.cols / 2)
            {
                vChannel.at<uchar>(cv::Point(i, (j - img.rows) * 2)) = yuv.at<uchar>(cv::Point(i, j));
            }
            else
            {
                vChannel.at<uchar>(cv::Point(i - yuv.cols/2, (j - img.rows) * 2+1)) = yuv.at<uchar>(cv::Point(i, j));
            }
        }
    }

    for (int j = img.rows + img.rows / 4; j <yuv.rows; j++)
    {
        for (int i = 0; i < yuv.cols; i++)
        {
            if (i < yuv.cols / 2)
            {
                uChannel.at<uchar>(cv::Point(i, (j - img.rows-img.rows/4) * 2)) = yuv.at<uchar>(cv::Point(i, j));
            }
            else
            {
                uChannel.at<uchar>(cv::Point(i - yuv.cols / 2, (j - img.rows - img.rows / 4) * 2 + 1)) = yuv.at<uchar>(cv::Point(i, j));
            }
        }
    }

    cv::Rect r(0, 0, img.cols, img.rows);

    cv::Mat yChannel = yuv(r);

    cv::imshow("Output", yuv);
    cv::imshow("Input", img);
    cv::imshow("vChannel", vChannel);
    cv::imshow("uChannel", uChannel);
    cv::imshow("yChannel", yChannel);

    cv::waitKey(0);*/
    /*********************************************************************************/

    /*Portion 3, take in YUV, display*/
    /*********************************************************************************/
    
    FILE* f; //open file stream

    errno_t error = fopen_s(&f, "STARCRAFT_1920x1080p60_0.yuv", "rb"); //Load in a file, rb stands for "read only" in no-text files.


    //Manually set the parameters for each yuv file, they are specified in a name
    int width = 704;
    int height = 576;
    int frames = 300;


    //Check if the files has been read into a stream correctly
    if (f == NULL)
    {
        printf("Error\n\n");
        return 0;
    }
    else
    {
        printf("Successfully Read\n\n");
    }

    //Get the sizes of the entire stream, a frame, and a Y component which is our primary working component
    int sizeY = width * height; //Size of Y in a frame
    int size = ftell(f); //Size of entire stream
    int frameSize = (width * height * 1.5); //Size of entire frame

    int frameNum = 0; //Frame number to keep count of the frames


    //Create a buffer for a frame
    unsigned char* frameBuf;
    frameBuf = new unsigned char[sizeY]; //Buffer specifically for a size of a Y component

    fseek(f, frameSize * frameNum, SEEK_SET); //Set the position of a stream to a specified offset
    int r = fread(frameBuf, 1, sizeY, f); //Read a buffered input from a file

    cv::Mat img = cv::Mat(height, width, CV_8UC2, frameBuf);
    cv::namedWindow("Input - yuv", 0);
    cv::imshow("Input - yuv", img);

return 0;
}