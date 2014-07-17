#!/bin/bash
# Author: tckb<chandra.tungathurthi>
# Ping notification using terminal- notifier
rm $HOME/.np_click $HOME/.np_exit 2>/dev/null
if [ -z ${1} ]
	then
		freq=5 #check every 5 seconds
	else
		freq=$1
fi

echo checking freq $freq seconds

#check if notifier is installed
echo ">Checking for terminal-notifier ..."
hash terminal-notifier >& /dev/null
if [ $? -ne 0 ]
	then
		echo ">Installing notifier..."
		sudo gem install terminal-notifier
fi

echo ">Testing internet connection...."

while [ 1 ]
	do
		if [[ -e $HOME/.np_exit ]]; then
			echo ">NP exit detected! Terminiating notifier!"
			rm $HOME/.np_click
			exit 0
		fi


	if [[ -e $HOME/.np_click ]]; then
		echo ">User click detected!"	
		rm $HOME/.np_click

		if [ $freq -gt 10 ]; then
				echo ">Probably too many notifcations -- user annoyed! terminating :P"
				terminal-notifier -message "Too many notifications, terminating ping notifier!. Re-run to start notifier" -title "Ping notifier" 2>/dev/null				
				exit 0

			else
				echo ">Increasing checking freq..."
				freq=`expr $freq + 5`
				echo ">Update frequency: $freq"
		fi
	fi	
	

	ping -c 5 google.com >& /dev/null
	if [ $? -ne 0 ]
	then
		echo ">Your connection is dead!! muwahahahah -- okay, notifying"
		terminal-notifier -message "Internet connection lost @ `date`" -title "Ping notifier" -execute "touch $HOME/.np_click" 2>/dev/null
	else
		echo ">It's alive!"
	fi

	sleep $freq


done
