# Docker_k8s
This is a projet to manipulate Redis en MongoDB Cluster (Atlas)

To init new Git dir:
```
git init
git remote add origin https://github.com/deppierre/Docker_k8s.git
git checkout master
git branch --set-upstream-to=origin/master
git add .
git commit -am 'push'
git push origin master
```
1. To recreate a MongoDB container:
- delete:
```
docker rm mongo_server -f && docker rmi deppierre/mongodb_server
```
- Rebuild the Dockerfile and run:
```
docker build -t deppierre/mongodb_server . -q
docker run -d --name mongo_server --memory 800MB deppierre/mongodb_server
```

2. To recreate a Redis container
- delete:
```
docker rm redis_server -f && docker rmi deppierre/redis_server
```

- Rebuild the Dockerfile and run:
```
docker build -t deppierre/redis_server . -q
docker run -d --name redis_server -ti --memory 800MB deppierre/redis_server
```

3. To push to Docker repository:
```
docker push deppierre/redis_server
docker push deppierre/mongodb_server
```
