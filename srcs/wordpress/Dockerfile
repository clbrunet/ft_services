FROM	alpine

WORKDIR	/var/www/html/

RUN		apk add --no-cache nginx curl php7-fpm php7-phar php7-json php7-openssl \
		php7-mysqli php7-iconv openrc mariadb mariadb-client; \
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
		chmod +x wp-cli.phar; mv wp-cli.phar /usr/local/bin/wp-cli; \
		wp-cli core download;

COPY	./srcs/ /root/

RUN		openrc; touch /run/openrc/softlevel; \
		rc-service mariadb setup; rc-service mariadb start; \
		mariadb < /root/mariadb_script.sql; \
		wp-cli config create --dbname=wp_database --dbuser=admin --dbpass=admin; \
		wp-cli core install --url=localhost --title="ft_wordpress" \
		--admin_user=admin --admin_password=admin --admin_email=admin@gmail.com --skip-email; \
		rm /etc/nginx/http.d/default.conf; mv ~/wordpress.conf /etc/nginx/http.d; \
		wp-cli user create editor editor@gmail.com --role=editor --user_pass=editor; \
		wp-cli user create author author@gmail.com --role=author --user_pass=author; \
		wp-cli user create contributor contributor@gmail.com --role=contributor --user_pass=contributor; \
		wp-cli user create subscriber subscriber@gmail.com --role=subscriber --user_pass=subscriber;


EXPOSE	80

ENTRYPOINT	["/root/start_services.sh"]
CMD			["/root/nginx_daemon_off.sh"]
