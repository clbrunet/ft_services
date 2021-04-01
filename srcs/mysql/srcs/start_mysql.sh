#!/bin/sh

rc-service mariadb setup
rc-service mariadb start
mariadb < ./mysql_script.sql
echo -e "\n[mysqld]\nskip-networking=0\nskip-bind-address" >> /etc/my.cnf

exec "$@"
