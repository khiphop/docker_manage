#!/bin/bash

if [ ! -d /var/log/eduNginxFront/log ]
then
    mkdir -p /var/log/eduNginxFront/log
fi

docker stop edu_bu_front
docker rm edu_bu_front

docker run -ti --name edu_bu_front \
-p 8002:80 \
-v /usr/local/www/edu_business_front/:/www/api/game/ \
-v /var/log/eduNginxFront/:/var/log/nginx/ \
-v /var/log/eduNginxFront/phpLog/:/www/api/log/ \
--log-opt max-size=50m --log-opt max-file=1 \
--cap-add=SYS_PTRACE \
--restart always \
-d khiphop/baison_common:20201209
