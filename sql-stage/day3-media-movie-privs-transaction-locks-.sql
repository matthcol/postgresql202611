-- database dbmovie
-- user postgres pour la supervision
-- users umovie, fan, matth pour les requetes métiers


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


-- ***********************
--     transactions
-- ***********************

-- par défaut chaque opération est atomique
insert into media (title, release_year) values ('Dune: Part 3', 2026) returning id; -- 34111120
select * from media where title = 'Dune: Part 3'; -- OK: pour cette session et les autres en //

-- transaction explicite
begin;  -- debut de transaction
update media set duration_mn = 180 where id = 34111120;
select * from media where title = 'Dune: Part 3'; -- cette transaction voit 180mn et les autres voient toujours NULL
-- autres actions

-- fin transaction : au choix
commit; -- valide tout
rollback;  -- annule tout



-- isolation des transactions réglable


-- verrous : lock et deadlock
select * from media where id in (34111119, 34111120);

-- session 1
begin;  -- debut de transaction
update media set duration_mn = 171 where id = 34111120;
update media set duration_mn = 171 where id = 34111119;
commit;
rollback;

-- session 2
begin;  -- debut de transaction
update media set duration_mn = 172 where id = 34111119;
update media set duration_mn = 172 where id = 34111120;
commit;
-- rollback;

-- supervision
select * from pg_locks;
select * from pg_stat_activity;

select 
	a.usename,
	t.relname,
	a.query,
	l.*
from 
	pg_locks l
	join pg_stat_activity a on l.pid = a.pid
	join pg_class t on l.relation = t.oid
where l.database > 0
;































