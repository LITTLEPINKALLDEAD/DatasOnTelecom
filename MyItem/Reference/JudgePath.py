import os
import time

def JudgePath(FPath):
    if not '\\' in FPath:
        print("The format of " +FPath + " should with '\\'")

if __name__ == '__main__':
    FPath = input("Please input file or folder path: ")
    if not FPath.strip():
        print("Do not input empty infos")
    else:
        if os.path.exists(FPath):
            JudgePath(FPath)
        else:
            print(FPath + " is NOT exists!")
    
        
