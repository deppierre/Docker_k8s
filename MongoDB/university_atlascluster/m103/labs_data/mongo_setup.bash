mongo admin --host localhost:27001 --eval '
   db.createUser({
     user: "m103-admin",
     pwd: "m103-pass",
     roles: [
       {role: "root", db: "admin"}
     ]
   })
 '
