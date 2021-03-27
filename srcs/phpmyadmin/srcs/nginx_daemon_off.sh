#!/bin/sh

rc-service nginx stop &> /dev/null;
nginx -g "daemon off;";
