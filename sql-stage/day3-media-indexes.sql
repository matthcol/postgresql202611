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
