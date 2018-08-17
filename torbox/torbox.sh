#!bin/bash

# Created: 8/14/2018
# Revised:  8/16/2018
#
# Applications to install and setup
#
#
#
#
#
#
#

# Set Variables for functions
INTERACTIVE=True #Used for whiptail menu
ASK_TO_REBOOT=0 #Keep track if reboot is required by a function
logDate=`date`'\n----------------------------\n' #Print Date/Time/horizontal line
logFile='/var/log/rock64-torbox_install.log' #logfile location and filename.log

# Create TorBox install log file
if [ ! -f $logFile ]; then
  echo -e "echo -e \e[0;93m> [ \e[0;96mLOGFILE \e[0;93m] Creating install log file at \e[0;92m$logFile \e[0m\n"
  sudo touch $logFile
  sudo chown dietpi:dietpi $logFile
  echo -e $logDate "[ LOGFILE ] Creating install log file at $logFile\n" >> $logFile
fi

# Log file functions for package (programs), service, update, upgrade, and variable; samples available
do_log() {
  # Examples for Log File
  # Typical command: sudo apt-get update
    #package="update"
    #do_log
    #do_update >> $logLoc 2>&1
  # Typical command: sudo apt-get upgrade -y
    #package="upgrade"
    #do_log
    #do_upgrade >> $logLoc 2>&1
  # Typical command: sudo apt-get install <package> -y
    #package="Package/Program Name"
    #do_log
    #sudo apt-get install <programName> -y >> $logLoc 2>&1
  # Typical command: cat > serviceName.service << EOF, cont'd
    #serviceC="<Service Name>"
    #do_log
    #cat > <serviceName>.service << EOF
    #...
    #EOF
  # Typical command:  sydo systemctl start <serviceName>
    #serviceS="<Service Name>"
    #do_log
    #sudo systemctl enable <serviceName.service>  >> $logFile 2>&1
    #sudo systemctl start <serviceName.service>
    #sudo systemctl stop <serviceName.service>
    #sudo systemctl status <serviceName.service> >> $logLoc
  # Unknown log needed
    #logTxt="[ SAMPLE ] Situation or comment to be logged"
    #logScr="echo -e \e[0;93m> [ \e[0;96mSAMPLE \e[0;93m] Situation or comment to be\e[0;92m logged.\e[0m"
    #do_log

  if ([ -n "$package" ] && ! [ "$package" == "update" ] && ! [ "$package" == "upgrade" ]); then
    logTxt="[ PACKAGE ] Downloading and installing: $package"
    logScr="echo -e \e[0;93m> [ \e[0;96mPACKAGE \e[0;93m] Downloading and installing:\e[0;92m $package\e[0m"
    $logScr && echo -e $logDate$logTxt >> $logLoc
    package=''
    return
  elif [ "$package" == "update" ]; then
    logTxt="[ UPDATE ] Updating package(s) and apt repositories..."
    logScr="echo -e \e[0;93m> [ \e[0;96mUPDATE \e[0;93m] Updating package(s) and apt repositories...\e[0m"
    $logScr && echo -e $logDate$logTxt >> $logLoc
    package=''
    return
  elif [ "$package" == "upgrade" ]; then
    logTxt="[ UPGRADE ] Upgrading package(s) and apt repositories..."
    logScr="echo -e \e[0;93m> [ \e[0;96mUPGRADE \e[0;93m] Updgrading package(s) and apt repositories...\e[0m"
    $logScr && echo -e $logDate$logTxt >> $logLoc
    package=''
    return
  elif [ -n "$settings" ]; then
    logTxt="[ SETTINGS ] Preassigned settings and files for: $settings"
    logScr="echo -e \e[0;93m> [ \e[0;96mSETTINGS \e[0;93m] Preassigned settings and files for:\e[0;92m $settings\e[0m"
    $logScr && echo -e $logDate$logTxt >> $logLoc
    settings=''
    return
  elif [ -n "$serviceC" ]; then
    logTxt="[ SERVICE ] Creating service for: $serviceC"
    logScr="echo -e \e[0;93m> [ \e[0;96mSERVICE \e[0;93m] Creating service:\e[0;92m $serviceC\e[0m"
    $logScr && echo -e $logDate$logTxt >> $logLoc
    serviceC=''
    return
  elif [ -n "$serviceS" ]; then
    logTxt="[ SERVICE ] Starting service: $serviceS"
    logScr="echo -e \e[0;93m> [ \e[0;96mSERVICE \e[0;93m] Starting service:\e[0;92m $serviceS\e[0m"
    $logScr && echo -e $logDate$logTxt >> $logLoc
    serviceS=''
    return
  fi
  $logScr && echo -e $logDate$logTxt >> $logLoc
  logTxt='' && logScr=''
}

# Reminder to reboot if required
do_reboot_reminder() {
  if [ $ASK_TO_REBOOT -eq 1 ]; then
    whiptail --title "Reboot Reminder" --yesno --defaultno "
    Rembember to reboot the system for the changes to take effect.\n
    Would you like to reboot now?  Reconnect in 15 seconds.
    " 10 70 2
    if [ $? -eq 0 ]; then # yes
      logTxt="[ REBOOT ] Rebooting system as per reminder command"
      logScr="echo -e \e[0;93m> [ \e[0;96mREBOOT \e[0;93m] Rebooting system as per \e[0;92mReminder \e[0mcommand"
      do_log
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
      logTxt="[ REBOOT ] Rebooting system as per Exit command"
      logScr="echo -e \e[0;93m[ \e[0;96mREBOOT \e[0;93m] Rebooting system as per\e[0;92mExit \e[0mcommand"
      reboot
    fi
  fi
  exit 0
}

# APT-GET UPDATE command
do_update() {
  #echo -e $logDate "Updating package(s) and apt repositories... \n" >> $logFile
  #echo -e "\e[0;96m\n> Updating package(s) and apt repositories... \e[0m\n"
  package="update" && do_log
  sudo apt-get update >> $logFile 2>&1
  return 0
}

# APT-GET UPGRADE command
do_upgrade() {
  #echo -e $logDate "Upgrading package(s) and application(s)... \n" >> $logFile
  #echo -e "\e[0;96m\n> Upgrading package(s) and application(s)... \e[0m\n"
  package="upgrade"
  do_log
  sudo apt-get upgrade -y >> $logFile 2>&1
  return 0
}

# Directories for the torrent box use under /home/dietpi
do_torbox_directories() {
  logTxt="[ FOLDER ] Creating folder(s) for Downloads, Music, Videos, Temp"
  logScr="echo -e \e[0;93m> [ \e[0;96mFOLDER \e[0;93m] Creating folder(s) for\e[0;92m Downloads, Music, Videos, Temp\e[0m"
  do_log
  install -d -m 0755 -o dietpi -g dietpi /home/dietpi/Downloads
  install -d -m 0755 -o dietpi -g dietpi /home/dietpi/Music
  install -d -m 0755 -o dietpi -g dietpi /home/dietpi/Videos
  install -d -m 0755 -o dietpi -g dietpi /home/dietpi/Temp
}

# Programs and packages required for the torrent box programs to work
do_torbox_requirement_packages() {
  logTxt="[ REQUIREMENT(S) ] Download and installation of required packages, create folders, and install log file"
  logScr="echo -e \e[0;93m> [ \e[0;96mREQUIREMENT(S) \e[0;93m] Download and installation of \e[0;92mrequired packages and create folders\e[0m"
  do_log
  cd /home/dietpi

  # git
  package="git"
  do_log
  sudo apt-get install git git-core -y >> $logFile 2>&1 &&

  # dirmngr
  package="apt-transport-https dirmngr"
  do_log
  sudo apt-get install apt-transport-https dirmngr -y >> $logFile 2>&1 &&
  logTxt="[ REQUEST ] Requesting package key: mono-project/repo"
  logScr="echo -e \e[0;93m> [ \e[0;96mREQUEST \e[0;93m] Requesting package key:\e[0;92m mono-project/repo\e[0m"
  do_log
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF >> $logFile 2>&1 &&
  echo "deb https://download.mono-project.com/repo/debian stable-raspbianstretch main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list >> $logFile 2>&1 &&
  do_update
  # echo -e "\e[0;96m> Package(s) Update Required \e[0m" &&
  # sudo apt-get update -y >> $logFile 2>&1 &&

  # mono
  package="mono-devel"
  do_log
  sudo apt-get install mono-devel -y >> $logFile 2>&1

  # libcurl
  package="libcurl4-openssl-dev"
  do_log
  sudo apt-get install libcurl4-openssl-dev -y >> $logFile 2>&1 &&

  # mediainfo
  package="mediainfo"
  do_log
  sudo apt-get install mediainfo -y >> $logFile 2>&1 &&
  do_upgrade
  # echo -e "\e[0;96m> Package(s) Update/Upgrade Required \e[0m" &&
  # sudo apt-get upgrade -y >> $logFile 2>&1 &&

  ASK_TO_REBOOT=1
}

# Programs and packages need for the torrent box
do_torbox_programs() {
  logTxt="[ PACKAGE(S) ] Download and installation of torrent box programs"
  logScr="echo -e \e[0;93m> [ \e[0;96mPACKAGE(S) \e[0;93m] Download and installation of\e[0;92m torrent box packages\e[0m"
  do_log
  cd /home/dietpi

  # OpenVPN:  program
  cd /home/dietpi
  package="OpenVPN"
  do_log
  sudo apt-get install openvpn -y >> $logFile 2>&1 &&

  # Deluge:  program
  package="Deluge"
  do_log
  sudo touch /var/log/deluged.log &&
  sudo touch /var/log/deluge-web.log &&
  sudo chown dietpi:dietpi /var/log/deluge* &&
  sudo apt-get install deluged -y >> $logFile 2>&1 &&
  sudo apt-get install deluge-webui -y >> $logFile 2>&1 &&
  sudo apt-get install deluge-console -y >> $logFile 2>&1 &&

  # Deluge:  service
  serviceC="Deluge"
  do_log
  cd /home/dietpi
  cat > deluge.service << EOF
[Unit]
Description=Deluge Bittorrent Client Daemon
After=network-online.target

[Service]
Type=simple
User=root
Group=root
UMask=000
ExecStart=/usr/bin/deluged -d
Restart=on-failure
# Configures the time to wait before service is stopped forcefully.
TimeoutStopSec=300

[Install]
WantedBy=multi-user.target
EOF
  sudo mv deluge.service /lib/systemd/system/deluge.service

  serviceC="Deluge-Web"
  do_log
  cd /home/dietpi
  cat > deluge-web.service << EOF
[Unit]
Description=Deluge Bittorrent Client Web Interface
After=network-online.target

[Service]
Type=simple
User=root
Group=root
UMask=000
ExecStart=/usr/bin/deluge-web
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
  sudo mv deluge-web.service /lib/systemd/system/deluge-web.service

  serviceS="Deluge + Deluge-Web"
  do_log
  sudo systemctl enable deluge >> $logFile 2>&1 &&
  sudo systemctl start deluge &&
  sudo systemctl enable deluge-web >> $logFile 2>&1 &&
  sudo systemctl start deluge-web &&
  sudo systemctl status deluge >> $logFile &&
  sudo systemctl status deluge-web >> $logFile &&

  # Jackett:  program
  package="Jackett"
  do_log
  cd /home/dietpi/Downloads
  wget https://github.com/Jackett/Jackett/releases/download/v0.9.41/Jackett.Binaries.Mono.tar.gz >> $logFile 2>&1 &&
  sudo tar -zxf Jackett.Binaries.Mono.tar.gz --directory /opt/ >> $logFile 2>&1 &&
  sudo chown -Rh dietpi:dietpi /opt/Jackett &&

  # Jackett:  service
  serviceC="Jackett"
  do_log
  cat > jackett.service << EOF
[Unit]
Description=Jackett Daemon
After=network.target

[Service]
user=dietpi
Restart=always
RestartSec=5
Type=simple
ExecStart=/usr/bin/mono --debug /opt/Jackett/JackettConsole.exe --NoRestart
TimeoutStopSec=20

[Install]
WantedBy=multi-user.target
EOF
  sudo mv jackett.service /lib/systemd/system/jackett.service

  serviceS="Jackett"
  do_log
  sudo systemctl enable jackett >> $logFile 2>&1 &&
  sudo systemctl start jackett &&
  sudo systemctl status jackett >> $logFile &&

  # Sonarr:  program
  package"Sonarr"
  do_log
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC >> $logFile 2>&1 &&
  logTxt="[ SOURCE ] Adding package to sources.list for: Sonarr"
  logScr="echo -e \e[0;93m> [ \e[0;96mSOURCE \e[0;93m] Adding package to sources.list for:\e[0;92m Sonarr\e[0m"
  do_log
  echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list >> $logFile 2>&1 &&
  package="update"
  do_log
  do_update
  # echo -e '\nPackage(s) Update Required'  >> $logFile &&
  # echo -e "\e[0;96m> Package(s) Update Required \e[0m" &&
  # sudo apt-get update -y >> $logFile 2>&1 &&
  package="Sonarr"
  do_log
  sudo apt-get install nzbdrone -y >> $logFile 2>&1 &&
  sudo chown -Rh dietpi:dietpi /opt/NzbDrone &&

  # Sonarr:  sevice
  serviceC="Sonarr"
  do_log
  cd /home/dietpi
  cat > sonarr.service << EOF
[Unit]
Description=Sonarr Daemon
After=syslog.target network.target

[Service]
user=dietpi
group=dietpi
Type=simple
ExecStart=/usr/bin/mono /opt/NzbDrone/NzbDrone.exe -nobrowser
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
  sudo mv sonarr.service /lib/systemd/system/sonarr.service

  serviceS="Sonarr"
  do_log
  sudo systemctl enable sonarr.service >> $logFile 2>&1 &&
  sudo systemctl start sonarr.service &&
  sudo systemctl status sonarr >> $logFile &&

  # Radarr:  program
  package="Radarr"
  do_log
  cd /home/dietpi/Downloads
  sudo curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 ) >> $logFile 2>&1 &&
  sudo tar -xzf Radarr.develop.*.linux.tar.gz --directory /opt/ >> $logFile 2>&1 &&
  sudo chown -Rh dietpi:dietpi /opt/Radarr &&

  # Radarr:  service
  serviceC="Radarr"
  do_log
  cat > radarr.service << EOF
[Unit]
Description=Radarr Daemon
After=syslog.target network.target

[Service]
user=dietpi
group=dietpi
Type=simple
ExecStart=/usr/bin/mono /opt/Radarr/Radarr.exe -nobrowser
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
  sudo mv radarr.service /lib/systemd/system/radarr.service

  serviceS="Radarr"
  do_log
  sudo systemctl enable radarr.service >> $logFile 2>&1 &&
  sudo systemctl start radarr.service &&
  sudo systemctl status radarr >> $logFile &&

  # Lidarr:  program
  package="Lidarr"
  do_log
  cd /home/dietpi/Downloads
  sudo wget https://github.com/lidarr/Lidarr/releases/download/v0.3.1.471/Lidarr.develop.0.3.1.471.linux.tar.gz >> $logFile 2>&1 &&
  sudo tar -xzf Lidarr.develop.*.linux.tar.gz --directory /opt/ >> $logFile 2>&1 &&
  sudo chown -Rh dietpi:dietpi /opt/Lidarr &&

  # Lidarr:  service
  serviceC="Lidarr"
  do_log
  cat > lidarr.service << EOF
[Unit]
Description=Lidarr Daemon
After=syslog.target network.target

[Service]
user=dietpi
group=dietpi
Type=simple
ExecStart=/usr/bin/mono /opt/Lidarr/Lidarr.exe -nobrowser
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

  sudo mv lidarr.service /lib/systemd/system/lidarr.service

  serviceS="Lidarr"
  do_log
  sudo systemctl enable lidarr.service >> $logFile 2>&1 &&
  sudo systemctl start lidarr.service &&
  sudo systemctl status lidarr >> $logFile

  # Ombi:  program
  package="Ombi"
  do_log
  cd /home/dietpi
  logTxt="[ SOURCE ] Adding package to sources.list for: Ombi"
  logScr="echo -e \e[0;93m> [ \e[0;96mSOURCE \e[0;93m] Adding package to sources.list for:\e[0;92m Ombi\e[0m"
  echo "deb [arch=amd64,armhf] http://repo.ombi.turd.me/develop/ jessie main" | sudo tee "/etc/apt/sources.list.d/ombi.list" >> $logFile 2>&1 &&
  wget -qO - https://repo.ombi.turd.me/pubkey.txt | sudo apt-key add - >> $logFile 2>&1 &&
  package="update"
  do_log
  do_update
  package="Ombi"
  do_log
  sudo apt-get install ombi -y >> $logFile 2>&1 &&

  # Organizr:  program
  package="Organizr"
  do_log
  cd /home/dietpi
  sudo git clone https://github.com/elmerfdz/OrganizrInstaller /opt/OrganizrInstaller >> $logFile 2>&1 &&
  cd /opt/OrganizrInstaller/ubuntu/oui >> $logFile 2>&1 &&
  sudo bash ou_installer.sh &&
  cd /home/dietpi

  ASK_TO_REBOOT=1
}

# Maintenance programs and packages used for the torrent box
do_torbox_maintenance_programs() {
  logTxt="[ PACKAGE(S) ] Download and Installation of maintenance utility programs"
  logScr="echo -e \e[0;93m> [ \e[0;96mPACKAGE(S) \e[0;93m] Download and Installation of:\e[0;92m maintenance utility programs\e[0m"
  do_log

  # Midnight Commander
  cd /home/dietpi
  package="Midnight Commander"
  do_log
  sudo apt-get install mc -y >> $logFile 2>&1 &&

  # Speedtest
  package="Speedtest"
  do_log
  cd /usr/local/bin
  sudo apt-get install python-pip -y >> $logFile 2>&1 &&
  sudo easy_install speedtest-cli >> $logFile 2>&1
  cd /home/dietpi

  # Cloud Commander
  #package="Cloud Commander"
  #do_log

}

# Preassigned settings to ease the installation of the above programs and packages
do_torbox_preassigned_settings() {
  if (whiptail --title "Criteria to use preassigned settings" --yesno --defaultno "
    • Rebooted after running the 'First Time Boot'
    • Installed the 'Requirement Packages'
    • Installed the 'TorBox Programs'
    • Rebooted after installing the 'Required Packages and TorBox Programs'
    • All the services have been started/opened by their respective port numbers
      via a local browser  (ie torboxIP:port - 192.168.0.60:8989)
      - Deluge  (torboxIP:8112)
      - Jackett (torboxIP:9117)
      - Sonarr  (torboxIP:8989)
      - Radarr  (torboxIP:7878)
      - Lidarr  (torboxIP:8686)


                      Has the following criteria been met?
      " 20 85) then

    logTxt="[ SETTINGS ] Editing, Download, Replacing, and Installation of preassgined settings"
    logScr="echo -e \e[0;93m> [ \e[0;96mSETTINGS \e[0;93m] Editing, Download, Replacing, and Installation of\e[0;92m preassgined settings\e[0m"
    do_log

    # Deluge
    settings="Deluge"
    do_log
    sudo systemctl stop deluge && sudo systemctl stop deluge-web &&
    sudo wget https://github.com/D4rkSl4ve/Rock64/raw/master/torbox/deluge/WebAPI-0.2.1-py2.7.egg -O /root/.config/deluge/plugins/WebAPI-0.2.1-py2.7.egg >> $logFile 2>&1 &&
    sudo chmod 666 /root/.config/deluge/plugins/WebAPI-0.2.1-py2.7.egg >> $logFile 2>&1 &&
    sudo rm /root/.config/deluge/core.conf >> $logFile 2>&1 &&
    sudo wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/deluge/core.conf -O /root/.config/deluge/core.conf >> $logFile 2>&1 &&
    sudo mv /usr/lib/python2.7/dist-packages/deluge/ui/web/js/deluge-all.js /usr/lib/python2.7/dist-packages/deluge/ui/web/js/deluge-all.js-backup >> $logFile 2>&1&&
    sudo wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/deluge/deluge-all.js -O /usr/lib/python2.7/dist-packages/deluge/ui/web/js/deluge-all.js >> $logFile 2>&1&&
    sudo chmod 644 /usr/lib/python2.7/dist-packages/deluge/ui/web/js/deluge-all.js >> $logFile 2>&1 &&
    sudo mv /usr/lib/python2.7/dist-packages/deluge/ui/web/auth.py /usr/lib/python2.7/dist-packages/deluge/ui/web/auth.py-backup >> $logFile 2>&1 &&
    sudo wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/deluge/auth.py -O /usr/lib/python2.7/dist-packages/deluge/ui/web/auth.py >> $logFile 2>&1 &&
    sudo chmod 644 /usr/lib/python2.7/dist-packages/deluge/ui/web/auth.py >> $logFile 2>&1 &&
    sudo sed -i 's+""show_session_speed": false,+"show_session_speed": true,+' /root/.config/deluge/web.conf >> $logFile 2>&1 &&
    sudo systemctl start deluge && sudo systemctl start deluge-web &&
    sudo systemctl status deluge >> $logFile &&
    sudo systemctl status deluge-web >> $logFile &&

    # Jackett
    settings="Jackett"
    do_log
    sudo systemctl stop jackett &&
    sed -i 's+"BasePathOverride": null,+"BasePathOverride": "/jackett",+' /home/dietpi/.config/Jackett/ServerConfig.json >> $logFile 2>&1 &&
    sed -i 's+"UpdatePrerelease": false,+"UpdatePrerelease": true,+' /home/dietpi/.config/Jackett/ServerConfig.json >> $logFile 2>&1 &&
    install -d -m 0755 -o pi -g pi /home/dietpi/.config/Jackett/Indexers && cd /home/dietpi/.config/Jackett/Indexers &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/jackett/Indexers/eztv.json >> $logFile 2>&1 &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/jackett/Indexers/rarbg.json >> $logFile 2>&1 &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/jackett/Indexers/thepiratebay.json >> $logFile 2>&1 &&
    sudo chown -R dietpi:dietpi /home/dietpi/.config/Jackett/Indexers/*
    sudo systemctl start jackett &&
    sudo systemctl status jackett >> $logFile &&

    # Sonarr
    settings="Sonarr"
    do_log
    sudo systemctl stop sonarr &&
    cd /home/dietpi/.config/NzbDrone &&
    rm config.xml && rm *.db* &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/sonarr/config.xml -O /home/dietpi/.config/NzbDrone/config.xml >> $logFile 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/NzbDrone/config.xml &&
    sudo chown dietpi:dietpi /home/dietpi/.config/NzbDrone/config.xml &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/sonarr/nzbdrone.db -O /home/dietpi/.config/NzbDrone/nzbdrone.db >> $logFile 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/NzbDrone/nzbdrone.db &&
    sudo chown dietpi:dietpi /home/dietpi/.config/NzbDrone/nzbdrone.db &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/sonarr/nzbdrone.db-journal -O /home/dietpi/.config/NzbDrone/nzbdrone.db-journal >> $logFile 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/NzbDrone/nzbdrone.db-journal &&
    sudo chown dietpi:dietpi /home/dietpi/.config/NzbDrone/nzbdrone.db-journal &&
    sudo systemctl start sonarr &&
    sudo systemctl status sonarr >> $logFile &&
    echo -e "\e[0;96m> The \e[0;92mAPI Key has to be reset \e[0;96mat Settings/General, generate New API Key\e[0m" &&

    # Radarr
    settings="Radarr"
    do_log
    sudo systemctl stop radarr &&
    cd /home/dietpi/.config/Radarr &&
    rm config.xml && rm *.db* &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/radarr/config.xml -O /home/dietpi/.config/Radarr/config.xml >> $logFile 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/Radarr/config.xml &&
    sudo chown dietpi:dietpi /home/dietpi/.config/Radarr/config.xml &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/radarr/nzbdrone.db -O /home/dietpi/.config/Radarr/nzbdrone.db >> $logFile 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/Radarr/nzbdrone.db &&
    sudo chown dietpi:dietpi /home/dietpi/.config/Radarr/nzbdrone.db &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/radarr/nzbdrone.db-journal -O /home/dietpi/.config/Radarr/nzbdrone.db-journal >> $logFile 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/Radarr/nzbdrone.db-journal &&
    sudo chown dietpi:dietpi /home/dietpi/.config/Radarr/nzbdrone.db-journal &&
    sudo systemctl start radarr &&
    sudo systemctl status radarr >> $logFile &&
    echo -e "\e[0;96m> The \e[0;92mAPI Key has to be reset \e[0;96mat Settings/General, generate New API Key\e[0m" &&

    # Lidarr
    settings="Lidarr"
    do_log
    sudo systemctl stop lidarr &&
    cd /home/dietpi/.config/Lidarr &&
    rm config.xml && rm *.db* &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/lidarr/config.xml -O /home/dietpi/.config/Lidarr/config.xml >> $logFile 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/Lidarr/config.xml &&
    sudo chown dietpi:dietpi /home/dietpi/.config/Lidarr/config.xml &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/lidarr/lidarr.db -O /home/dietpi/.config/Lidarr/lidarr.db >> $logFile 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/Lidarr/lidarr.db &&
    sudo chown dietpi:dietpi /home/dietpi/.config/Lidarr/lidarr.db &&
    sudo systemctl start lidarr &&
    sudo systemctl status lidarr >> $logFile &&
    echo -e "\e[0;96m> The \e[0;92mAPI Key has to be reset \e[0;96mat Settings/General, generate New API Key\e[0m"

    ASK_TO_REBOOT=1

    else
      return 0
  fi
  do_reboot_reminder
}

# Future settings spot on the menu
do_future_settings() {
  if [ "$INTERACTIVE" = True ]; then
    whiptail --msgbox "This portion of the the script is for future use.\n" 20 60 2
  fi
}

# Main Menu for torrent box installation and settings
if [ "$INTERACTIVE" = True ]; then
  while true; do
    menuOption=$(whiptail --title "Rock64 Torrent Box Configuration Menu (rock64-torbox)" --backtitle "$(cat /proc/device-tree/model)" --menu "Rock64 Torrent Box Options" 15 85 7 --cancel-button Finish --ok-button Select \
      "1 Requirement Packages" "Installation of required packages, and  log" \
      "2 TorBox Programs" "Installation of torrent box programs and services" \
      "3 Maintenance Utilities" "Installation of maintenance utilities" \
      "4 Preassigned Settings" "Installation of 'Programs' preassigned settings" \
      "7 Update\Upgrade" "Repository Update and Upgade" \
      "8 Reboot Rock64" "Reboot Rock64 to take effect" \
      "9 DietPie Launcher" "DietPi Launcher Menu" \
      3>&1 1>&2 2>&3)
    RET=$?
    if [ $RET -eq 1 ]; then
      do_exit
    elif [ $RET -eq 0 ]; then
      case "$menuOption" in
        1\ *) echo -e '\nRequirement Packages activate\n'$logDate >> $logLoc && do_torbox_requirement_packages ;;
        2\ *) echo -e '\nTorBox Programs activate\n'$logDate >> $logLoc && do_torbox_directories && do_torbox_programs ;;
        3\ *) echo -e '\nMaintenance Utilities activate\n'$logDate >> $logLoc && do_torbox_maintenance_programs ;;
        4\ *) echo -e '\nPreassigned Settings activate\n'$logDate >> $logLoc && do_torbox_preassigned_settings ;;
        7\ *) echo -e '\nUpdate\Update/Upgrade activate\n'$logDate >> $logLoc && do_update && do_upgrade ;;
        8\ *) echo -e '\nReboot Rock64 activate\n'$logDate >> $logLoc && do_reboot ;;
        9\ *) echo -e '\nDietPi Laucnher Menu activate\n'$logDate >> $logLoc && do_raspi_config_menu ;;
        *) whiptail --msgbox "Programmer error: unrecognized option" 30 60 1 ;;
      esac || whiptail --msgbox "There was an error running option $menuOption" 30 60 1
    else
      do_reboot_reminder
    fi
  done
fi
do_exit
}
