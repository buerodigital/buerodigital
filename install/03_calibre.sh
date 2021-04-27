#!/bin/bash

confirm="n"
function funct_pull {
docker-compose -f /bdcloud/03_calibre/docker-compose.yml pull
}
while [ "$confirm" == "n" ]
do
  funct_pull
  echo -e "\nFalls die Installation fehlerhaft war bitte mit \"n\" abbrechen:\n"
  read confirm
done


# Installation 03_calibre
docker volume create --name=data_03_calibre
docker volume create --name=conf_03_calibre_web
sudo cp -f /bdcloud/03_calibre/calibre.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/calibre.subfolder.conf
sudo cp -f /bdcloud/03_calibre/calibre-web.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/calibre-web.subfolder.conf
docker-compose -f /bdcloud/03_calibre/docker-compose.yml up -d

# Restart Proxy
docker-compose -f /bdcloud/01_proxy/docker-compose.yml down
docker-compose -f /bdcloud/01_proxy/docker-compose.yml up -d

