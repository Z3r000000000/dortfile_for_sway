#!/usr/bin/env bash
setup_terminal() {
    log "info" "Настройка Fish shell..."
    [ "$SHELL" != "/usr/bin/fish" ] && chsh -s /usr/bin/fish
    run_cmd "Обновление кэша шрифтов" "fc-cache -fv"
}