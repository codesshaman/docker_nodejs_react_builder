#!/bin/bash
name="$(grep "BUILDER" .env | sed -r 's/.{,8}//')"
echo "[NodeJS React Builder] Подключаюсь к контейнеру"
docker exec -it $name sh