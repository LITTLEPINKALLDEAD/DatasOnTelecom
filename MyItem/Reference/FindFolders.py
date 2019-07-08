import os

def SearchBackupFolder():
    k = 0
    Dir = 'D:\\'
    Name = '_Backup'
    BackupFolder = []
    for root,dirs,filenames in os.walk(Dir):
        for myFolder in dirs:
            if Name.lower() in myFolder.lower():
                k = k + 1
                BackupFolder = os.path.join(root,myFolder)
                print (BackupFolder)

    if k == 0:
        print("BackupFolder is not exixts and won't put back!")

    return BackupFolder
    

if __name__ == '__main__':
    Bak = SearchBackupFolder()
    print ("=======================")
    print ("Backup Folder on main is: " + Bak)
   
    
