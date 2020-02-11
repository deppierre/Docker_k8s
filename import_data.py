import redis
import os

try:
    redis_host = os.environ['REDIS_HOST']
    redis_port = os.environ['REDIS_PORT']
    redis_password = os.environ['REDIS_PASSWORD']
except KeyError as error:
    redis_host = 'redis-12160.c51.ap-southeast-2-1.ec2.cloud.redislabs.com'
    redis_password = 'PdZ0787#'
finally:
    redis_port = redis_host.split('.')[0].lstrip('redis-')


r = redis.Redis(host=redis_host,port=redis_port,password=redis_password)