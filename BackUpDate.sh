#!/bin/bash


function Do_Compose () { 
    # Each time you find docker-compose.yml run action using the set varilable
    for OUTPUT in $(find $DockerFolder -type f -name $Compose); 
        do 
            docker-compose -f $OUTPUT $1;
    done
} #End Do_Compose function

#Define variables
BackupLocation="/mnt/nas/bk/Docker-Compose" #Location to backup to
DockerFolder="/Docker-Compose/*" #Location of Docker-Compose
Compose="docker-compose.yml" #Compose file used

#Pull latest Git merges
echo -n Reaching out to GIT
git --git-dir=/Docker-Compose/.git --work-tree=/Docker-Compose pull

function Do_Pull() {
    #Pull latest versions of containers
    echo \n Pulling Docker images
    Do_Compose "pull"
} # End Do_Pull function

function Do_Backup() {
    #Notify Discord
    echo \n Notifying Discord Channel
    curl -H "Content-Type: application/json" -X POST -d '{"DockerBot": "#general", "content": "Docker is being restarted. Services such as Ombi will be down."}' 'https://discordapp.com/api/webhooks/732244627842793543/pz0yw2i0vedIQoz7TJpGvPUUTFO_vdQvtu_blS9-yeWbzXb8m6FdNnAdFNRLSkqrv9tJ'

    #Stop running containers
    echo \n Stopping Docker images
    Do_Compose "stop"

    #Update cert.crt and cert.key for Guacozy
    echo \n Shifting Certs
    cp /docker/ssh/acme/LetsEncryptTOB.crt /docker/ssh/acme/cert.crt
    cp /docker/ssh/acme/LetsEncryptTOB.key /docker/ssh/acme/cert.key
    cp /docker/ssh/acme/LetsEncryptTOB.all.pem /docker/ssh/acme/cert.pem

    #Backup all config directories and files
    echo \n Backing up container configs
    rsync -rlptD /docker/ $BackupLocation
} #End Do_Backup function

function Do_Start() {
    #Start all containers
    echo \n Starting Docker images
    Do_Compose "up -d"

    #Prune old images
    echo \n Purging Docker images
    docker image prune -f

    #Notify Discord
    echo \n Notifying Discord
    curl -H "Content-Type: application/json" -X POST -d '{"DockerBot": "#general", "content": "Docker is starting. Services such as Ombi will be restored in 2 minutes."}' 'https://discordapp.com/api/webhooks/732244627842793543/pz0yw2i0vedIQoz7TJpGvPUUTFO_vdQvtu_blS9-yeWbzXb8m6FdNnAdFNRLSkqrv9tJ'
} #End Dp_Start Function

echo -n BackUpDate.sh -n-n
echo -n '1) Full Pull, Stop, Backup and Start'
echo -n '2) Stop Backup and Start'
echo -n '3) Start Only'
echo -n 'Enter) Exit'
echo -n What would you like to perform?:
read CHOICE

Case CHOICE in
    1) # Full Pull, Stop, Backup and Start
        Do_Pull
        Do_Backup
        Do_Start
    ;;
    2) # Stop Backup and Start
        Do_Backup
    ;;
    3)
        Do_Start
    ;;
esac
