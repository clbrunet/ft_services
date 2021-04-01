#!/bin/sh

rc-service influxdb start
while ! influx < ./influxdb_script.iql; do
	sleep 0.2;
done

exec "$@"
