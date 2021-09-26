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
NGINX_CONF="/etc/nginx/sites-available/$CLIENT_NAME"

if [ ! -f $NGINX_CONF ]; then
    sudo touch $NGINX_CONF
    sudo ln -s "/etc/nginx/sites-available/${CLIENT_NAME}" /etc/nginx/sites-enabled/
fi

sed -e "s/\${DN}/${DN}/" -e "s/\${HTTP_PORT}/${HTTP_PORT}/" docker/nginx.conf.stub | sudo tee -a $NGINX_CONF
sudo service nginx restart

if [[ -z $(grep "${DN}" /etc/hosts) ]]; then
    echo "127.0.0.1 ${DN}" | sudo tee -a /etc/hosts
fi

sed -e "s/\${DN}/${DN}/" docker/apache-php/default.conf.stub | tee docker/apache-php/default.conf

docker-compose --env-file=./docker/.env up -d

docker ps | grep $CONTAINER_NAME