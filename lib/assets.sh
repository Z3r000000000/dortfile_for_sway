#!/usr/bin/env bash

sync_assets() {
    # 1. Загрузка обоев
    local wall_url="https://github.com/dhrruvsharma/wallpapers.git"
    local wall_dir="$HOME/Pictures/Wallpapers"
    fetch_resource "$wall_url" "$wall_dir" "Коллекция обоев Tokyo Night"

    # 2. Пример загрузки чего-то еще (например, курсоров или иконок)
    # local icons_url="https://github.com/vinceliuice/Tela-circle-icon-theme.git"
    # fetch_resource "$icons_url" "/tmp/tela-icons" "Темы иконок"

    run_cmd "Обновление кэша шрифтов" "fc-cache -fv"
    log "success" "Все медиа-ресурсы синхронизированы."
}