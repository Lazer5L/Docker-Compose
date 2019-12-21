#!/bin/sh
docker-compose -f /guacozy/docker-compose.yml pull
docker-compose -f /deluge/docker-compose.yml pull
docker-compose -f /nzbget/docker-compose.yml pull
docker-compose -f /ombi/docker-compose.yml pull
docker-compose -f /sonarr/docker-compose.yml pull
docker-compose -f /unifi/docker-compose.yml pull
