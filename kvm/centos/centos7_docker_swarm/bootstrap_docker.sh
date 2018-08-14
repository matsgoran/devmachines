#!/bin/sh
# boostrap_docker.sh - kubernetes requires docker 1.12

#Update yum
yum update
# Add the Docker public key for CE Docker Engine packages
rpm --import "https://sks-keyservers.net/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e"
# Install required packages. yum-utils provides the yum-config-manager utility,
#and device-mapper-persistent-data and lvm2 are required by the devicemapper storage driver.
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
# Add the Docker CE stable repository
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
# Install docker
yum install -y docker-ce
# Start the docker service
systemctl start docker
# Add user to docker group
usermod -a -G docker vagrant
