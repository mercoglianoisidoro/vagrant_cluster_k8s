#!/usr/bin/env bash

cd cluster_k8s/
vagrant destroy -f
cd ..


cd cluster_k8s_baseImage
vagrant destroy -f
vagrant box update
rm cluster_k8s_baseImage.box  && true
rm cluster_k8s_baseImage_ubuntu_focal64.box && true
vagrant up
vagrant halt
vagrant package --output cluster_k8s_baseImage_ubuntu_focal64.box
vagrant destroy -f
cd ..

cd cluster_k8s/
vagrant destroy -f
./up.sh




