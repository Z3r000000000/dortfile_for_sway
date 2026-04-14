#!/usr/bin/env bash

LOG_FILE="$REPO_DIR/install.log"
# Очищаем лог при запуске
echo "--- СТАРТ УСТАНОВКИ $(date) ---" > "$LOG_FILE"

log() {
    local level="$1"
    local msg="$2"
    case "$level" in
        "info")    echo -e "[${CL_BLUE}ℹ${RC}] $msg" ;;
        "success") echo -e "[${CL_GREEN}✔${RC}] $msg" ;;
        "error")   echo -e "[${CL_RED}✘${RC}] $msg" ; echo "[ERROR] $msg" >> "$LOG_FILE" ;;
        "warn")    echo -e "[${CL_YELLOW}⚠${RC}] $msg" ;;
    esac
    # Дублируем все сообщения в лог-файл без цветов
    echo "[$(date +'%H:%M:%S')] [$level] $msg" >> "$LOG_FILE"
}

# Функция-обертка для запуска команд
# Использование: run_cmd "Название действия" "команда"
run_cmd() {
    local msg="$1"
    local cmd="$2"

    log "info" "$msg..."
    if eval "$cmd" >> "$LOG_FILE" 2>&1; then
        log "success" "Готово: $msg"
    else
        log "warn" "Ошибка при: $msg. Подробности в install.log"
        return 1
    fi
}