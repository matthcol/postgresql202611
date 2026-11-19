SELECT clock_timestamp() AS debut_import;
SET client_encoding = 'UTF8';

\echo '--- person ---'
BEGIN;
TRUNCATE TABLE person;
\copy person FROM 'person.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, ENCODING 'UTF-8');
COMMIT;

\echo '--- profession ---'
BEGIN;
TRUNCATE TABLE profession;
\copy profession FROM 'profession.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, ENCODING 'UTF-8');
COMMIT;

\echo '--- have_profession ---'
BEGIN;
TRUNCATE TABLE have_profession;
\copy have_profession FROM 'have-profession.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, ENCODING 'UTF-8');
COMMIT;

\echo '--- known_for ---'
BEGIN;
TRUNCATE TABLE known_for;
\copy known_for FROM 'known-for.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, ENCODING 'UTF-8');
COMMIT;

\echo '--- media ---'
BEGIN;
TRUNCATE TABLE media;
\copy media FROM 'media.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, ENCODING 'UTF-8');
COMMIT;

\echo '--- have_genre ---'
BEGIN;
TRUNCATE TABLE have_genre;
\copy have_genre FROM 'have-genre.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, ENCODING 'UTF-8');
COMMIT;

\echo '--- direct ---'
BEGIN;
TRUNCATE TABLE direct;
\copy direct FROM 'direct.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, ENCODING 'UTF-8');
COMMIT;

\echo '--- play ---'
BEGIN;
TRUNCATE TABLE play;
\copy play FROM 'play.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, ENCODING 'UTF-8');
COMMIT;

\echo '--- have_episode ---'
BEGIN;
TRUNCATE TABLE have_episode;
\copy have_episode FROM 'have-episode.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, ENCODING 'UTF-8');
COMMIT;

\echo '--- aka ---'
BEGIN;
TRUNCATE TABLE aka;
\copy aka FROM 'aka.tsv' WITH (FORMAT csv, DELIMITER E'\t', HEADER, ENCODING 'UTF-8');
COMMIT;

SELECT clock_timestamp() AS fin_import_data;

\echo '--- keys ---'
\i 98-keys.sql
SELECT clock_timestamp() AS fin_keys;

\echo '--- checkup ---'
\i 98-checkup.sql


SELECT clock_timestamp() AS fin_import;
