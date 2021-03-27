#!/bin/sh

echo -e "php-fpm start [ongoing]"
rc-service php-fpm7 restart &> /dev/null;
if [ $? -eq 0 ]; then
	echo -e "\r\033[1A\033[Kphp-fpm start [done]"
else
	echo -e "\r\033[1A\033[Kphp-fpm start [failed]"
fi

echo -e "nginx start [ongoing]"
rc-service nginx restart &> /dev/null;
if [ $? -eq 0 ]; then
	echo -e "\r\033[1A\033[Knginx start [done]"
else
	echo -e "\r\033[1A\033[Knginx start [failed]"
fi

wp-cli config create --dbname=wp_database --dbhost=mariadb --dbuser=admin --dbpass=admin;
wp-cli core install --url=192.168.49.2:5050 --title="ft_wordpress" --admin_user=admin \
	--admin_password=admin --admin_email=admin@gmail.com --skip-email;
wp-cli user create editor editor@gmail.com --role=editor --user_pass=editor;
wp-cli user create author author@gmail.com --role=author --user_pass=author;
wp-cli user create contributor contributor@gmail.com --role=contributor --user_pass=contributor;
wp-cli user create subscriber subscriber@gmail.com --role=subscriber --user_pass=subscriber;

exec "$@"
