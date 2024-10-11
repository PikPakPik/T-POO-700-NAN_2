#! /bin/bash

# Have multiple parameters to run the script
# ./timemanager.sh -backend
# ./timemanager.sh -frontend
# ./timemanager.sh -all

if [ "$1" == "-backend" ]; then
    echo "Launching backend"
    docker-compose -f docker-compose.local.yml  --profile backend up --pull always --build --remove-orphans --force-recreate
fi

if [ "$1" == "-frontend" ]; then
    echo "Launching frontend"
    docker-compose -f docker-compose.local.yml --profile frontend up --pull always --build --remove-orphans --force-recreate
fi

if [ "$1" == "-all" ]; then
    echo "Launching all"
    docker-compose -f docker-compose.local.yml --profile all up --pull always --build --remove-orphans --force-recreate
fi

if [ "$1" == "-prod" ]; then
    echo "Launching prod"
    docker-compose -f docker-compose.yml up --pull always --build --remove-orphans --force-recreate
fi

if [ "$1" == "" ]; then
    echo "No argument provided, usage: ./timemanager.sh (-backend|-frontend|-all|-prod)"
fi
