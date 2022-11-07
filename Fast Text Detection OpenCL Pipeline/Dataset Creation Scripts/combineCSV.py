import sys
import time
import cv2
import pandas as pd
import glob

xiph_derf_files = glob.glob("*.csv") 
df = pd.concat((pd.read_csv(f, header = 0) for f in xiph_derf_files))
df.to_csv("Dataset.csv", index=False)