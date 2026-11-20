-- base dbmedia
-- exemples d'indexes

create index idx_media_year_btree on media using btree(release_year);
-- reorganiser la table physiquement
cluster media using idx_media_year_btree;
-- siupprimer l'index provisoire
drop index idx_media_year_btree;
create index idx_media_year_brin on media using brin(release_year);
analyze media;

select * from media where release_year = 1950;

create index idx_media_title_fts on media using gin(to_tsvector('english', title));

create index idx_aka_title_fr on aka using gin(to_tsvector('french', title))
    where region = 'FR';


select *
from media
where to_tsvector('english', title) @@ plainto_tsquery('english', 'heist');


select *
from aka
where 
	to_tsvector('french', title) @@ plainto_tsquery('french', 'bouton')
	and region = 'FR'
;


select *
from person
where name like '% Eastwood';

select * from pg_extension; -- "plpgsql"
select * from pg_available_extensions;  -- pg_trgm est là => à activer

create index idx_person on person using gin(name gin_trgm_ops);

select *
from person
where name like '% Eastwood';

select *
from person
where name ~* 'eastwood';


select
    m.id,
    m.title,
    m.release_year,
    m.end_year,
    count(*) as nb_episodes
from have_episode he
    join media m on m.id = he.series_id
group by m.id, m.title, m.release_year, m.end_year
order by nb_episodes desc
limit 10;








