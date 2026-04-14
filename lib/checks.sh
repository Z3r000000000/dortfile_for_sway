#!/usr/bin/env bash

# Добавим проверку AUR пакетов в общий отчет
verify_system() {
    print_banner
    log "info" "Диагностика системы..."
    echo "--------------------------------------------------"
    
    local critical_errors=0

    echo -e "${BOLD}Официальные репозитории:${RC}"
    run_check "Sway WM" _check_pkg "sway" || ((critical_errors++))
    run_check "Waybar" _check_pkg "waybar" || ((critical_errors++))
    
    echo -e "\n${BOLD}AUR пакеты:${RC}"
    run_check "wlogout (меню выхода)" _check_pkg "wlogout"
    
    echo -e "\n${BOLD}Конфигурация:${RC}"
    run_check "Конфиг Fish" _check_file "fish/config.fish"
    run_check "Конфиг Starship" _check_file "starship.toml"

    echo "--------------------------------------------------"
    if [ $critical_errors -eq 0 ]; then
        log "success" "Базовая система настроена. Можно запускать Sway!"
    else
        log "error" "Критическая нехватка пакетов ($critical_errors). Проверьте install.log"
    fi
}