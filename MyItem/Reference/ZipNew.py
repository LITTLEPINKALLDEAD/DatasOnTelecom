import os
import time
import zipfile

def adddirfile(): 
    f = zipfile.ZipFile('E:\\archive.zip','w',zipfile.ZIP_DEFLATED,allowZip64=True) 
    startdir = "E:\\Test Folder\\te ST 48\\McLaren"
    print((os.path.dirname(startdir)))
    os.chdir(os.path.dirname(startdir)) 
    for dirpath, dirnames, filenames in os.walk(startdir): 
        for filename in filenames: 
            f.write(os.path.join(dirpath,filename)) 
    f.close()
    
def adddirfile2():
    f = zipfile.ZipFile('E:\\archive.zip','w',zipfile.ZIP_DEFLATED,allowZip64=True)
    f.write(filename,file_url)
    f.close()
    
if __name__ == '__main__':
    adddirfile2()
