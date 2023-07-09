#!/bin/bash
volume=($(docker-compose -f ./docker-compose.prod.yml ps -a -q | xargs docker inspect --format '{{ .Name }}'))
len=${#volume}
if [ $len != 0  ]; then
    volume_name="${volume:1}"
    docker volume rm $volume_name
    echo "Раздел успешно удалён"
fi