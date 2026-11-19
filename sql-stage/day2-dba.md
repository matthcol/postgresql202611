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

# edit postgresql.conf  => port 5452
pg_ctl start -D "C:\Database\data-media"
pg_ctl stop -D "C:\Database\data-media"

psql -U postgres -p 5452
```

NB: en prod utiliser un user de service qui est propriétaire du répertoire data
  et créer le service avec pg_ctl