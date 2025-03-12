#!/usr/bin/env bash

NODE=$1
NODE_HOST_IP=20+$NODE

$(cat /vagrant/kubeadm-init.out | grep -A 2 "kubeadm join" | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')

cp /vagrant/admin.conf /etc/kubernetes/admin.conf
chmod ugo+r /etc/kubernetes/admin.conf
echo "KUBECONFIG=/etc/kubernetes/admin.conf" >> /etc/environment