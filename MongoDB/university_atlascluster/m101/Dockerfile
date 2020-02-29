FROM mongo
ENV mongodb_university_user="m001-student"
ENV mongodb_university_password="m001-mongodb-basics"
RUN apt-get update && \
    apt-get install wget -y && \
    mkdir /M001 && \
    echo "mongo \"mongodb://cluster0-shard-00-00-jxeqq.mongodb.net:27017,cluster0-shard-00-01-jxeqq.mongodb.net:27017,cluster0-shard-00-02-jxeqq.mongodb.net:27017/test?replicaSet=Cluster0-shard-0\" --authenticationDatabase admin --ssl --username $mongodb_university_user --password $mongodb_university_password" > /M001/mongo_university_chain.sh && \
    echo "mongo \"mongodb+srv://sandbox-x5alo.mongodb.net/test\" --authenticationDatabase admin --ssl --username $mongodb_university_user --password $mongodb_university_password" > /M001/mongo_atlas_chain.sh && \
    chmod +x /M001/mongo_university_chain.sh && chmod +x /M001/mongo_atlas_chain.sh && \
    ln -s /M001/mongo_university_chain.sh /bin/mongodbu && ln -s /M001/mongo_atlas_chain.sh /bin/mongodba && \
    wget https://github.com/deppierre/Docker_k8s/raw/master/MongoDB/university_atlascluster/dataset_mongo.tar -O /M001/dataset_mongo.tar && tar xvf /M001/dataset_mongo.tar -C /M001