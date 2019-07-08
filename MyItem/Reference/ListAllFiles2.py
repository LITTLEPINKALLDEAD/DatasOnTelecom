import os

Dir = r'E:\Test Folder'

for root,dirs,filenames in os.walk(Dir):
    FD = [filenames,dirs]
    
    for myF in FD:
        files = root+'\\'.join(myF)
        print(files)
        #print os.path.join(root,files)
        
    """
    for myFolder in dirs:
        print os.path.join(root,myFolder)

    print "============================="
    
    for myFile in filenames:
        print os.path.join(root,myFile)

    """
    
