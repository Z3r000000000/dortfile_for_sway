#!/usr/bin/env bash

install_packages() {
    log "info" "Установка системных пакетов..."
    sudo pacman -S --needed --noconfirm "${REPO_PKGS[@]}" $UCODE $GPU_DRV

    if ! command -v yay &> /dev/null; then
        fetch_resource "https://aur.archlinux.org/yay-bin.git" "/tmp/yay-bin" "AUR помощник (yay)"
        run_cmd "Сборка yay" "cd /tmp/yay-bin && makepkg -si --noconfirm"
    fi

    for pkg in "${AUR_PKGS[@]}"; do
        run_cmd "Установка $pkg" "yay -S --noconfirm $pkg"
    done
}