#!/bin/bash



name=`head -n 1 tosave` # folder where files will be copied


if [ ! -e $name ]
then
	mkdir $name
elif [ ! -d $name ]
then
	echo "A file named $name already exists."
	exit 1
else
	rm -rf $name # to ease the update of files, start with removing the folder
	mkdir $name
fi


dest=`readlink -f $name` # full path of saving folder


# Symbolic links are not used during copying, because Git stores them as symbolic
# links and not as plain text files (by default).

for file in `tail -n +2 tosave`
do
	echo "Copying $file..."

	if [ ! -e $file ]
	then
		echo "$file doesn't exist."
	elif [ -d $file ]
	then
		cp -r --parents $file $dest
	else
		cp --parents $file $dest
	fi
done


dpkg -l > $dest/packages.list

echo "Files copied. Don't forget to commit !"
