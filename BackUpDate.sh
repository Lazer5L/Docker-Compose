#!/bin/sh

#Define variables
BackupLocation="/mnt/nas/bk" #Location to backup to
DockerFolder="/Docker-Compose/*" #Location of Docker-Compose
Compose="docker-compoase.yml"

#Pull latest Git merges
git --git-dir=/Docker-Compose/.git --work-tree=/Docker-Compose pull

#Pull latest versions of containers
Action="pull"
Do_Compse

#Stop running containers
Action="stop"
Do_Compse

#Update cert.crt and cert.key for Guacozy
cp /docker/ssh/acme/LetsEncryptTOB.crt /docker/ssh/acme/cert.crt
cp /docker/ssh/acme/LetsEncryptTOB.key /docker/ssh/acme/cert.key

#Backup all config directories and files
rsync --archive --verbose --recursive --checksum /docker/ $BackupLocation

#Start all containers
Action="up -d"
Do_Compse

#Prune old images
docker image prune -f

function Do_Compose { 
    # Each time you find docker-compose.yml run action using the set varilable
    for OUTPUT in $(find $DockerFolder -type f -name $Compose); 
        do 
            docker-compose -f $OUTPUT $Action;
    done
} #End Do_Compose