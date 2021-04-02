#!/bin/sh

rc-service mariadb stop &> /dev/null;
mysqld --user=root
