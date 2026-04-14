#!/usr/bin/env bash

# Универсальный загрузчик
fetch_resource() {
    local url="$1"
    local target="$2"
    local description="$3"

    log "info" "Загрузка: $description..."
    
    if [ -d "$target/.git" ]; then
        run_cmd "Обновление $description" "cd $target && git pull"
    else
        run_cmd "Клонирование $description" "git clone --depth 1 $url $target"
    fi
}