#!/usr/bin/env bash

# Универсальный загрузчик ресурсов (git или curl)
fetch_resource() {
    local url="$1"
    local target="$2"
    local description="$3"

    log "info" "Синхронизация: $description..."
    
    if [ -d "$target/.git" ]; then
        run_cmd "Обновление $description" "cd '$target' && git pull"
    else
        mkdir -p "$(dirname "$target")"
        run_cmd "Загрузка $description" "git clone --depth 1 '$url' '$target'"
    fi
}