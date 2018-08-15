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

# Variables for functions
  ASK_TO_REBOOT=0
  logDate=`date`'\n----------------------------\n'
  logTxt='/var/log/rock64-torbox_install.log'

  #  Exmples for Log File
  #  echo -e $logDate "Comment on Screen \n" >> $logTxt OR >> $logTxt 2>&1
  #  echo -e "\e[0;96m> Comment on\e[0;92mScreen \e[0m"
  #  sudo touch $logTxt
  #  sudo apt-get update >> $logTxt 2>&1

# Create TorBox install log file
if [ ! -f $logTxt ]; then
  echo -e "\e[0;96m> Creating install log file at \e[0;92m$logTxt \e[0m\n"
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
      echo -e "\e[0;96m> Rebooting system as per\e[0;92mReminder command \e[0m\n"
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
      echo -e "\e[0;96m> Rebooting system as per\e[0;92mExit command \e[0m\n"
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


# CHECK FROM HERE DOWN


do_torbox_directories() {
  echo -e $logDate "Creating directoies for Downloads, Music, Videos, Temp \n" >> $logTxt &&
  echo -e "\e[0;96m\n> Creating directories for:\e[0;92m  Downloads, Music, Videos and Temp \e[0m\n" &&
  install -d -m 0755 -o dietpi -g dietpi /home/dietpi/Downloads
  install -d -m 0755 -o dietpi -g dietpi /home/dietpi/Music
  install -d -m 0755 -o dietpi -g dietpi /home/dietpi/Videos
  install -d -m 0755 -o dietpi -g dietpi /home/dietpi/Temp
}

do_torbox_requirement_packages() {
  echo -e $logDate "Download and installation of required packages, create folders, and install log file \n" >> $logTxt &&
  echo -e "\e[0;93m\n> Download and installation of required packages, create folders, and install log file \e[0m\n" &&
  cd /home/dietpi

  # git
  echo -e "Downloading and installing package(s):  git" >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing package(s):\e[0;92m  git \e[0m" &&
  sudo apt-get install git git-core -y >> $logTxt 2>&1 &&

  # dirmngr
  echo -e "Downloading and installing package(s):  apt-transport-https dirmngr" >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing package(s):\e[0;92m  apt-transport-https dirmngr \e[0m"
  sudo apt-get install apt-transport-https dirmngr -y >> $logTxt 2>&1 &&
  echo -e "\e[0;96m> Requesting package key:\e[0;92m  mono-project/repo \e[0m" &&
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF >> $logTxt 2>&1 &&
  echo "deb https://download.mono-project.com/repo/debian stable-raspbianstretch main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list >> $logTxt 2>&1 &&
  do_update
  # echo -e "\e[0;96m> Package(s) Update Required \e[0m" &&
  # sudo apt-get update -y >> $logTxt 2>&1 &&

  # mono
  echo -e "Downloading and installing:  mono-devel" >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing package(s):\e[0;92m  mono-devel \e[0m" &&
  sudo apt-get install mono-devel -y >> $logTxt 2>&1

  # libcurl
  echo -e  "Downloading and installing package(s):  libcurl4-openssl-dev" >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing package(s):\e[0;92m  libcurl4-openssl-dev \e[0m" &&
  sudo apt-get install libcurl4-openssl-dev -y >> $logTxt 2>&1 &&

  # mediainfo
  echo -e "Downloading and installing package(s):  mediainfo" >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing package(s):\e[0;92m  mediainfo \e[0m" &&
  sudo apt-get install mediainfo -y >> $logTxt 2>&1 &&
  do_upgrade
  # echo -e "\e[0;96m> Package(s) Update/Upgrade Required \e[0m" &&
  # sudo apt-get upgrade -y >> $logTxt 2>&1 &&

  ASK_TO_REBOOT=1
}

do_torbox_programs() {
  echo -e $logDate "Download and installation of torrent box programs\n" >> $logTxt &&
  echo -e "\e[0;93m\n> Download and installation of torrent box programs \e[0m\n" &&
  cd /home/dietpi

  # OpenVPN:  program
  cd /home/dietpi
  echo -e 'Downloading and installing program:  OpenVPN' >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing program:\e[0;92m  OpenVPN \e[0m" &&
  sudo apt-get install openvpn -y >> $logTxt 2>&1 &&

  # Deluge:  program
  echo -e 'Downloading and installing program:  Deluge' >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing program:\e[0;92m  Deluge \e[0m" &&
  sudo touch /var/log/deluged.log &&
  sudo touch /var/log/deluge-web.log &&
  sudo chown dietpi:dietpi /var/log/deluge* &&
  sudo apt-get install deluged -y >> $logTxt 2>&1 &&
  sudo apt-get install deluge-webui -y >> $logTxt 2>&1 &&
  sudo apt-get install deluge-console -y >> $logTxt 2>&1 &&

  # Deluge:  services
  echo -e 'Creating service for:  Deluge' >> $logTxt &&
  echo -e "\e[0;96m> Creating service for:\e[0;92m  Deluge \e[0m" &&
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

  echo -e 'Creating service for:  Deluge-Web' >> $logTxt &&
  echo -e "\e[0;96m> Creating service for:\e[0;92m  Deluge-Web \e[0m" &&
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

  echo -e 'Starting service:  Deluge + Deluge-Web' >> $logTxt &&
  echo -e "\e[0;96m> Starting service:\e[0;92m  Deluge + Deluge-Web \e[0m" &&
  sudo systemctl enable deluge >> $logTxt 2>&1 &&
  sudo systemctl start deluge &&
  sudo systemctl enable deluge-web >> $logTxt 2>&1 &&
  sudo systemctl start deluge-web &&
  sudo systemctl status deluge >> $logTxt &&
  sudo systemctl status deluge-web >> $logTxt &&

  # Jackett:  program
  echo -e '\nDownloading and installing program:  Jackett' >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing program:\e[0;92m  Jackett \e[0m" &&
  cd /home/dietpi/Downloads
  wget https://github.com/Jackett/Jackett/releases/download/v0.9.41/Jackett.Binaries.Mono.tar.gz >> $logTxt 2>&1 &&
  sudo tar -zxf Jackett.Binaries.Mono.tar.gz --directory /opt/ >> $logTxt 2>&1 &&
  sudo chown -Rh dietpi:dietpi /opt/Jackett &&

  # Jackett:  service
  echo -e '\nCreating service for:  Jackett' >> $logTxt &&
  echo -e "\e[0;96m> Creating service for:\e[0;92m  Jackett \e[0m" &&
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

  echo -e '\nStarting service:  Jackett' >> $logTxt &&
  echo -e "\e[0;96m> Starting service:\e[0;92m  Jackett \e[0m" &&
  sudo systemctl enable jackett >> $logTxt 2>&1 &&
  sudo systemctl start jackett &&
  sudo systemctl status jackett >> $logTxt &&

  # Sonarr:  program
  echo -e '\nDownloading and installing program:  Sonarr' >> $logTxt &&
  echo -e "\e[0;96m> Requesting package key:\e[0;92m  Sonarr \e[0m" &&
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC >> $logTxt 2>&1 &&
  echo -e "\e[0;96m> Adding package to sources.list for:\e[0;92m  Sonarr \e[0m" &&
  echo "deb http://apt.sonarr.tv/ master main" | sudo tee /etc/apt/sources.list.d/sonarr.list >> $logTxt 2>&1 &&
  do_update
  # echo -e '\nPackage(s) Update Required'  >> $logTxt &&
  # echo -e "\e[0;96m> Package(s) Update Required \e[0m" &&
  # sudo apt-get update -y >> $logTxt 2>&1 &&
  echo -e "\e[0;96m> Downloading and installing program:\e[0;92m  Sonarr \e[0m" &&
  sudo apt-get install nzbdrone -y >> $logTxt 2>&1 &&
  sudo chown -Rh dietpi:dietpi /opt/NzbDrone &&

  # Sonarr:  sevice
  echo -e '\nCreating service for:  Sonarr' >> $logTxt &&
  echo -e "\e[0;96m> Creating service for:\e[0;92m  Sonarr \e[0m" &&
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

  echo -e '\nStarting service:  Sonarr' >> $logTxt &&
  echo -e "\e[0;96m> Starting service:\e[0;92m  Sonarr \e[0m" &&
  sudo systemctl enable sonarr.service >> $logTxt 2>&1 &&
  sudo systemctl start sonarr.service &&
  sudo systemctl status sonarr >> $logTxt &&

  # Radarr:  program
  echo -e '\nDownloading and installing program:  Radarr' >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing program:\e[0;92m  Radarr \e[0m" &&
  cd /home/dietpi/Downloads
  sudo curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 ) >> $logTxt 2>&1 &&
  sudo tar -xzf Radarr.develop.*.linux.tar.gz --directory /opt/ >> $logTxt 2>&1 &&
  sudo chown -Rh dietpi:dietpi /opt/Radarr &&

  # Radarr:  service
  echo -e '\nCreating service for:  Radarr' >> $logTxt &&
  echo -e "\e[0;96m> Creating service for:\e[0;92m  Radarr \e[0m" &&
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

  echo -e '\nStarting service:  Radarr' >> $logTxt &&
  echo -e "\e[0;96m> Starting service:\e[0;92m  Radarr \e[0m" &&
  sudo systemctl enable radarr.service >> $logTxt 2>&1 &&
  sudo systemctl start radarr.service &&
  sudo systemctl status radarr >> $logTxt &&

  # Lidarr:  program
  echo -e '\nDownloading and installing program:  Lidarr' >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing program:\e[0;92m  Lidarr \e[0m" &&
  cd /home/dietpi/Downloads
  sudo wget https://github.com/lidarr/Lidarr/releases/download/v0.3.1.471/Lidarr.develop.0.3.1.471.linux.tar.gz >> $logTxt 2>&1 &&
  sudo tar -xzf Lidarr.develop.*.linux.tar.gz --directory /opt/ >> $logTxt 2>&1 &&
  sudo chown -Rh dietpi:dietpi /opt/Lidarr &&

  # Lidarr:  service
  echo -e '\nCreating service for:  Lidarr' >> $logTxt &&
  echo -e "\e[0;96m> Creating service for:\e[0;92m  Lidarr \e[0m" &&
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
  echo -e '\nStarting service:  Lidarr' >> $logTxt &&
  echo -e "\e[0;96m> Starting service:\e[0;92m  Lidarr \e[0m" &&
  sudo systemctl enable lidarr.service >> $logTxt 2>&1 &&
  sudo systemctl start lidarr.service &&
  sudo systemctl status lidarr >> $logTxt

  # Ombi:  program
  cd /home/dietpi
  echo -e '\nDownloading and installing program:  Ombi' >> $logTxt &&
  echo -e "\e[0;96m> Adding package to sources.list for:\e[0;92m  Ombi \e[0m" &&
  echo "deb [arch=amd64,armhf] http://repo.ombi.turd.me/develop/ jessie main" | sudo tee "/etc/apt/sources.list.d/ombi.list" >> $logTxt 2>&1 &&
  wget -qO - https://repo.ombi.turd.me/pubkey.txt | sudo apt-key add - >> $logTxt 2>&1 &&
  do_update
  # echo -e "\e[0;96m> Package(s) Update Required \e[0m" &&
  # sudo apt-get update >> $logTxt 2>&1 &&
  echo -e "\e[0;96m> Downloading and installing program:\e[0;92m  Ombi \e[0m" &&
  sudo apt-get install ombi -y >> $logTxt 2>&1 &&

  # Organizr:  program
  cd /home/dietpi
  echo -e '\nDownloading and installing program:  Organizr' >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing program:\e[0;92m  Organizr \e[0m" &&
  sudo git clone https://github.com/elmerfdz/OrganizrInstaller /opt/OrganizrInstaller >> $logTxt 2>&1 &&
  cd /opt/OrganizrInstaller/ubuntu/oui >> $logTxt 2>&1 &&
  sudo bash ou_installer.sh &&
  cd /home/dietpi

  ASK_TO_REBOOT=1
}

do_torbox_maintenance_programs() {
  echo -e $logDate "Download and Installation of maintenance utility programs\n" >> $logTxt &&
  echo -e "\e[0;93m\n> Download and Installation of maintenance utility programs \e[0m\n" &&

  # Midnight Commander
  cd /home/dietpi
  echo -e 'Downloading and installing program:  Midnight Commander' >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing program:\e[0;92m  Midnight Commander \e[0m" &&
  sudo apt-get install mc -y >> $logTxt 2>&1 &&

  # Speedtest
  echo -e 'Downloading and installing program:  Speedtest' >> $logTxt &&
  echo -e "\e[0;96m> Downloading and installing program:\e[0;92m  Speedtest \e[0m" &&
  cd /usr/local/bin
  sudo apt-get install python-pip -y >> $logTxt 2>&1 &&
  sudo easy_install speedtest-cli >> $logTxt 2>&1
  cd /home/dietpi

  # Cloud Commander
}

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

    echo -e $logDate "Editing, Download, Replacing, and Installation of preassgined settings\n'" >> $logTxt &&
    echo -e "\e[0;93m\n> Editing, Download, Replacing, and Installation of preassgined settings \e[0m\n" &&

    # Deluge
    echo -e 'Downloading and replacing file(s) for:  Deluge' >> $logTxt &&
    echo -e "\e[0;96m> Downloading and replacing file(s) for:\e[0;92m  Deluge \e[0m" &&
    sudo systemctl stop deluge && sudo systemctl stop deluge-web &&
    sudo wget https://github.com/D4rkSl4ve/Rock64/raw/master/torbox/deluge/WebAPI-0.2.1-py2.7.egg -O /root/.config/deluge/plugins/WebAPI-0.2.1-py2.7.egg >> $logTxt 2>&1 &&
    sudo chmod 666 /root/.config/deluge/plugins/WebAPI-0.2.1-py2.7.egg >> $logTxt 2>&1 &&
    sudo rm /root/.config/deluge/core.conf >> $logTxt 2>&1 &&
    sudo wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/deluge/core.conf -O /root/.config/deluge/core.conf >> $logTxt 2>&1 &&
    sudo mv /usr/lib/python2.7/dist-packages/deluge/ui/web/js/deluge-all.js /usr/lib/python2.7/dist-packages/deluge/ui/web/js/deluge-all.js-backup >> $logTxt 2>&1&&
    sudo wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/deluge/deluge-all.js -O /usr/lib/python2.7/dist-packages/deluge/ui/web/js/deluge-all.js >> $logTxt 2>&1&&
    sudo chmod 644 /usr/lib/python2.7/dist-packages/deluge/ui/web/js/deluge-all.js >> $logTxt 2>&1 &&
    sudo mv /usr/lib/python2.7/dist-packages/deluge/ui/web/auth.py /usr/lib/python2.7/dist-packages/deluge/ui/web/auth.py-backup >> $logTxt 2>&1 &&
    sudo wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/deluge/auth.py -O /usr/lib/python2.7/dist-packages/deluge/ui/web/auth.py >> $logTxt 2>&1 &&
    sudo chmod 644 /usr/lib/python2.7/dist-packages/deluge/ui/web/auth.py >> $logTxt 2>&1 &&
    sudo sed -i 's+""show_session_speed": false,+"show_session_speed": true,+' /root/.config/deluge/web.conf >> $logTxt 2>&1 &&
    sudo systemctl start deluge && sudo systemctl start deluge-web &&
    sudo systemctl status deluge >> $logTxt &&
    sudo systemctl status deluge-web >> $logTxt &&

    # Jackett
    echo -e 'Downloading and replacing file(s) for:  Jackett' >> $logTxt &&
    echo -e "\e[0;96m> Downloading and replacing file(s) for:\e[0;92m  Jackett \e[0m" &&
    sudo systemctl stop jackett &&
    sed -i 's+"BasePathOverride": null,+"BasePathOverride": "/jackett",+' /home/dietpi/.config/Jackett/ServerConfig.json >> $logTxt 2>&1 &&
    sed -i 's+"UpdatePrerelease": false,+"UpdatePrerelease": true,+' /home/dietpi/.config/Jackett/ServerConfig.json >> $logTxt 2>&1 &&
    install -d -m 0755 -o pi -g pi /home/dietpi/.config/Jackett/Indexers && cd /home/dietpi/.config/Jackett/Indexers &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/jackett/Indexers/eztv.json >> $logTxt 2>&1 &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/jackett/Indexers/rarbg.json >> $logTxt 2>&1 &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/jackett/Indexers/thepiratebay.json >> $logTxt 2>&1 &&
    sudo chown -R dietpi:dietpi /home/dietpi/.config/Jackett/Indexers/*
    sudo systemctl start jackett &&
    sudo systemctl status jackett >> $logTxt &&

    # Sonarr
    echo -e '\nDownloading and replacing file(s) for:  Sonarr' >> $logTxt &&
    echo -e "\e[0;96m> Downloading and replacing file(s) for:\e[0;92m  Sonarr \e[0m" &&
    sudo systemctl stop sonarr &&
    cd /home/dietpi/.config/NzbDrone &&
    rm config.xml && rm *.db* &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/sonarr/config.xml -O /home/dietpi/.config/NzbDrone/config.xml >> $logTxt 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/NzbDrone/config.xml &&
    sudo chown dietpi:dietpi /home/dietpi/.config/NzbDrone/config.xml &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/sonarr/nzbdrone.db -O /home/dietpi/.config/NzbDrone/nzbdrone.db >> $logTxt 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/NzbDrone/nzbdrone.db &&
    sudo chown dietpi:dietpi /home/dietpi/.config/NzbDrone/nzbdrone.db &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/sonarr/nzbdrone.db-journal -O /home/dietpi/.config/NzbDrone/nzbdrone.db-journal >> $logTxt 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/NzbDrone/nzbdrone.db-journal &&
    sudo chown dietpi:dietpi /home/dietpi/.config/NzbDrone/nzbdrone.db-journal &&
    sudo systemctl start sonarr &&
    sudo systemctl status sonarr >> $logTxt &&
    echo -e "\e[0;96m> The \e[0;92mAPI Key has to be reset \e[0;96mat Settings/General, generate New API Key\e[0m" &&

    # Radarr
    echo -e '\nDownloading and replacing file(s) for:  Radarr' >> $logTxt &&
    echo -e "\e[0;96m> Downloading and replacing file(s) for:\e[0;92m  Radarr \e[0m" &&
    sudo systemctl stop radarr &&
    cd /home/dietpi/.config/Radarr &&
    rm config.xml && rm *.db* &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/radarr/config.xml -O /home/dietpi/.config/Radarr/config.xml >> $logTxt 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/Radarr/config.xml &&
    sudo chown dietpi:dietpi /home/dietpi/.config/Radarr/config.xml &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/radarr/nzbdrone.db -O /home/dietpi/.config/Radarr/nzbdrone.db >> $logTxt 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/Radarr/nzbdrone.db &&
    sudo chown dietpi:dietpi /home/dietpi/.config/Radarr/nzbdrone.db &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/radarr/nzbdrone.db-journal -O /home/dietpi/.config/Radarr/nzbdrone.db-journal >> $logTxt 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/Radarr/nzbdrone.db-journal &&
    sudo chown dietpi:dietpi /home/dietpi/.config/Radarr/nzbdrone.db-journal &&
    sudo systemctl start radarr &&
    sudo systemctl status radarr >> $logTxt &&
    echo -e "\e[0;96m> The \e[0;92mAPI Key has to be reset \e[0;96mat Settings/General, generate New API Key\e[0m" &&

    # lidarr
    echo -e '\nDownloading and replacing file(s) for:  Lidarr' >> $logTxt &&
    echo -e "\e[0;96m> Downloading and replacing file(s) for:\e[0;92m  Lidarr \e[0m" &&
    sudo systemctl stop lidarr &&
    cd /home/dietpi/.config/Lidarr &&
    rm config.xml && rm *.db* &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/lidarr/config.xml -O /home/dietpi/.config/Lidarr/config.xml >> $logTxt 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/Lidarr/config.xml &&
    sudo chown dietpi:dietpi /home/dietpi/.config/Lidarr/config.xml &&
    wget https://raw.githubusercontent.com/D4rkSl4ve/Rock64/master/torbox/lidarr/lidarr.db -O /home/dietpi/.config/Lidarr/lidarr.db >> $logTxt 2>&1 &&
    sudo chmod 644 /home/dietpi/.config/Lidarr/lidarr.db &&
    sudo chown dietpi:dietpi /home/dietpi/.config/Lidarr/lidarr.db &&
    sudo systemctl start lidarr &&
    sudo systemctl status lidarr >> $logTxt &&
    echo -e "\e[0;96m> The \e[0;92mAPI Key has to be reset \e[0;96mat Settings/General, generate New API Key\e[0m"

    ASK_TO_REBOOT=1

    else
      return 0
  fi
  do_reboot_reminder
}

do_future_settings() {
  if [ "$INTERACTIVE" = True ]; then
    whiptail --msgbox "This portion of the the script is not finished yet.\n" 20 60 2
  fi
}
