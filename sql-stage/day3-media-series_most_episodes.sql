-- Séries (dbmedia) triées par nombre d'épisodes décroissant
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
