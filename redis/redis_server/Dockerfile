FROM redis
RUN apt-get update && \
    apt-get install \ 
    wget -y && \
    cd /tmp && \
    wget 'https://raw.githubusercontent.com/deppierre/Docker_k8s/master/redis/redis_dataset/country.csv'
CMD redis-server