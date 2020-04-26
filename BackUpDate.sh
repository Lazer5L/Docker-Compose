#!/bin/sh

#Pull latest Git merges
git --git-dir=/Docker-Compose/.git --work-tree=/Docker-Compose pull

#Get the directories in /Dcoker-Compose
DockerFolder="ls -d /Docker-Compose/*"

#Pull latest versions of containers
for OUTPUT in $DockerFolder; do docker-compose -f $OUTPUT/docker-compose.yml pull; done

#Stop running containers
for OUTPUT in $DockerFolder; do docker-compose -f $OUTPUT/docker-compose.yml stop; done

#Update cert.crt and cert.key for Guacozy
cp /docker/ssh/acme/LetsEncryptTOB.crt /docker/ssh/acme/cert.crt
cp /docker/ssh/acme/LetsEncryptTOB.key /docker/ssh/acme/cert.key

#Backup all config directories and files
rsync --archive --verbose --recursive --checksum /docker/ /mnt/nas/bk

#Start all containers
for OUTPUT in $DockerFolder; do docker-compose -f $OUTPUT/docker-compose.yml up -d; done

#Prune old images
docker image prune -f