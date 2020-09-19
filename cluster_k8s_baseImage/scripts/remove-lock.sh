#!/bin/sh


#this is to solve a locking problem coming from the image

echo "checking apt and dpkg processes"

while pgrep apt > /dev/null; do  echo "waiting for apt to finish" && sleep 10; done
while pgrep apt-get > /dev/null;do  echo "waiting for apt-get to finish" && sleep 10; done
while pgrep dpkg > /dev/null; do  echo "waiting for dpkg to finish" && sleep 10; done


echo "remove apt lock if existing"
rm -rf /var/lib/dpkg/lock*
rm /var/lib/apt/lists/lock

# -exec rm -R {} \;

echo "apt update"
dpkg --configure -a
apt-get update
apt-get upgrade -y
