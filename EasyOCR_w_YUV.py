import easyocr
import time
import yuvio #the person who build the library is from FAU is a research person and still active
import cv2
import numpy as np
import math
import csv
#reader = yuvio.get_reader("CSGO.yuv", 1920, 1080, "yuv420p")

counter = 0
readers = easyocr.Reader(['en'])

cap = cv2.VideoCapture('CSGO.mp4')
ret, frame = cap.read()

    #print(yuv_frame) #test to see what its inside of the frame
bounds = readers.readtext(frame, detail=1)
frame_array = np.zeros((1920, 1080), dtype=int, order='F')

header = ['x', 'y', 'classification value']
print(bounds)
for bound in bounds:

    #print(bound)
    bounds_coor = bound[0]

    top_left = bounds_coor[0]
    top_left[0] = math.floor(top_left[0])
    top_left[1] = math.floor(top_left[1])
    top_right = bounds_coor[1]
    top_right[0] = math.floor(top_right[0])
    top_right[1] = math.floor(top_right[1])
    bottom_right = bounds_coor[2]
    bottom_right[0] = math.floor(bottom_right[0])
    bottom_right[1] = math.floor(bottom_right[1])
    bottom_left = bounds_coor[3]
    bottom_left[0] = math.floor(bottom_left[0])
    bottom_left[1] = math.floor(bottom_left[1])

    print("Top Left corner: " + "(" + str(top_left[0]) + "," + str(top_left[1]) + ") ")
    print("Top Right corner: " + "(" + str(top_right[0]) + "," + str(top_right[1]) + ") ")
    print("Botttom right corner: " + "(" + str(bottom_right[0]) + "," + str(bottom_right[1]) + ") ")
    print("Bottom left corner: " + "(" + str(bottom_left[0]) + "," + str(bottom_left[1]) + ") ")

    x_offset = top_left[0]%16
    y_offset = top_left[1]%16

    x_macro = top_left[0] - x_offset
    y_macro = top_left[1] - y_offset
    output = 0
    if (x_offset < 10 and y_offset < 10):
        output = 1
    print(output)
    print(x_offset)
    print(y_offset)
    print(" (", x_macro, ",", y_macro, ") ")

    x_offset = top_right[0]%16
    y_offset = top_right[1]%16
    x_macro2 = top_right[0] - x_offset
    y_macro2 = top_right[1] - y_offset
    print(output)
    print(x_offset)
    print(y_offset)
    print("(", x_macro2, ",", y_macro2, ")")

    for i in range(x_macro, x_macro2+16, 16):
        frame_array[i][y_macro] = output

    x_offset = bottom_right[0]%16
    y_offset = bottom_right[1]%16
    x_macro3 = bottom_right[0] - x_offset
    y_macro3 = bottom_right[1] - y_offset
    output = 0
    print(output)
    print(x_offset)
    print(y_offset)
    print(" (", x_macro3, ",", y_macro3, ") ")

    x_offset = bottom_left[0]%16
    y_offset = bottom_left[1]%16
    x_macro4 = bottom_left[0] - x_offset
    y_macro4 = bottom_left[1] - y_offset
    output = 0
    print(output)
    print(x_offset)
    print(y_offset)
    print(" (", x_macro4, ",", y_macro4, ") ")

    if (x_offset > 6 and y_offset < 10):
        output = 1
    for i in range(x_macro4, x_macro3+16, 16):
        frame_array[i][y_macro4] = output

    for j in range(y_macro + 16, y_macro4, 16):
        for i in range(x_macro, x_macro2+16, 16):
            if i == x_macro or i == x_macro2:
                if frame_array[x_macro][y_macro] == 1 or frame_array[x_macro4][y_macro4] == 1:
                    frame_array[i][j] = 1
                else:
                    frame_array[i][j] = 0
            else:
                frame_array[i][j] = 1

    #for j in range(0, 320, 16):
        #for i in range(0, 1920, 16):
         #   print("(" + str(i) + "," + str(j) + ") =" + str(frame_array[i][j]), end=' ')
        #print("\n")
counter+= 1
with open('testing.csv', 'w', encoding='UTF8', newline = '') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    for j in range(0, 1064, 16):
        for i in range(0, 1920, 16):
            data = [i, j, frame_array[i][j]]
            writer.writerow(data)
cap.release()


