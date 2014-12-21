#!/bin/bash

docker ps

ID=`docker ps -q rzpqyo/pgsql93:latest`
docker stop $ID && docker rm $ID

docker ps
