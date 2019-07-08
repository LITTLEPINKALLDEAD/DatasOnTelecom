import os

def DiskExitstOrNot():
    Dir = input("Please input path: ")
    DiskRoot = '\\'.join(Dir.split("\\")[:1])
    
    if os.path.exists(DiskRoot):
        print(DiskRoot)
    else:
        print("Disk " + DiskRoot + " is not exists on your computer")

if __name__ == '__main__':
    DiskExitstOrNot()
