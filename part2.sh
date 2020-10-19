#!/bin/bash

# It defines the dialogue box exit status codes
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

# function to display information according to selection
show_info() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$info" 0 0
}

# Display the menu item with a while loop
while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Computer System Information" \
    --title "[Main Menu]" \
    --clear \
    --cancel-label "Exit" \
    --menu "\nPlease select:" $HEIGHT $WIDTH 4 \
    "1" "Display OS Type" \
    "2" "Display CPU Info" \
    "3" "Display Memory Info" \
    "4" "Display HardDisk Info" \
    "5" "Display File System" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  
  # Case to display if program exit successfully or aborted the program
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program exit successfully."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  
  # case selection to display info as per the choice selected by user
  case $selection in
    0 )
      clear
      echo "Program exit successfully."
      ;;
    1 )
      info=$(uname -o)
      show_info "Operating System Type"
      ;;
    2 )
      info=$(lscpu)
      show_info "CPU Information"
      ;;
    3 )
      info=$(less /proc/meminfo)
      show_info "Memory Information"
      ;;
    4 )
      info=$(lsblk)
      show_info "Hard disk Information"
      ;;
    5 )
      info=$(df)
      show_info "File System (Mounted)"
      ;;
  esac
done
  
