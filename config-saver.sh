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


echo "Saving list of installed package..."
dpkg -l > $dest/packages.list


echo "Saving installed CRONs..."
for user in $(cut -f1 -d: /etc/passwd);
do
    cron=`crontab -u $user -l 2>&1`
    if [[ $cron != no* ]]
    then
        echo $user >> $dest/crons
        echo "$cron" | tail -n+22 >> $dest/crons
    fi
done

echo "Files copied. Don't forget to commit !"
