FROM	alpine

WORKDIR	/root/

RUN		apk add --no-cache openrc influxdb; \
		openrc; touch /run/openrc/softlevel;

COPY	./srcs/ ./

EXPOSE	8086

ENTRYPOINT	["./start_influxdb.sh"]
CMD			["./influxd.sh"]
