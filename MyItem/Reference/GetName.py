# -*- coding: cp936 -*-
import sys
def get_cur_info(aaa):
    print(sys._getframe().f_code.co_filename)  #��ǰ�ļ���������ͨ��__file__���
    print(sys._getframe().f_code.co_name)  #��ǰ������
    print(sys._getframe().f_lineno) #��ǰ�к�
    if 'get' in sys._getframe().f_code.co_name:
        print("True")
    else:
        print("False")

get_cur_info(123)
