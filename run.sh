#!/bin/bash

docker run -itd -v ~/work/tmp/pgsql93/mydata:/var/lib/postgresql/9.3/main rzpqyo/pgsql93
docker ps
