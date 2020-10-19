#!/bin/bash
# utilitymenu.sh - A sample shell script to display menus on screen
# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$

# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$


# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM


# Purpose - display output using msgbox 
#  $1 -> set msgbox height
#  $2 -> set msgbox width
#  $3 -> set msgbox title

function display_output(){
	local h=${1-10}			# box height default 10
	local w=${2-41} 		# box width default 41
	local t=${3-Output} 	# box title 
	dialog --backtitle "Coursework 1" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}
}

# Purpose - display current system date & time

function show_date(){
	echo "Today is $(date) @ $(hostname -f)." >$OUTPUT
    display_output 6 60 "Date and Time"
}

# Purpose - display a calendar

function show_calendar(){
	cal=$(zenity --calendar --title="Calendar" --text="Select a date to add new task" --height=500 --width=400)
    date=${cal:0:2}${cal:3:2}${cal:6:2}
    ans=$?
    txt=".txt"
    fname=${date}${txt}
    touch $fname
    if [ $ans -eq 0 ]
    then
    newf=$(zenity --text-info --filename=$fname --editable --width=500 --height=500)
ans=$?  
  if [ $ans -eq 0 ]
then 
    echo $newf > $fname
zenity --info --text="File saved" --timeout=3 --width=300
fi    
fi
 
}


# Purpose- delete a file slected by the user

function delete_file(){
    file=$(zenity --file-selection)
    zenity --question --title="Delete File" --text="Are you sure you want to delete the file?" --width=400
    x=$?

    if [ $x -eq 0 ]
    then 
    rm $file
    fi
}
   exit(){
break
}

# set infinite loop

while true
do

### display main menu ###
dialog --clear  --help-button --backtitle "Coursework 1" \
--title " Main Menu " \
--menu " Choose one of the following options:-" 15 50 4 \
Date/time "Display date and time" \
Calendar "Display calendar" \
Delete "Select a file to delete" \
Exit "Exit to the shell" 2>"${INPUT}"

menuitem=$(<"${INPUT}")


# make decision 
case $menuitem in
	Date/time) show_date;;
	Calendar) show_calendar;;
	Delete) delete_file;;
	Exit) break;;
esac

done

# if temp files found, delete them
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
