#!/bin/sh

/etc/init.d/php-fpm7 status | grep started > /dev/null
