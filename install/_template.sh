#!/bin/bash

# -i --install
# -s --start --restart
# -h --stop --halt
# -r --remove --delete
# -p --purge
# -a --about

case $1 in

  "-i" | "--install" )
    echo "Lithuanian" 
    ;;

  "-s" | "--start" | "--restart" )
    echo "Romanian" 
    ;;

  "-h" | "--stop" | "--halt" )
    echo "Italian"
    ;;

  "-r" | "--remove" | "--delete")
    echo "Italian"
    echo "Samba haendisch loeschen!!!!!"
    ;;

  "-a" | "--about" )
    echo "Italian"
    ;;

  *)
    echo "unknown"
    ;;

esac

exit 0
