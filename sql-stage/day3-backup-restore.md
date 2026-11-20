# Backup and Restore
https://www.postgresql.org/docs/19/backup.html

## Sauvegarde OS à froid
Base arrétée, n'importe quel outil de backup du répertoire PGDATA (cp, copy, tar, rsync, scp, ...).

Pour la restauration:
- recopier le dossier
- bien vérifier les droits des fichiers
- (re)démarrer la base

## Dumps
Outils : 
- pg_dump    : 1 base avec 1 grain +/- grand
- pg_dumpall : tout le serveur (toutes les bases), tous les user/role(s)

### Exporter users et roles avec pg_dumpall
```sh
pg_dumpall -U postgres -l postgres -r -f backup-roles.dump
```

### Exemples de dump avec pg_dump
#### Backup complet au format plain text (SQL et psql commands)
```sh
pg_dump -U postgres -d dbmovie -f backup-dbmovie-plain.dump 
```

#### Reimport format plain
Au format plain, les restaurations se font avec l'outil psql.
```sh
psql -U postgres -d postgres # maintenance
    # create database dbmovie encoding 'UTF-8';
psql -U postgres -d dbmovie -f .\backup-dbmovie-plain.dump
psql -U umovie -d dbmovie 
    # select count(*) from play;
```

### Dump partiel
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

### Format Postgresql : custom (c), tar (t), directory (d)
```sh
pg_dump -U postgres -d dbmovie -F c -f backup-dbmovie-custom.dump
pg_dump -U postgres -d dbmovie -F c -Z 0 -f backup-dbmovie-custom-0.dump  # + outil externe de compression (7z, winzip, rar, ..)
pg_dump -U postgres -d dbmovie -F c -Z 9 -f backup-dbmovie-custom-9.dump

pg_dump -U postgres -d dbmovie -F d  -f backup-dbmovie-custom-dir
pg_dump -U postgres -d dbmovie -F t  -f backup-dbmovie-custom.tar
```

### Restore backup binaire
Outil `pg_restore`:

```sh
# complet
pg_restore -U postgres -d dbmovie -v backup-dbmovie-custom-9.dump
# partiel
pg_restore -U postgres -d dbmovie -v -n nsmovie -t play backup-dbmovie-custom-9.dump
```

## Basebackup + PITR
L'outil `pg_basebackup` permet de backuper une base à chaud et autorise le PITR
si on conserve les fichiers WALs nécessaires.

https://www.postgresql.org/docs/19/continuous-archiving.html


### Backup base
NB: il est recommandé au préalabble de forcer une rotation des logs 
et une synchro disque des des buffers en mémoire:
```sql
select pg_switch_wal();      -- force le passage au WAL suivant
checkpoint;   -- force synchro shared buffer <-> disque
select pg_current_wal_lsn(); -- visualiser le LSN courant
```

Sauvegarde en elle-même:
```sh
pg_basebackup -U postgres -D .\backup\base\2026-11-20\
```

### Backup des Wals
Configurer dans le fichier postgresql.conf (exemple windows):
```
wal_level = replica
archive_mode = on
archive_command = 'copy  %p C:\\Backup\\archive_wal\\%f'
```

Chaque WAL finalisé est archivé automatiquement en fonction de la commande `archive_command`.

### Restore
Résumé:
1. un backup physique de base (`pg_basebackup` ou autre)
2. tous les WAL archivés depuis ce backup
3. restore du backup + rejeu des WAL jusqu'à une cible (`recovery_target_time`, `_xid`, `_lsn`, ou `immediate`)

On repart du backup physique de PGDATA sur une version logicielle identique.

Configuration provisoire du postgresql.conf (ou postgresql.auto.conf):
```ini
restore_command = 'cp /backup/wal_archive/%f %p'
recovery_target_time = '2024-12-05 14:32:15+01'
```

```sh
touch /var/lib/postgresql/18/main/recovery.signal
pg_ctl start -D /var/lib/postgresql/18/main         # ou autre commande démarrage
```
Le process de restauration s'occupe de récupérer les WALs nécessaires et de les
rejouer au démarrage.

NB: limiter l'accès à la base en modifant le pg_hba.conf ou autre pare-feu.