import os

def OSSystem():
    print (os.popen('pip list'))
    print (os.system('pip list'))


if __name__ == '__main__':
    OSSystem()
    
