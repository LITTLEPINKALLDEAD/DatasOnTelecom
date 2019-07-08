# -*- coding:utf-8 -*- 
import os
import time

def CompressZip(Target,zipfilename,types):
    import zipfile
    #print Target
    #print zipfilename
    if 'file' in types:
        if os.path.exists(zipfilename):
            print(zipfilename + " is exists and won't cover!")
        else:
            #cfile = zipfile.ZipFile(zipfilename,'w',zipfile.ZIP_DEFLATED) #,zipfile.ZIP_DEFLATED
            #Core statements
            cfile = zipfile.ZipFile(zipfilename,'w',zipfile.ZIP_DEFLATED,allowZip64=True)
            os.chdir(os.path.dirname(Target)) #Need to switch to current dir then use os.chdir
            myfile = "".join(Target.split('\\')[-1])#last file can showed here
            cfile.write(myfile)
            #Core statements
            print(Target + " has been compressed as " + zipfilename + " succeessfully!")
            cfile.close()
    
    if 'dir' in types:
        if os.path.exists(zipfilename):
            print(zipfilename + " is exists and won't cover!")
        else:
            cfile = zipfile.ZipFile(zipfilename,'w',zipfile.ZIP_DEFLATED,allowZip64=True)  #zipfile.ZIP_DEFLATED can compress more space, allowZip64=True can compress more than 4G files!
            #startdir = "c:\\mydirectory"

            #Core statements
            for dirpath, dirnames, filenames in os.walk(Target):  
                for filename in filenames:  
                    cfile.write(os.path.join(dirpath,filename))
            #Core statements
            print(Target + " has been compressed as " + zipfilename + " succeessfully!")
            cfile.close()
    
if __name__ == "__main__":
    while 1:
        Target = input("Please input file or folder path: ")
        if os.path.exists(Target):
            if os.path.isdir(Target):
                zipfilename = "\\".join(Target.split('\\'))+".zip" # Show full path
                #zipfilename = "".join(Target.split('\\')[-1])+".zip" #Only last file can be showed
                types = 'dir'
            elif os.path.isfile(Target):
                #zipfilename = "".join(Target.split('.'))+".zip" # Show full path
                zipfilename = os.path.splitext(Target)[0]+'.zip' # Show full path without extension name
                #zipfilename = "".join(Target.split('\\')[-1])+".zip" #Only showed last file can be showed
                types = 'file'
            #print zipfilename
            #print Target
            #print os.path.splitext(Target)[0]
            print("".join(Target.split('\\')[-1]))
            CompressZip(Target,zipfilename,types)
            break
            
            
        elif not Target.strip():
            print("Cannot input empty infos")       
        else:
            print(Target + " is not exists!")


