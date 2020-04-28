#!/bin/sh

function Do_Compose () { 
    # Each time you find docker-compose.yml run action using the set varilable
    for OUTPUT in $(find $DockerFolder -type f -name $Compose); 
        do 
            docker-compose -f $OUTPUT $1;
    done
} #End Do_Compose

#Define variables
BackupLocation="/mnt/nas/bk/Docker-Compose" #Location to backup to
DockerFolder="/Docker-Compose/*" #Location of Docker-Compose
Compose="docker-compose.yml" #Compose file used

#Pull latest Git merges
git --git-dir=/Docker-Compose/.git --work-tree=/Docker-Compose pull

#Pull latest versions of containers
Do_Compose "pull"

#Stop running containers
Do_Compose "stop"

#Update cert.crt and cert.key for Guacozy
cp /docker/ssh/acme/LetsEncryptTOB.crt /docker/ssh/acme/cert.crt
cp /docker/ssh/acme/LetsEncryptTOB.key /docker/ssh/acme/cert.key
cp /docker/ssh/acme/LetsEncryptTOB.pem /docker/ssh/acme/cert.pem

#Backup all config directories and files
rsync --archive --verbose --recursive --checksum /docker/ $BackupLocation

#Start all containers
Do_Compose "up -d"

#Prune old images
docker image prune -f