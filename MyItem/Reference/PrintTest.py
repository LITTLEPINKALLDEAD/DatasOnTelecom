import os

"""
Install = 2
InstallList = ['selenium','Django']

if Install == 1:
    pkg = 'package has'
else:
    pkg = 'packages have'
print ("{0} ({1}) ".format(str(Install),','.join(InstallList)) + pkg +" insalled on this PC successfully!")

Updated = 1
UpdatedList = ['numpy']

if Updated == 1:
    pkg = 'package has'
else:
    pkg = 'packages have'
print ("{0} ({1}) ".format(str(Updated),','.join(UpdatedList)) + pkg + " updated on this PC successfully!")
"""

Installed = 1
InstalledList = ['rarfile']

if Installed == 1:
    pkg = 'package was'
else:
    pkg = 'packages were'
print ("{0} ({1}) ".format(str(Installed),','.join(InstalledList)) + pkg + " installed on this PC are the latest version!")

if Installed == 1:
    pkg = 'package was'
else:
    pkg = 'packages were'
print ("There are {0} ({1}) ".format(str(Installed),','.join(InstalledList)) + pkg + " insalled on this PC!")
