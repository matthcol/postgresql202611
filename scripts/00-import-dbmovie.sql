create database dbmovie encoding 'UTF-8';
create user umovie with login password 'password';

\c dbmovie
create schema nsmovie authorization umovie;
alter user umovie set search_path to nsmovie, public;

set session authorization umovie;
set search_path = nsmovie;

\i ../sql-init-dbmovie/01-tables.sql
\i ../sql-init-dbmovie/02-data-person.sql
\i ../sql-init-dbmovie/03-data-movie.sql
\i ../sql-init-dbmovie/04-data-play.sql
\i ../sql-init-dbmovie/05-data-genres.sql
\i ../sql-init-dbmovie/98-realign-seq.sql
\i ../sql-init-dbmovie/99-checkup.sql