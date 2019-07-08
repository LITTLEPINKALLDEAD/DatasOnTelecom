import os
import time

def ListAllFiles(Dirs,Content):
    for root,dirs,filenames in os.walk(Dirs):
        for myfile in filenames: 
            ff = os.path.join(root,myfile)
            myList = str(ff).split(",")
            if Content.lower() in myfile.lower():
                #myList.append(str(ff))
                print(myList)

    
if __name__ == '__main__':
    Dirs = input("Please input the folder path: ")
    Content = input("What you want delete? ")
    if os.path.exists(Dirs):
        if os.path.isfile(Dirs):
            print("Sorry, you can not input the file path " + Dirs)
        else:
            ListAllFiles(Dirs,Content)
    else:
        print(Dirs + " is NOT exists!")
