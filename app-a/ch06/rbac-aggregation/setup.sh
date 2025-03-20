#!/usr/bin/env bash

# Create SSL cert
mkdir cert && cd cert
sudo openssl genrsa -out ellasmith.key 2048
sudo openssl req -new -key ellasmith.key -out ellasmith.csr -subj "/CN=ellasmith/O=cka-study-guide"
sudo openssl x509 -req -in ellasmith.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out ellasmith.crt -days 364

# Create user and context
sudo kubectl config set-credentials ellasmith --client-certificate=ellasmith.crt --client-key=ellasmith.key
sudo kubectl config set-context ellasmith-context --cluster=kubernetes --user=ellasmith

# Create namespace
kubectl create namespace development