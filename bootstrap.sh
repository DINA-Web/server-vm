#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

echo "Install OS system requirements and security updates"
apt-get update
apt-get install -y unattended-upgrades git wget rdate
apt-get upgrade
dpkg-reconfigure -plow unattended-upgrades

echo "Synching time"
rdate -n dc1.nrm.se

echo "Setting up swap file"
dd if=/dev/zero of=/var/my_swap bs=1M count=4096
mkswap -f /var/my_swap
swapon /var/my_swap

echo "Setting up bitnami open source server sw stacks"
echo "...TODO..."

echo "Installing DINA-WEB system modules"
echo "...TODO..."

echo "Installing DINA-WEB system datasets"
echo "...TODO..."

echo "Done"
