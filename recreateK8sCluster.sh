#!/usr/bin/env bash

# vagrant box update

cd cluster_k8s_baseImage
vagrant destroy -f
rm cluster_k8s_baseImage.box
vagrant up
sleep 300
vagrant package --output cluster_k8s_baseImage.box
vagrant destroy -f
cd ..

cd cluster_k8s/
./recreate.sh




