import os
import shutil
if __name__ == '__main__':
    n=0
    for root, dirs, files in os.walk('D:/...'):          # replace the ... with your starting directory
        for file in files:
            path_file = os.path.join(root,file)
            n=n+1
            shutil.copy(path_file,'D:/.../'+str(n)+'.png')          # replace the ... with the destination dir