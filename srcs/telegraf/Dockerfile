FROM	alpine

WORKDIR	/root/

RUN		apk add --no-cache telegraf;

COPY	./srcs/ ./

CMD		["./telegraf.sh"]
