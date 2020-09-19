#!/usr/bin/env bash

set -e

vagrant up --provider virtualbox
vagrant ssh-config > ~/.ssh/config.d/vagrant-cluster

vagrant ssh vagrantclusterk8s-node1 -c "sudo -i systemctl daemon-reload && sudo -i service kubelet start"
vagrant ssh vagrantclusterk8s-node2 -c "sudo -i systemctl daemon-reload && sudo -i service kubelet start"
vagrant ssh vagrantclusterk8s-master -c "sudo -i systemctl daemon-reload && sudo -i service kubelet start"

vagrant ssh vagrantclusterk8s-master -c "kubectl get all --all-namespaces"


# KUBECONFIG=~/.kube/config:$(dirname $(pwd))/cluster_k8s/cluster_k8s_configs/kubeconfig_admin
echo "export KUBECONFIG=$KUBECONFIG" > kubectl_config.sh
echo "--------------------------------------------------------------"
echo "configuration to be set to connect to the server"
echo "export KUBECONFIG=$KUBECONFIG"
echo "--------------------------------------------------------------"
echo ""
echo ""
echo ""
echo "--------------------------------------------------------------"
echo "Here all the available ssh host"
vagrant ssh-config | grep "Host "
echo "--------------------------------------------------------------"

source kubectl_config.sh
kubectl config use-context kubernetes-admin@kubernetes
kubectl get pods --all-namespaces
