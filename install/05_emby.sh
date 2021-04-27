#!/bin/bash

confirm="n"
function funct_pull {
docker-compose -f /bdcloud/05_emby/docker-compose.yml pull
}
while [ "$confirm" == "n" ]
do
  funct_pull
  echo -e "\nFalls die Installation fehlerhaft war bitte mit \"n\" abbrechen:\n"
  read confirm
done


# Installation 05_emby
docker volume create --name=conf_05_emby
docker volume create --name=data_05_emby_tvshows
docker volume create --name=data_05_emby_movies
sudo cp -f /bdcloud/05_emby/emby.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/emby.subfolder.conf
docker-compose -f /bdcloud/05_emby/docker-compose.yml up -d

# Restart Proxy
docker-compose -f /bdcloud/01_proxy/docker-compose.yml down
docker-compose -f /bdcloud/01_proxy/docker-compose.yml up -d
