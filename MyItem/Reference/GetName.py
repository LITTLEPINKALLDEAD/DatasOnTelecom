# -*- coding: cp936 -*-
import sys
def get_cur_info(aaa):
    print(sys._getframe().f_code.co_filename)  #当前文件名，可以通过__file__获得
    print(sys._getframe().f_code.co_name)  #当前函数名
    print(sys._getframe().f_lineno) #当前行号
    if 'get' in sys._getframe().f_code.co_name:
        print("True")
    else:
        print("False")

get_cur_info(123)
