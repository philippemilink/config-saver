#!/bin/bash

if [ ! -f tosave ]
then
    echo "File 'tosave' is not present."
    exit 1
fi

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



function save_cron_of_user () {
    cron=`crontab -u $1 -l 2>&1`
    if [[ $cron != no* ]]
    then
        echo $1 >> $dest/crons
        echo "$cron" | tail -n+22 >> $dest/crons
    fi
}

echo "Saving installed CRONs..."
if [[ "$(id -u)" != "0" ]]; then
    echo "Script must be launched as root to save CRONs of other users."

    save_cron_of_user $USER
else
    for user in $(cut -f1 -d: /etc/passwd);
    do
        save_cron_of_user $user
    done

    # If we are executed as root, give files to the initial user, to ease later file manipulation:
    user=${SUDO_USER:-$(whoami)}
    chown -R $user:$user $dest
fi

echo "Files copied. Don't forget to commit !"
