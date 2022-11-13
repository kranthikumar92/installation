sudo apt install apt-transport-https curl -y

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
sudo mv ~/kubernetes.list /etc/apt/sources.list.d

sudo apt update
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
kubectl version --client && kubeadm version

sudo swapoff -a
sudo modprobe br_netfilter
sudo sysctl net.bridge.bridge-nf-call-iptables=1
lsmod | grep br_netfilter

sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{ "exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts":
{ "max-size": "100m" },
"storage-driver": "overlay2"
}
EOF

rm /etc/containerd/config.toml

systemctl restart containerd
systemctl restart docker
systemctl enable docker
systemctl daemon-reload
systemctl restart docker
