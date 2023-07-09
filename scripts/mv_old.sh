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
# Функция восстановления
if [ -d $old_folder ]; then
    if confirm "Восстановить исходники из последней резервной копии? (y/n or enter for no)"; then
        echo "[NodeJS React Builder] Восстанавливаю резервную копию"
        rm -rf $folder_name
        cp -rf $old_folder $folder_name
    else
        echo "[NodeJS React Builder] Восстановление отменено"
    fi
else
    echo "[NodeJS React Builder] Резервная копия отсутствует"
fi
