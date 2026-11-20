-- occupation disque
select * from pg_stat_user_tables;
select * from pg_stat_user_indexes;  -- utilisation des indexes
select * from pg_stats;

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





























