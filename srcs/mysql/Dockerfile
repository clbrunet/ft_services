FROM	alpine

WORKDIR	/root/

RUN		apk add --no-cache openrc mariadb mariadb-client; \
		openrc; touch /run/openrc/softlevel;

COPY	./srcs/ ./

EXPOSE	3306

ENTRYPOINT	["./start_mysql.sh"]
CMD			["./mysqld.sh"]
