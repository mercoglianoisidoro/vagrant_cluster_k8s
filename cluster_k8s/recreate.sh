#!/usr/bin/env bash
vagrant box update
vagrant destroy -f
./up.sh
