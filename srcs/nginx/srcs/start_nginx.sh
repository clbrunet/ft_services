#!/bin/sh

echo -e "nginx start [ongoing]"
rc-service nginx restart &> /dev/null;
if [ $? -eq 0 ]; then
	echo -e "\r\033[1A\033[Knginx start [done]"
else
	echo -e "\r\033[1A\033[Knginx start [failed]"
fi

exec "$@"
