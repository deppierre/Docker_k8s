# Learning NoSQL with Docker
This is a projet to manipulate Redis and MongoDB Cluster (Atlas) within handy containers

To use this Git repo:
```
git init
git remote add origin https://github.com/deppierre/Docker_k8s.git
git checkout master
git branch --set-upstream-to=origin/master
git add .
git commit -am 'push'
git push origin master
```
# 1. To build a MongoDB container:

## 1. Container for m101:
- Build the Dockerfile and run:
```
docker build -t deppierre/mongodb_server_m101 . -q
docker run -d --name mongo_server --memory 800MB deppierre/mongodb_server_m101
```
- delete:
```
docker rm mongodb_server_m101 -f && docker rmi deppierre/mongodb_server_m101
```

## 2. Container for m103
- Build the Dockerfile and run via docker-compose:
```
docker-compose build && docker-compose up -d
```
- delete:
```
docker-compose down --volumes
```

2. To create a Redis container

- Build the Dockerfile and run:
```
docker build -t deppierre/redis_server . -q
#start the container
docker run -d --name redis_server --memory 800MB deppierre/redis_server
#Import sample data
docker exec redis_server /bin/sh -c 'cat /tmp/country.csv | redis-cli --pipe'
```

- delete:
```
docker rm redis_server -f && docker rmi deppierre/redis_server
```

3. To push to Docker repository:
```
docker push deppierre/redis_server
docker push deppierre/mongodb_server
```
