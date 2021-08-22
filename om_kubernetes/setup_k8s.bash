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
cat <<EOF | kind create cluster --config -
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
  extraPortMappings:
    - containerPort: 30843
      hostPort: 8443
      protocol: TCP
    - containerPort: 27017 
      hostPort: 27017
      protocol: TCP
    - containerPort: 27018
      hostPort: 27018
      protocol: TCP
    - containerPort: 27019
      hostPort: 27019
      protocol: TCP
    - containerPort: 30080
      hostPort: 8080
      protocol: TCP
- role: worker
EOF &&\
\
#Setup OM \
kubectl create namespace mongodb &&\
kubectl apply -f /tmp/kubernetes_operator/crds.yaml --namespace=mongodb &&\
kubectl apply -f /tmp/kubernetes_operator/mongodb-enterprise.yaml --namespace=mongodb &&\
kubectl create secret generic ops-manager-admin-secret --from-literal=Username="pierre.depretz@mongodb.com" --from-literal=Password="pierre" --from-literal=FirstName="Pierre" --from-literal=LastName="Depretz" -n mongodb &&\
cat <<EOF | kubectl apply -f -
---
apiVersion: mongodb.com/v1
kind: MongoDBOpsManager
metadata:
  name: ops-manager-external
  namespace: mongodb
spec:
  replicas: 1
  version: 5.0.0
  adminCredentials: ops-manager-admin-secret
  externalConnectivity:
    type: NodePort
    port: 30080
    externalTrafficPolicy: Local
  configuration:
    mms.ignoreInitialUiSetup: "true"
    automation.versions.source: mongodb
    mms.adminEmailAddr: support@example.com
    mms.fromEmailAddr: support@example.com
    mms.replyToEmailAddr: support@example.com
    mms.mail.hostname: support@localhost
    mms.mail.port: "465"
    mms.mail.ssl: "true"
    mms.mail.transport: smtp
    mms.minimumTLSVersion: TLSv1.2
  backup:
    enabled: false
  applicationDatabase:
    version: "4.4.4-ent"
    members: 3
EOF