#!/bin/sh

echo "ECHO"
cat /etc/my.cnf;
echo "ECHO"
cat /etc/my.cnf.d/*;
openrc
touch /run/openrc/softlevel
rc-service mariadb setup
rc-service mariadb start
mariadb < ./mariadb_script.sql
echo "ECHO"
cat /etc/my.cnf;
echo "ECHO"
cat /etc/my.cnf.d/*;
echo -e "\n[mysqld]\nskip-networking=0\nskip-bind-address" >> /etc/my.cnf


exec "$@"
