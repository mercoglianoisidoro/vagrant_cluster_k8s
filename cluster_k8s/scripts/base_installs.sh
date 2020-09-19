#!/bin/sh

set -e

echo "------------------------------------------------------------- base_install.sh"


#disable swap, needed by kubernetes
echo "disable swap"
sed -i  '/swap/d' /etc/fstab
swapoff -a


#set hosts
echo "set hots"
cat >> /etc/hosts <<EOF
192.168.1.180  vagrantcluster-master
192.168.1.181  vagrantcluster-node1
192.168.1.182  vagrantcluster-node2
EOF


# bash completition for
echo "installing bash completition"
#local user
echo "source <(kubectl completion bash)" >> ~/.bashrc
echo "alias k=kubectl" >> ~/.bashrc
echo "complete -F __start_kubectl k" >> ~/.bashrc
#vagrant user
echo "source <(kubectl completion bash)" >> /home/vagrant/.bashrc
echo "alias k=kubectl" >> /home/vagrant/.bashrc
echo "complete -F __start_kubectl k" >> /home/vagrant/.bashrc


exit 0;
