import os
import time
import sys
import win32api

def MainFunction():
    Choose = input ("""
=============Welcome to File Operation=============
13. Open file or folder

=============Welcome to File Operation=============

Press AnyKey to Exit
        
Please choose : """)
    Fun = sys._getframe().f_code.co_name
    if Choose == '13':
        print("===============Open file or folder=================")
        Dir = input ("Please input file or folder path: ")
        if not Dir.strip():
            EmptyOrNot(Fun)
        else:
            if os.path.exists(Dir):
                FormatJudge(Dir,Fun)
                OpenFileOrFolder(Dir)
            else:
                ExistOrNot(Dir)
    else:
        print("Bye!")
        exit(1)

def OpenFileOrFolder(Dir):
    print("=================== Start =========================")
    print(time.strftime("Start Time :%Y-%m-%d %X",time.localtime()))
    os.startfile(Dir)
    print(Dir + " has been opened sucessfully!")
    print(time.strftime("End Time :%Y-%m-%d %X",time.localtime()))
    print("=================== Finish ========================")
    CountineOrExit()

def EmptyOrNot(Fun):
    print("Please do not input empty infos")
    if 'Main' in Fun:
        CountineOrExit()

def ExistOrNot(Dir):
    print("{0} is NOT Exist!" .format(Dir))
    CountineOrExit()

def FormatJudge(Dir,Fun):
    if not '\\' in Dir:
        print("The format of " + Dir + " is incorrect! Should with '\\'")
        if 'Main' in Fun:
            CountineOrExit()

def CountineOrExit():
    IsExit = input ("Countine(Y) or Exit(N)? ")
    while(1):
        if IsExit.upper() == 'Y':
            MainFunction()
        elif IsExit.upper() == 'N':
            print("Bye~")
            exit(0)
        else:
            print("You have inputed illegal character,try again!")
            CountineOrExit()
            break


if __name__ == '__main__':
    MainFunction()
    
