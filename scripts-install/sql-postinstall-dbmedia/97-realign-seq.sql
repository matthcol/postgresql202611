select setval('person_id_seq', max(id)) from person;
select setval('media_id_seq', max(id)) from media;
select setval('profession_id_seq', max(id)) from profession;
select setval('aka_id_seq', max(id)) from aka;
