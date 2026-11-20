# Filtrage des accès avec `pg_hba.conf`
Documentation: https://www.postgresql.org/docs/19/auth-pg-hba-conf.html

Exemple de fichier `pg_hba.conf`:
```
local   all             postgres                                peer
# IPv4 local connections:
host    all             postgres             127.0.0.1/32            scram-sha-256
host    all             postgres        192.168.50.50/32       scram-sha-256
host    dbmedia         @dbmedia_users.conf             127.0.0.1/32        scram-sha-256
host    dbmedia         @dbmedia_users.conf             192.168.50.0/24        scram-sha-256
```

et fichier `@dbmedia_users.conf` (1 ligne par utilisateur):
```
umedia
fan
matth
```