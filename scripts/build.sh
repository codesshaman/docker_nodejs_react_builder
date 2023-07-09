#!/bin/bash
git_repos="$(grep "REPOS" .env | sed -r 's/.{,6}//')"
git_branch="$(grep "BRANCH" .env | sed -r 's/.{,7}//')"
folder_name="$(grep "FOLDER" .env | sed -r 's/.{,7}//')"
builder_name="$(grep "BUILDER" .env | sed -r 's/.{,8}//')"
product_name="$(grep "PRODUCT" .env | sed -r 's/.{,8}//')"
no='\033[0m'
ok='\033[1;32m'
blue='\033[0;34m'
warn='\033[33;01m'
error='\033[31;01m'
build_check=false
status_check=false
runing_check=false
answer_check=false
timeout=1
if [ ! -f .env ]; then
    echo -e "${blue}[NodeJS React Builder]${no} ${error}.env-файл отсутствует.${no}"
    echo -e "${blue}[NodeJS React Builder]${no} ${warn}Воспользуйтесь командой${no} ${ok}make env${no} ${warn}для его создания${no}"
    exit
fi
if [ ! -d build ]; then
    mkdir -v build
fi
if [ ! -d prod ]; then
    mkdir -v prod
fi
if [ ! -d $folder_name ]; then
    echo -e "${blue}[NodeJS React Builder]${no} ${warn}Скачиваю проект из репозитория${no}"
    git clone $git_repos -b $git_branch $folder_name
elif [ -d $folder_name ]; then
    echo -e "${blue}[NodeJS React Builder]${no} ${warn}Обновляю код проекта${no}"
    cd $folder_name
    git pull
    cd ../
fi
cp -rf build lastbuild
rm -rf build/*
echo -e "${blue}[NodeJS React Builder]${no} ${warn}Запускаю сборку${no}"
echo -e "${blue}[NodeJS React Builder]${no} ${ok}Вывод перенаправляется в файл, ожидайте${no}"
docker-compose -f ./docker-compose.build.yml up -d --build > logs.txt
echo -e "${blue}[NodeJS React Builder]${no} ${warn}Сборка закончена, ожидаю старта контейнера${no}"
grep 'Successfully built' logs.txt && build_check=true || build_check=false
# docker inspect $builder_name > inspect1.txt
# sleep $timeout
# curl -Is http://localhost:999 | head -n 1 >> logs.txt
# grep 'HTTP/1.1 200 OK' logs.txt && answer_check=true || answer_check=false
# created_check=true
# waiting=5
# while $created_check
# do
#     docker inspect $builder_name > inspect.txt
#     grep '"Status": "created"' inspect.txt && created_check=true || created_check=false
#     if [ $created_check == true ]; then
#         echo -e "${blue}[NodeJS React Builder]${no}Ожидаю запуска контейнера"
#     else
#         echo -e "${blue}[NodeJS React Builder]${no}Контейнер успешно запущен"
#     fi
#     sleep $waiting
# done
# docker inspect $builder_name >> logs.txt
# grep '"Status": "running"' logs.txt && status_check=true || status_check=false
# grep  '"Running": true' logs.txt && runing_check=true || runing_check=false
echo -e "${blue}[NodeJS React Builder]${no} ${warn}Выполняю проверку запуска${no}"
# Проверка сборки
if [ $build_check == true ]; then
    echo  -e "${blue}[NodeJS React Builder]${no} ${ok}Проверка сборки пройдена${no}"
else
    echo -e "${blue}[NodeJS React Builder]${no} ${error}Сборка завершилась неудачно${no}"
fi
# Проверка запуска
# if [ $status_check == true ]; then
#     echo -e "${blue}[NodeJS React Builder]${no} Проверка запуска пройдена"
# else
#     echo -e "${blue}[NodeJS React Builder]${no} Обнаружены проблемы с запуском"
# fi
# Проверка запуска
# if [ $runing_check == true ]; then
#     echo -e "${blue}[NodeJS React Builder]${no} Контейнер успешно запущен"
# else
#     echo -e "${blue}[NodeJS React Builder]${no} Не удалось запустить контейнер"
# fi
# Проверка healthcheck
# if [ $answer_check == true ]; then
#     echo -e "${blue}[NodeJS React Builder]${no} Проверка здоровья пройдена"
# else
#     echo -e "${blue}[NodeJS React Builder]${no} Проверка здоровья не пройдена"
# fi
# if [ $answer_check == true ] && [ $runing_check == true ] && [ $status_check == true ] && [ $build_check == true ]; then
if [ $build_check == true ]; then
    echo -e "${blue}[NodeJS React Builder]${no} ${warn}Запускаю билд nginx${no}"
    echo -e "${blue}[NodeJS React Builder]${no} ${warn}Останавливаю контейнеры${no}"
    docker-compose -f ./docker-compose.build.yml down
    make down
    echo -e "${blue}[NodeJS React Builder]${no} ${warn}Удаляю предыдущую сборку${no}"
    rm -rf prod/*
    echo -e "${blue}[NodeJS React Builder]${no} ${warn}Копирую новую сборку${no}"
    cp -rf build/* prod/
    echo -e "${blue}[NodeJS React Builder]${no} ${warn}Запускаю контейнер nginx${no}"
    docker-compose -f ./docker-compose.prod.yml up -d --build
    make vol
    make ps
else
    echo -e "${blue}[NodeJS React Builder]${no} ${warn}Проверяю состояние production${no}"
    make ps > logstart.txt
    grep $product_name logstart.txt && name_check=true || name_check=false
    grep 'Up (healthy)' logstart.txt && health_check=true || health_check=false
    # grep 'HTTP/1.1 200 OK' logstart.txt && statansw_check=true || statansw_check=false
    # if [ $statansw_check == true ] && [ $health_check == true ] && [ $name_check == true ]; then
    if [ $health_check == true ] && [ $name_check == true ]; then
        echo -e "${blue}[NodeJS React Builder]${no} ${ok}Production-контейнер работает${no}"
        make ps
    else
        make
        make ps
    fi
fi