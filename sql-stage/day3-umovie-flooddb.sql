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