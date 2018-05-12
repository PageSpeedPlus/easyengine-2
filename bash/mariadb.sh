#!/bin/bash
# ===================================================================================
# | MariaDB 10.2 - Installation & Konfiguration
# ===================================================================================
# Script: mariadb.sh
# Version: 1.0.0
# Date: 2018-05-12
# Author: Daniel Bieli <danibieli.1185@gmail.com>
# Description: MariaDB 10.2 installieren und konfigurieren.
#------------------------------------------------------------------------------------
# 1. Induviduelle Variabeln
#------------------------------------------------------------------------------------
LOGFILE=/var/log/mariadb.sh
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
# 4. Repository hinzufügen
#------------------------------------------------------------------------------------
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash -s -- --mariadb-server-version=10.2 --skip-maxscale
apt-get -qq update > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 5. Root Passwort generieren
#------------------------------------------------------------------------------------
ROOT_SQL_PASS=$(/dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1; echo;)
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mariadb-server mysql-server/root_password password $ROOT_SQL_PASS'
debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again password $ROOT_SQL_PASS'
#------------------------------------------------------------------------------------
# 6. MariaDB installieren
#------------------------------------------------------------------------------------
apt-get -yqq install mariadb-server percona-toolkit > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 7. Root Account Daten in MariaDB Konfig hinterlegen
#------------------------------------------------------------------------------------
cat <<EOF >~/.my.cnf
 [client]
 user=root
 password=$ROOT_SQL_PASS
EOF
#------------------------------------------------------------------------------------
# 8. Lade Tools zur MariaDB Optimierung
#------------------------------------------------------------------------------------
mkdir /home/tools > /dev/null 2>&1
cd /home/tools
wget http://www.day32.com/MySQL/tuning-primer.sh > /dev/null 2>&1
wget http://mysqltuner.com/mysqltuner.pl > /dev/null 2>&1
chmod 700 tuning-primer.sh mysqltuner.pl
#------------------------------------------------------------------------------------
# 9. Skript Ende & Logfile Pfad Ausgabe
#------------------------------------------------------------------------------------
echo -e "${GREEN}MariaDB installiert - Logfile: $LOGFILE ${NC}\n"
