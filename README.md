# config-saver
Shell script to save listed files and folders

1. Create a file called *tosave*. In this file, the first line should be the name of this save, and all 
   following lines absolute path to files or folders to save.
2. Executing `./config-saver.sh` from the folder where was put the file *tosave* will create a folder named
   like the name in the first line of file, and copy all files and folders specified, by recreating the
   filesystem tree in the saving folder.
