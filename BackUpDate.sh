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

#Notify Discord
curl -H "Content-Type: application/json" -X POST -d '{"DockerBot": "#general", "content": "Docker is being restarted. Services such as Ombi will be down."}' 'https://discordapp.com/api/webhooks/732244627842793543/pz0yw2i0vedIQoz7TJpGvPUUTFO_vdQvtu_blS9-yeWbzXb8m6FdNnAdFNRLSkqrv9tJ'

#Stop running containers
Do_Compose "stop"

#Update cert.crt and cert.key for Guacozy
cp /docker/ssh/acme/LetsEncryptTOB.crt /docker/ssh/acme/cert.crt
cp /docker/ssh/acme/LetsEncryptTOB.key /docker/ssh/acme/cert.key
cp /docker/ssh/acme/LetsEncryptTOB.all.pem /docker/ssh/acme/cert.pem

#Backup all config directories and files
rsync --archive --verbose --recursive --checksum /docker/ $BackupLocation

#Start all containers
Do_Compose "up -d"

#Prune old images
docker image prune -f

#Notify Discord
curl -H "Content-Type: application/json" -X POST -d '{"DockerBot": "#general", "content": "Docker is starting. Services such as Ombi will be restored in 2 minutes."}' 'https://discordapp.com/api/webhooks/732244627842793543/pz0yw2i0vedIQoz7TJpGvPUUTFO_vdQvtu_blS9-yeWbzXb8m6FdNnAdFNRLSkqrv9tJ'
