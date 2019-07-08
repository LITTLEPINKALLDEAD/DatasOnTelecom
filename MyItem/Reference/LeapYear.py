import os

def LeapYear(Year):
    if int(Year) % 4 == 0 and int(Year) % 100 != 0 or int(Year) % 100 == 0 and int(Year) % 400 == 0:
        print (Year + " is leap year!")
    else:
        print (Year + " is NOT leap year!")

if __name__ == '__main__':
    Year = input("Please input year: ")
    if not Year.strip():
        print ("Cannot input empty infos")
    else:
        if Year.isdigit():
            if int(Year) > 0:
                LeapYear(Year)
            else:
                print ("Cannot input negative number")
        else:
            print ("Cannot input non-numeric character")
                
        
    
