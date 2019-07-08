import os,sys,time,progressbar



def ProcessBar1():
    for i in range(100):
        sys.stdout.write('>')
        sys.stdout.flush()
        time.sleep(0.1)

def ProcessBar2():
    for i in range(100):
        sys.stdout.write('\r%s%%'%(i+1))
        sys.stdout.flush()
        time.sleep(0.1)

def ProcessBar3():
    for i in range(100):
        k = i + 1
        str = '>'*i+' '*(100-k)
        sys.stdout.write('\r'+str+'[%s%%]'%(i+1))
        sys.stdout.flush()
        time.sleep(0.1)

def ProcessBar4():
    for i in range(100):
        k = i + 1
        str = '>'*(i//2)+' '*((100-k)//2)
        sys.stdout.write('\r'+str+'[%s%%]'%(i+1))
        sys.stdout.flush()
        time.sleep(0.1)

def ProcessBar5():
    source = r'D:\MyMusic'
    target = r'E:\123'
    #copyFiles(source,target)
    num = GetSize(source)
    size = GetSize(target)
    
    #bar = progressbar.ProgressBar()

    bar = progressbar.ProgressBar(widgets=[' [', progressbar.Timer(), '] ',progressbar.Percentage(),' (', progressbar.ETA(), ') ',])
    for i in bar(range(int(GetSize(target)),int(GetSize(source)))):
        #print ('source folder:' + str(GetSize(source)))
        #print ('target folder:' + str(GetSize(target)))
        time.sleep(0.1)

def copyFiles(sourceDir, targetDir): 
    if sourceDir.find(".svn") > 0: 
        return 
    
    files = []
    i = 0
    while(1):
        try:
            files = os.listdir(sourceDir)
            break
        except OSError as e:
            print(e)
            if i >= 10:
                raise Exception('Cannot connect to resource more than 10 times: ' + '"' + sourceDir + '"')
            i = i + 1
            time.sleep(2)
        
    for file in files: 
        sourceFile = os.path.join(sourceDir, file) 
        targetFile = os.path.join(targetDir, file) 
        if os.path.isfile(sourceFile): 
            if not os.path.exists(targetDir):  
                os.makedirs(targetDir)  
            if not os.path.exists(targetFile) or(os.path.exists(targetFile) and (os.path.getsize(targetFile) != os.path.getsize(sourceFile))):  
                open(targetFile, "wb").write(open(sourceFile, "rb").read()) 
        if os.path.isdir(sourceFile): 
            copyFiles(sourceFile, targetFile)

def GetSize(Source):  
   size = 0
   for root, dirs, files in os.walk(Source):
       for names in files:
           myfiles = os.path.join(root,names)
           size += sum([os.path.getsize(myfiles)])
   return (size/1024.00/1024.00)

if __name__=='__main__':
    #ProcessBar1()
    ProcessBar5()
