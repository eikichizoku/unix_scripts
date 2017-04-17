#!/bin/sh

#sleepwatcher.sh installs homebrew, installs sleepwatcher then creates the launching daemons to catch and kill opendirectoryd each time the laptop goes out from sleep mode
#There is a bug on how mac os bind to Active Directory using the native opendirectoryd daemon making the password uneffective when the computer goes out of sleep mode. There is no open case registered at Apple for this issue, as far as i know.

#v1.0 Vinh Francis Guyait


#Silly variables declarations
#let's add some colors because color is life
RED='\033[0;31m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
HIGHLIGHT='\033[37;7m'
NC='\033[0m'

echo ${WHITE} "This script will install sleepwatcher through homebrew and set it to kill opendirectoryd after each wake up state. It will create launchdaemons files to do so -  Do you want to proceed ? [y/n]"${NC}

read -r yn

if [[ "$yn" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		echo  ${WHITE} "I need your password to perform few actions"
		su -
		echo''
		echo Installing homebrew and sleepwatcher...
		echo''
	
		if [ -f "/usr/local/bin/brew" ];
			then
			
				if [ -f "/usr/local/sbin/sleepwatcher" ]
					then
						echo "Nothing to install, brew and sleepwatcher are already installed"
					else
						
						echo "Installing sleepwatcher"
						echo''
						brew install sleepwatcher >> /dev/null
						sudo chmod 777 /usr/local/share/man/man8
						chmod 777 /usr/local/sbin/
						brew link sleepwatcher
						chmod 755 /usr/local/share/man/man8
						chmod 755 /usr/local/sbin/
						echo "Sleepwatcher has been installed successfully"
						echo "Strike any key to continue"
						read go			
				fi
			else
				/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
				echo''
				echo "Homebrew has been installed successfully"
				echo''
				
				if [ -f "/usr/local/sbin/sleepwatcher" ]
                                        then
                                                echo "Luckily sleepwatcher is already installed :)"
                                        else
    
                                                echo  ${WHITE} "Installing sleepwatcher..."
						echo''
                                                brew install sleepwatcher >> /dev/null
                                                sudo chmod 777 /usr/local/share/man/man8
                                                chmod 777 /usr/local/sbin/
                                                brew link sleepwatcher
                                                chmod 755 /usr/local/share/man/man8
                                                chmod 755 /usr/local/sbin/
                                                echo "Sleepwatcher has been installed sucessfully"
                                                echo "Strike any key to continue"
                                                read go   

				fi	
		fi
#Creating the rc file
			echo''
			echo "Creating the launch script as /etc/rc.killiopendirectoryd" 
			printf '#!/bin/sh\nkillall -9 opendirectoryd\n' > ~/killopendirectoryd.temp
			chmod +x ~/killopendirectoryd.temp
			sudo mv ~/killopendirectoryd.temp /etc/rc.killopendirectoryd

# Creating ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist from https://phabricator.fb.com/P56157785
			echo''
			echo "Creating the launchdaemon plist for Sleepwatcher in /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopenirectoryd.plist"
			printf '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n<plist version="1.0">\n<dict>\n\t<key>Label</key>\n\t<string>de.bernhard-baehr.sleepwatcher</string>\n\t<key>ProgramArguments</key>\n\t<array>\n\t\t<string>/usr/local/sbin/sleepwatcher</string>\n\t\t<string>-V</string>\n\t\t<string>-W /etc/rc.killopendirectoryd</string>\n\t</array>\n\t<key>RunAtLoad</key>\n\t<true/>\n\t<key>KeepAlive</key>\n\t<true/>\n</dict>\n</plist>\n'> ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist

			sudo mv ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist /Library/LaunchDaemons/
	
#Loading the daemon
			echo''
			echo "Loading the daemon using the plist..."
			launchctl load /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
			sleep 2
			echo ''
			echo "Slepwatcher is set and ready to kill opendirectoryd after each wake"

			echo "Closing script, hit enter to proceed"
			read key
			clear
	
	
	else
		echo  ${WHITE} "Goodbye !"
		echo "Strike any key to quit" ${NC}
		read go
		clear
fi
	

