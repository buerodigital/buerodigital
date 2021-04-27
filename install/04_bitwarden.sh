#!/bin/bash

confirm="n"
function funct_pull {
docker-compose -f /bdcloud/04_bitwarden/docker-compose.yml pull
}
while [ "$confirm" == "n" ]
do
  funct_pull
  echo -e "\nFalls die Installation fehlerhaft war bitte mit \"n\" abbrechen:\n"
  read confirm
done


# Installation 04_bitwarden
docker volume create --name=conf_04_bitwarden
sudo cp -f /bdcloud/04_bitwarden/bitwarden.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/bitwarden.subfolder.conf
docker-compose -f /bdcloud/04_bitwarden/docker-compose.yml up -d

# Restart Proxy
docker-compose -f /bdcloud/01_proxy/docker-compose.yml down
docker-compose -f /bdcloud/01_proxy/docker-compose.yml up -d

