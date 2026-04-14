#!/usr/bin/env bash
set -e

export REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LIB_DIR="$REPO_DIR/lib"
export LOG_FILE="$REPO_DIR/install.log"

for module in "$LIB_DIR/"*.sh; do source "$module"; done

# Функция подменю
config_submenu() {
    while true; do
        print_banner
        echo -e "${BOLD}ВЫБОРОЧНОЕ ОБНОВЛЕНИЕ КОНФИГОВ:${RC}"
        echo -e "  ${CL_CYAN}1)${RC} Обновить Sway"
        echo -e "  ${CL_CYAN}2)${RC} Обновить Waybar"
        echo -e "  ${CL_CYAN}3)${RC} Обновить Foot (Терминал)"
        echo -e "  ${CL_CYAN}4)${RC} Обновить Fish"
        echo -e "  ${CL_CYAN}5)${RC} Обновить ВСЁ сразу"
        echo -e "  ${CL_RED}6)${RC} Назад в главное меню"
        read -p ">> " subchoice

        case $subchoice in
            1) deploy_specific "sway" "Sway" ;;
            2) deploy_specific "waybar" "Waybar" ;;
            3) deploy_specific "foot" "Foot Terminal" ;;
            4) deploy_specific "fish" "Fish Shell" ;;
            5) deploy_configs ;;
            6) break ;;
            *) echo "Неверный выбор" ; sleep 1 ;;
        esac
        echo -e "\nНажмите Enter, чтобы продолжить..."
        read
    done
}

# Главный цикл
while true; do
    print_banner
    echo -e "${BOLD}Выберите действие:${RC}"
    echo -e "  ${CL_GREEN}1)${RC} ${BOLD}ПОЛНАЯ УСТАНОВКА${RC}"
    echo -e "  ${CL_BLUE}2)${RC} [System] Пакеты и драйверы"
    echo -e "  ${CL_MAGENTA}3)${RC} [Configs] МЕНЮ КОНФИГУРАЦИЙ"
    echo -e "  ${CL_CYAN}4)${RC} [Assets] Загрузка обоев"
    echo -e "  ${CL_YELLOW}5)${RC} [Check] Проверка системы"
    echo -e "  ${CL_RED}6)${RC} Выход"
    read -p ">> " choice

    case $choice in
        1) detect_hardware && install_packages && deploy_configs && sync_assets && verify_system ;;
        2) detect_hardware && install_packages ;;
        3) config_submenu ;;
        4) sync_assets ;;
        5) verify_system ;;
        6) exit 0 ;;
        *) log "warn" "Неверный выбор" ; sleep 1 ;;
    esac
done