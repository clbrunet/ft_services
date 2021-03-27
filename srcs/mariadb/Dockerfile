FROM	alpine

WORKDIR	/root/

RUN		apk add --no-cache openrc mariadb mariadb-client;

COPY	./srcs/ ./

EXPOSE	3306

ENTRYPOINT	["./start_mariadb.sh"]
CMD			["./mariadbd.sh"]
