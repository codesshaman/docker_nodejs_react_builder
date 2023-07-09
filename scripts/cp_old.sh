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
# Функция создания резервной копии
if [ -d $folder_name ]; then
    if confirm "Создать резервную копию исходников проекта? (y/n or enter for no)"; then
        if [ -d $old_folder ]; then
            echo "[NodeJS React Builder] Удаляю предыдущую копию исходников проекта"
            rm -rf $old_folder
        fi
        echo "[NodeJS React Builder] Создаю резервную копию исходников проекта"
        cp -rf $folder_name $old_folder
    else
        echo "[NodeJS React Builder] Резервное копирование отменено"
    fi
fi