#!/bin/sh

#A weird bug is affecting Mac Os X when it's binded to an Active Directory domain : when locked after a sleep mode, a failure from the opendirectoryd daemon stop all connections with AD and block the password authentication. There are many workarounds but they all do the same at the end, kill the opendirectoryd process which restarts automatically and reenable the connection. This script uses sleepwatcher and launch a script that kills/restart the daemon each time the laptop goes off from sleep mode.


#Functions

#Colors
function rainbow_colors()
{
RED='\033[0;31m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
HIGHLIGHT='\033[37;7m'
NC='\033[0m'
}

#Calvin
function calvin_hobbes()
{
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
}

#Install rc.killopendirectory
function install_killopendirectoryd()
{
echo''	
echo "Creating the launch script as /etc/rc.killiopendirectoryd"
printf '#!/bin/sh\nkillall -9 opendirectoryd\n' > ~/killopendirectoryd.temp
chmod +x ~/killopendirectoryd.temp
sudo mv ~/killopendirectoryd.temp /etc/rc.killopendirectoryd
echo''
echo "Creating the launchdaemon plist for Sleepwatcher in /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopenirectoryd.plist"
printf '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n<plist version="1.0">\n<dict>\n\t<key>Label</key>\n\t<string>de.bernhard-baehr.sleepwatcher</string>\n\t<key>ProgramArguments</key>\n\t<array>\n\t\t<string>/usr/local/sbin/sleepwatcher</string>\n\t\t<string>-V</string>\n\t\t<string>-W /etc/rc.killopendirectoryd</string>\n\t</array>\n\t<key>RunAtLoad</key>\n\t<true/>\n\t<key>KeepAlive</key>\n\t<true/>\n</dict>\n</plist>\n'> ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
sudo mv ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist /Library/LaunchDaemons/
echo''
echo "Loading the daemon using the plist..."
launchctl load /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
sleep 2
echo ''
echo "Slepwatcher is set and ready to kill opendirectoryd after each wake"
echo "Closing script, hit enter to proceed"
read key
clear
}

#Install Sleepwatcher
function install_sleepwatcher()
{
echo''
echo "Installing sleepwatcher..."
echo''
brew install sleepwatcher
sudo chmod 777 /usr/local/share/man/man8
chmod 777 /usr/local/sbin/
brew link sleepwatcher
chmod 755 /usr/local/share/man/man8
chmod 755 /usr/local/sbin/
echo "Sleepwatcher has been installed successfully"
echo "Strike any key to continue"
read go
}

#Install Homebrew
function install_homebrew()
{
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo''
echo "Homebrew has been installed successfully"
echo''
}

#sudo rights
function sudo_ask()
{
echo  ${WHITE} "I need your password to perform few actions"
su -
echo''
}

#start script
calvin_hobbes
rainbow_colors

echo ${WHITE} "This script will install sleepwatcher through homebrew and set it to kill opendirectoryd after each wake up state. It will create launchdaemons files to do so -  Do you want to proceed ? [y/n]"${NC}
read -r yn



##set -x
if [[ "$yn" =~ ^([yY][eE][sS]|[yY])+$ ]]
        then
		sudo_ask		
#If the script killopendirectoryd is installed, verify if sleepwatcher is here and running, if not, check if homebrew is here and install if needed, then install sleepwatcher
		echo''
		echo "Lets see if you already installed the killopendirectory daemon..."
                
                if [ -f "/etc/rc.killopendirectoryd" ];
        	        then
				echo''
				echo ${RED}"killopendirectoryd is already present"
				echo''
				echo ${WHITE}"Lets see if sleepwatcher is installed and running it..."
					if [ -f "/usr/local/sbin/sleepwatcher" ]
						then
							echo''
							echo ${RED}"sleepwatcher is installed and running killopendirectoryd - We're all good"
							echo''
							echo "Hit any key to exit" ${NC}
							read bye
							clear
									
						else
							echo''
							echo ${RED}"sleepwatcher is not installed"
							if [ ! -f "/usr/local/bin/brew" ]
								then
									echo "Homebrew is needed to install sleepwatcher, installing it now"
									install_homebrew
									install_sleepwatcher
									echo ${RED}"sleepwatcher is installed and running killopendirectoryd - We're all good"
									echo''
						
								else
									install_sleepwatcher
									echo ${RED}"sleepwatcher is installed and running killopendirectoryd - We're all good"
									echo''
					
							fi
					fi		
#Script killopendirectory not here, verify if sleepwatcher is installed, if yes, create the script and create/install the script, if not, install homebrew if needed, then install sleeptwatcher, then the script.
			else
				echo "Script not present - veryfing if sleepwatcher is installed"
				if [ -f "/usr/local/sbin/sleepwatcher" ]					
					then
						echo "sleepwatcher is installed"
						install_killopendirectoryd
					else
						echo "sleepwatcher is not installed"
						if [ ! -f "/usr/local/bin/brew" ]
							then
								echo "Homebrew is needed to install sleepwatcher, installing it now"
								install_homebrew
								install_sleepwatcher
								install_killopendirectoryd
							else
								install_sleepwatcher
								install_killopendirectoryd
						fi
				fi
				
				echo ${RED}"sleepwatcher is installed and running killopendirectoryd - We're all good"
				echo''


		fi
	else
		echo ${WHITE}"Bye"
		echo "Hit any key  to exit" ${NC}
		read bye
		clear
fi

