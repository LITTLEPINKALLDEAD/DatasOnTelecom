import os

def DictListDir():
    FusionPath = r'C:\Users\AutoDesk\Fusion360'
    LDir = ['Neutron','CAM','Drawing','Graphics','Sketch']
    for i in LDir:
        print(os.path.join(FusionPath,i))

def DictListDir2():
    FPath = r'E:\Test Folder'
    for root,dir,filename in os.walk(FPath):
        LDir = [filename,dir]
        for i in LDir:
            for myii in i:
                print(os.path.join(root,myii))
    
if __name__ == '__main__':
    #DictListDir()
    DictListDir2()
    
