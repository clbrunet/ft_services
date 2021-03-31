FROM	alpine

WORKDIR	/var/www/html/

RUN		apk add --no-cache nginx curl php7-fpm php7-phar php7-json php7-openssl \
		php7-mysqli php7-iconv php7-ctype openrc mariadb-client telegraf; \
		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
		chmod +x wp-cli.phar; mv wp-cli.phar /usr/local/bin/wp-cli; \
		wp-cli core download; openrc; touch /run/openrc/softlevel;

COPY	./srcs/ /root/

RUN		rm /etc/nginx/http.d/default.conf; mv ~/wordpress.conf /etc/nginx/http.d;

EXPOSE	5050

ENTRYPOINT	["/root/start_wordpress.sh"]
CMD			["/root/nginx_daemon_off.sh"]
