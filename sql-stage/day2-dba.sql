-- user postgres (dba)

select * from pg_database; -- oid = repertoire base

select * from pg_tables;
select * from pg_indexes;
select * from pg_class order by relowner, relname;
select * from pg_class where relowner = 24578 order by relname;
-- voir relkind pour le type d'objet :
-- https://www.postgresql.org/docs/18/catalog-pg-class.html
-- r = ordinary table, i = index, S = sequence, t = TOAST table, v = view, m = materialized view, c = composite type, f = foreign table, p = partitioned table, I = partitioned index

-- vacuum auto
-- * postgresql.conf
-- * tunable par table

-- vacuum manuel
vacuum nsmovie.movie;

select * from pg_class where relowner = 24578 order by relname;

vacuum full;
select * from pg_class where relowner = 24578 order by relname;

-- rafraichir les stats
vacuum full analyze;

-- TODO : fonctions/tables pour analyser tailles disques, fragmentation et stats








