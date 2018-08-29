#!/bin/sh
# boostrap_kubernetes.sh

#Disable swap (No swap under kubernetes)
swapoff -a
lvremove -Ay /dev/centos/swap
# Fetch the latest version of kubernetes kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
# Make kubectl executable
chmod +x ./kubectl
# Move kubectl into $PATH
mv ./kubectl /usr/local/bin/kubectl
# Add kubelet and kubeadm to yum repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
# Disabling SELinux by running setenforce 0 is required to allow containers to access the host filesystem, which is required by pod networks for example.
setenforce 0
# Install kubelet and kubeadm
yum install -y kubelet kubeadm
# Workaround for issue https://github.com/kubernetes/kubernetes/issues/43805 ()
sed -i 's#Environment="KUBELET_CGROUP_ARGS=-.*#Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"#g' \
    /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
# Start kubelet
systemctl enable kubelet.service && systemctl start kubelet.service
# Kubernetes requires that bridge-nf-call-iptables is enabled
echo 'net.bridge.bridge-nf-call-iptables = 1' >> /etc/sysctl.conf
sysctl -p
# Initialize kuberentes master with kube-router pod network
kubeadm init --pod-network-cidr 10.244.0.0/16 --token-ttl 0
# Configure kube for user vagrant
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
# Install Flannel pod network
sudo -u vagrant kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sudo -u vagrant kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel-rbac.yml
# Schedule pods on the master (single node cluster)
sudo -u vagrant kubectl taint nodes --all node-role.kubernetes.io/master-
# Deploy Dashboard UI
sudo -u vagrant kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
# Deploy traefik ingress controller - https://docs.traefik.io/user-guide/kubernetes/
# RBAC configured cluster - allow traefik to use kubernetes API
sudo -u vagrant kubectl create -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml
# Deploy traefik using Deployment
sudo -u vagrant kubectl create -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-deployment.yaml
# Install helm - workaround manipulate paths so install script is happy
sudo -- bash -c 'export PATH=/usr/local/bin:$PATH && curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash'
# Setup service account for tiller in kube cluster (Cluster is running in RBAC mode) ref. https://docs.bitnami.com/kubernetes/how-to/configure-rbac-in-your-kubernetes-cluster/
sudo -u vagrant kubectl create sa tiller --namespace kube-system
sudo -u vagrant kubectl create -f - <<EOF
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1beta1
metadata:
  name: tiller-clusterrolebinding
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: ""
EOF
# Install Tiller in cluster
sudo -u vagrant -- bash -c 'export PATH=/usr/local/bin:$PATH && helm init --service-account tiller --upgrade'
