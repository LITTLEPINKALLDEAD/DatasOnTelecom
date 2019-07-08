# -*- coding: cp936 -*-
import re,urllib.request,urllib.error,urllib.parse
from subprocess import Popen, PIPE

print("Intranet IP：" + re.search('\d+\.\d+\.\d+\.\d+',Popen('ipconfig', stdout=PIPE).stdout.read()).group(0))
try:
    ipinfo = urllib.request.urlopen('http://ip138.com/ip2city.asp').read()
    w_ip = re.search('\d+\.\d+\.\d+\.\d+',ipinfo).group(0)
    print("Public network IP: " + w_ip)
except Exception as e:
    print(str(e))

#'http://www.whereismyip.com'
#'http://ip138.com/ip2city.asp' This site is available to search IP
