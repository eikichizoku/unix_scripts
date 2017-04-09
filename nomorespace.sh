#!/bin/sh






#Silly variables declarations
#let's add some colors because color is life
RED='\033[0;31m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
HIGHLIGHT='\033[37;7m'
NC='\033[0m'

echo ${WHITE} 'Do you want me to check the filesize of each folder under your account ? Most of the issues come from here usually'
read -r yn

if [[ "$yn" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		echo "Enumerating each folder size under '$HOME'"
		echo ''
		echo 'Here are the folders under '$USER' account where are the largest files'
		du -sh $HOME/* | grep '[0-9]G\>' | sort -k 1rn
		echo ''
        	echo 'I will open the biggest folder for you to investigate'
	        open1=`du -sh $HOME/* | grep '[0-9]G\>' | sort -k 1rn | head -1`
		open $open1
	
	else
	
		echo 'Where do you want to check the space used in your computer ?'
		read -r where
		echo ''

		echo 'Enumerating each folder size under $where'
		echo ''
		echo 'Here are the folders under '$where' where are the largest files'
		du -sh $where/* | grep '[0-9]G\>' | sort -k 1rn

		echo ''
		echo 'I will open the biggest folder for you to investigate'
		open du -sh $where/* | grep '[0-9]G\>' | sort -k 1rn | head -1

fi

