#!/bin/sh
#v1.0 (26 Feb 2017) Script by Vinh Francis Guyait. Determine for files their whole path character lenght, sort by longest, tag them in Mac Os.
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
echo ${BLUE}"           █░░█           v1.0 Scripted by Vinh Francis Guyait"
echo ${BLUE}"           █░░█"
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
echo ${RED}"############## ILLEGAL CHARACTERS REMOVAL FROM BASENAME FILES ##############"
echo''
echo ${BLUE}Hello ! Let"'"s remove all the characters you want from your files '!' 
echo''
echo • Under what folder do you want to work ? Note this will be done recursively${WHITE}
echo''
read -r -e -p "Folder:" folder
echo''

echo $folder

echo ${BLUE} • Please type all the characters you want to get rid of in your files names${WHITE} 

export illegalchars
read illegalchars
echo''

echo $illegalchars

#Install brew then install the tag utility
echo ${BLUE}• I will now install some stuff to rename all those files, this will take few seconds, be patient !
echo''
echo ${HIGHLIGHT}Strike any key to start the installation${NC}
read go

if [ -f "/usr/local/bin/rename" ];
        then
                echo "Nothing to install !"
		echo''
        else
                echo "Entering the Matrix...">&2
                /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &&brew install rename
fi

echo''
echo ${HIGHLIGHT}We"'"re done ! Strike return to continue
read go
echo''

#Illegal characters removal except space before and after basename
echo Removing now characters $illegalchars  in all the files and folders under $folder...
cd $folder
rename 's/'$illegalchars'//g' -v *
sleep 2
#'s/[?<>\\:*#|\%"]//g'



echo • Renaming done ! 
sleep 1
echo ''
echo '*************************************************'
echo '                   Good bye !!!                  '    
echo '*************************************************'
echo ''
echo ${HIGHLIGHT}Strike return to exit${NC}
read go
clear
