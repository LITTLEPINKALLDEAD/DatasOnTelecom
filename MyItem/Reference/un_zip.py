import os

def un_zip(file_name):
    import zipfile
    """unzip zip file"""  
    zip_file = zipfile.ZipFile(file_name)  
    if os.path.isdir(file_name + "_files"):  
        pass  
    else:  
        os.mkdir(file_name + "_files")  
    for names in zip_file.namelist():  
        zip_file.extract(names,file_name + "_files/")  
    zip_file.close() 

if __name__ == '__main__':
    file_name = input("Please input zip file path: ")
    if os.path.exists(file_name):
        if os.path.isfile(file_name):
            if '.zip' in file_name:
                un_zip(file_name)
            else:
                print(file_name + " is not .zip format file")
        else:
            print(file_name + " is not file!")
    else:
        print(file_name + " is not exists!")
