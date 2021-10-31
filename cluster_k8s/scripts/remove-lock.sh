#!/bin/sh


echo "checking apt and dpkg processes, this can take some time"

# this is needed by a problem in the image
while pgrep apt > /dev/null; do  echo "waiting for apt to finish" && sleep 10; done
while pgrep apt-get > /dev/null;do  echo "waiting for apt-get to finish" && sleep 10; done
while pgrep dpkg > /dev/null; do  echo "waiting for dpkg to finish" && sleep 10; done


# if pgrep "apt" >/dev/null 2>&1 ; then
#     echo "apt is running, cant' continue"
#     exit 1
# fi

# if pgrep "apt-get" >/dev/null 2>&1 ; then
#     echo "apt-get is running, cant' continue"
#     exit 1
# fi

# if pgrep "dpkg" >/dev/null 2>&1 ; then
#     echo "dpkg is running, cant' continue"
#     exit 1
# fi

echo "remove apt lock if existing"
rm -rf /var/lib/dpkg/lock*
rm /var/lib/apt/lists/lock

# -exec rm -R {} \;

echo "apt lists"
ls -la /var/lib/apt/lists/

echo "apt update"
dpkg --configure -a
apt-get update
apt-get upgrade -y

echo "isidoro"
ls -la /var/lib/apt/lists/