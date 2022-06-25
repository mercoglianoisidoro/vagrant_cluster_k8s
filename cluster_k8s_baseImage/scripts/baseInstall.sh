#!/bin/sh

ls -la /var/lib/dpkg

set -e


#install docker
echo "install docker"
apt-get update
apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io

usermod -aG docker $USER






##install kubeadm
echo "install kubeadm"
apt-get update && sudo apt-get install -y apt-transport-https curl


# from https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list



sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
# sudo apt-get install -y kubelet=1.20.1-00 kubeadm=1.20.1-00 kubectl=1.20.1-00

# https://github.com/kubernetes-sigs/cri-tools/issues/710
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo kubeadm config images pull

apt-get update
apt-get upgrade -y

exit 0
