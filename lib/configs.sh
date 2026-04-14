#!/usr/bin/env bash

# Функция для частичного обновления
deploy_specific() {
    local target=$1
    local name=$2
    local backup_dir="$HOME/.config_backups/partial_$(date +%Y%m%d_%H%M%S)"

    log "info" "Обновление компонента: $name"
    
    # Бэкап только одной части
    if [ -e "$HOME/.config/$target" ]; then
        mkdir -p "$backup_dir"
        mv "$HOME/.config/$target" "$backup_dir/"
    fi

    # Копирование из репозитория
    mkdir -p "$HOME/.config/$target"
    if [ -d "$REPO_DIR/configs/$target" ]; then
        cp -r "$REPO_DIR/configs/$target/." "$HOME/.config/$target/"
        log "success" "$name успешно обновлен."
    elif [ -f "$REPO_DIR/configs/$target" ]; then
        # Если это одиночный файл (например starship.toml)
        cp "$REPO_DIR/configs/$target" "$HOME/.config/$target"
        log "success" "$name успешно обновлен."
    else
        log "warn" "Источник $target не найден в репозитории!"
    fi
}

# Старая функция для полного деплоя (использует новую логику)
deploy_configs() {
    log "info" "Запуск полного деплоя конфигураций..."
    deploy_specific "sway" "Sway WM"
    deploy_specific "waybar" "Waybar"
    deploy_specific "foot" "Foot Terminal"
    deploy_specific "mako" "Mako Notifications"
    deploy_specific "wofi" "Wofi Launcher"
    deploy_specific "fish" "Fish Shell"
    deploy_specific "starship.toml" "Starship Prompt"
}