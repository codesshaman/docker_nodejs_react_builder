#!/bin/bash
# Необходимые переменные
mypath=${PWD}
repos=($(cat repos.txt))
network=($(cat network.txt))
branch=($(cat nameofbranch.txt))
arr=($(echo "${mypath}" | tr '.' '\n'))
arr=($(echo "${arr}" | tr '/' '\n'))
preffix="${arr[-1]}"
timeout=1
if [ ! -f .env ]; then
    if [ ! -f nameofbranch.txt ]; then
        echo "Файл с именем ветки отсутствует"
        echo "Сохраните имя вашей ветки git в файле с именем nameofbranch.txt в корне проекта"
        exit
    fi
    if [ ! -f network.txt ]; then
        echo "Файл с именем сети отсутствует"
        echo "Сохраните имя вашей сети docker в файл network.txt в корне проекта"
        exit
    fi
    if [ ! -f repos.txt ]; then
        echo "Файл с именем репозитория отсутствует"
        echo "Сохраните адрес репозитория в файл repos.txt в корне проекта"
        exit
    fi
    cp .env.example .env
    echo "Вывожу список используемых портов:"
    docker ps --format "{{.Ports}}"
    echo "Введите номер порта:"
    read port
    sed -i "s!BUILDER=react_builder!BUILDER=${preffix}_react_builder!1" .env
    sed -i "s!PRODUCT=nginx_product!PRODUCT=${preffix}_nginx_product!1" .env
    sed -i "s!NETWORK_NAME=default!NETWORK_NAME=${network}!1" .env
    sed -i "s!BRANCH=Developer!BRANCH=${branch}!1" .env
    sed -i "s!REPOS=your_repos!REPOS=${repos}!1" .env
    sed -i "s!PORT=80!PORT=${port}!1" .env
    BUILDER=react_builder
    echo "Конфигурация .env успешно создана!"
    echo "Теперь вы можете запустить make build"
else
    echo "Конфигурация .env уже существует"
fi