# PostgreSQL

## Install PostgreSQL Server
Follow instructions from [www.postgresql.org/download](www.postgresql.org/download)

## Base dbmovie (petite taille)
Dans le répertoire scripts:
- pour docker : `docker-compose-up.ps1|sh`
    * possibilité de personnalisation avec un fichier `.env` (modèle `.env-sample`)
    * si user et password personnalisés, renouveler le `.pgpass` avec `update-cfg-pgadmin.ps1|sh`
- pour windows ou linux: `00-import-dbmovie.sql` 
    * add options `-h <host>` or  `-p <port>` if necessary: 
```sh
psql -U postgres -f  00-import-dbmovie.sql
```

## CLI psql
```sh
psql     # user = user OS
psql -U postgres   # defaults: host = localhost ; port = 5432 ; dbname = user
psql -U postgres -p 5432 -h localhost -d postgres
```

Commandes psql
```psql
\l        -- list of datbases
\d        -- list of tables
\q        -- quit
```

## Réseau
Visualiser interface réseau + port
```sh
netstat -ano  # windows
ss -plantu    # linux
```
