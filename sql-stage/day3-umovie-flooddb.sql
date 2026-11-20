-- user umovie, database dbmovie

-- salves d'inserts pour générer des rotations de logs


-- La base est en mode archive wals, cf postgresql.conf (windows) :
-- archive_mode = on
-- archive_command = 'copy  %p C:\\Backup\\archive_wal\\%f'

-- 1ère salve
do
$$
begin
        for i in 1..100000 loop
                insert into movie (title, year) values ('Hunger Games '  || i, 2026);
        end loop;
exception
        when others then
                raise notice 'error: % (%)', SQLERRM, SQLSTATE;
end
$$
;


-- 2 ème salve
do
$$
begin
        for i in 1..1000000 loop
                insert into movie (title, year) values ('James Bond '  || i, 2026);
        end loop;
exception
        when others then
                raise notice 'error: % (%)', SQLERRM, SQLSTATE;
end
$$
;