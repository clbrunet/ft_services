FROM	alpine

WORKDIR	/root/

RUN		apk add --no-cache libc6-compat; \
		wget https://dl.grafana.com/oss/release/grafana-7.5.1.linux-amd64.tar.gz; \
		tar -zxvf grafana-7.5.1.linux-amd64.tar.gz;

COPY	./srcs/ ./

RUN		mv ./influxdb_datasource.yaml ./grafana-7.5.1/conf/provisioning/datasources/; \
		mv ./dashboard.yaml ./grafana-7.5.1/conf/provisioning/dashboards/;

EXPOSE	3000

CMD		["./start_grafana.sh"]
