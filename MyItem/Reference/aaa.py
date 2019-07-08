#!/usr/bin/python
import zipfile
f = zipfile.ZipFile('archive.zip','w',zipfile.ZIP_DEFLATED)
#f.write('E:\\Files\\1212\\ZipFileAndFolder.py')
f.write('ZipFileAndFolder.py')
f.close()
