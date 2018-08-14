#!bin/bash

# Created: 8/14/2018
# Revised:  8/14/2018
#
# Applications to install and setup
#
#
#
#
#
#
#

# Set function defaults
  AST_TO_REBOOT=0
  logDate=`date`'\n----------------------------\n'
  logTxt='/var/log/rock64-torbox_install.log'

  #  Exmples for Log File
  #  echo -e $logDate "Comment on Screen \n" >> $logTxt OR >> $logTxt 2>&1
  #  echo -e "\e[0;96m> Comment on\e[0;92mScreen \e[0m"
  #  sudo touch $logTxt
  #  sudo apt-get update >> $logTxt 2>&1

# Create TorBox install log file
if [ ! -f $logTxt ]; then
  echo -e "\e[0;96m> Creating install log file at \e[0;92m$logTxt \e[0m"
  sudo touch $logTxt
  sudo chown dietpi:dietpi $logTxt
  echo -e $logDate "Creating install log file at $logTxt\n" >> $logTxt
fi

# Reminder to reboot if required
do_reboot_reminder() {
  if [ $ASK_TO_REBOOT -eq 1 ]; then
    whiptail --title "Reboot Reminder" --yesno --defaultno "
    Rembember to reboot the system for the changes to take effect.\n
    Would you like to reboot now?  Reconnect in 15 seconds.
    " 10 70 2
    if [ $? -eq 0 ]; then # yes
      echo -e $logDate "Rebooting system as per Reminder command\n" >> $logTxt
      echo -e "\e[0;96m> Rebooting system as per\e[0;92mReminder command \e[0m"
      reboot
    fi
  fi
  return 0
}

# Exit Command, will check if reboot is required
do_exit() {
  if [ $ASK_TO_REBOOT -eq 1 ]; then
    whiptail --title "Must Reboot System" --yesno "
    Please reboot the system for changes to take effect.\n
    Would you like to reboot now?  Reconnect in 15 seconds.
    " 10 60 2
    if [ $? -eq 0 ]; then # yes
      echo -e $logDate "Rebooting system as per Exit command\n" >> $logTxt
      echo -e "\e[0;96m> Rebooting system as per\e[0;92mExit command \e[0m"
      reboot
    fi
  fi
  exit 0
}

# APT-GET UPDATE command
do_update() {
  echo -e $logDate "Updating package(s) and apt repositories... \n" >> $logTxt
  echo -e "\e[0;96m\n> Updating package(s) and apt repositories... \e[0m\n"
  sudo apt-get update >> $logTxt 2>&1
  return 0
}

# APT-GET UPGRADE command
do_upgrade() {
  echo -e $logDate "Upgrading package(s) and application(s)... \n" >> $logTxt
  echo -e "\e[0;96m\n> Upgrading package(s) and application(s)... \e[0m\n"
  sudo apt-get upgrade -y >> $logTxt 2>&1
  return 0
}
