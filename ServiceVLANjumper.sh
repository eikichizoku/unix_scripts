#!/bin/sh

#RemoteVNC Seervice VLAN stuff like Wayfinder and SOC mac minis

echo "What is your adminusername ?"
read adminuser

echo what host do you want to remote control ?
read host

echo "What is the account to use on this remote host ?"
read localuser

echo "Trying to reach this host"

ping -q -c5 $host.dhcp.thefacebook.com > /dev/null
 
if [ $? -eq 0 ]
	then
		echo "I found $host"

	else
		echo "Can't find any host responding to pings at $host"
fi

echo "What jumphost do you want to connect to ?"
read jumphost

echo "Trying to reach this host"

ping -q -c5 $jumphost > /dev/null
 
if [ $? -eq 0 ]
	then
		echo "Jumphost $jumphost reacheable"
	else 
		echo "Jumphost $jumphost not reacheable"

fi

echo "Connecting to $jumphost"

set -x

ssh -L 5901:localhost:5901 $adminuser@$jumphost "ssh -L 5901:localhost:5900 $localuser@$host.dhcp.thefacebook.com"

open vnc://localhost:5901

