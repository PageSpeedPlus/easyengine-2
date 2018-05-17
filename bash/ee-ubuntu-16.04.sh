#!/bin/bash
# ===================================================================================
# | EasyEngine Ubuntu 16.04 - Installation & Konfiguration
# ===================================================================================
# Script: ee-ubuntu-16.04.sh
# Version: 1.0.0
# Date: 2018-05-11
# Author: Daniel Bieli <danibieli.1185@gmail.com>
# Description: EasyEngine auf Ubuntu 16.04 installieren und konfigurieren.
#------------------------------------------------------------------------------------
# 1. Induviduelle Variabeln
#------------------------------------------------------------------------------------
LOGFILE=/var/log/ee-ubuntu-16.04.sh
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
# 4. Ubuntu 16.04 - Grundkonfiguration
#------------------------------------------------------------------------------------
bash <(wget --no-check-certificate -O - https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/bash/ubuntu-16.04.sh)
#------------------------------------------------------------------------------------
# 5. MariaDB 10.2 installieren
#------------------------------------------------------------------------------------
bash <(wget --no-check-certificate -O - https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/bash/mariadb.sh)
#------------------------------------------------------------------------------------
# 6. EasyEngine installieren
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
# 7. NGiNX kompilieren
#------------------------------------------------------------------------------------
bash <(wget --no-check-certificate -O - https://raw.githubusercontent.com/VirtuBox/nginx-ee/master/nginx-build.sh)
#------------------------------------------------------------------------------------
# 8. NGiNX konfigurieren
#------------------------------------------------------------------------------------
wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/nginx/nginx.conf
wget -O /etc/nginx/conf.d/webp.conf  https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/nginx/conf.d/webp.conf
wget -O /etc/nginx/conf.d/upstream.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/nginx/conf.d/upstream.conf
wget -O /etc/nginx/conf.d/pagespeed.conf https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/nginx/conf.d/pagespeed.conf
wget -O /etc/nginx/common/pagespeed-vhost.conf https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/nginx/common/pagespeed-vhost.conf

cd /etc/nginx/common || exit
wget https://raw.githubusercontent.com/PageSpeedPlus/easyengine/master/etc/nginx/common/common.zip
unzip common.zip
wget -O /etc/nginx/sites-available/default  https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/nginx/sites-available/default
wget -O /etc/nginx/sites-available/22222 https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/nginx/sites-available/22222
systemctl restart nginx
#------------------------------------------------------------------------------------
# Allow shell for www-data for SFTP usage
#------------------------------------------------------------------------------------
usermod -s /bin/bash www-data
#------------------------------------------------------------------------------------
# Install Composer - Fix phpmyadmin install issue
#------------------------------------------------------------------------------------
bash <(wget --no-check-certificate -O - https://git.virtubox.net/virtubox/debian-config/raw/master/composer.sh)
sudo -u www-data composer update -d /var/www/22222/htdocs/db/pma/
sudo wp --allow-root cli update --nightly
#------------------------------------------------------------------------------------
# PHP 7.0
#------------------------------------------------------------------------------------
wget -O /etc/php/7.0/cli/php.ini https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.0/cli/php.ini
wget -O /etc/php/7.0/fpm/php.ini https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.0/fpm/php.ini
service php7.0-fpm restart > /dev/null 2>&1

wget -O /etc/nginx/common/wpcommon-php7.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/nginx/common/wpcommon-php7.conf
service nginx reload
#------------------------------------------------------------------------------------
# Secure Memcached server
#------------------------------------------------------------------------------------
echo '-U 0' >> /etc/memcached.conf 
systemctl restart memcached
#------------------------------------------------------------------------------------
# PHP 7.2
#------------------------------------------------------------------------------------
apt-get -qq update && apt-get -yqq php7.2-fpm php7.2-xml php7.2-bz2 php7.2-zip php7.2-mysql php7.2-intl php7.2-gd php7.2-curl php7.2-soap php7.2-mbstring > /dev/null 2>&1
wget -O /etc/php/7.2/fpm/php.ini https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.2/fpm/php.ini
wget -O /etc/php/7.2/fpm/pool.d/www.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.2/fpm/pool.d/www.conf
service php7.2-fpm restart > /dev/null 2>&1

wget -O /etc/nginx/common/wpcommon-php72.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/nginx/common/wpcommon-php72.conf
service nginx reload
#------------------------------------------------------------------------------------
# Fail2Ban
#------------------------------------------------------------------------------------
wget -O /etc/fail2ban/filter.d/ddos.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/fail2ban/filter.d/ddos.conf
wget -O /etc/fail2ban/filter.d/ee-wordpress.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/fail2ban/filter.d/ee-wordpress.conf
wget -O /etc/fail2ban/jail.d/custom.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/fail2ban/jail.d/custom.conf
wget -O  /etc/fail2ban/jail.d/ddos.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/fail2ban/jail.d/ddos.conf
fail2ban-client reload
#------------------------------------------------------------------------------------
Acme.sh
#------------------------------------------------------------------------------------
wget -O -  https://get.acme.sh | sh
source ~/.bashrc
#------------------------------------------------------------------------------------
netdata
#------------------------------------------------------------------------------------
bash <(curl -Ss https://my-netdata.io/kickstart.sh) all

# save 40-60% of netdata memory
echo 1 >/sys/kernel/mm/ksm/run
echo 1000 >/sys/kernel/mm/ksm/sleep_millisecs

# disable email notifications
wget -O /etc/netdata/health_alarm_notify.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/netdata/health_alarm_notify.conf
service netdata restart
#------------------------------------------------------------------------------------
# PHP 7.1
#------------------------------------------------------------------------------------
apt-get -qq update && apt-get -yqq install php7.1-fpm php7.1-cli php7.1-zip php7.1-opcache php7.1-mysql php7.1-mcrypt php7.1-mbstring php7.1-json php7.1-intl php7.1-gd php7.1-curl php7.1-bz2 php7.1-xml php7.1-tidy php7.1-soap php7.1-bcmath > /dev/null 2>&1
wget -O /etc/php/7.1/fpm/php.ini https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.1/fpm/php.ini
wget -O /etc/php/7.1/fpm/pool.d/www.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.1/fpm/pool.d/www.conf
service php7.1-fpm restart > /dev/null 2>&1

wget -O /etc/nginx/common/wpcommon-php71.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/nginx/common/wpcommon-php71.conf
service nginx reload
