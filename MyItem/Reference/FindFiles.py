# -*- coding: utf-8 -*-
import os
import re
import shutil
import time



def FindFilesonDirs(Path):
    File = input ("What file or folder you want to find on this folder? ")
    k = 0
    print("================================ Start ===============================")
    print(time.strftime("Start Time :%Y-%m-%d %X",time.localtime()))
    for root,dirnames,filenames in os.walk(Path):
        if os.path.isfile(os.path.join(Path,File)):
            for myFile in filenames:
                if File.lower() in myFile.lower():
                    k = k + 1
                    print("File: " + File + " has found on " + root)
                    print("  ")
        elif os.path.isdir(os.path.join(Path,File)):
            for myFolder in dirnames:
                if File.lower() in myFolder.lower():
                    k = k + 1
                    print("Folder: " + File + " has found on " + root)
                    print("  ")   
    if k == 0:
        print("File: " + File + " didn't found on " + Path)
    print(time.strftime("End Time :%Y-%m-%d %X",time.localtime()))
    print("================================ Finish ===============================")

if __name__ == "__main__":
    print("============Find Files on Folder===========")
    Path  = input ("Please input the folder path: ")
    if os.path.exists(Path):
        FindFilesonDirs(Path)
    elif not Path.strip():
        print("Please do not input the empty infos")
    else:
        print("{0} is NOT Exist!" .format(Path))
       
    
