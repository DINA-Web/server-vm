#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo "Setting hostname to dina-web-vm"
hostname dina-web-vm

echo "Install OS system requirements and security updates"
apt-get update > /dev/null
apt-get install -y unattended-upgrades git wget rdate > /dev/null
apt-get upgrade > /dev/null
dpkg-reconfigure -plow unattended-upgrades

echo "Synching time"
rdate -n dc1.nrm.se

echo "Setting up swap file"
dd if=/dev/zero of=/var/my_swap bs=1M count=4096
mkswap -f /var/my_swap
swapon /var/my_swap

echo "Adding DINA-WEB system user called dina"
useradd -p $(openssl passwd -1 $(cat /vagrant/.bitnami-pass)) dina
addgroup dina sudo
su dina -l -c /vagrant/dina_admin_setup_key.sh

echo "Installing bitnami open source server sw stacks"
# su dina -l -c /vagrant/bitnami-sw.sh

echo "Installing DINA-WEB system modules"
# su dina -l -c /vagrant/dina-src.sh

echo "Installing DINA-WEB system datasets"
# su dina -l -c /vagrant/dina-data.sh

echo "Install SSL certificates"
echo "...TODO..."
sleep 1s

echo "Installing firewall rules"
#iptables -t mangle -A PREROUTING -p tcp --dport 8080 -j MARK --set-mark 1
#iptables -t mangle -A PREROUTING -p tcp --dport 8443 -j MARK --set-mark 1
#iptables -t mangle -A PREROUTING -p tcp --dport 8090 -j MARK --set-mark 1
#iptables -A INPUT -p TCP -m mark --mark 1 -j REJECT --reject-with tcp-reset
iptables -t nat -I PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-ports 8080
iptables -t nat -I PREROUTING -i eth0 -p tcp --dport 443 -j REDIRECT --to-ports 8443
iptables -t nat -A OUTPUT -o lo -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -A OUTPUT -o lo -p tcp --dport 443 -j REDIRECT --to-port 8443
sleep 1s

echo "Configuring automatic startup of services"
echo "... use rc.local approach for portability..."
# cp /vagrant/etc/rc.local /etc/rc.local

echo "Configuring backups"
echo "Install and setup iRODS-commands deb"
echo "... TODO schedule w crontab calls to backup scripts under ~/bin"

echo "Done!"


