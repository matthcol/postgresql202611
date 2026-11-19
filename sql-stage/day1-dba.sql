-- user : postgres
-- db : postgres

-- liste des bases (y compris template)
select * from pg_database;

-- liste des bases (hors template)
select * from pg_database where not datistemplate;

-- maintenance des autres bases
drop database dbmeteo;
create database dbmeteo encoding 'UTF-8';
drop database DBMETEO;
create database dbmeteo encoding 'UTF-8';

-- identifiant quoté
create database "DbTransport" encoding 'UTF-8';
select * from pg_database where not datistemplate;

drop database dbtransport;  -- ko
drop database DbTransport;  -- ko
drop database "DbTransport"; -- ok

-- base connectée
select current_database();

-- creation user
CREATE ROLE meteo WITH
	LOGIN
	PASSWORD 'password123';

select * from pg_user;
select * from pg_roles;  
	-- rolcanlogin = false => role
	-- rolcanlogin = true => user "interactif"


-- NB: keyword ROLE et USER sont interchangeables dans le SQL DDL
drop role meteo;
CREATE user meteo WITH
	LOGIN
	PASSWORD 'password123';
select * from pg_roles where rolcanlogin;
select * from pg_user;
select * from pg_authid;
select * from pg_shadow;


-- database dbmeteo
drop schema meteo;
create schema meteo authorization meteo;
select * from pg_namespace; -- lister les schemas

-- réglages sessions
show password_encryption; -- "scram-sha-256"
set password_encryption = md5;
show password_encryption;

-- drop user mat;
create user mat with password 'password123';  -- WARNING:  setting an MD5-encrypted password
select * from pg_shadow; -- mdp crypté : "md5bfbc6fda5ddda54a7a80ceec82832939"

set password_encryption = "scram-sha-256";
show password_encryption; -- scram-sha-256
alter user mat with password 'password123'; 
select * from pg_shadow; -- mdp renouvelé en SCRAM-SHA-256 : "SCRAM-SHA-256$4096:qMR52/yHL690tL8bG77vDQ==$zjvwzKCcDtMpoGajf7IXLaNBVc6oJDrDeH2rRJjRoP4=:qRmZKtbur3TlHIyf22rwtVxJfh1cYBIXqZpGJVx/p7g="


-- table weather dans le schema meteo du user meteo, propriétaire meteo
CREATE TABLE meteo.weather
(
    label varchar(10)
);

ALTER TABLE IF EXISTS meteo.weather
    OWNER to meteo;

drop table meteo.weather;

-- pour utiliser public donner le droit suivant:
--    NB: public est protégé en écrityure depuis postgresql 15/16
grant create on schema public to meteo;


-- utiliser les tables métiers;
-- database dbmovie
select * from movie where year = 1994; -- ko
show search_path;  -- """$user"", public"  => ne voit pas les tables du schema nsmovie

-- soit utiliser un search_path provisoire
set search_path = nsmovie;
select * from movie where year = 1994;

-- soit prefixer (pas d'ambiguité)
select * from nsmovie.movie where year = 1994;




















