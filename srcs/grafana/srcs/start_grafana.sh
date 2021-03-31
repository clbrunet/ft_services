#!/bin/sh

telegraf --config /root/telegraf.conf &> /root/telegraf.out &

cd /root/grafana-7.5.1
./bin/grafana-server
