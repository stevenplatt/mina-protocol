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

findcontainer("../mina", "Size.Small")
print("This repository has " + str(container_count) + " container dependencies")

# findip("../mina")
# print("This repository has " + str(ip_count) + " IP dependencies")
