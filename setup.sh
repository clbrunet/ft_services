#!/bin/bash

if [ $(nproc) -lt 2 ]; then
	echo "You need at least 2 CPUs"
	exit
fi
echo "Setup docker permissions."
sudo chmod 777 /var/run/docker.sock
if systemctl is-active --quiet nginx.service; then
	echo "Stopping local nginx."
	sudo /etc/init.d/nginx stop > /dev/null
	echo "Local nginx stopped."
fi

minikube delete
minikube start --driver=docker
ip=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' minikube)
if ! [[ $ip =~ ^([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}$ ]]; then
	echo "Docker supplies a wrong ip: \"$ip\"."
	exit
fi
minikube addons enable metrics-server
minikube addons enable dashboard

kubectl get configmap kube-proxy -n kube-system -o yaml | \
	sed -e "s/strictARP: false/strictARP: true/" | \
	kubectl apply -f - -n kube-system
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f ./srcs/metallb/metallb_config.yaml

ip_regex="\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\}"
sed --in-place "s/${ip_regex}/${ip}/g" ./srcs/metallb/metallb_config.yaml
sed --in-place "s/${ip_regex}/${ip}/g" ./srcs/nginx/Dockerfile
sed --in-place "s/${ip_regex}/${ip}/g" ./srcs/nginx/srcs/nginx.conf
sed --in-place "s/${ip_regex}/${ip}/g" ./srcs/nginx/srcs/index.html
sed --in-place "s/${ip_regex}/${ip}/g" ./srcs/ftps/Dockerfile
sed --in-place "s/${ip_regex}/${ip}/g" ./srcs/ftps/srcs/vsftpd.conf
sed --in-place "s/${ip_regex}/${ip}/g" ./srcs/wordpress/srcs/entrypoint.sh

eval $(minikube -p minikube docker-env)

docker build -t clbrunet/influxdb ./srcs/influxdb/
kubectl apply -f ./srcs/influxdb/influxdb.yaml

docker build -t clbrunet/mysql ./srcs/mysql/
kubectl apply -f ./srcs/mysql/mysql.yaml

docker build -t clbrunet/telegraf ./srcs/telegraf/
kubectl apply -f ./srcs/telegraf/telegraf.yaml

docker build -t clbrunet/grafana ./srcs/grafana/
kubectl apply -f ./srcs/grafana/grafana.yaml

docker build -t clbrunet/phpmyadmin ./srcs/phpmyadmin/
kubectl apply -f ./srcs/phpmyadmin/phpmyadmin.yaml

docker build -t clbrunet/ftps ./srcs/ftps/
kubectl apply -f ./srcs/ftps/ftps.yaml

docker build -t clbrunet/nginx ./srcs/nginx/
kubectl apply -f ./srcs/nginx/nginx.yaml

docker build -t clbrunet/wordpress ./srcs/wordpress/
while [[ $(kubectl get pods -n metallb-system -l app=metallb -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True True"
	|| $(kubectl get pods -l app=mysql -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
	sleep 0.2;
done
kubectl apply -f ./srcs/wordpress/wordpress.yaml

minikube dashboard
