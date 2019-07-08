import os
import time

def ReplaceContentOnDir(Dir):
    if 'txt' in str(os.listdir(Dir)):
        c = 0
        Original = input("Please input what word you want to find: ")
        Replace = input("Please input what word you want to replace: ")
        print("================================ Start ===============================")
        print(time.strftime("Start Time :%Y-%m-%d %X",time.localtime()))
        for root,dirs,filenames in os.walk(Dir):
            for myFile in filenames:
                TxtFile = os.path.join(root,myFile)
                files = open (TxtFile,'r') 
                content = files.read()      
                files.close()
                Original = Original.lower()
                content = content.lower()
                if Original in content:
                    c+=1         
                    files = open (TxtFile,'w') 
                    files.write(content.replace(Original, Replace))
                    files.close()
                    print(Original + " has been replaced as " + Replace + " on file "+ TxtFile +" succeeded!")
                    print("   ")
                
                files.close()
        
        if c ==0:
            print(Original + " didn't found on " + Dir)
        
        print(time.strftime("End Time :%Y-%m-%d %X",time.localtime()))
        print("================================ Finish ===============================")
    else:
        print("There is no txt files under folder " + Dir)

if __name__ == "__main__":
    print("========Replace content on txt files========")
    Dir = input ("Please input the folder path: ")
    if os.path.exists(Dir):
        ReplaceContentOnDir(Dir)
    elif not Dir.strip():
        print("NO EMPTY!")
    else:
        print("NOT EXISTS!")
               
