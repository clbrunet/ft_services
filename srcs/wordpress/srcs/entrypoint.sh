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

while ! mariadb --host=mysql --user=admin --password=admin < /dev/null > /dev/null; do
	sleep 0.2;
done
wp-cli config create --dbname=wp_database --dbhost=mysql --dbuser=admin --dbpass=admin;
wp-cli core install --url=192.168.49.2:5050 --title="ft_wordpress" --admin_user=admin \
	--admin_password=admin --admin_email=admin@gmail.com --skip-email;
wp-cli user create editor editor@gmail.com --role=editor --user_pass=editor;
wp-cli user create author author@gmail.com --role=author --user_pass=author;
wp-cli user create contributor contributor@gmail.com --role=contributor --user_pass=contributor;
wp-cli user create subscriber subscriber@gmail.com --role=subscriber --user_pass=subscriber;

exec "$@"
