#!/bin/sh

#A weird bug is affecting Mac Os X for years when it's binded to an Active Directory domain : when the laptop has been locked after a sleep mode, a failure in the opendirectoryd daemon may stop all connections with AD and refuse the password authentication. There are many workarounds but they all do the same at the end, kill the opendirectoryd process which restarts automatically and reenable the connection. This script uses sleepwatcher and launch a script that kills/restart the daemon each time the laptop goes off from sleep mode. This avoid to use a dirty cronjob or to activate/use the switch user function in Mac Os.


#FUNCTIONS AND VARIABLES DECLARATIONS ########################################################################################################

#We'll use those ones to evaluate if sleepwatcher is loaded and running
PROCESS=$(pgrep sleepwatcher)
MODULE=$(launchctl list | grep -i sleepwatcher)

#Colors
function rainbow_colors()
{
RED='\033[0;31m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
HIGHLIGHT='\033[37;7m'
NC='\033[0m'
}

#Install rc.killopendirectory
function install_killopendirectoryd()
{
echo''	
echo ${RED}"Creating the launch script as /etc/rc.killiopendirectoryd"
printf '#!/bin/sh\nkillall -9 opendirectoryd\n' > ~/killopendirectoryd.temp
chmod +x ~/killopendirectoryd.temp
sudo mv ~/killopendirectoryd.temp /etc/rc.killopendirectoryd
rm -rf ~/killopendirectoryd.temp
echo''
echo "Creating the launchdaemon plist for Sleepwatcher in /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopenirectoryd.plist"
printf '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n<plist version="1.0">\n<dict>\n\t<key>Label</key>\n\t<string>de.bernhard-baehr.sleepwatcher</string>\n\t<key>ProgramArguments</key>\n\t<array>\n\t\t<string>/usr/local/sbin/sleepwatcher</string>\n\t\t<string>-V</string>\n\t\t<string>-W /etc/rc.killopendirectoryd</string>\n\t</array>\n\t<key>RunAtLoad</key>\n\t<true/>\n\t<key>KeepAlive</key>\n\t<true/>\n</dict>\n</plist>\n'> ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
sudo chown root ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
sudo chgrp wheel ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
sudo mv ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist /Library/LaunchDaemons/
rm -rf ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
echo''
echo "Loading daemon..."
sudo launchctl load /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
sleep 2
echo ''
echo "Sleepwatcher is set and ready to kill opendirectoryd after each wake"
echo''
echo ${BLUE}"Closing script, hit enter to proceed"${NC}
read bye
clear
}

#Install Sleepwatcher
function install_sleepwatcher()
{
echo''
echo ${RED}"Installing sleepwatcher..."
brew install sleepwatcher
sudo chmod 777 /usr/local/share/man/man8
chmod 777 /usr/local/sbin/
brew link sleepwatcher
chmod 755 /usr/local/share/man/man8
chmod 755 /usr/local/sbin/
echo''
echo "Sleepwatcher has been installed successfully"
echo''
echo ${BLUE}"Strike any key to continue"${NC}
read go
}

#Install Homebrew
function install_homebrew()
{
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo''
echo ${RED}"Homebrew has been installed successfully"
}

#sudo rights
function sudo_ask()
{
echo ${BLUE} "I need your password to perform few actions"
su -
echo''
}

#Is everything is working now ?
function is_everything_alright_now()
{
if [ "${PROCESS}" -gt 0 ] || [ -f "/etc/rc.killopendirectoryd" ] || [ -f "/Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist" ] || [ -z "$MODULE"] 
	then
		echo''
		echo ${RED}"Sleepwatcher is installed and running killopendirectoryd - We're all good"${NC}
		echo''
		read bye
		clear
	else
		echo''
		echo ${RED}"Something went wrong, we are unable to install the script on your machine. Meet your nearest IT to reimage your laptop"${NC}
		echo ${BLUE}"Closing script, hit enter to proceed"${NC}
		read bye
		clear
fi
}

#Uninstaller
function uninstall_sleepwatcher()
{
echo ${BLUE}"Are you sure you want to uninstall sleepwatcher and all the dependent files ?"
read yn2
if [[ "$yn2" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		brew uninstall sleepwatcher
		rm -rf /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
		rm -rf /etc/rc.d/killopendirectoryd		
		echo "Sleepwatcher has been successfully uninstalled, press a key to exit"${NC}
		read bye
		clear
	else
		echo "Exiting without changes, press a key to quit"${NC}
		read bye
		clear
fi	

}

#END OF FUNCTIONS AND VARIABLES DECLARATIONS ##############################@#####################################################





#START SCRIPT ####################################################################################################################

clear
rainbow_colors
#osascript -e "tell application \"Terminal\" to set background color of window 1 to {0.2549019753932953", "0.4117647111415863", "0.6666666865348816"}


echo ${BLUE}"#####################################"
echo "Sleepwatcher Installer"
echo "#####################################"
echo''
echo "Do you want to install / uninstall sleepwatcher ? [1-Install / 2-Uninstall]"
read iu

case $iu in
1)

echo''
echo ${BLUE}"This script will install sleepwatcher through homebrew and set it to kill opendirectoryd after each wake up state. This will create launchdaemons files to do so -  Do you want to proceed ? [y/n]"${NC}
read -r yn

#Sorry for the Pyramid, i love ancient Egypt

if [[ "$yn" =~ ^([yY][eE][sS]|[yY])+$ ]]
        then
		sudo_ask 
		echo''
		echo ${RED}"Let's see if you already installed the killopendirectory daemon..."
		sleep 2                
                if [ -f "/etc/rc.killopendirectoryd" ] && [ -f "/Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist" ]
        	        then
				echo''
				echo "killopendirectoryd is already present"
				echo''
				sleep 2
				echo "Lets see if sleepwatcher is installed and running it..."
					sleep 2
					if [ -f "/usr/local/sbin/sleepwatcher" ] && [ "${PROCESS}" -gt 0 ]
						then
							is_everything_is_alright_now			
						else
							echo''
							echo "Sleepwatcher is not installed or not running, let's reinstall it properly"
							sleep 2
							if [ ! -f "/usr/local/bin/brew" ]
								then
									echo''
									echo "Homebrew is needed to install sleepwatcher, installing it now"
									install_homebrew
									install_sleepwatcher
									launchctl load /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
									is_everything_is_alright_now
								else
									install_sleepwatcher
									launchctl load /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
									is_everything_is_alright_now
					
							fi
					fi		
		else
				echo''
				echo "Script not present - veryfing if sleepwatcher is installed"
				sleep 2
				if [ -f "/usr/local/sbin/sleepwatcher" ] && [ "${PROCESS}" -gt 0 ]					
					then
						echo ''
						echo "Sleepwatcher is installed"
						install_killopendirectoryd
					else
						echo''
						echo "Sleepwatcher is not installed or running properly, let's reinstall it"
						sleep 2
						if [ ! -f "/usr/local/bin/brew" ]
							then
								echo''
								echo "Homebrew is needed to install sleepwatcher, installing it now"
								echo''
								install_homebrew
								install_sleepwatcher
								install_killopendirectoryd
								is_everything_is_alright_now
							else
								install_sleepwatcher
								install_killopendirectoryd
								is_everything_is_alright_now
						fi
				fi
				
		

		fi
	else
		echo ${RED}"Bye"
		echo ${BLUE}"Hit any key to exit" ${NC}
		read bye
		clear
fi;;
2) uninstall_sleepwatcher;;

*) echo ${WHITE}"Wrong input exiting script";;
esac


