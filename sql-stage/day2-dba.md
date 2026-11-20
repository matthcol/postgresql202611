# Création d'une 2e instance

# windows
Avec user normal en ayant crée avec ce même user `C:\Database\`

```sh
& "C:\Program Files\PostgreSQL\18\bin\initdb.exe" `
  -D "C:\Database\data-media" `
  -U "postgres" `
  -E UTF8 `
  --locale=French_France.1252 `
  -W
# -U user dba 
# -W demande interactive de mot de passe

# edit postgresql.conf 
#    => port 5452
#    => wal_level = minimal   # pour import alllégé côté WAL 
#    => max_wal_senders = 0   # pour import alllégé côté WAL
pg_ctl start -D "C:\Database\data-media"   # + log
#pg_ctl stop -D "C:\Database\data-media"

cd sql-init-dbmedia
psql -U postgres -p 5452  # test connexion
psql -U postgres -p 5452 -f 00-import-dbmedia.sql

# check again
psql -U umedia -d dbmedia -p 5452 -f 99-checkup.sq!l
```

NB: en prod utiliser un user de service qui est propriétaire du répertoire data
  et créer le service avec pg_ctl