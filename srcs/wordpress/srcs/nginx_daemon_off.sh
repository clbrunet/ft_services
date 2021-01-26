#!/bin/sh

rc-service nginx stop;
nginx -g "daemon off;";
