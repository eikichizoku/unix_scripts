#!/bin/sh
#sleepwatcher.sh installs homebrew, installs sleepwatcher then creates the launching daemons to catch and kill opendirectoryd each time the laptop goes to sleep
#script based on Mark Govea phabricator (https://phabricator.intern.facebook.com/P56157790)
#v1.0 Vinh Francis Guyait <vinh@fb.com>
#
#

#Silly variables declarations
#let's add some colors because color is life
RED='\033[0;31m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
HIGHLIGHT='\033[37;7m'
NC='\033[0m'


echo ${WHITE} "This script will install sleepwatcher and create files to launch it as a startup deamon. this will address the issue related to opendirectoryd with mac os x laptops unable to unlock after sleep state (t7225148) -  Do you want to proceed ? [y/n]"${NC}

read -r yn

if [[ "$yn" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		echo  ${WHITE} "I need your password to perform all actions"
		su -

		if [ -f "/usr/local/bin/brew" ];
			then
			
				if [ -f "/usr/local/sbin/sleepwatcher" ]
					then
						echo  ${WHITE} "Nothing to install, brew and sleepwatcher are already installed"
					else
						
						echo  ${WHITE} "Installing sleepwatcher"
						brew install sleepwatcher >> /dev/null
						sudo chmod 777 /usr/local/share/man/man8
						chmod 777 /usr/local/sbin/
						brew link sleepwatcher
						chmod 755 /usr/local/share/man/man8
						chmod 755 /usr/local/sbin/
						echo "Sleepwatcher has been installed"
						echo "Strike any key to continue"
						read go			
				fi
		fi
	else
		echo  ${WHITE} "Goodbye !"
		echo "Strike any key to quit" ${NC}
		read go
		clear
fi
		


	#Creating the rc file
#	printf '#!/bin/sh\nkillall -9 opendirectoryd\n' > ~/killopendirectoryd.temp
#	chmod +x ~/killopendirectoryd.temp
#	sudo mv ~/killopendirectoryd.temp /etc/rc.killopendirectoryd

	# Creating ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist from https://phabricator.fb.com/P56157785
#	printf '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n<plist version="1.0">\n<dict>\n\t<key>Label</key>\n\t<string>de.bernhard-baehr.sleepwatcher</string>\n\t<key>ProgramArguments</key>\n\t<array>\n\t\t<string>/usr/local/sbin/sleepwatcher</string>\n\t\t<string>-V</string>\n\t\t<string>-W /etc/rc.killopendirectoryd</string>\n\t</array>\n\t<key>RunAtLoad</key>\n\t<true/>\n\t<key>KeepAlive</key>\n\t<true/>\n</dict>\n</plist>\n'> ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
#	sudo mv ~/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist /Library/LaunchDaemons/
	
	#Loading the daemon
#	launchctl load /Library/LaunchDaemons/de.bernhard-baehr.sleepwatcher-killopendirectoryd.plist
#echo "OK"
#else

#	echo "Closing script, hit enter to proceed"
#	read key
#	killall Terminal

#fi


