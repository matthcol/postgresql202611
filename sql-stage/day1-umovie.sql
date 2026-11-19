-- user umovie, database dbmovie
select
	current_database(),
	current_user,
	CURRENT_DATE,
	CURRENT_TIME,
	CURRENT_TIMESTAMP
;

show search_path; -- nsmovie, public

-- utilisation des tables sans prefixer par le schema
select count(*) from person;
select * from person where name like 'Clint E%';
select * from movie where year = 1994;

-- utilisation des tables en prefixer par le schema
select * from nsmovie.movie where year = 1994;


select * from pg_tables;
select * from pg_tables where tableowner = 'umovie';
select * from pg_tables where schemaname = 'nsmovie';

select * from pg_indexes where schemaname = 'nsmovie';
-- contrainte UNIQUE (y compris PK) => index implicite

-- index explicite
create index idx_person_name on person(name);
select * from pg_indexes where schemaname = 'nsmovie';


select * from person where name = 'Steve McQueen';

-- sequences :
-- * gestion depuis l'appli/ORM
-- * gestion depuis la base
--     - mot clé serial : => creation sequence + type entier + clause default pour remplir l'id automatiquement
--          # serial  : integer (32 bits)   ~ -2 G à +2 G  (milliard)
--          # smallserial : smallint (16 bits)  ~ -32 K à + 32 K
--          # bigserial   : bigint   (64 bits)  ~ -9 E  à + 9 E (milliard de milliard)
--     - clause identity : https://www.postgresql.org/docs/18/ddl-identity-columns.html


select 
	2 ^ 16,
	2 ^ 32,
	2 ^ 64
;


insert into movie (title, year) values ('Dune: Part 3', 2026);  -- id : 30825739
select * from movie where year = 2026;

insert into movie (title, year) values ('The Odyssey', 2026); -- id : 30825740
insert into movie (title, year) values ('Scrooge', 2026) returning id; -- 30825741
select * from movie where year = 2026;

insert into movie (title) values ('Avengers: Doomsday') returning id; 
-- SQL state: 23502
-- Detail: Failing row contains (30825742, Avengers: Doomsday, null, null, null, null, null, null, null).

insert into movie (title, year, director_id) values ('Avengers: Doomsday', 2026, -1) returning id;
-- ERROR:  insert or update on table "movie" violates foreign key constraint "fk_movie_director"
-- Key (director_id)=(-1) is not present in table "person". 
-- SQL state: 23503
-- Detail: Key (director_id)=(-1) is not present in table "person".

select currval('movie_id_seq'); -- le dernier numéro tiré dans cette session
select nextval('movie_id_seq');
select currval('movie_id_seq');

-- reset sequence
select setval('movie_id_seq', 30825741);

insert into movie (title, year) values ('Avengers: Doomsday', 2026) returning id; -- 30825742





