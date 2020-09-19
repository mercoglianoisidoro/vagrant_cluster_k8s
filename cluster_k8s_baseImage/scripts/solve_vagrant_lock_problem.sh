#!/bin/sh

echo "removing automatic upgrade causing random problem on apt actions"
sed -i 's/1/0/' /etc/apt/apt.conf.d/20auto-upgrades
# from:
# https://askubuntu.com/questions/1059971/disable-updates-from-command-line-in-ubuntu-16-04
# https://askubuntu.com/questions/1057458/how-to-remove-ubuntus-automatic-internet-connection-needs/1057463#1057463
systemctl disable --now apt-daily{,-upgrade}.{timer,service}
#note: this doens't work :https://medium.com/@koalallama/vagrant-up-failing-could-not-get-lock-var-lib-dpkg-lock-13c73225782d
mkdir -p /etc/systemd/system/apt-daily.timer.d/
touch /etc/systemd/system/apt-daily.timer.d/apt-daily.timer.conf
cat /etc/systemd/system/apt-daily.timer.d/apt-daily.timer.conf
echo "
[Timer]
Persistent=false
" >> /etc/systemd/system/apt-daily.timer.d/apt-daily.timer.conf
systemctl stop apt-daily.timer

