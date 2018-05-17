#!/bin/bash
# ===================================================================================
# | Ubuntu 16.04 - Grundinstallation & Konfiguration
# ===================================================================================
# Script: ubuntu-16.04.sh
# Version: 1.0.0
# Date: 2018-05-12
# Author: Daniel Bieli <danibieli.1185@gmail.com>
# Description: Ubuntu 16.04 installieren und konfigurieren.
#------------------------------------------------------------------------------------
# 1. Induviduelle Variabeln
#------------------------------------------------------------------------------------
LOGFILE=/var/log/ubuntu-16.04.sh
#------------------------------------------------------------------------------------
# 2. Standart Variabeln
#------------------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
PWD=$(pwd);
exec > >(tee -i $LOGFILE)
exec 2>&1
#------------------------------------------------------------------------------------
# 3. Root Check
#------------------------------------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
    echo "Error: You must be root to run this script, please use the root user to install the software."
    exit 1
fi
clear
#------------------------------------------------------------------------------------
# 4. Ubuntu aktualisieren & aufräumen
#------------------------------------------------------------------------------------
apt-get -qq update && apt-get -yqq upgrade && apt-get -yqq autoremove && apt-get -qq clean > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 5. Benötigte Software installieren
#------------------------------------------------------------------------------------
apt-get -yqq install manpages-de cron-apt unattended-upgrades curl wget ufw haveged git unzip zip fail2ban htop dnsutils zoo bzip2 arj nomarch lzop cabextract locate apt-listchanges apt-transport-https software-properties-common lsb-release ca-certificates ssh openssh-server ntp ntpdate debconf-utils binutils sudo e2fsprogs openssh-server openssl ssl-cert mcrypt nano rsync > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 6. Standart Shell von Dash auf Bash Shell umstellen
#------------------------------------------------------------------------------------
echo "dash dash/sh boolean false" | debconf-set-selections
dpkg-reconfigure -f noninteractive dash > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 7. Erlaubt SSH Logins via Passwort & Verbietet Root Login
#------------------------------------------------------------------------------------
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/' /etc/ssh/sshd_config
/etc/init.d/ssh restart
#------------------------------------------------------------------------------------
# 8. Syntax Highlighten im nano Editor
#------------------------------------------------------------------------------------
wget https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh -O- | sh
#------------------------------------------------------------------------------------
# 9. UFW Firewall konfigurieren & aktivieren
#------------------------------------------------------------------------------------
ufw logging on
ufw default allow outgoing
ufw default deny incoming
ufw allow 22
ufw allow http
ufw allow https
ufw allow 123
ufw allow 161
ufw allow 6556
ufw allow 19999
ufw allow 22222
ufw enable
#------------------------------------------------------------------------------------
# 10. Whitelist Cloudflare network IPv4+IPv6
#------------------------------------------------------------------------------------
wget https://raw.githubusercontent.com/Paul-Reed/cloudflare-ufw/master/cloudflare-ufw.sh
bash cloudflare-ufw.sh
#------------------------------------------------------------------------------------
# 11. Tweak Kernel source & Increase open files limits source
#------------------------------------------------------------------------------------
wget -O /etc/sysctl.conf https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/sysctl.conf > /dev/null 2>&1
sysctl -p > /dev/null 2>&1
wget -O /etc/security/limits.conf https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/security/limits.conf > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 12. Configure Automatic security updates
#------------------------------------------------------------------------------------
dpkg-reconfigure unattended-upgrades
#------------------------------------------------------------------------------------
# 13. Skript Ende & Logfile Pfad Ausgabe
#------------------------------------------------------------------------------------
echo -e "${GREEN}Ubuntu 16.04 Grundkonfiguration abgeschlossen - Logfile: $LOGFILE ${NC}\n"