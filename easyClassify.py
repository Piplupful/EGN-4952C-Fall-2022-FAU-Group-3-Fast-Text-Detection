import sys
import easyocr
import time
import cv2
import numpy as np
import pandas as pd
import PIL 
from PIL import ImageDraw
from PIL import Image
import glob

def draw_boxes(image, bounds):
    draw = ImageDraw.Draw(image)
    for bound in bounds:
        p0, p1, p2, p3 = bound[0]
        draw.line([*p0, *p1, *p2, *p3, *p0], fill=123, width=2)
    return np.asarray(image)
    
frameNums = [0, 429, 527, 410, 1131, 1567, 1741, 1834, 2042, 2210, 2479, 2755, 2963, 3536, 3580] # change based on frames selected

fileName = "EuroTruckSim_1920x1080p60" # change based on video selected

counter = 0
readers = easyocr.Reader(['en'])
cap = cv2.VideoCapture(fileName + ".mp4")

for frameNum in frameNums:
  cap.set(1, frameNum)
  ret,frame = cap.read()
  bounds = readers.readtext(frame, detail=1)
  bounds_arr = bounds[0]
  print(frameNum)

  df = pd.read_csv(fileName + "_" + str(frameNum) + ".csv")
  df['CLASS'] = 0

  for i in range(len(bounds)):
    bound = bounds[i][0]
    #print(bound)
    top_left = bound[0]
    top_left_x = top_left[0]
    top_left_y = top_left[1]
    xdeviation = (top_left_x % 16)
    ydeviation = (top_left_y % 16)
    top_left_x = top_left_x - xdeviation
    top_left_y = top_left_y - ydeviation
    #print(top_left_x, top_left_y)
    top_right = bound[1]
    top_right_x = top_right[0]
    top_right_y = top_right[1]
    xdeviation = (top_right_x % 16)
    ydeviation = (top_right_y % 16)
    top_right_x = top_right_x - xdeviation
    top_right_y = top_right_y - ydeviation
    #print(top_right_x, top_right_y)
    bottom_right = bound[2]
    bottom_right_x = bottom_right[0]
    bottom_right_y = bottom_right[1]
    xdeviation = (bottom_right_x % 16)
    ydeviation = (bottom_right_y % 16)
    bottom_right_x = bottom_right_x - xdeviation
    bottom_right_y = bottom_right_y - ydeviation
    #print(bottom_right_x, bottom_right_y)
    bottom_left = bound[3]
    bottom_left_x = bottom_left[0]
    bottom_left_y = bottom_left[1]
    xdeviation = (bottom_left_x % 16)
    ydeviation = (bottom_left_y % 16)
    bottom_left_x -= xdeviation
    bottom_left_y -= ydeviation
    #print(bottom_left_x, bottom_left_y)
    df.loc[(df['X'] >= top_left_x) & (df['X'] <= top_right_x) & (df['Y'] >= top_left_y) & (df['Y'] <= bottom_left_y), 'CLASS'] = 1
    output = fileName + "_" + str(frameNum) + "_CLASS.csv"
    df.to_csv(output, index=False)
    
individual_files = glob.glob("*CLASS.csv") 
df = pd.concat((pd.read_csv(f, header = 0) for f in individual_files))
df.to_csv(fileName + ".csv", index=False)