#!/bin/sh




echo "------------------------------------------------------------- install_master.sh"

set -e



#inspired by:
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/


echo "install etcd-client"
apt-get update
apt-get install -y etcd-client


echo "kubeadm reset"
kubeadm reset -f
rm /etc/containerd/config.toml
systemctl restart containerd
echo "kubeadm init"
kubeadm init --apiserver-advertise-address=192.168.1.180 --pod-network-cidr=10.217.0.0/16

#--pod-network-cidr=10.217.0.0/16
# --pod-network-cidr=192.168.1.0/16

# store join command to be accessed by nodes
echo "store join command to be accessed by nodes"
mkdir -p /vagrant/tmp/
kubeadm token create --print-join-command --ttl 0 > /vagrant/tmp/master-join-command.sh

# conf for kubelet
echo "prepare conf for kubelet"
sed -i "s#/usr/bin/kubelet#/usr/bin/kubelet --node-ip=$ip#" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload
service kubelet start

# $HOME/.kube
mkdir -p $HOME/.kube
sudo cp -Rf /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube
sudo chown $(id -u):$(id -g) $HOME/.kube/config


#export conf: export conf to be used outside de virtual host
if [ -e "/vagrant/cluster_k8s_configs" ];then rm -rf /vagrant/cluster_k8s_configs ; fi
mkdir -p /vagrant/cluster_k8s_configs
sudo cp $HOME/.kube/config /vagrant/cluster_k8s_configs/kubeconfig_admin
sed -i "s/kubernetes-admin@kubernetes/kubernetes-admin@vagrantkubernetes/" /vagrant/cluster_k8s_configs/kubeconfig_admin
sed -i "s/name: kubernetes/name: vagrantkubernetes/" /vagrant/cluster_k8s_configs/kubeconfig_admin
sed -i "s/cluster: kubernetes/cluster: vagrantkubernetes/" /vagrant/cluster_k8s_configs/kubeconfig_admin
sed -i "s/user: kubernetes-admin/user: vagrantkubernetes-admin/" /vagrant/cluster_k8s_configs/kubeconfig_admin

#kubelet conf: TODO: move above
#--enable-aggregator-routing=true
#sed -i "s/- kube-apiserver/- kube-apiserver --enable-aggregator-routing=true/" /etc/kubernetes/manifests/kube-apiserver.yaml
sed -i "s/- kube-apiserver/- kube-apiserver\\
    - --enable-aggregator-routing=true/" /etc/kubernetes/manifests/kube-apiserver.yaml
systemctl daemon-reload && service kubelet restart

mkdir -p /home/vagrant/.kube
cp /root/.kube/config /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

# cp /vagrant/certs/id_rsa /root/.ssh/id_rsa
# cp /vagrant/certs/id_rsa.pub /root/.ssh/id_rsa.pub
# chmod 400 /root/.ssh/id_rsa
# chmod 400 /root/.ssh/id_rsa.pub



#network:
# calico:  (must review conf for kubeam init if activated)
#kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml
#cilium: (must review conf for kubeam init if activated)
#kubectl create -f https://raw.githubusercontent.com/cilium/cilium/v1.6/install/kubernetes/quick-install.yaml
#weave:
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"


#tests
# calico + --pod-network-cidr=192.168.0.0/16 => bho
# calico + senza --pod-network-cidr => bhp
# cilium +  --pod-network-cidr=10.217.0.0/16 bho
# weave  +--pod-network-cidr=10.217.0.0/16 => SIIIII



#metric server

kubectl apply -f /vagrant/scripts/metric-server-v0.5.0_edited.yaml

#dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
