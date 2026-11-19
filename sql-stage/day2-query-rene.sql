 SET client_encoding = 'UTF8';  

select *
from person
where name ~*  '^ren[eé]'
order by name;