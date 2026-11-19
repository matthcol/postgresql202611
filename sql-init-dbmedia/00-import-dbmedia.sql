-- necessite wal_level = minimal (et max_wal_senders = 0) sur le cluster
-- pour que TRUNCATE + COPY dans la meme transaction saute la journalisation WAL

create database dbmedia encoding 'UTF-8';
create user umedia with login password 'password';

\c dbmedia
create schema nsmedia authorization umedia;
alter user umedia set search_path to nsmedia, public;

set session authorization umedia;
set search_path = nsmedia;

\i 01-tables.sql
\i 02-data.sql
