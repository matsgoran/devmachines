#!/bin/sh
# boostrap_docker.sh

#Update yum
yum update
# Docker 1.12 installation, https://docs.docker.com/cs-engine/1.12/#install-using-a-repository
rpm --import "https://sks-keyservers.net/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e"
yum install -y yum-utils
yum-config-manager --add-repo https://packages.docker.com/1.12/yum/repo/main/centos/7
yum makecache fast
yum install docker-engine
# Start docker
systemctl enable docker.service && systemctl start docker.service
# Add vagrant to docker group
usermod -a -G docker vagrant
