#!/bin/bash

if ! [[ -f ./docker/.env ]]; then
    cp ./docker/.env.example ./docker/.env
    echo "Environment file (docker/.env) has been created. Please configure it and run this script again."
    exit;
fi

HTTP_PORT=$(grep HTTP_PORT docker/.env | cut -d '=' -f 2-)
PROJECT_NAME=$(grep PROJECT_NAME docker/.env | cut -d '=' -f 2-)
CLIENT_NAME=$(grep CLIENT_NAME docker/.env | cut -d '=' -f 2-)
DN="${PROJECT_NAME}.${CLIENT_NAME}"
CONTAINER_NAME="${CLIENT_NAME}.${PROJECT_NAME}"

if [[ -z $(grep "${DN}" /etc/hosts) ]]; then
    echo "127.0.0.1 ${DN}" | sudo tee -a /etc/hosts
fi

docker-compose --env-file=./docker/.env up -d

docker ps | grep $CONTAINER_NAME