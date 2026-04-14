#!/usr/bin/env bash

# Пакеты из официальных репозиториев
REPO_PKGS=(
    sway waybar foot wofi mako swaylock git base-devel 
    fish starship brightnessctl pamixer libnotify wl-clipboard
    ttf-jetbrains-mono-nerd ttf-font-awesome adobe-source-code-pro-fonts
    zram-generator mesa intel-media-driver vulkan-intel
)

# Пакеты из AUR
AUR_PKGS=(
    wlogout
    # сюда можно добавить swaylock-effects, если захочешь размытие при блокировке
)

install_packages() {
    log "info" "Обновление баз данных pacman..."
    sudo pacman -Sy

    # 1. Установка официальных пакетов
    log "info" "Установка системных пакетов..."
    for pkg in "${REPO_PKGS[@]}"; do
        if _check_pkg "$pkg"; then
            log "success" "Пакет $pkg уже установлен"
        else
            run_cmd "Установка $pkg" "sudo pacman -S --needed --noconfirm $pkg"
        fi
    done

    # 2. Обработка AUR
    install_aur_helper
    
    for pkg in "${AUR_PKGS[@]}"; do
        if _check_pkg "$pkg"; then
            log "success" "AUR пакет $pkg уже установлен"
        else
            if command -v yay &> /dev/null; then
                run_cmd "Установка AUR пакета $pkg" "yay -S --noconfirm $pkg"
            elif command -v paru &> /dev/null; then
                run_cmd "Установка AUR пакета $pkg" "paru -S --noconfirm $pkg"
            else
                log "warn" "Пропуск $pkg: AUR помощник не найден."
            fi
        fi
    done
}

install_aur_helper() {
    if command -v yay &> /dev/null || command -v paru &> /dev/null; then
        log "success" "AUR помощник найден."
    else
        log "info" "AUR помощник не найден. Пытаюсь установить yay..."
        run_cmd "Клонирование yay" "git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin"
        run_cmd "Сборка yay" "cd /tmp/yay-bin && makepkg -si --noconfirm"
    fi
}