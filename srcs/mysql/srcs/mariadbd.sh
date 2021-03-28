#!/bin/sh

rc-service mariadb stop &> /dev/null;
mariadbd --user=root
