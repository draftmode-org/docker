## docker-compose

### start mysql-server

```docker-compose up -d```

### remove persistent database/volume

```docker-compose down -v```

### create new database

```docker-compose exec -it {servicename} patch-db.sh {database}```

### create new user

```docker-compose exec -it {servicename} patch-user.sh {database} {user} {password} {grant-type}```

grant-type(s) are limited and covert by:
- mig (=ALL)
- app (=SELECT,UPDATE,INSERT,DELETE,EXECUTE)
- ro (=SELECT)