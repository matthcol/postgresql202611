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


-- supervisions sessions / users
-- 1 session = 1 processus postgres
select * from pg_stat_activity where usename is not null;
-- => usename, pid = processus session
select pg_terminate_backend(1387);

select * from pg_locks;

-- utilisateurs tiers
create user fan with
	login
	password 'password123!'  -- alternatives : ldap, kerberos, ...
;
alter user fan set search_path = nsmedia, public;
grant usage on schema nsmedia to fan;
-- revoke usage on schema nsmedia from fan;
grant select on nsmedia.media to fan;
grant select on all tables in schema nsmedia to fan; -- tables + vues (non retro actif)

-- as fan :
-- select count(*) from media;  -- OK
-- delete from media;  -- KO

revoke select on all tables in schema nsmedia from fan;
revoke usage on schema nsmedia from fan;

create role r_media_reader;
grant usage on schema nsmedia to r_media_reader;
grant select on all tables in schema nsmedia to r_media_reader;

grant r_media_reader to fan;

create role r_media_contrib;
grant r_media_reader to r_media_contrib;
grant insert on nsmedia.media to r_media_contrib;
grant update (duration_mn, media_type) on nsmedia.media to r_media_contrib;
grant usage on sequence nsmedia.media_id_seq to r_media_contrib;


create user matth with
	login
	password 'password123!' 
;
alter user matth set search_path = nsmedia, public;
grant r_media_contrib to matth;


-- realign sequences
select setval('nsmedia.media_id_seq', max(id)) from nsmedia.media;
-- + others

-- as matth
-- select * from media where release_year = 2026;
-- select * from media where release_year = 2026 and title ~* 'odyssey';
-- insert into media (title, release_year) values ('The Odyssey', 2026); -- id : 34111119
-- select * from media where release_year = 2026 and title ~* 'odyssey';
-- update media set duration_mn = 180 where id = 34111119;    -- ok
-- update media set release_year = 2050 where id = 34111119;  -- ko


-- + privileges sur les vues

-- reload : postgresql.conf + pg_hba.conf
-- OS : service, pg_ctl, pg_ctlcluster
select pg_reload_conf();






















