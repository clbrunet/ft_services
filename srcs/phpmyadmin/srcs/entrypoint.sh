#!/bin/sh

echo -e "php-fpm start [ongoing]"
rc-service php-fpm7 restart &> /dev/null;
if [ $? -eq 0 ]; then
	echo -e "\r\033[1A\033[Kphp-fpm start [done]"
else
	echo -e "\r\033[1A\033[Kphp-fpm start [failed]"
fi

rc-service nginx start &> /dev/null;
rc-service nginx stop &> /dev/null;

exec "$@"
