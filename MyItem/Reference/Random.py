import os
import random

def Random():
    #print (random.randrange(0,100))
    List1 = ['老广东','福荣祥','吉祥馄饨','原素西餐','麻辣香锅','黄焖鸡米饭']
    Item = random.choice(List1)
    print (Item)
    
    #Index = List1.index(Item)
    #print (Index)

    #List1.remove(Item)
    #print (List1)

    
if __name__ == '__main__':
    Random()
