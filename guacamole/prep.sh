#!/bin/sh
mkdir /docker/guacamole/config/init >/dev/null 2>&1
chmod -R +x /docker/guacamole/config/init
cp /Docker-Compose/guavamole/psql.sh /docker/guacamole/config/init/psql.sh
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgresql > /docker/guacamole/config/init/initdb.sql
docker compose -f /Docker-Compose/guacamole/docker-compose.yml up -d postgres
docker exec postgres bash /docker-entrypoint-initdb.d/psql.sh
