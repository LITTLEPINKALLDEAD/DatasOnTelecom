import os

a = input("Please input: ")
if os.path.exists(a):
    if '\\' in a:
        print("OK")
    else:
        a = a.replace(a,os.path.join(a,'\\'))
        print('New target path is ' + a)
else:
    print(a + " is not exists!")
