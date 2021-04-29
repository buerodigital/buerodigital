#!/bin/bash

function install {
  echo "Install"
  
docker network create proxy
docker volume create --name=conf_01_proxy
docker volume create --name=conf_01_heimdall
  
  cat > 01_proxy.yml <<EOL
version: "3.7"

services:
  proxy:
    image: linuxserver/nginx:amd64-version-8349a582
    container_name: proxy
    depends_on:
      - "heimdall"
    environment:
      # User (Docker User) und Gruppen (Docker Gruppe) anpassen
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
    volumes:
      - conf_01_proxy:/config:z
    ports:
      - 80:80
      - 443:443
    restart: unless-stopped
    networks:
      - proxy


  heimdall:
    image: linuxserver/heimdall:version-2.2.2
    container_name: heimdall
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
    volumes:
      - conf_01_heimdall:/config:z
    restart: unless-stopped
    networks:
      - proxy

networks:
  proxy:
    external: true

volumes:
  conf_01_proxy:
    external: true
  conf_01_heimdall:
    external: true
    
  EOL
  
  CONFIRM="n"
  while [ "$CONFIRM" == "n" ]
  do
    docker-compose -f 01_proxy.yml pull
    echo -e "\nFalls die Installation fehlerhaft war bitte mit \"n\" wiederholen:\n"
    read CONFIRM
  done  

docker-compose -f 01_proxy.yml up -d
docker-compose -f 01_proxy.yml down

sudo mkdir /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs

  cat > default <<EOL
      
  EOL
sudo mv default /var/lib/docker/volumes/conf_01_proxy/_data/nginx/site-confs/default

  cat > proxy.conf <<EOL
      
  EOL
sudo mv proxy.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy.conf

  cat > heimdall.subfolder.conf <<EOL
      
  EOL
sudo mv heimdall.subfolder.conf /var/lib/docker/volumes/conf_01_proxy/_data/nginx/proxy-confs/heimdall.subfolder.conf
  
  
}

function remove {
  echo "Remove"
}

function start {
  echo "Start"
  #docker-compose -f 01_proxy.yml up -d
}

function stop {
  echo "Stop"
  #docker-compose -f 01_proxy.yml down
  }

function help {
  echo "01_proxy\n"
  echo "Installiert die Grundfunktionalität\n\n"
  echo "Die Funktion bitte mit einem der folgenden Parameter aufrufen:\n"
  echo -e " -i, --install\t\t\t Installiert die Anwendung"
  echo -e " -s, --start, --restart\t\t\t Startet die Anwendung"   
  echo -e " -h, --stop, --halt\t\t\t Beendet die Anwendung"   
  echo -e " -r, --remove, --delete\t\t\t Deinstalliert die Anwendung (Volumes bleiben erhalten!)"   
}

case $1 in
  "-i" | "--install" )
    install 
    ;;
  "-s" | "--start" | "--restart" )
    start 
    ;;
  "-h" | "--stop" | "--halt" )
    stop
    ;;
  "-r" | "--remove" | "--delete")
    remove
    ;;
  "-a" | "--about" )
    about
    ;;
  *)
    help
    ;;
esac

exit 0
