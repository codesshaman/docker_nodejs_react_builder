#!/bin/bash
if [ ! -f .env ]; then
    echo ".env-файл отсутствует"
    exit
else
    rm .env
    echo ".env - файл успешно удалён"
fi
