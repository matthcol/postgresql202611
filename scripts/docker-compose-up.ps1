$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$project_name = "pg-dbmovie"
# --renew-anon-volumes : recree les volumes anonymes
docker compose `
  -f (Join-Path $scriptDir "docker-compose.yml") `
  -f (Join-Path $scriptDir "docker-compose.persist.yml") `
  -p "$project_name" `
  up -d --renew-anon-volumes @args
