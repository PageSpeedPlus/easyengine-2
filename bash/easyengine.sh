#!/bin/bash
# ===================================================================================
# | EasyEngine - Installation
# ===================================================================================
# Script: easyengine.sh
# Version: 1.0.0
# Date: 2018-05-27
# Author: Daniel Bieli <danibieli.1185@gmail.com>
# Description: EasyEngine installieren und konfigurieren.
#------------------------------------------------------------------------------------
# 1. Induviduelle Variabeln
#------------------------------------------------------------------------------------
LOGFILE=/var/log/easyengine.sh.log
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
# EasyEngine installieren
#------------------------------------------------------------------------------------
wget -qO ee rt.cx/ee && bash ee
source /etc/bash_completion.d/ee_auto.rc
ee stack install
ee stack install --php7 --redis --admin --phpredisadmin
#------------------------------------------------------------------------------------
# disable transparent hugepage for redis
#------------------------------------------------------------------------------------
echo never > /sys/kernel/mm/transparent_hugepage/enabled
#------------------------------------------------------------------------------------
# Secure Memcached server
#------------------------------------------------------------------------------------
echo '-U 0' >> /etc/memcached.conf 
systemctl restart memcached
#------------------------------------------------------------------------------------
# Ask for WordPress prefix while site creation
#------------------------------------------------------------------------------------
sed -i "s/prefix = False/prefix = true/" /etc/ee/ee.conf
#------------------------------------------------------------------------------------
# Skript Ende & Logfile Pfad Ausgabe
#------------------------------------------------------------------------------------
echo -e "${GREEN}EasyEngine Installation - Logfile: $LOGFILE ${NC}\n"
