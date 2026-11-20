
create table person (
	id serial constraint pk_person primary key,
	name varchar(150) not null,
	birthdate date null
);

create table movie (
	id serial constraint pk_movie primary key,
	title varchar(300) not null,
	year smallint not null,
	duration smallint null,
	synopsis text null,
	poster_uri varchar(300) null,
	color varchar(20) null,
	pg varchar(15) null,
	director_id int null,
	constraint uniq_movie UNIQUE(title, year),
	constraint chk_movie_year CHECK(year >= 1888)
);

create table play (
	movie_id int not null,
	actor_id int not null,
	character varchar(100),
	constraint pk_play primary key(movie_id, actor_id)
);

create table have_genre(
	movie_id int not null,
	genre varchar(20) not null,
	constraint uniq_genre UNIQUE(movie_id, genre)
);


alter table movie add constraint fk_movie_director 
	foreign key (director_id)
	references person(id);

alter table play add constraint fk_play_movie 
	foreign key (movie_id)
	references movie(id);

alter table play add constraint fk_play_actor 
	foreign key (actor_id)
	references person(id);

alter table have_genre add constraint fk_have_genre
	foreign key (movie_id)
	references movie(id);


