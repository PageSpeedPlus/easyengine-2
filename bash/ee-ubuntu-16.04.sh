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
# 4. Ubuntu aktualisieren & aufräumen
#------------------------------------------------------------------------------------
apt-get -qq update && apt-get -yqq upgrade && apt-get -yqq autoremove && apt-get -qq clean > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 5. Benötigte Software installieren
#------------------------------------------------------------------------------------
apt-get -yqq install curl debconf wget ufw haveged git unzip zip fail2ban htop > /dev/null 2>&1
#------------------------------------------------------------------------------------
# 6. Erlaubt SSH Logins via Passwort & Verbietet Root Login
#------------------------------------------------------------------------------------
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin without-password/' /etc/ssh/sshd_config
/etc/init.d/ssh restart
#------------------------------------------------------------------------------------
# 6. Syntax Highlighten im nano Editor
#------------------------------------------------------------------------------------
wget https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh -O- | sh
#------------------------------------------------------------------------------------
# 7. UFW Firewall konfigurieren & aktivieren
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
# Whitelist Cloudflare network IPv4+IPv6
#------------------------------------------------------------------------------------
wget https://raw.githubusercontent.com/Paul-Reed/cloudflare-ufw/master/cloudflare-ufw.sh
bash cloudflare-ufw.sh
#------------------------------------------------------------------------------------
# 8. Tweak Kernel source & Increase open files limits source
#------------------------------------------------------------------------------------
wget -O /etc/sysctl.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/sysctl.conf > /dev/null 2>&1
sysctl -p > /dev/null 2>&1
wget -O /etc/security/limits.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/security/limits.conf > /dev/null 2>&1
#------------------------------------------------------------------------------------
# MariaDB 10.2 installieren
#------------------------------------------------------------------------------------
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash -s -- --mariadb-server-version=10.2 --skip-maxscale
apt-get -qq update > /dev/null 2>&1
ROOT_SQL_PASS=$(/dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1; echo;)
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< 'mariadb-server mysql-server/root_password password $ROOT_SQL_PASS'
debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again password $ROOT_SQL_PASS'
apt-get -yqq install mariadb-server > /dev/null 2>&1
cat <<EOF >~/.my.cnf
 [client]
 user=root
 password=$ROOT_SQL_PASS
EOF
#------------------------------------------------------------------------------------
# EasyEngine installieren
#------------------------------------------------------------------------------------
wget -qO ee rt.cx/ee && bash ee > /dev/null 2>&1
source /etc/bash_completion.d/ee_auto.rc
#------------------------------------------------------------------------------------
# EasyEngine Stack installieren
#------------------------------------------------------------------------------------
ee stack install
ee stack install --php7 --redis --admin --phpredisadmin
#------------------------------------------------------------------------------------
# NGiNX kompilieren
#------------------------------------------------------------------------------------
bash <(wget --no-check-certificate -O - https://raw.githubusercontent.com/VirtuBox/nginx-ee/master/nginx-build.sh)
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
# disable transparent hugepage for redis
#------------------------------------------------------------------------------------
echo never > /sys/kernel/mm/transparent_hugepage/enabled
#------------------------------------------------------------------------------------
# PHP 7.0
#------------------------------------------------------------------------------------
wget -O /etc/php/7.0/cli/php.ini https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.0/cli/php.ini
wget -O /etc/php/7.0/fpm/php.ini https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.0/fpm/php.ini
service php7.0-fpm restart > /dev/null 2>&1

wget -O /etc/nginx/common/wpcommon-php7.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/nginx/common/wpcommon-php7.conf
service nginx reload
#------------------------------------------------------------------------------------
# PHP 7.1
#------------------------------------------------------------------------------------
apt-get -qq update && apt-get -yqq install php7.1-fpm php7.1-cli php7.1-zip php7.1-opcache php7.1-mysql php7.1-mcrypt php7.1-mbstring php7.1-json php7.1-intl php7.1-gd php7.1-curl php7.1-bz2 php7.1-xml php7.1-tidy php7.1-soap php7.1-bcmath > /dev/null 2>&1
wget -O /etc/php/7.1/fpm/php.ini https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.1/fpm/php.ini
wget -O /etc/php/7.1/fpm/pool.d/www.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.1/fpm/pool.d/www.conf
service php7.1-fpm restart > /dev/null 2>&1

wget -O /etc/nginx/common/wpcommon-php71.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/nginx/common/wpcommon-php71.conf
service nginx reload
#------------------------------------------------------------------------------------
# PHP 7.2
#------------------------------------------------------------------------------------
apt-get -qq update && apt-get -yqq php7.2-fpm php7.2-xml php7.2-bz2  php7.2-zip php7.2-mysql  php7.2-intl php7.2-gd php7.2-curl php7.2-soap php7.2-mbstring > /dev/null 2>&1
wget -O /etc/php/7.2/fpm/php.ini https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.2/fpm/php.ini
wget -O /etc/php/7.2/fpm/pool.d/www.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/php/7.2/fpm/pool.d/www.conf
service php7.2-fpm restart > /dev/null 2>&1

wget -O /etc/nginx/common/wpcommon-php72.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/nginx/common/wpcommon-php72.conf
service nginx reload
#------------------------------------------------------------------------------------
# Secure Memcached server
#------------------------------------------------------------------------------------
echo '-U 0' >> /etc/memcached.conf 
sudo systemctl restart memcached
#------------------------------------------------------------------------------------
# Fail2Ban
#------------------------------------------------------------------------------------
wget -O /etc/fail2ban/filter.d/ddos.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/fail2ban/filter.d/ddos.conf
wget -O /etc/fail2ban/filter.d/ee-wordpress.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/fail2ban/filter.d/ee-wordpress.conf
wget -O /etc/fail2ban/jail.d/custom.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/fail2ban/jail.d/custom.conf
wget -O  /etc/fail2ban/jail.d/ddos.conf https://raw.githubusercontent.com/VirtuBox/ubuntu-nginx-web-server/master/etc/fail2ban/jail.d/ddos.conf
fail2ban-client reload
#------------------------------------------------------------------------------------
# Install Composer - Fix phpmyadmin install issue
#------------------------------------------------------------------------------------
bash <(wget --no-check-certificate -O - https://git.virtubox.net/virtubox/debian-config/raw/master/composer.sh)
sudo -u www-data composer update -d /var/www/22222/htdocs/db/pma/
sudo wp --allow-root cli update --nightly