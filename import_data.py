import redis
import os
import sys

try:
    redis_host = os.environ['REDIS_HOST']
    redis_port = os.environ['REDIS_PORT']
    redis_password = os.environ['REDIS_PASSWORD']
except KeyError:
    redis_host = 'redis-12160.c51.ap-southeast-2-1.ec2.cloud.redislabs.com'
    if len(sys.argv) > 1:
        redis_password = sys.argv[1]
    else:
        print('redis_password must be defined')
        redis_host = redis_port= redis_password = ''
        sys.exit(0)
finally:
    redis_port = redis_host.split('.')[0].lstrip('redis-')
    r = redis.Redis(host=redis_host,port=redis_port,password=redis_password)

