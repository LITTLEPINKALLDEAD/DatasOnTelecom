import time
import os

def GetDate():
    Date = time.strftime("%Y-%m-%d %X", time.localtime())
    Today = time.strftime("%A",time.localtime())
    time.strftime("%a",time.localtime()) #Shorthand
    return "Today is " + Date +" , "+Today  #Full

if __name__ == '__main__':
    a = input("""
    =========================================
    123
    456
    =============""" + GetDate() + """ ============================
    """
    )
    
    




