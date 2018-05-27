#!/bin/bash
# ===================================================================================
# | EasyEngine Fail2Ban - Konfiguration
# ===================================================================================
# Script: fail2ban.sh
# Version: 1.0.0
# Date: 2018-05-27
# Author: Daniel Bieli <danibieli.1185@gmail.com>
# Description: EasyEngine Fail2Ban konfigurieren.
#------------------------------------------------------------------------------------
# 1. Induviduelle Variabeln
#------------------------------------------------------------------------------------
LOGFILE=/var/log/nginx.sh.log
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
# 4. Fail2Ban installieren
#------------------------------------------------------------------------------------
apt-get -y install fail2ban
#------------------------------------------------------------------------------------
# 5. Fail2Ban konfigurieren
#------------------------------------------------------------------------------------
wget -O /etc/fail2ban/jail.local https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/fail2ban/jail.local
wget -O /etc/fail2ban/fail2ban.local https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/fail2ban/fail2ban.local
wget -O /etc/fail2ban/filter.d/ee-wordpress.conf https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/fail2ban/filter.d/ee-wordpress.conf
wget -O /etc/fail2ban/action.d/abuseipdb.conf https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/fail2ban/action.d/abuseipdb.conf
