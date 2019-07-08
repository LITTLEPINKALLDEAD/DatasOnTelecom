import os  
from os.path import join, getsize  
  
def getdirsize(dir):  
   size = 0
   if os.path.isdir(dir):
      for root, dirs, files in os.walk(dir):  
         size += sum([getsize(join(root, name)) for name in files])
   elif os.path.isfile(dir):
      size = os.path.getsize(dir)
   return (size/1024.00/1024.00)  
  
if __name__ == "__main__":
   dir = input("Please input: ")
   filesize = getdirsize(dir)
   #print '%.3f' % filesize
   print('There are %.3f' % filesize, 'Mbytes in D:\eclipse')  
