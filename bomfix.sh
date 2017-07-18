#!/bin/bash
#QuickFix by Vinh Francis Guyait <vinh@fb.com>

echo''
echo 'This script will fix the script.sh file inside the bomgar app'
echo''
echo "Please input user's password"
su -
echo''
echo "Doing some magic..."
echo''

if [ -d /Applications/IT\ Technical\ Support.app ]
	then

		echo -e '#!/bin/bash\n/Library/CPE/lib/flib/scripts/pyexec /Library/CPE/lib/flib/scripts/bomgar_launcher.py &' > /tmp/shortcut.sh

		sudo mv /Applications/IT\ Technical\ Support.app/Contents/MacOS/shortcut.sh /Applications/IT\ Technical\ Support.app/Contents/MacOS/shortcut.OLD

		sudo cp /tmp/shortcut.sh /Applications/IT\ Technical\ Support.app/Contents/MacOS/shortcut.sh
		
		sudo chmod +x /Applications/IT\ Technical\ Support.app/Contents/MacOS/shortcut.sh

		echo "You're good to go, try to connect to the team now !"

else

		echo "Seems you need to reinstall bomgar... App is not seen as installed"

fi
