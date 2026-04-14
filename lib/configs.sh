deploy_configs() {
    local backup_dir="$HOME/.config_backups/$(date +%Y%m%d_%H%M%S)"
    log "info" "Создание бэкапа в $backup_dir"
    mkdir -p "$backup_dir"

    # Создаем список того, что нужно бэкапить на основе папки configs
    # Это лучше, чем хардкодить имена папок
    for item in "$REPO_DIR/configs/"*; do
        local name=$(basename "$item")
        if [ -e "$HOME/.config/$name" ]; then
            mv "$HOME/.config/$name" "$backup_dir/"
        fi
    done

    log "info" "Деплой новых конфигов..."
    cp -r "$REPO_DIR/configs/"* "$HOME/.config/"
    
    # Копируем скрипты в sway
    mkdir -p "$HOME/.config/sway/scripts"
    cp -r "$REPO_DIR/scripts/"* "$HOME/.config/sway/scripts/"
    chmod +x "$HOME/.config/sway/scripts/"*.sh 2>/dev/null || true
}