#!/bin/bash

minikube delete
minikube start
minikube addons enable metrics-server
minikube addons enable dashboard
eval $(minikube -p minikube docker-env)

kubectl get configmap kube-proxy -n kube-system -o yaml | \
	sed -e "s/strictARP: false/strictARP: true/" | \
	kubectl apply -f - -n kube-system
sed --in-place "s/\(- \)\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\}/\1$(minikube ip)/" ./srcs/metallb/metallb_config.yaml
sed --in-place "s/\(--url=\)\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\}\(:5050\)/\1$(minikube ip)\3/" ./srcs/wordpress/Dockerfile

docker build -t clbrunet/nginx ./srcs/nginx/
docker build -t clbrunet/wordpress ./srcs/wordpress/

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f ./srcs/metallb/metallb_config.yaml

kubectl apply -f ./srcs/nginx/nginx.yaml
kubectl apply -f ./srcs/wordpress/wordpress.yaml
