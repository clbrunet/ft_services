#!/bin/bash

if [ $(nproc) -lt 2 ]; then
	echo "You need at least 2 CPUs"
	exit
fi
if ! groups | grep "docker" > /dev/null; then
	echo "Adding docker group to $(whoami)."
	sudo usermod -aG docker $(whoami)
	echo "The docker group has been added to $(whoami)."
	echo "Please restart the script."
	newgrp docker
	exit
fi

minikube delete
minikube start --driver=docker
minikube addons enable metrics-server
minikube addons enable dashboard
eval $(minikube -p minikube docker-env)

kubectl get configmap kube-proxy -n kube-system -o yaml | \
	sed -e "s/strictARP: false/strictARP: true/" | \
	kubectl apply -f - -n kube-system

ip=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' minikube)
sed --in-place "s/\(- \)\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\}/\1${ip}/" ./srcs/metallb/metallb_config.yaml
sed --in-place "s/\(https\?:\/\/\)\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\}/\1${ip}/g" ./srcs/nginx/srcs/index.html
sed --in-place "s/\(--url=\)\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\}\(:5050\)/\1${ip}\3/" ./srcs/wordpress/srcs/start_wordpress.sh

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f ./srcs/metallb/metallb_config.yaml

docker build -t clbrunet/mysql ./srcs/mysql/
kubectl apply -f ./srcs/mysql/mysql.yaml

docker build -t clbrunet/nginx ./srcs/nginx/
kubectl apply -f ./srcs/nginx/nginx.yaml

docker build -t clbrunet/phpmyadmin ./srcs/phpmyadmin/
kubectl apply -f ./srcs/phpmyadmin/phpmyadmin.yaml

docker build -t clbrunet/wordpress ./srcs/wordpress/
while [[ $(kubectl get pods -n metallb-system -l app=metallb -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True True"
	|| $(kubectl get pods -l app=mysql -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
	sleep 0.5;
done
kubectl apply -f ./srcs/wordpress/wordpress.yaml
