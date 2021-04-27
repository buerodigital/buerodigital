#!/bin/bash

confirm="n"
function funct_pull {
docker-compose -f /bdcloud/01_proxy/docker-compose.yml pull
}
while [ "$confirm" == "n" ]
do
  funct_pull
  echo -e "\nFalls die Installation fehlerhaft war bitte mit \"n\" abbrechen:\n"
  read confirm
done


# Installation 01_proxy
docker network create proxy
docker volume create --name=conf_01_proxy
docker volume create --name=conf_01_heimdall
docker-compose -f /bdcloud/01_proxy/docker-compose.yml up -d
docker-compose -f /bdcloud/01_proxy/docker-compose.yml down
sudo cp -f /bdcloud/01_proxy/default /var/lib/docker/volumes/conf_01_proxy/_data/nginx/site-confs/default
sudo cp -f /bdcloud/01_proxy/proxy.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy.conf
sudo mkdir /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs
sudo cp -f /bdcloud/01_proxy/heimdall.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/heimdall.subfolder.conf


# Proxy als letztes starten
docker-compose -f /bdcloud/01_proxy/docker-compose.yml up -d


