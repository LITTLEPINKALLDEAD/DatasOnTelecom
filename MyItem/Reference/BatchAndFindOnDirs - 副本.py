# -*- coding: utf-8 -*-
import os
import re
import shutil
import time
import sys

def BatchAndFindOnDirs(Dir,Fun):
    k = 0
    if os.path.isdir(Dir):
        while 1:
            Find = input ("What want to find on this folder? ")
            if not Find.strip():
                print("Cannot input empty file or folder name, please input again!")
            else:
                break
            
        if 'Rename' in Fun:
            while 1:
                Replace = input("Please input new name to replace: ")
                if not Replace.strip():
                    print("Cannot input empty replace content, please input again!")
                else:
                    break

        if 'Del' in Fun:
            while 1:
                IsDel = input("Are you sure to batch delete files or folders? (Y/N)")
                if IsDel.lower() == 'y':
                    break
                elif IsDel.lower() == 'n':
                    CountineOrExit()
                    break
        
        print("=================== Start =========================")
        print(time.strftime("Start Time :%Y-%m-%d %X",time.localtime()))
        for root,dirs,filenames in os.walk(Dir):
            aa = ''.join(root)
            bb = ''.join(filenames)
            print("IS: "+ os.path.join(aa,bb))
            for myFile in filenames:
                if Find.lower() in myFile.lower():
                    k = k + 1
                    F = os.path.join(root,myFile)
                    if 'Del' in Fun:                        
                        os.remove(F)
                        if not os.path.exists(F):
                            print(F + " has been deleted successfully!")
                            print("  ")
                        else:
                            print(F + " has been deleted failed!")
                        
                    elif 'Find' in Fun:
                        print(Find + " has found on " + F)
                        print("  ")
                    elif 'Rename' in Fun:
                        Find = Find.lower()
                        myFile = myFile.lower()
                        OldName = os.path.join(root,myFile)
                        myFile = myFile.replace(Find,Replace)
                        NewName = os.path.join(root,myFile)
                        os.rename (OldName,NewName)
                        if os.path.exists(NewName):
                            print(OldName +" has been replaced as " + NewName + " successfully!")
                            print("   ")
                            
            for myFolder in dirs:
                if Find.lower() in myFolder.lower():
                    k = k + 1
                    F = os.path.join(root,myFolder)
                    if 'Del' in Fun:                        
                        shutil.rmtree(F)
                        if not os.path.exists(F):
                            print(F + " has been deleted successfully!")
                            print("  ")
                        else:
                            print(F + " has been deleted failed!")
                        
                    elif 'Find' in Fun:
                        print(Find + " has found on " + F)
                        print("  ")
                    elif 'Rename' in Fun:
                        Find = Find.lower()
                        myFolder = myFolder.lower()
                        OldName = os.path.join(root,myFolder)
                        myFolder = myFolder.replace(Find,Replace)
                        NewName = os.path.join(root,myFolder)
                        os.rename (OldName,NewName)
                        if os.path.exists(NewName):
                            print(OldName +" has been replaced as " + NewName + " successfully!")
                            print("   ")
        
        if k == 0:
            print(Find + " didn't found on " + Dir)
        print(time.strftime("End Time :%Y-%m-%d %X",time.localtime()))
        print("=================== Finish ========================")
    else:
        print(Dir + " is a file path , please input a folder path")

def FormatJudge(Dir):
    if not '\\' in Dir:
        print("The format of " + Dir + " is incorrect! Should with '\\'")

def EmptyOrNot():
    print("Please do not input empty infos")

def ExistOrNot(Dir):
    print("{0} is NOT Exist!" .format(Dir))

if __name__ == '__main__':
    Dir  = input ("Please input folder path: ")
    if os.path.exists(Dir):
        FormatJudge(Dir)
        BatchAndFindOnDirs(Dir,'Find')
    elif not Dir.strip():
        EmptyOrNot()
    else:
        ExistOrNot(Dir)

