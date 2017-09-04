#!/bin/sh
# boostrap_docker.sh - kubernetes requires docker 1.12

#Update yum
yum update
# Add the Docker public key for CS Docker Engine packages
rpm --import "https://sks-keyservers.net/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e"
# Install yum-utils if necessary
yum install -y yum-utils
# Add the Docker repository
yum-config-manager --add-repo https://packages.docker.com/1.12/yum/repo/main/centos/7
# Install docker
yum makecache fast
yum install -y docker-engine
# Start the docker service
systemctl enable docker.service && systemctl start docker.service
# Add user to docker group
usermod -a -G docker vagrant
