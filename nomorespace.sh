#!/bin/sh
#This a simple script that run recursively over the current user $HOME directory or a provided path to list the heaviest folder and open it in Finder for human investigation.



#Silly variables declarations
#let's add some colors because color is life
RED='\033[0;31m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
HIGHLIGHT='\033[37;7m'
NC='\033[0m'

echo ${BLUE} 'Do you want me to check the filesize of each folder under your account ? Most of the issues come from here usually'
read -r yn

if [[ "$yn" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then	
		echo''
		echo ${WHITE}"Enumerating each folder size under $USER's home directory..."
		echo ''
		bighome=`du -sh "$HOME"/* | grep '[0-9]G\>' | sort -rnk1 | LC_ALL=C sed -e "s,[^/]*\(/.*\),'\1',;q"`
		bighomesize=`du -sh $HOME/* | grep '[0-9]G\>' | sort -k 1rn | head -1 | awk '{ print $1 }'`
		echo 'The folder '${RED}''$bighome' '${WHITE}'is the biggest one in your account home directory with a size of '${RED}''$bighomesize''${WHITE} ${NC}
		echo''

	else

		read -ep "Folder:" WHERE
	
			case ${WHERE} in

  				*\ * )
					echo HasSpace
					bigwherespace=`du -sh "$WHERE"/* | grep '[0-9]G\>' | sort -rnk1 | LC_ALL=C sed -e "s,[^/]*\(/.*\),'\1',;q"`
					bigwherespacesize=`du -sh "$WHERE"/*|grep '[0-9]G\>'|sort -k 1rn |head -1|awk '{ print $1 }'`
					echo $bigwherespace		
					echo $bigwherespacesize
					;;  				
				* )
					echo NoSpace
					bigwhere=`du -sh $WHERE/* | grep '[0-9]G\>' | sort -rnk1 | LC_ALL=C sed -e "s,[^/]*\(/.*\),'\1',;q"`
					bigwheresize=`du -sh $WHERE/*|grep '[0-9]G\>'|sort -k 1rn |head -1|awk '{ print $1 }'`
					echo $bigwhere
					echo $bigwheresize	
				;;
			esac

fi
