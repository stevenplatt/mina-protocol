import os
import re
# this script can be used to search a local git repository for static assignments of IP addresses and container images

container_count = 0
ip_count = 0

def findcontainer(dir,keyword): # search all files in a directory for a specific container image keyword
  global container_count

  for file in os.listdir(dir):
    path = dir + "/" + file

    try :
        if os.path.isdir(path):
          findcontainer(path, keyword)
        else:
          if keyword in open(path).read():
            print(path)
            container_count = container_count +1
    except Exception as notice:
        #print(notice)
        pass

# disabled for now, more work is needed to filter out IP addresses such as 127.0.0.1 and 0.0.0.0
# https://www.geeksforgeeks.org/extract-ip-address-from-file-using-python/

# https://github.com/MinaProtocol/mina/blob/develop/frontend/wallet/src/render/CodaProcess.re is a good example of static IP assignment

def findip(dir): # search all files in a directory for static IP addresses
  global ip_count
  ip_pattern = re.compile(r'((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)')

  for file in os.listdir(dir):
    path = dir + "/" + file

    try :
        if os.path.isdir(path):
          findip(path)
        else:
          if ip_pattern.search(open(path).read()):
            print(path)
            ip_count = ip_count +1
    except Exception as notice:
        #print(notice)
        pass

findcontainer("../mina", "gcr.io/o1labs-192920/")
print("This repository has " + str(container_count) + " container dependencies")

# findip("../mina")
# print("This repository has " + str(ip_count) + " IP dependencies")