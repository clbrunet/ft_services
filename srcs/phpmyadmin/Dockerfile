FROM	alpine

WORKDIR	/usr/share/webapps/phpmyadmin/

RUN		apk add --no-cache nginx php7-fpm phpmyadmin openrc; \
		openrc; touch /run/openrc/softlevel; \
		sed --in-place "s/localhost/mariadb/" /etc/phpmyadmin/config.inc.php; \
		echo "\$cfg['PmaAbsoluteUri'] = './';" >> /etc/phpmyadmin/config.inc.php;

COPY	./srcs/ /root/

RUN		rm /etc/nginx/http.d/default.conf; mv ~/phpmyadmin.conf /etc/nginx/http.d;

EXPOSE	5000

ENTRYPOINT	["/root/start_phpmyadmin.sh"]
CMD			["/root/nginx_daemon_off.sh"]
