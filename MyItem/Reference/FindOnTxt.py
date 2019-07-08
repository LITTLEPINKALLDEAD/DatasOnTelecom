import os
import time
"""
Dir  = raw_input ("Please input the folder path: ")

print str(os.listdir(Dir))
if 'txt' in str(os.listdir(Dir)):
    print 'True'
else:
    print 'False'
"""

def FindOnTxtMethod(Dir):
    if 'txt' in str(os.listdir(Dir)):
        c = 0
        Content = input ("What content you want to find on txt file? ")
        print("================================ Start ===============================")
        print(time.strftime("Start Time :%Y-%m-%d %X",time.localtime()))
        for root,dirs,filenames in os.walk(Dir):
            for myFile in filenames:
                i = 0
                TxtFile = os.path.join(root,myFile)
                f = open (TxtFile, 'r')
                Filecontent = f.readlines()              
                for eachline in Filecontent:
                    if Content.lower() in eachline.lower():
                        i += 1
                        c += 1
                f.close()
                if i > 0:
                    print(Content + " found on " + TxtFile + " for " + str(i) + " times")

        if c ==0 and i == 0:
            print(Content + " didn't found on " + Dir)
    else:
        print("There is no txt files under folder " + Dir)
        
    print(time.strftime("End Time :%Y-%m-%d %X",time.localtime()))
    print("================================ Finish ===============================")
    #CountineOrExit()
    """
    for root,dirs,filenames in os.walk(Dir):
        for myFile in filenames:
            TxtFile = os.path.join(root,myFile)
            i=0          
            if 'txt' in myFile:
                t = t + 1      
                f = open (TxtFile, 'r')
                Filecontent = f.readlines()
                for eachline in Filecontent:
                    if Content.lower() in eachline.lower():
                        i+= 1
                        c+= 1      
                if i > 0:
                    print Content + " found on " + TxtFile + " for " + str(i) + " times"
                    print "   "
                f.close()
    
    if c == 0 and t != 0:
        print Content + " didn't found on " + Dir              
    if c == 0 and t == 0:
        print "There is no txt files under folder " + Dir
    """
    #print time.strftime("End Time :%Y-%m-%d %X",time.localtime())
    #print "================================ Finish ==============================="
    #CountineOrExit()

if __name__ == "__main__":
    print("=========Find contents on txt files========")
    Dir  = input ("Please input the folder path: ")
    if os.path.exists(Dir):
        FindOnTxtMethod(Dir)
    elif not Dir.strip():
        print("NO EMPTY!")
    else:
        print(Dir + " not exists!")
               
