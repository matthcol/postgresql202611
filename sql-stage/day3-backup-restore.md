

## Sauvegarde OS à froid
TODO : compléter ici

## Dumps
Outils : 
- pg_dump    : 1 base avec 1 grain +/- grand
- pg_dumpall : tout le serveur (toutes les bases), tous les user/role(s)

Liste des users et roles
```sh
pg_dumpall -U postgres -l postgres -r -f backup-roles.dump
```

Backup avec pg_dump:
```sh
pg_dump -U postgres -d dbmovie -f backup-dbmovie-plain.dump 
```

Reimport
```sh
psql -U postgres -d postgres # maintenance
    # create database dbmovie encoding 'UTF-8';
psql -U postgres -d dbmovie -f .\backup-dbmovie-plain.dump
psql -U umovie -d dbmovie 
    # select count(*) from play;
```

Dump partiel
```sh
# data only
pg_dump -U postgres -d dbmovie -a -f backup-dbmovie-data-plain.dump 
pg_dump -U postgres -d dbmovie -a  --inserts -f backup-dbmovie-data-i-plain.dump 

# ddl only
pg_dump -U postgres -d dbmovie -s -f backup-dbmovie-ddl-plain.dump

# choisir un grain
pg_dump -U postgres -d dbmovie -n nsmovie -f backup-nsmovie-plain.dump
pg_dump -U umovie -d dbmovie -t movie -t person -f backup-2-tables-plain.dump
```

Format Postgresql : custom (c), tar (t), directory (d)
```sh
pg_dump -U postgres -d dbmovie -F c -f backup-dbmovie-custom.dump
pg_dump -U postgres -d dbmovie -F c -Z 0 -f backup-dbmovie-custom-0.dump  # + outil externe de compression (7z, winzip, rar, ..)
pg_dump -U postgres -d dbmovie -F c -Z 9 -f backup-dbmovie-custom-9.dump

pg_dump -U postgres -d dbmovie -F d  -f backup-dbmovie-custom-dir
pg_dump -U postgres -d dbmovie -F t  -f backup-dbmovie-custom.tar
```

Restore backup binaire:
```sh
# complet
pg_restore -U postgres -d dbmovie -v backup-dbmovie-custom-9.dump
# partiel
pg_restore -U postgres -d dbmovie -v -n nsmovie -t play backup-dbmovie-custom-9.dump
```

## Base BAckup + PITR
```sh
pg_basebackup -U postgres -D .\backup\base\2026-11-20\
```

backup des Wals, postgresql.conf:
```
archive_mode = on
archive_command = 'copy  %p C:\\Backup\\archive_wal\\%f'
```
