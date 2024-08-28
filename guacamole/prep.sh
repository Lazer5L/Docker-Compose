#!/bin/sh
sudo mkdir /docker/guacamole/config/init >/dev/null 2>&1
sudo chmod -R +x /docker/guacamole/config/init
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --postgresql > /docker/guacamole/config/init/initdb.sql
docker compose -f /Docker-Compose/guacamole/docker-compose.yml up -d
