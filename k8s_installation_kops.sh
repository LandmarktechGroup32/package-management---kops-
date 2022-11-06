#!/bin/bash

sudo apt update -y
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#install kops
curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops

#Install kubectl
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl


aws s3 mb s3://shifu.k8s.local
echo export NAME=shifu.k8s.local >> .bashrc
echo export KOPS_STATE_STORE=s3://shifu.k8s.local >> .bashrc
source .bashrc

yes '' | ssh-keygen -N ''

kops create cluster --zones ca-central-1a --networking calico --master-size t3.medium --master-count 1 --node-size t3.medium --node-count=2 ${NAME}
kops create secret --name ${NAME} sshpublickey admin -i ~/.ssh/id_rsa.pub
kops update cluster --name shifu.k8s.local --yes --admin
kops validate cluster
kubectl get nodes

# kops delete cluster --name=${NAME} --state=${KOPS_STATE_STORE} --yes 
