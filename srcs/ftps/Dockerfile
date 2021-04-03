FROM	alpine

WORKDIR	/root/

RUN		apk add --no-cache vsftpd; \
		echo -ne "\n\n" | adduser admin;

EXPOSE	21

CMD			["vsftpd"]
