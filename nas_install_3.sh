#!/bin/bash

# Systemupdate und Hostnamen
sudo apt-get --assume-yes update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes dist-upgrade

# Programme installieren
docker, docker-compose, 
sudo apt-get --assume-yes install git openssl openssh-server apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s) -$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

sudo systemctl start docker
sudo systemctl enable docker

# Aufräumen
sudo apt-get --assume-yes clean
sudo apt-get --assume-yes autoremove
docker stop $(sudo docker ps -a -q)
docker system prune -a --volumes

echo "Bitte den aktuellen User abmelden und wieder anmelden!!!"




