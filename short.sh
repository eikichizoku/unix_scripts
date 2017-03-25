#!/bin/sh
#v1.0 (26 Feb 2017) Script by Vinh Francis Guyait <vinh@fb.com>. Determine for files their whole path character lenght, sort by longest, tag them in Mac Os.
#Will also rename basename files to match Micro$oft basename filesystems requirements - Useful when you migrate stuff to SharePoint.

#count length for each files
#ls | awk '$(NF+1)=length'

#Silly variables declarations
#let's add some colors because color is life
RED='\033[0;31m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
HIGHLIGHT='\033[37;7m'
NC='\033[0m'

clear

#Input folder path we want to analyze and give value for character lenght we want to list
echo ${BLUE}"            ▄▄"
echo ${BLUE}"           █░░█           v1.0 Scripted by Vinh Francis Guyait <vinh@fb.com>"
echo ${BLUE}"           █░░█           IT-FIELD EMEA"     
echo ${BLUE}"          █░░░█"
echo ${BLUE}"         █░░░░█"
echo ${BLUE}"███████▄▄█░░░░██████▄▄"   
echo ${BLUE}"▓▓▓▓▓▓█░░░░░░░░░░░░░░█"
echo ${BLUE}"▓▓▓▓▓▓█░░░░░░░░░░░░░░░█"
echo ${BLUE}"▓▓▓▓▓▓█░░░░░░░░░░░░░░░█"
echo ${BLUE}"▓▓▓▓▓▓█░░░░░░░░░░░░░░░█"
echo ${BLUE}"▓▓▓▓▓▓█░░░░░░░░░░░░░░░█"
echo ${BLUE}"▓▓▓▓▓▓█████░░░░░░░░░░█"
echo ${BLUE}"██████▀    ▀▀██████▀"
echo''
echo''
echo ${RED}"############## SHORTEN FILE NAMES WHERE PATH IS LONGER TO X CHARACTERS ##############"
echo''
echo ${BLUE}Hello ! I will count all the files having a pathname lenght over a certain amount you will give me
echo''
echo • Under what folder do you want to start the count ? Note this will be done recursively${WHITE}
echo''
read -r -e -p "Folder:" folder
echo''

#echo $folder

echo ${BLUE}• Over what character lenght should i display files under this folder ?${WHITE} 
read maxlenght


#Count and sort by max lenght all the files under Dropbox.
echo''
echo ${BLUE}Running count for paths files over $maxlenght characters...

find "$folder" | awk 'length($0)>'"$maxlenght"'{print $0}' | sort -rn | less > .testcounter.txt
howmany=$(wc -l < .testcounter.txt)
echo''
sleep 3


#Displaying Results
echo ${RED}**********RESULTS***********
echo • I can see $howmany files with more than $maxlenght caracters in $folder and its subfolders
maxword=$(awk '{print $0;}' .testcounter.txt|wc -c)
sleep 2


#Few stats...
echo • The longest file path has ${WHITE}$maxword ${RED}characters
diff=$(($maxword-$maxlenght))
sleep 2
echo • You need to shorten the filename by ${WHITE}$diff ${RED}characters
echo''
sleep 2


#Illegal characters removal except space before and after basename
#echo •Oh btw i removed all the illegal characters possible '" # % * : < > ? / \ |' in all the files and folders i went throught :")"
#find /Users/vinh/Desktop/TEST/ | rename 's/[?<>\\:*#|\%"]//g' -v * > .illegal.txt 2>&1


#Install brew then install the tag utility
echo ${BLUE}• I will now install some stuff to tag all those files, this will take few seconds, be patient !
echo''
echo ${HIGHLIGHT}Strike any key to start the installation${NC}
read go

if [ -f "/usr/local/bin/brew" ];
	then
   		echo "Nothing to install !"
	else
   		echo "Entering the Matrix...">&2
   		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &&brew install tag
fi

echo ${HIGHLIGHT}We"'"re done ! Strike return to continue
read go


#Tagging those files now
echo ${BLUE}• Tagging all the affected files with tag name '"ODH"'... 
echo ''
tr '\n' '\0' < .testcounter.txt | xargs -0 tag -a ODH
sleep 1
echo • Tagging done ! 
sleep 1
echo''
echo • You will now need to create a smart folder to display them. Sorry i can"'"t do that for you...
sleep 2
echo ''
echo '*************************************************'
echo '                   Good bye !!!                  '    
echo '*************************************************'
echo ''
echo ${HIGHLIGHT}Strike return to exit${NC}
read go
clear
