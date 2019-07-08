import os
import re

def isnumber(num):
    regex = re.compile(r"^(-?\d+)(\.\d*)?$")
    if re.match(regex,num):
        print ("True")
    else:
        print ("False")
        

if __name__ == '__main__':
    num = input("Please input a number: ")
    isnumber(num)
