-- user umovie base dbmovie
-- (ou user umedia base dbmedia)

-- occupation disque
select * from pg_stat_user_tables;
select * from pg_stat_user_indexes;  -- utilisation des indexes

-- détails et colonnes utiles
select 
	relname
	-- activité base
	n_tup_ins,
	n_tup_upd,
	n_tup_del,
	-- fragmentation
	n_live_tup,
	n_dead_tup,
	n_dead_tup::decimal / (n_live_tup + n_dead_tup) as ratio_dead_live,
	-- analyze/vacuum
	last_vacuum,
	last_autovacuum,
	last_analyze,
	last_autoanalyze
from pg_stat_user_tables;


-- statistiques sur les colonnes => choix des indexes
select * 
from pg_stats 
where schemaname = 'nsmovie'
order by tablename;

-- stat n_distinct utile pour les indexes B-TREE
-- * < 0 => selectivité bonne = nb val distincte / nb de valeurs totale  (bon candidat pour 1 BTREE)
-- * >=0 => nb de valeurs distinctes

-- types indexes 
-- - B-Tree : quasi unique, recherche exacte ou basée sur l'ordre
-- - Hash : recherche exacte
-- - GiST : GIS
-- - SP-GiST
-- - GIN : tableau, FTS
-- - BRIN : range (doit etre stocké dans l'ordre de la colonne)
--      * historisation

create index idx_movie_year on movie using brin(year);
alter table movie drop constraint uniq_movie;

select * from movie where year = 1950; -- index BRIN inutile

drop index idx_movie_year;
-- index provisoire btree
create index idx_movie_year_btree on movie using btree(year);
-- reorganiser la table physiquement
cluster movie using idx_movie_year_btree;
-- siupprimer l'index provisoire
drop index idx_movie_year_btree;
create index idx_movie_year_brin on movie using brin(year);
analyze movie;

select * from movie where year = 1950;
select * from movie where year between 1950 and 1959;


-- NB : le paramétrage d'auto analyze se fait conjointement avec l'auto vacuum
--  * Quelques paramètres:
-- 		autovacuum_analyze_threshold
-- 		autovacuum_analyze_scale_factor 
-- 		default_statistics_target  => influe la taille de l'échantillonage
--  * Paramétrage tunable dans postgresql.conf (général), au niveau d'une table ou d'une colonne




select * from pg_available_extensions order by name;

-- activer l'extension pg_trgm
create extension pg_trgm;
select * from pg_extension;

-- tracker les requetes
create extension pg_stat_statements;
-- + postgresql.conf : shared_preload_libraries = 'pg_stat_statements'   


show pg_stat_statements.track; -- all / top / none

-- Reset statistiques
select pg_stat_statements_reset();
select * from pg_stat_statements order by total_exec_time desc;

-- fin observation
drop extension pg_stat_statements;



-- NB: pour un reset des compteurs de pg_stats
pg_stat_reset(); -- → toute la base courante
pg_stat_reset_single_table_counters(oid);  --

-- NB: Extension pgstattuple => Quantification du bloat réel
CREATE EXTENSION IF NOT EXISTS pgstattuple;
SELECT * FROM pgstattuple('nom_table'); 
































