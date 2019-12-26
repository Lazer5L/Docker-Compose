#!/bin/sh

#Pull latest Git merges
git --git-dir=/Docker-Compose/.git --work-tree=/Docker-Compose pull

#Pull latest versions of containers
docker-compose -f /Docker-Compose/guacozy/docker-compose.yml pull
docker-compose -f /Docker-Compose/deluge/docker-compose.yml pull
docker-compose -f /Docker-Compose/nzbget/docker-compose.yml pull
docker-compose -f /Docker-Compose/ombi/docker-compose.yml pull
docker-compose -f /Docker-Compose/sonarr/docker-compose.yml pull
docker-compose -f /Docker-Compose/unifi/docker-compose.yml pull

#Stop running containers
docker-compose -f /Docker-Compose/guacozy/docker-compose.yml stop
docker-compose -f /Docker-Compose/deluge/docker-compose.yml stop
docker-compose -f /Docker-Compose/nzbget/docker-compose.yml stop
docker-compose -f /Docker-Compose/ombi/docker-compose.yml stop
docker-compose -f /Docker-Compose/sonarr/docker-compose.yml stop
docker-compose -f /Docker-Compose/unifi/docker-compose.yml stop

#Backup all config directories and files
cp -R /docker/ /mnt/nas/bk

#Start all containers
docker-compose -f /Docker-Compose/guacozy/docker-compose.yml up -d
#docker-compose -f /Docker-Compose/deluge/docker-compose.yml up -d
#docker-compose -f /Docker-Compose/nzbget/docker-compose.yml up -d
docker-compose -f /Docker-Compose/ombi/docker-compose.yml up -d
#docker-compose -f /Docker-Compose/sonarr/docker-compose.yml up -d
docker-compose -f /Docker-Compose/unifi/docker-compose.yml up -d
