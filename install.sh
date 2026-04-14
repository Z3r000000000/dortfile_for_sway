#!/usr/bin/env bash

# --- КОНФИГУРАЦИЯ ---
LOG_FILE="manage_$(date +%F_%T).log"
BACKUP_DIR="$HOME/backups/dotfiles_$(date +%F_%T)"
REPO_DIR=$(pwd)

# Цвета
RC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'

log() {
    local timestamp=$(date +"%H:%M:%S")
    echo -e "${timestamp} [$1] : $2" >> "$LOG_FILE"
    case "$1" in
        "INFO")    echo -e "${BLUE}[INFO]${RC} $2" ;;
        "SUCCESS") echo -e "${GREEN}[OK]${RC} $2" ;;
        "WARN")    echo -e "${YELLOW}[WARN]${RC} $2" ;;
        "ERROR")   echo -e "${RED}[ERROR]${RC} $2" ;;
    esac
}

# --- ФУНКЦИЯ БЭКАПА ---
create_backup() {
    log "INFO" "Создание бэкапа текущей конфигурации в $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    
    # Список папок для бэкапа
    local targets=("sway" "waybar" "wofi" "mako" "foot" "wlogout")
    
    for target in "${targets[@]}"; do
        if [ -d "$HOME/.config/$target" ]; then
            cp -r "$HOME/.config/$target" "$BACKUP_DIR/"
            log "INFO" "Бэкап $target выполнен."
        fi
    done
    log "SUCCESS" "Бэкап завершен."
}

# --- ПРОВЕРКА ОБНОВЛЕНИЙ GIT ---
check_for_updates() {
    log "INFO" "Проверка обновлений репозитория на GitHub..."
    git fetch origin >> "$LOG_FILE" 2>&1
    
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})
    
    if [ "$LOCAL" != "$REMOTE" ]; then
        log "WARN" "Обнаружена новая версия в GitHub!"
        read -p "Обновить локальный репозиторий? (y/n): " up_resp
        if [[ "$up_resp" == "y" ]]; then
            git pull origin $(git branch --show-current) >> "$LOG_FILE" 2>&1
            log "SUCCESS" "Репозиторий обновлен. Пожалуйста, перезапустите скрипт."
            exit 0
        fi
    else
        log "SUCCESS" "Локальный репозиторий актуален."
    fi
}

# --- ФУНКЦИЯ ПОЛНОЙ УСТАНОВКИ (ТВОЯ ПРОШЛАЯ ЛОГИКА) ---
full_install() {
    create_backup
    log "INFO" "Начало полной установки..."
    # Тут вызываются твои функции детекции железа и установки пакетов
    # (Детекция GPU, pacman -S, ZRAM и т.д.)
    # ...
    deploy_configs
}

# --- ФУНКЦИЯ ВОЗВРАТА К СТАБИЛЬНОЙ ВЕРСИИ ---
reset_to_stable() {
    log "WARN" "ВНИМАНИЕ: Все локальные изменения в репозитории будут стерты!"
    read -p "Вы уверены, что хотите сбросить проект к стабильной версии GitHub? (y/n): " confirm
    if [[ "$confirm" == "y" ]]; then
        create_backup
        log "INFO" "Сброс репозитория к origin/master..."
        git reset --hard origin/$(git branch --show-current) >> "$LOG_FILE" 2>&1
        git clean -fd >> "$LOG_FILE" 2>&1
        log "SUCCESS" "Репозиторий сброшен."
        deploy_configs
    else
        log "INFO" "Сброс отменен."
    fi
}

# --- РАЗВЕРТЫВАНИЕ КОНФИГОВ ---
deploy_configs() {
    log "INFO" "Развертывание конфигурационных файлов в ~/.config..."
    mkdir -p "$HOME/.config"
    cp -r "$REPO_DIR/configs/"* "$HOME/.config/"
    chmod +x "$HOME/.config/sway/scripts/"* 2>/dev/null
    log "SUCCESS" "Конфигурация развернута."
}

# --- ГЛАВНОЕ МЕНЮ ---
show_menu() {
    clear
    echo -e "${CYAN}=========================================="
    echo -e "   МЕНЕДЖЕР ДОТФАЙЛОВ TOKYO NIGHT SWAY   "
    echo -e "==========================================${RC}"
    check_for_updates
    echo -e "\nВыберите вариант работы:"
    echo -e "${G}1)${RC} Полная установка (Драйверы + Пакеты + Конфиги)"
    echo -e "${Y}2)${RC} Сброс к стабильной версии (GitHub State + Backup)"
    echo -e "${B}3)${RC} Только обновить конфиги (Deploy)"
    echo -e "${R}4)${RC} Выход"
    echo -e ""
    read -p "Введите номер: " choice

    case $choice in
        1) full_install ;;
        2) reset_to_stable ;;
        3) create_backup && deploy_configs ;;
        4) exit 0 ;;
        *) log "ERROR" "Неверный выбор"; sleep 2; show_menu ;;
    esac
}

# Запуск
show_menu