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
wget -qO ee rt.cx/ee && bash ee > /dev/null 2>&1
source /etc/bash_completion.d/ee_auto.rc
ee stack install
ee stack install --php7 --redis --admin --phpredisadmin
#------------------------------------------------------------------------------------
# disable transparent hugepage for redis
#------------------------------------------------------------------------------------
echo never > /sys/kernel/mm/transparent_hugepage/enabled
#------------------------------------------------------------------------------------
# Install Composer - Fix phpmyadmin install issue
#------------------------------------------------------------------------------------
cd ~/
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/bin/composer
sudo -u www-data composer update -d /var/www/22222/htdocs/db/pma/
wp --allow-root cli update --nightly
#------------------------------------------------------------------------------------
# Secure Memcached server
#------------------------------------------------------------------------------------
echo '-U 0' >> /etc/memcached.conf 
systemctl restart memcached
#------------------------------------------------------------------------------------
Install extplorer
#------------------------------------------------------------------------------------
mkdir /var/www/22222/htdocs/files
wget http://extplorer.net/attachments/download/74/eXtplorer_2.1.10.zip -O /var/www/22222/htdocs/files/ex.zip
cd /var/www/22222/htdocs/files && unzip ex.zip && rm ex.zip
#------------------------------------------------------------------------------------
Install ee-dashboard
#------------------------------------------------------------------------------------
cd ~/
git clone https://github.com/VirtuBox/easyengine-dashboard.git
cp -rf easyengine-dashboard/* /var/www/22222/htdocs/
chown -R www-data:www-data /var/www/22222/htdocs
#------------------------------------------------------------------------------------
# Skript Ende & Logfile Pfad Ausgabe
#------------------------------------------------------------------------------------
echo -e "${GREEN}EasyEngine Installation - Logfile: $LOGFILE ${NC}\n"
