-- primary and unique constraints
\echo '--- pk_person ---'
alter table person add constraint pk_person primary key(id);
\echo '--- pk_media ---'
alter table media add constraint pk_media primary key(id);
\echo '--- unique_genre (have_genre) ---'
alter table have_genre add constraint unique_genre unique(media_id, genre);
\echo '--- pk_profession ---'
alter table profession add constraint pk_profession primary key (id);
\echo '--- unique_profession ---'
alter table profession add constraint unique_profession unique (name);
\echo '--- pk_have_profession ---'
alter table have_profession add constraint pk_have_profession primary key(person_id, prof_id);
\echo '--- pk_known_for ---'
alter table known_for add constraint pk_known_for primary key(person_id, media_id);
\echo '--- pk_direct ---'
alter table direct add constraint pk_direct primary key(media_id, director_id);
-- alter table play add constraint pk_play primary key(media_id, actor_id);
\echo '--- pk_have_episode ---'
alter table have_episode add constraint pk_have_episode primary key(series_id, episode_id);
\echo '--- pk_aka ---'
alter table aka add constraint pk_aka primary key(id);

-- foreign keys constraints
\echo '--- FK_PLAY_MEDIA (play) ---'
alter table play add constraint FK_PLAY_MEDIA
	FOREIGN KEY (media_id)
	references media(id);
\echo '--- FK_PLAY_ACTOR (play) ---'
alter table play add constraint FK_PLAY_ACTOR
	FOREIGN KEY (actor_id)
	references person(id);
\echo '--- FK_HAVE_GENRE (have_genre) ---'
alter table have_genre add constraint FK_HAVE_GENRE
	FOREIGN KEY (media_id)
	references media(id);
\echo '--- FK_HAVE_PROF_PERSON (have_profession) ---'
alter table have_profession add constraint FK_HAVE_PROF_PERSON
	FOREIGN KEY (person_id)
	references person(id);
\echo '--- FK_HAVE_PROF_PROF (have_profession) ---'
alter table have_profession add constraint FK_HAVE_PROF_PROF
	FOREIGN KEY (prof_id)
	references profession(id);
\echo '--- FK_KNOWN_FOR_PERSON (known_for) ---'
alter table known_for add constraint FK_KNOWN_FOR_PERSON
	FOREIGN KEY (person_id)
	references person(id);
\echo '--- FK_KNOWN_FOR_MEDIA (known_for) ---'
alter table known_for add constraint FK_KNOWN_FOR_MEDIA
	FOREIGN KEY (media_id)
	references media(id);
\echo '--- FK_DIRECT_DIRECTOR (direct) ---'
alter table direct add constraint FK_DIRECT_DIRECTOR
	FOREIGN KEY (director_id)
	references person(id);
\echo '--- FK_DIRECT_MEDIA (direct) ---'
alter table direct add constraint FK_DIRECT_MEDIA
	FOREIGN KEY (media_id)
	references media(id);
\echo '--- FK_HAVE_EP_SERIES (have_episode) ---'
alter table have_episode add constraint FK_HAVE_EP_SERIES
	FOREIGN KEY (series_id)
	references media(id);
\echo '--- FK_HAVE_EP_EP (have_episode) ---'
alter table have_episode add constraint FK_HAVE_EP_EP
	FOREIGN KEY (episode_id)
	references media(id);
\echo '--- FK_AKA_MEDIA (aka) ---'
alter table aka add constraint FK_AKA_MEDIA
	FOREIGN KEY (media_id)
	references media(id);
