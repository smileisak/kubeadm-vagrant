#/!bin/sh

sudo yum install -y wget
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

# Ports activation
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10251/tcp
sudo firewall-cmd --permanent --add-port=10252/tcp
sudo firewall-cmd --permanent --add-port=10255/tcp
firewall-cmd --permanent --add-port=8443/tcp
sudo firewall-cmd -–reload

#Disable Swap
swapoff -a

echo "###################"
echo "# Install docker  #"
echo "###################"

sudo yum remove docker \
                  docker-common \
                  docker-selinux \
                  docker-engine

sudo yum install -y yum-utils device-mapper-persistent-data lvm2

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

#Optionnal
sudo yum-config-manager --enable docker-ce-edge

sudo yum-config-manager --enable docker-ce-test

# You can disable edge repository by running this command
#sudo yum-config-manager --disable docker-ce-edge

sudo yum makecache fast
sudo yum install -y docker-ce

sudo systemctl start docker
sudo systemctl enable docker


echo "###################"
echo "# Install kubectl #"
echo "###################"

wget https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl


echo "###############################"
echo "# Install kubelet and kubeadm #"
echo "###############################"

sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo yum -y update
setenforce 0
sudo yum install -y kubelet kubeadm
systemctl enable kubelet && systemctl start kubelet
