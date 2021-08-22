#Setup rpm
sudo yum -y update &&\
sudo yum -y install docker git &&\
\
#Fetch confs
git clone https://github.com/mongodb/mongodb-enterprise-kubernetes /tmp/kubernetes_operator &&\
git clone https://github.com/deppierre/Docker_k8s.git /tmp/conf &&\
\
#Setup kubectl \
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&\
sudo usermod -aG docker $USER && newgrp docker &&\
sudo systemctl enable docker --now &&\
sudo cp /tmp/kubernetes_operator/alias.sh /etc/profile.d/kubernetes.sh
#Setup kind \
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64 &&\
chmod +x ./kind &&\
sudo mv ./kind /usr/bin/kind &&\
kind create cluster --config /tmp/conf/om_kubernetes/kind-config.yaml &&\
\
#Setup MDB OM \
kubectl create namespace mongodb &&\
kubectl apply -f /tmp/kubernetes_operator/crds.yaml --namespace=mongodb &&\
kubectl apply -f /tmp/kubernetes_operator/mongodb-enterprise.yaml --namespace=mongodb &&\
kubectl create secret generic ops-manager-admin-secret --from-literal=Username="pierre.depretz@mongodb.com" --from-literal=Password="pierre" --from-literal=FirstName="Pierre" --from-literal=LastName="Depretz" -n mongodb &&\
kubectl apply -f /tmp/conf/om_kubernetes/ops-manager-external.yaml