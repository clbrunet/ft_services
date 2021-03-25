#!/bin/bash

minikube delete
minikube start
minikube addons enable metrics-server
minikube addons enable dashboard
eval $(minikube -p minikube docker-env)

docker build -t clbrunet/nginx ./srcs/nginx/
docker build -t clbrunet/wordpress ./srcs/wordpress/

kubectl get configmap kube-proxy -n kube-system -o yaml | \
	sed -e "s/strictARP: false/strictARP: true/" | \
	kubectl apply -f - -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.6/manifests/metallb.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
sed --in-place "s/\([[:digit:]]\{1,3\}\.\)\{3\}[[:digit:]]\{1,3\}/$(minikube ip)/g" srcs/metallb/metallb_config.yaml
kubectl apply -f ./srcs/metallb/metallb_config.yaml

kubectl apply -f ./srcs/nginx/nginx.yaml
kubectl apply -f ./srcs/wordpress/wordpress.yaml
