#!/bin/bash
# ===================================================================================
# | Monit (EasyEngine)- Installation & Konfiguration
# ===================================================================================
# Script: monit.sh
# Version: 1.0.0
# Date: 2018-05-11
# Author: Daniel Bieli <danibieli.1185@gmail.com>
# Description: Monit installieren und konfigurieren.
#------------------------------------------------------------------------------------
# 1. Induviduelle Variabeln
#------------------------------------------------------------------------------------
LOGFILE=/var/log/monit.sh.log
MONITUSER=monit
MONITPW=easyengine
MONITPORT=2812
MONITMAILSERVER=localhost
MONITMAILSENDER=monit@`hostname -f`
MONITMAILRECIPIENT=admin@yourmail.com
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
# 3. Monit installieren
#------------------------------------------------------------------------------------
apt-get -qq update && apt-get -yqq install monit > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 4. Konfigurationsdatei für EasyEngine laden
#------------------------------------------------------------------------------------
wget -O /etc/monit/monitrc https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/monit/monitrc
wget -O /etc/monit/common/initd-integrity https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/monit/common/initd-integrity
wget -O /etc/monit/common/pidchange-alert https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/monit/common/pidchange-alert
wget -O /etc/monit/common/restart-timeout https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/monit/common/restart-timeout
wget -O /etc/monit/templates/rootbin https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/monit/templates/rootbin
wget -O /etc/monit/templates/rootrc https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/monit/templates/rootrc
wget -O /etc/monit/templates/rootstrict https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/monit/templates/rootstrict 
wget -O /etc/monit/conf.d/fail2ban.conf https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/monit/conf.d/fail2ban.conf
#------------------------------------------------------------------------------------
# 5. Induviduelle Konfiguration
#------------------------------------------------------------------------------------
sed -i 's/set mailserver localhost/set mailserver $MONITMAILSERVER/' /etc/monit/monitrc
sed -i 's/set mail-format { from: monit@localhost }/set mail-format { from: $MONITMAILSENDER }/' /etc/monit/monitrc
sed -i 's/set alert root@localhost/set alert $MONITMAILRECIPIENT/' /etc/monit/monitrc
sed -i 's/set httpd port 2812/set httpd port $MONITPORT/' /etc/monit/monitrc
sed -i 's/allow admin:easyengine/allow $MONITUSER:$MONITPW/' /etc/monit/monitrc
#------------------------------------------------------------------------------------
# 6. UFW Firewall Port öffnen für Webzugriff
#------------------------------------------------------------------------------------
ufw allow $MONITPORT > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 7. Monit starten
#------------------------------------------------------------------------------------
service monit start > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 8. Monit URL anzeigen
#------------------------------------------------------------------------------------
printf "${RED}Das Monit Dashboard können Sie im Browser via http://%s:$MONITPORT aufrufen.${NC}\n" `hostname -f`
echo
#------------------------------------------------------------------------------------
# 9. Skript Ende & Logfile Pfad Ausgabe
#------------------------------------------------------------------------------------
echo -e "${GREEN}Monit Installation abgeschlossen - Logfile: $LOGFILE ${NC}\n"
