import os

def UsePipInstall():
    output = os.popen('pip list')
    if 'WMI' not in output.read():
        os.system('pip install wmi')
    
    """
    if 'rarfile' not in output.read():
        os.system('pip install rarfile')
    else:
        print ("Update package rarfile")
        os.system('pip install rarfile -U')
        
    if 'selenium' not in output.read():
        os.system('pip install selenium')
    else:
        print ("Update package selenium")
        os.system('pip install selenium -U')

    if 'Django' not in output.read():
        os.system('pip install Django')
    else:
        print ("Update package Django")
        os.system('pip install Django -U')

    if 'pypiwin32' not in output.read():
        os.system('pip install pypiwin32')
    else:
        print ("Update package pypiwin32")
        os.system('pip install pypiwin32 -U')
    """
    
if __name__ == '__main__':
    UsePipInstall()
    
