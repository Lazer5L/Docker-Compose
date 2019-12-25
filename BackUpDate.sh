#!/bin/sh
docker-compose -f /Docker-Compose/guacozy/docker-compose.yml pull
docker-compose -f /Docker-Compose/deluge/docker-compose.yml pull
docker-compose -f /Docker-Compose/nzbget/docker-compose.yml pull
docker-compose -f /Docker-Compose/ombi/docker-compose.yml pull
docker-compose -f /Docker-Compose/sonarr/docker-compose.yml pull
docker-compose -f /Docker-Compose/unifi/docker-compose.yml pull
