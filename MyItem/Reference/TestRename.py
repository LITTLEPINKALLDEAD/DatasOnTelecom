# -*- coding: cp936 -*-
"""
import os
import shutil

FolderA = r'D:\\Test\\Abc\\123'

FolderB = 'Test2'

#print str(FolderA.split('\\')[:-2])
os.rename(FolderA,os.path.join(str(FolderA.split('\\')[:-2]),FolderB))

 


import os 

srcPath=r"WallReference.pdf" 

path=os.path.abspath(srcPath) 

print "全路径为：",path 

print "路径名，文件名",os.path.split(path)

"""
import os 

FolderA = r'D:\\Test\\Test3'

FolderB = 'Test2'

FolderA=os.path.abspath(FolderA) 

print("全路径为：", FolderA) 

print("路径名，文件名", os.path.split(FolderA))

#os.rename (FolderA,os.path.join(os.path.split(path)[0],FolderB))

