
# Se connecter a un host:
mongo --host "192.168.103.100:27001" -u "m103-admin" -p "m103-pass" --authenticationDatabase "admin"

# Demarrer un mongod avec un fichier de conf
mongod -f <fichier de confi(/data/replica_set)>
