sudo yum -y update &&\
sudo yum -y install docker git &&\
\
#Setup kubectl \
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&\
sudo usermod -aG docker $USER && newgrp docker &&\
sudo systemctl enable docker --now &&\
sudo su -c "echo \"alias k='kubectl'\" > /etc/profile.d/kubernetes.sh" &&\
\
#Setup Kind \
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64 &&\
chmod +x ./kind &&\
sudo mv ./kind /usr/bin/kind &&\
kind create cluster --config $(wget -qO- https://raw.githubusercontent.com/deppierre/Docker_k8s/master/kind_config.yaml)
