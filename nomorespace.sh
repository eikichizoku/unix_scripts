#!/bin/sh
#This a simple script that run recursively over the current user $HOME directory or a provided path to list the heaviest folder and open it in Finder for human investigation.

#Silly variables declarations
#let's add some colors because color is life
RED='\033[0;31m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
HIGHLIGHT='\033[37;7m'
NC='\033[0m'

echo ${BLUE}'                  o$$'
echo ${BLUE}'             $$    $"o$"  oooo'
echo ${BLUE}'            o"$  $"  o$o$" $"'
echo ${BLUE}'            $ "$$    "$   $oooooo'
echo ${BLUE}'       o   $   "           ooo'
echo ${BLUE}'        o  "  "    oo""o    "o"""'
echo ${BLUE}'   $   o                " "o"$$oo'
echo ${BLUE}'   "$                   $  o  $ "'
echo ${BLUE}' "o"$                  "$ o"$o o'
echo ${BLUE}' ooo                   " "   $ "'
echo ${BLUE}' """o    "                  $" $      https://github.com/eikichizoku !'
echo ${BLUE}'  """$oo          oo$$o$ooooo  o"'
echo ${BLUE}'   $""""        $$$$$$$$$$$$$$ o$'
echo ${BLUE}'  "$          o$$" """$$$$$$$" $'
echo ${BLUE}'   "ooo  o    $$o     $$$$$$" $'
echo ${BLUE}'      """ $o   $$$ooo$$$$$" o"'
echo ${BLUE}'          o$$    " """"ooo$"o ooo'
echo ${BLUE}'         o"o"""ooo$o"$$"$$oooo   ""o'
echo ${BLUE}'       o$$o" " o" $""$$o"  o"" o   $'
echo ${BLUE}'      $$ o" $ o" o  $""" o  """" oo"'
echo ${BLUE}'     $oo  $"$o$oo  $" ""oo$" o$ $'
echo ${BLUE}'    $oo " " o o $"$     "" "   "$" "o'
echo ${BLUE}'   o"  """ "    $       """"o  o" "$'
echo ${BLUE}'   $"" " o" " """            "o $$"'
echo ${BLUE}'   $$ooooo o   $o              "'
echo ${BLUE}'  o$$$$$$$$$$$$$oo'
echo ${BLUE}' o$$$$$$$$$$$$$"$""""oo'
echo ${BLUE}'$o "$$$o$$ """""o     o$'
echo ${BLUE}' "$ooo "        $ooo$""'
echo ${BLUE}'     """"$ $o$"""'
echo''


echo ${BLUE} 'Do you want me to check the filesize of each folder under your account ? Most of the issues come from here usually'
read -r yn

if [[ "$yn" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		#echo "I will need your password to perform few actions"
		#sudo -s
		echo''
		echo ${WHITE}"Enumerating each folder size under $USER's home directory..."
		echo ''
		bighome=`du -sh "$HOME"/* | grep '[0-9]G\>' | sort -rnk1 | LC_ALL=C sed -e "s,[^/]*\(/.*\),'\1',;q"`
		bighomesize=`du -sh $HOME/* | grep '[0-9]G\>' | sort -k 1rn | head -1 | awk '{ print $1 }'`
		echo 'The folder '${RED}''$bighome' '${WHITE}'is the biggest one in your account home directory with a size of '${RED}''$bighomesize''${WHITE} ${NC}
		echo''

	else

		if [[ "$yn" =~ ^([nN][oO]|[nN])+$ ]]
			then
				read -ep "Folder:" WHERE
				#echo "I will need your password to perform few actions"
				#sudo -s
		
				case ${WHERE} in
		
  					*\ * )
						bigwherespace=`du -sh "$WHERE"/* | grep '[0-9]G\>' | sort -rnk1 | LC_ALL=C sed -e "s,[^/]*\(/.*\),'\1',;q"`
						bigwherespacesize=`du -sh "$WHERE"/*|grep '[0-9]G\>'|sort -k 1rn |head -1|awk '{ print $1 }'`
					
							if [ -z "$bigwherespace" ]
								then
									echo ${WHITE} "Nothing over 1Gb in ${RED}$WHERE ${WHITE}- probably need to look somewhere else !"
								else
									echo ${WHITE}"The biggest file / folder is ${RED}$bigwherespace ${WHITE}with a size of ${RED}$bigwherespacesize${WHITE}"
							fi
					;;  				
					* )
						bigwhere=`du -sh $WHERE/* | grep '[0-9]G\>' | sort -rnk1 | LC_ALL=C sed -e "s,[^/]*\(/.*\),'\1',;q"`
						bigwheresize=`du -sh $WHERE/*|grep '[0-9]G\>'|sort -k 1rn |head -1|awk '{ print $1 }'`

							if [ -z "$bigwhere" ]
								then
									echo "${WHITE}Nothing over 1Gb here - probably need to look somewhere else !"
								else
									echo ${WHITE}"The biggest file / folder is ${RED}$bigwhere ${WHITE}with a size of ${RED}$bigwheresize${WHITE} ${NC}"
							fi
					;;
				esac

			else
				echo "Answer Yes or No please i'm quitting the script."
		fi							
fi

