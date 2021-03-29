FROM	alpine

WORKDIR	/root/

RUN		apk add --no-cache nginx openssl openrc; \
		openrc; touch /run/openrc/softlevel;

COPY	./srcs/ ./

RUN		rm /etc/nginx/http.d/default.conf; mv ./nginx.conf /etc/nginx/http.d/; \
		openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
		-keyout /etc/ssl/private/192.168.49.2.key -out /etc/ssl/certs/192.168.49.2.crt \
		-subj '/CN=192.168.49.2';  \
		mkdir -p /var/www/html/; mv ./index.html /var/www/html/;

EXPOSE	80 443

ENTRYPOINT	["./start_nginx.sh"]
CMD			["./nginx_daemon_off.sh"]
