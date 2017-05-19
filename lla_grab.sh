#!/bin/bash
#Refresh LLA Datacenter welcome/instructions powerpoint presentation in the reception lobby. V1 - Vinh Francis Guyait <vinh@fb.com>

prezpath=/Users/$USER/Desktop/presentation

set -x

#Check if the presentation folder exists, creates it, download the pps
if [ -d $HOME/Desktop/presentation ]
	then
		curl "https://swift.thefacebook.com/v1/LDAP_nicklasm/LLA_PRES/lulz.pptx?temp_url_sig=082c177ce575e0cfeb6bb9cbde1c3e9e11c56829&temp_url_expires=1495184333" -o "$prezpath/blubb.pps"
	else
		mkdir $prezpath
		curl "https://swift.thefacebook.com/v1/LDAP_nicklasm/LLA_PRES/lulz.pptx?temp_url_sig=082c177ce575e0cfeb6bb9cbde1c3e9e11c56829&temp_url_expires=1495184333" -o "$prezpath/blubb.pps"
fi

#kill powerpoint
pkill "PowerPoint"

#refresh presentation for sure

if [ -f $prezpath/presentation.pps ]
	then
		if [$prezpath/presentation.pps -ot $prezpath/blubb.pps]
			then
  				rm -rf $prezpath/presentation.pps
  				mv $prezpath/blubb.pps ./presentation.pps
	
			else
				rm -rf $prezpath/blubb.pps
		fi
	else
		mv $prezpath/blubb.pps ./presentation.pps
fi

open presentation.pps

