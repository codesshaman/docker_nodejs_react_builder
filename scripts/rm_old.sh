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
if [ -d $old_folder ]; then
    if confirm "Удалить предыдущую резервную копию исходников проекта? (y/n or enter for no)"; then
        echo "[NodeJS React Builder] Удаляю резервную копию исходников проекта"
        rm -rf $old_folder
    else
        echo "[NodeJS React Builder] Удаление отменено"
    fi
fi
