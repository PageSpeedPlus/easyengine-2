#!/bin/bash
# ===================================================================================
# | UFW Firewall einrichten & Cloudflare IPs whitelisten
# ===================================================================================
# Script: ufw.sh
# Version: 1.0.0
# Date: 2018-05-27
# Author: Daniel Bieli <danibieli.1185@gmail.com>
# Description: UFW Firewall einrichten & Cloudflare IPs whitelisten.
#------------------------------------------------------------------------------------
# 1. Induviduelle Variabeln
#------------------------------------------------------------------------------------
LOGFILE=/var/log/ufw.sh.log
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
# 4. UFW Firewall installieren
#------------------------------------------------------------------------------------
apt-get -qq update && apt-get -yqq install ufw > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 5. UFW Firewall konfigurieren & aktivieren
#------------------------------------------------------------------------------------
ufw logging on
ufw default allow outgoing
ufw default deny incoming
ufw allow 22
ufw allow 80
ufw allow 443
ufw allow 2812
ufw allow 19999
ufw allow 22222
ufw enable
#------------------------------------------------------------------------------------
# 6. Whitelist Cloudflare network IPv4+IPv6 - https://github.com/Paul-Reed/cloudflare-ufw
#------------------------------------------------------------------------------------
mkdir /home/tools
wget -O /home/tools/cloudflare-ufw.sh https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/home/tools/cloudflare-ufw.sh
chmod 700 /home/tools/cloudflare-ufw.sh
bash cloudflare-ufw.sh
systemctl restart ufw
#------------------------------------------------------------------------------------
# 7. Skript Ende & Logfile Pfad Ausgabe
#------------------------------------------------------------------------------------
echo -e "${GREEN}UFW Firewall einrichten und Cloudflare IPs whitelisten - Logfile: $LOGFILE ${NC}\n"
