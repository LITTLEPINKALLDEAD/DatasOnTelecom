import os

a = input ("Insert a character:")

if not a.isdigit():
    print("This is not a number!")
elif int(a) in range(1,10):
    print(a)
else:
    print("Not")

