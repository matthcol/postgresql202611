-- user umovie
-- base dbmovie


create or replace view v_movie_1980s as (
	select id, title, year, duration, director_id
	from movie
	where year between 1980 and 1989
);

-- lecture à travers une vue
select 
	*
from 
	v_movie_1980s m
	join person d on m.director_id = d.id
order by m.year, m.title;

-- écriture à travers une vue (implicite)
--   * 1 seule table 
--   * inclus la PK et toutes les colonnes obligatoires
--   * pas d'agrégats

insert into v_movie_1980s (title, year) values ('La Boum', 1980);
select * from v_movie_1980s where title = 'La Boum';
select * from movie where title = 'La Boum'; -- id = 30825744

-- 1er pb
insert into v_movie_1980s (title, year) values ('Spiderman: Brand New Day', 2026);
select * from v_movie_1980s where year = 2026; -- pas vu
select * from movie where year = 2026; -- bien là

-- 2e pb
update v_movie_1980s set year = 2026 where id = 30825744;
select * from v_movie_1980s where title = 'La Boum';  -- plus là
select * from movie where title = 'La Boum'; 

-- solution : clause 'with check option'
create or replace view v_movie_1980s as (
	select id, title, year, duration, director_id
	from movie
	where year between 1980 and 1989
) with CHECK OPTION;

-- tests
insert into v_movie_1980s (title, year) values ('Les Rayons et les Ombres', 2026);
-- ERROR:  new row violates check option for view "v_movie_1980s"
-- Failing row contains (30825746, Les Rayons et les Ombres, 2026, null, null, null, null, null, null). 
-- SQL state: 44000
-- Detail: Failing row contains (30825746, Les Rayons et les Ombres, 2026, null, null, null, null, null, null).

select * from v_movie_1980s;
-- update v_movie_1980s set year = 2026 where id = 80455;
-- ERROR:  new row violates check option for view "v_movie_1980s"
-- Failing row contains (80455, The Blues Brothers, 2026, 133, After the release of Jake Blues from prison, he and brother Elwo..., https://m.media-amazon.com/images/M/MV5BYTdlMDExOGUtN2I3MS00MjY5..., null, R, 484). 

-- SQL state: 44000
-- Detail: Failing row contains (80455, The Blues Brothers, 2026, 133, After the release of Jake Blues from prison, he and brother Elwo..., https://m.media-amazon.com/images/M/MV5BYTdlMDExOGUtN2I3MS00MjY5..., null, R, 484).


-- NB: écriture à travers une vue (explicite) avec un trigger instead of



-- ************************************************************************** --
--          code stocké    
-- ************************************************************************** --

-- * procedures
-- * functions
-- * triggers
-- * types
-- * operators

-- * PAS de packages => utiliser un schema

-- plusieurs langages de programmation
-- * pl/pgsql (default)
-- * python
-- * C
-- * perl

-- voir code dans fichier day2-umovie-stored-proc.sql

-- utilisation fonction
select 
	title,
	year,
	fn_format_duration(duration) as duration_hm
from v_movie_1980s;

-- utilisation procedure
call add_movie(p_title => 'Oppenheimer', p_year => 2023::smallint, p_director_name => 'Christopher Nolan');

select * from movie where year = 2023;


-- types / fonctions/ operateurs

select 
	0.1::real * 3,  -- calcul en flottant (approx) : real, double
	0.1::decimal * 3  -- calcul en decimal (exact) : decimal, numeric
;

-- LOB:
-- * jusqu'à 1G => text (clob) ou bytea (blob)
-- * au delà => extension LOB

-- comparaison de texte : LIKE vs SIMILAR vs Regexp
-- https://www.postgresql.org/docs/18/functions-matching.html
select title, year
from movie
where title ~* 'star|war'  -- regexp (case insentive)
;


select
	current_date,
	CURRENT_TIMESTAMP, -- with tz
	CURRENT_TIMESTAMP::timestamptz, -- with tz
	CURRENT_TIMESTAMP::timestamp  --without tz
;

select 
	title,
	CURRENT_TIMESTAMP::timestamp - last_update as delta   -- type interval
from movie
where year = 2023
;

select
	name,
	birthdate,
	current_date - birthdate as age_days, -- integer,
	extract(year from birthdate) as birth_year,
	date_part('year', birthdate) as birth_year2,
	date_trunc('year', birthdate)::date as begin_birthdate
from person
where
	name ~* 'eastwood$'
;


select * from person where birthdate = '1930-05-31';
select * from person where birthdate = '31/05/1930';
show datestyle; -- "ISO, DMY"
set datestyle = MDY;
show datestyle; -- "ISO, MDY"
select * from person where birthdate = '5/31/1930';

select 
	year,
	count(*) as nb_movie,
	sum(duration) as total_duration
from v_movie_1980s
group by year
order by year
;

select 
	title,
	year,
	duration,
	count(*) over (partition by year) as nb_movie_year,
	rank() over (order by duration desc) as rank_duration
from v_movie_1980s
order by year
;


select *
from person
where name ~*  '^ren[eé]'
order by name;  -- => collation par défaut de la base

select * from pg_collation where collname like 'fr%';

select *
from person
where name ~*  '^ren[eé]'
order by name collate "fr-FR-x-icu";  -- collation independante de l'OS

-- Collation réglable au niveau :
-- * query
-- * colonne d'une table
-- * base
-- + index


-- Full Text Search (FTS)
-- https://www.postgresql.org/docs/18/textsearch.html
select to_tsvector('english', 'STAR WARS: THE LAST JEDI');
-- 'jedi':5 'last':4 'star':1 'war':2

select to_tsvector('french', 'des chevaux et des chèvres');


select *
from movie
where to_tsvector('english', title) @@ plainto_tsquery('english', 'war');

select *
from movie
where to_tsvector('english', title) @@ to_tsquery('english', 'war|peace');


-- vaccum sur ses tables
-- vacuum manuel
vacuum nsmovie.movie;
vacuum movie;

delete from play where actor_id % 2 = 1;  -- DELETE 32770
vacuum play;
vacuum full play;

-- index seul
reindex index CONCURRENTLY idx_person_name;
reindex table CONCURRENTLY person;

-- rafraichir les stats : auto ou manuel
analyze movie;
vacuum analyze movie;





























