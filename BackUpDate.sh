#!/bin/sh

#Pull latest Git merges
git --git-dir=/Docker-Compose/.git --work-tree=/Docker-Compose pull

#Get the directories in /Dcoker-Compose
DockerFolder="ls -d /Docker-Compose/*"

#Pull latest versions of containers
foreach n ($DockerFolder) {
    docker-compose -f $n/docker-compose.yml pull
}
#docker-compose -f /Docker-Compose/guacozy/docker-compose.yml pull
#docker-compose -f /Docker-Compose/deluge/docker-compose.yml pull
#docker-compose -f /Docker-Compose/nzbget/docker-compose.yml pull
#docker-compose -f /Docker-Compose/ombi/docker-compose.yml pull
#docker-compose -f /Docker-Compose/sonarr/docker-compose.yml pull
#docker-compose -f /Docker-Compose/unifi/docker-compose.yml pull
#docker-compose -f /Docker-Compose/plex/docker-compose.yml pull
#docker-compose -f /Docker-Compose/sftp/docker-compose.yml pull
#docker-compose -f /Docker-Compose/tautulli/docker-compose.yml pull

#Stop running containers
#docker-compose -f /Docker-Compose/guacozy/docker-compose.yml stop
#docker-compose -f /Docker-Compose/deluge/docker-compose.yml stop
#docker-compose -f /Docker-Compose/nzbget/docker-compose.yml stop
#docker-compose -f /Docker-Compose/ombi/docker-compose.yml stop
#docker-compose -f /Docker-Compose/sonarr/docker-compose.yml stop
#docker-compose -f /Docker-Compose/unifi/docker-compose.yml stop
#docker-compose -f /Docker-Compose/plex/docker-compose.yml stop
#docker-compose -f /Docker-Compose/sftp/docker-compose.yml stop
#docker-compose -f /Docker-Compose/tautulli/docker-compose.yml stop

#Update cert.crt and cert.key for Guacozy
cp /docker/ssh/acme/LetsEncryptTOB.crt /docker/ssh/acme/cert.crt
cp /docker/ssh/acme/LetsEncryptTOB.key /docker/ssh/acme/cert.key

#Backup all config directories and files
rsync --archive --verbose --recursive --checksum /docker/ /mnt/nas/bk

#Start all containers
docker-compose -f /Docker-Compose/guacozy/docker-compose.yml up -d
docker-compose -f /Docker-Compose/deluge/docker-compose.yml up -d
docker-compose -f /Docker-Compose/nzbget/docker-compose.yml up -d
docker-compose -f /Docker-Compose/ombi/docker-compose.yml up -d
docker-compose -f /Docker-Compose/sonarr/docker-compose.yml up -d
docker-compose -f /Docker-Compose/unifi/docker-compose.yml up -d
#docker-compose -f /Docker-Compose/plex/docker-compose.yml up -d
#docker-compose -f /Docker-Compose/sftp/docker-compose.yml up -d
docker-compose -f /Docker-Compose/tautulli/docker-compose.yml up -d

#Prune old images
docker image prune -f