#!/bin/sh

echo -e "php-fpm start [ongoing]"
rc-service php-fpm7 restart &> /dev/null;
if [ $? -eq 0 ]; then
	echo -e "\r\033[1A\033[Kphp-fpm start [done]"
else
	echo -e "\r\033[1A\033[Kphp-fpm start [failed]"
fi
echo -e "mariadb start [ongoing]"
rc-service mariadb restart &> /dev/null;
if [ $? -eq 0 ]; then
	echo -e "\r\033[1A\033[Kmariadb start [done]"
else
	echo -e "\r\033[1A\033[Kmariadb start [failed]"
fi
echo -e "nginx start [ongoing]"
rc-service nginx restart &> /dev/null;
if [ $? -eq 0 ]; then
	echo -e "\r\033[1A\033[Knginx start [done]"
else
	echo -e "\r\033[1A\033[Knginx start [failed]"
fi

exec "$@"
