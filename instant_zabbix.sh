clear;cd;apt update
wget https://repo.zabbix.com/zabbix/5.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.4-1+ubuntu20.04_all.deb
dpkg -i zabbix-release_5.4-1+ubuntu20.04_all.deb
apt update
apt install -y git php-curl php-json openssh-server php net-tools zabbix-server-mysql
apt install -y zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent
apt install -y snmp-mibs-downloader python python3-pip mysql-server curl adduser libfontconfig1
mysql -u root -e"create database zabbix character set utf8 collate utf8_bin;"
mysql -u root -e"create user zabbix identified by 'password'"
mysql -u root -e"grant all privileges on zabbix.* to zabbix"
zcat /usr/share/doc/zabbix-sql-scripts/mysql/create.sql.gz | mysql -u zabbix -p zabbix --password=password
timedatectl set-timezone Asia/Bangkok
git clone https://github.com/xXxRosxXx/zabbix_component
mkdir /usr/lib/zabbix;mkdir /usr/lib/zabbix/alertscripts
mv /etc/php/7.4/apache2/php.ini /etc/php/7.4/apache2/php.ini.old
mv /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf.old
mv /usr/share/zabbix/chart.php /usr/share/zabbix/chart.php.old
mv /usr/share/zabbix/chart2.php /usr/share/zabbix/chart2.php.old
chmod +x zabbix_component/LINE_Notify.sh;cp zabbix_component/LINE_Notify.sh /usr/lib/zabbix/alertscripts
cp zabbix_component/php.ini /etc/php/7.4/apache2/
cp zabbix_component/zabbix_server.conf /etc/zabbix/
cp zabbix_component/chart.php /usr/share/zabbix/
cp zabbix_component/chart2.php /usr/share/zabbix/
sed -i '/ZBX_MAX_GRAPHS_PER_PAGE/c\define('"'"'ZBX_MAX_GRAPHS_PER_PAGE'"'"', 1024);' /usr/share/zabbix/include/defines.inc.php
wget https://dl.grafana.com/oss/release/grafana_7.4.1_amd64.deb
dpkg -i grafana_7.4.1_amd64.deb;grafana-cli plugins install alexanderzobnin-zabbix-app
grafana-cli plugins install grafana-clock-panel
grafana-cli plugins install innius-video-panel
systemctl restart mysql;systemctl enable mysql
systemctl restart zabbix-server;systemctl enable zabbix-server
systemctl restart zabbix-agent;systemctl enable zabbix-agent
systemctl restart grafana-server;systemctl enable grafana-server
systemctl restart apache2;systemctl enable apache2
cd;rm -rf zabbix_component;rm grafana_*;rm zabbix-re*
printf "\nNOTE: Don't forget to insert your LINE Token in /usr/lib/zabbix/alertscripts/LINE_Notify.sh"
printf "\nInstalled Zabbix Server and Grafana Server.\n"
