#!/bin/bash

function install {
  echo "Install"
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
