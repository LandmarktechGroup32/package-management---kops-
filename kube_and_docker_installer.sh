#!/bin/bash

# First, login as ‘root’ user because the following set of commands need to be executed with ‘sudo’ permissions.

sudo su -

# Install Required packages and apt keys.

apt-get update -y
apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update -y



#Turn Off Swap Space

swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

modprobe br_netfilter
sysctl -p
sudo sysctl net.bridge.bridge-nf-call-iptables=1

# Install And Enable Docker

apt install docker.io -y
usermod -aG docker ubuntu
systemctl restart docker
systemctl enable docker.service


#Install kubeadm, Kubelet And Kubectl

apt-get install -y kubelet kubeadm kubectl kubernetes-cni

# Enable and start kubelet service

systemctl daemon-reload
systemctl start kubelet
systemctl enable kubelet.service
