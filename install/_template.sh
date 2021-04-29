#!/bin/bash

function about(){
  #cat https://github.com/buerodigital/nas/edit/main/install/_template.sh
    echo "About"
}

function install(){
    echo "Install"
}

function start(){
    echo "Start"
}

function stop(){
    echo "Stop"
}

function remove(){
    echo "Remove"
}

function help(){
  echo "Die Funktion bitte mit einem der folgenden Parameter aufrufen:"
  echo -e " -a --about\t\t Gibt Informationen über die Anwendung aus"     
  echo -e " -i --install\t\t Installiert die Anwendung"
  echo -e " -s --start --restart\t\t Startet die Anwendung"   
  echo -e " -h --stop --halt\t\t Beendet die Anwendung"   
  echo -e " -r --remove --delete\t\t Deinstalliert die Anwendung (Volumes bleiben erhalten!)"   
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
