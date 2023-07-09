#!/bin/bash
folder_name="$(grep "FOLDER" .env | sed -r 's/.{,7}//')"
postfix="_old"
old_folder=$folder_name$postfix
# Функция подтверждения
confirm() {
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}
# Функция удаления
if [ -d $folder_name ]; then
    if confirm "Удалить текущую папку исходников проекта? (y/n or enter for no)"; then
        if [ -d $old_folder ]; then
            echo "[NodeJS React Builder] Удаляю предыдущую резервную копию проекта"
            rm -rf $old_folder
        fi
        echo "[NodeJS React Builder] Создаю резервную копию проекта"
        cp -rf $folder_name $old_folder
        echo "[NodeJS React Builder] Удаляю основной каталог исходников проекта"
        rm -rf $folder_name
    else
        echo "[NodeJS React Builder] Удаление отменено"
    fi
    
fi