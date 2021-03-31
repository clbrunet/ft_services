#!/bin/sh

rc-service influxdb stop
influxd run -config /etc/influxdb.conf
