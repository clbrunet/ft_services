#!/bin/sh

rc-service nginx start &> /dev/null;
rc-service nginx stop &> /dev/null;

exec "$@"
