import os

def GetSize(Source):  
   size = 0
   if os.path.isfile(Source):
       size = os.path.getsize(Source)
   elif os.path.isdir(Source):
       for root, dirs, files in os.walk(Source):
           for names in files:
               myfiles = os.path.join(root,names)
               size += sum([os.path.getsize(myfiles)]) #Need to add [] that let string transfer to long
   return (size/1024/1024)  
  
if __name__ == '__main__':
    Source = input("Please input the file or folder path: ")
    if os.path.exists(Source):
        filesize = GetSize(Source)
        print(str(filesize) + ' MB on ' + Source)
    else:
        print(Source + " is not exists!")
