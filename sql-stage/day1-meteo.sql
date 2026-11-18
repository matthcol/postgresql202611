-- user meteo, database dbmeteo

CREATE TABLE meteo.weather
(
    label varchar(10)
);

select * from weather;
select * from meteo.weather;

show search_path;  -- "$user", public

drop table meteo.weather;
CREATE TABLE weather
(
    label varchar(10)
); -- => créée dans le schema meteo
select * from pg_tables where tableowner = 'meteo';
select * from weather;
select * from meteo.weather;

drop table meteo.weather;
drop schema meteo;

CREATE TABLE weather
(
    label varchar(10)
); -- => créée dans le schema public (car il n y a pas de schema meteo)
select * from weather;
select * from public.weather;
	








