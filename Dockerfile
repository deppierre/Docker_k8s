#docker build --build-arg redis_password= -t deppierre/database_lab:redis_client . --force-rm
#docker run --name redis_client -ti --rm deppierre/database_lab:redis_client sh
#docker push deppierre/database_lab:redis_client
FROM alpine
ARG redis_password
ENV REDIS_PORT="12160"
ENV REDIS_HOST="redis-12160.c51.ap-southeast-2-1.ec2.cloud.redislabs.com"
ENV REDIS_PASSWORD=${redis_password}
RUN apk update && \
#SETUP PACKAGES
    apk add redis && \
    apk add python3 && \
    apk add git && \
    pip3 install redis --disable-pip-version-check && \
    cd /tmp && git clone https://github.com/deppierre/Docker_k8s.git && \
    cd /tmp/Docker_k8s && python3 import_data.py
CMD redis-cli -h $REDIS_HOST -p $REDIS_PORT -a $REDIS_PASSWORD ping