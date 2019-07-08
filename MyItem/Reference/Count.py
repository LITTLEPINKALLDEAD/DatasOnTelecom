import os

a = input ("Insert a number:")

if a.isdigit():
    if a in range(1,12):
        print(a)
    else:
        print(a + " is out of edge")
else:
    print(a + " is not a number")
