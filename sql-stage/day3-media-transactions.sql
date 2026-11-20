-- base dbmedia

-- transactions

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











