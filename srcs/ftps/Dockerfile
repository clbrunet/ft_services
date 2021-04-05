FROM	alpine

WORKDIR	/root/

RUN		apk add --no-cache vsftpd openssl; mkdir -p /usr/share/ssl/certs; \
		openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
		-keyout /usr/share/ssl/certs/vsftpd.pem -out /usr/share/ssl/certs/vsftpd.pem \
		-subj '/CN=192.168.49.2'; echo -ne "admin\nadmin\n" | adduser admin; \
		echo "ftps is nice" > /home/admin/dl_testfile; chown -R admin:admin /home/admin/;

COPY	./srcs/ ./

EXPOSE	21 20 21000-21009

CMD		["./vsftpd.sh"]
