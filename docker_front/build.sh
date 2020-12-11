#!/bin/bash
#echo $1 | sed "s/\(\(\/\)\|\(\?\)\|\(\&\)\)/\\\\\1/g"

if [ ! -d /var/log/gameNginx/phpLog ]
then
    mkdir -p /var/log/gameNginx/phpLog
fi

docker stop php72Game
docker rm php72Game

docker build -t php72game .

docker run -ti --name php72Game \
-p 8001:80 \
-v /usr/local/www/newSperver/game/:/www/api/game/ \
-v /var/log/gameNginx/:/var/log/nginx/ \
-v /var/log/gameNginx/phpLog/:/www/api/log/ \
--log-opt max-size=50m --log-opt max-file=1 \
--cap-add=SYS_PTRACE \
--restart always \
-d php72game
