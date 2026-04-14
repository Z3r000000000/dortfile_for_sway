#!/usr/bin/env bash
set -e

export REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export LIB_DIR="$REPO_DIR/lib"
export LOG_FILE="$REPO_DIR/install.log"

for module in "$LIB_DIR/"*.sh; do source "$module"; done

print_banner

echo -e "${BOLD}Выберите действие:${RC}"
echo -e "  ${CL_GREEN}1)${RC} Полная установка (Все пункты ниже по очереди)"
echo -e "  ${CL_BLUE}2)${RC} [System] Установка пакетов и драйверов"
echo -e "  ${CL_MAGENTA}3)${RC} [Configs] Деплой конфигураций и бэкап"
echo -e "  ${CL_CYAN}4)${RC} [Assets] Загрузка обоев и ресурсов"
echo -e "  ${CL_YELLOW}5)${RC} [Check] Проверка состояния системы"
echo -e "  ${CL_RED}6)${RC} Выход"
read -p ">> " choice

case $choice in
    1)
        detect_hardware && install_packages && setup_zram
        setup_terminal && sync_assets && deploy_configs
        verify_system
        ;;
    2)
        detect_hardware && install_packages && setup_zram
        ;;
    3)
        deploy_configs && setup_terminal
        ;;
    4)
        sync_assets
        ;;
    5)
        verify_system
        ;;
    6)
        exit 0
        ;;
    *)
        log "warn" "Неверный выбор"
        ;;
esac