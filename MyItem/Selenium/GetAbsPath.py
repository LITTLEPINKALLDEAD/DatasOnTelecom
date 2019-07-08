import os

print "Current file path is " + os.path.abspath(os.curdir)
print "Current file path is " + os.path.abspath('.')
print "Last file path is " + os.path.abspath('..')
