select * from pg_class 
where relowner = 16389 --id user umedia
order by relname;


select
	pg_database_size('dbmedia'),
	pg_database_size('postgres')
;

select
	pg_size_pretty(pg_database_size('dbmedia')),
	pg_size_pretty(pg_database_size('postgres'))
;

select
	pg_size_pretty(pg_table_size('nsmedia.media'))
;

select 
	relname as table_name
	, pg_size_pretty(pg_relation_size(relname::regclass)) as size_data  -- data seule
	, pg_size_pretty(pg_table_size(relname::regclass)) as size_table  -- taille totale de la table (sauf index)
	, pg_size_pretty(pg_indexes_size(relname::regclass)) as size_index
	, pg_size_pretty(pg_total_relation_size(relname::regclass)) as size_total -- table + index
from pg_class 
where 
	relowner = 16389 --id user umedia
	and relkind = 'r'
order by pg_total_relation_size(relname::regclass) desc;

select * from pg_indexes where schemaname = 'nsmedia';



-- TODO:
select * from pg_stat_user_tables;
select * from pg_stat_user_indexes;
select * from pg_stats;








