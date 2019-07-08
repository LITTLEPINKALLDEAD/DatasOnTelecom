# -*- coding:utf-8 -*- 
import os


def un_zip(cfile,extractpath):
    import zipfile
    """unzip zip file"""
    zip_file = zipfile.ZipFile(cfile)

    """
    if os.path.isdir(extractpath): #shotname,cfile + "_AA"
        print extractpath + " is exists and won't cover!"
    else:
        os.mkdir(extractpath)
    """
    if os.path.exists(extractpath):
        print(extractpath + " is exists and won't cover!")
        #print cfile + " has been decompressed to " + extractpath + " successfullly!"
    else:
        os.mkdir(extractpath)
        print(cfile + " has been decompressed to " + extractpath + " successfullly!")
        #print cfile + " has been decompressed failed!"
    #Core statements
    for names in zip_file.namelist():
        zip_file.extract(names,extractpath)
    #Core statements
    zip_file.close()

def un_rar(cfile,extractpath): #Need to Copy Unrar.exe and same folder that can do this operation or it will error
    output = os.popen('pip list')
    if 'rarfile' not in output.read():
        os.system('pip install rarfile')
        os.system('pip install unrar')
    #os.environ['UNRAR_LIB_PATH'] = 'C:\Program Files (x86)\UnrarDLL\x64\UnRAR64.dll'
    import rarfile
    #from rarfile import RarFile
    #RarFile.UNRAR_TOOL = 'C:\Program Files\WinRAR\UnRAR.exe'
    
    """unrar zip file"""
    rar = rarfile.RarFile(cfile)
    if os.path.exists(extractpath):
        print(extractpath + " is exists and won't cover!")
    else:
        os.mkdir(extractpath)
        print(cfile + " has been decompressed to " + extractpath + " successfullly!")
    #os.chdir(extractpath):
    #Core statements
    rar.extractall(extractpath) # Need to add a path on extractall() or it will depress empty file
    #Core statements
    rar.close()

if __name__ == "__main__":
    while 1:
        cfile = input("Please input compressed file path: ")
        if os.path.exists(cfile):
            extractpath = "".join(cfile.split('.')[:-1]) #This path include full path except extension name,Eg: E:\AAA\BBB\123.txt , only use E:\AAA\BBB
            if 'zip' in cfile:
                un_zip(cfile,extractpath)
            elif 'rar' in cfile:
                un_rar(cfile,extractpath)
            else:
                print("Cannot decompress non-zip and non-rar file")       
        elif not cfile.strip():
            print("Cannot input empty infos")       
        else:
            print(cfile + " is not exists!")

        
    
    #zipfilename = "".join(os.path.split(cfile)[-1:])
    #extractname = "".join(cfile.split('.')[:-1])

    #print extractname
    #print zipfilename
    #(shotname,extension) = os.path.splitext(zipfilename) #shortname and extension name can be split here
    #print shotname

    #un_zip(cfile,extractname)
    
