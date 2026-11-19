# Création d'une 2e instance

# windows
```sh
& "C:\Program Files\PostgreSQL\18\bin\initdb.exe" `
  -D "C:\Database\data-media" `
  -E UTF8 `
  --locale=French_France.1252 `
  -W
```