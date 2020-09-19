#!/bin/sh

echo "------------------------------------------------------------- install-worker.sh"
kubeadm reset -f
#join to the cluster
sh /vagrant/tmp/master-join-command.sh
systemctl daemon-reload
service kubelet start

#kubelet conf
sed -i "s#/usr/bin/kubelet#/usr/bin/kubelet --node-ip=$ip#" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl daemon-reload && service kubelet start


