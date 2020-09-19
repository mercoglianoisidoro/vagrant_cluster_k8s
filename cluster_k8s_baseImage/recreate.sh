#!/usr/bin/env bash

# vagrant box update

vagrant destroy -f
# rm cluster_k8s_baseImage.box
vagrant up
# vagrant package --output baseClusterImage.box




