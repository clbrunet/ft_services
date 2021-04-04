FROM	alpine

WORKDIR	/root/

RUN		apk add --no-cache vsftpd ; \
		echo -ne "admin\nadmin\n" | adduser admin; echo "ftps is nice" > /home/admin/dl_testfile

COPY	./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

EXPOSE	21 20 21000-21009

CMD			["vsftpd", "/etc/vsftpd/vsftpd.conf"]
