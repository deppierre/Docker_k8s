#Setup rpm
sudo yum -y update &&\
sudo yum -y install docker git &&\
\
#Setup kubectl \
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" &&\
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl &&\
sudo usermod -aG docker $USER &&\
sudo groupadd -f docker &&\
sudo systemctl enable docker --now &&\
\
#Setup kind \
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64 &&\
chmod +x ./kind &&\
sudo mv ./kind /usr/bin/kind &&\
cat <<EOF | /usr/bin/kind create cluster -q --config -
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
EOF
#Setup OM \
/usr/local/bin/kubectl create namespace mongodb &&\
sudo su -c "cat <<EOF > /etc/profile.d/kubernetes.sh
#!/bin/bash
alias k=\"/usr/local/bin/kubectl\"
/usr/local/bin/kubectl config set-context $(/usr/local/bin/kubectl config current-context) --namespace=mongodb
EOF
" &&\
/usr/local/bin/kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/crds.yaml --namespace=mongodb &&\
/usr/local/bin/kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-enterprise-kubernetes/master/mongodb-enterprise.yaml --namespace=mongodb &&\
cat <<EOF | /usr/local/bin/kubectl apply -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: ops-manager-admin-secret
  namespace: mongodb
stringData:
  username: pierre.depretz@mongodb.com
  password: pierre
  firstName: Pierre
  lastName: Depretz 
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
