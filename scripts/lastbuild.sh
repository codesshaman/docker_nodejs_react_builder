#!/bin/bash
if [ ! -f build/index.html ]; then
    echo "[NodeJS React Builder] Сборка завершилась неудачно"
    
else
    echo "[NodeJS React Builder] Запускаю старую сборку"
    rm -rf prod/*
    cp -rf lastbuild/* prod/
    docker-compose -f ./docker-compose.prod.yml up -d --build
    make ps
fi