## docker-compose

### start mysql-server

```docker-compose up -d```

### remove persistent database/volume

```docker-compose down -v```

### create database

```docker-compose exec -it {servicename} create-db {database}```

### create user and grant permissions

```docker-compose exec -it {servicename} create-user --database={database} --user={user} --password={password} --grant={grant}```

grant-types(s) are limited and covert by:
- migration (=ALL)
- application (=SELECT,UPDATE,INSERT,DELETE,EXECUTE)
- readonly (=SELECT)