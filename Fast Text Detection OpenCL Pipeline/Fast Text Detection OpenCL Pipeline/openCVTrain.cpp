#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/ml/ml.hpp>
#include <iostream>

#include "csvFileOpenUtil.h"

using namespace std;
using namespace cv;
using namespace ml;

int openCVTrainDTC(bool results)
{
    char fileName[2000];
    char filePath[2000];

    openCSVFile(fileName, filePath);

    //https://docs.opencv.org/4.x/dc/d32/classcv_1_1ml_1_1TrainData.html#ab3264a32194126ff8d6821e76018cde3
    Ptr<cv::ml::TrainData> dataSet = ml::TrainData::loadFromCSV(filePath, 1);

    int n_samples = dataSet->getNSamples();
    if (n_samples == 0) {
        cerr << "Could not read file: " << fileName << endl;
        exit(-1);
    }
    else {
        cout << "Read " << n_samples << " samples from " << fileName << endl;
    }

    dataSet->setTrainTestSplitRatio(0.90, false);
    int n_train_samples = dataSet->getNTrainSamples();
    int n_test_samples = dataSet->getNTestSamples();
    cout << "Found " << n_train_samples << " Train Samples, and "
        << n_test_samples << " Test Samples" << endl;

    cv::Ptr<cv::ml::RTrees> dtree = cv::ml::RTrees::create();

    //https://docs.opencv.org/4.x/d8/d89/classcv_1_1ml_1_1DTrees.html
    dtree->setMaxDepth(15);
    dtree->setMinSampleCount(50);
    dtree->setRegressionAccuracy(0);
    //dtree->setUseSurrogates(false);
    dtree->setMaxCategories(2);
    dtree->setCVFolds(0); // nonzero causes core dump
    dtree->setUse1SERule(false);
    dtree->setTruncatePrunedTree(false);
    //Train model
    dtree->train(dataSet);

    if(results)
    {
        cv::Mat results;
        float train_performance = dtree->calcError(dataSet,
            false, // use train data
            results // cv::noArray()
        );

        float test_performance = dtree->calcError(dataSet,
            true, // use test data
            results // cv::noArray()
        );
        cout << "Performance on training data: " << train_performance << "%" << endl;
        cout << "Performance on test data: " << test_performance << " % " << endl;
    }

    dtree->save("../dtree.xml");

    return 0;
}

//Reference: https://github.com/oreillymedia/Learning-OpenCV-3_examples/blob/master/example_21-01.cpp#L29
//Basing this training code heavily from this sample dramatically accelerated development of the DTC model through OpenCV.