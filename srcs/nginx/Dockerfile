FROM	alpine

WORKDIR	/root/

RUN		apk add --no-cache nginx openssl openrc; \
		openrc; touch /run/openrc/softlevel;

COPY	./srcs/ ./

RUN		rm /etc/nginx/http.d/default.conf; mv ./nginx.conf /etc/nginx/http.d/; \
		mkdir -p /var/www/html/; mv ./index.html /var/www/html/;

EXPOSE	80 443

ENTRYPOINT	["./start_nginx.sh"]
CMD			["./nginx_daemon_off.sh"]
