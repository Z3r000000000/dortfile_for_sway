#!/usr/bin/env bash

REPO_PKGS=(sway waybar foot wofi mako swaylock git base-devel fish starship brightnessctl pamixer libnotify wl-clipboard ttf-jetbrains-mono-nerd ttf-font-awesome adobe-source-code-pro-fonts)
AUR_PKGS=(wlogout)

detect_hardware() {
    log "info" "Анализ оборудования..."
    if grep -q "Intel" /proc/cpuinfo; then
        UCODE="intel-ucode"
        GPU_DRV="mesa vulkan-intel intel-media-driver libva-intel-driver"
        log "info" "Оптимизация под Intel включена."
    else
        UCODE="amd-ucode"
        GPU_DRV="mesa lib32-mesa xf86-video-amdgpu"
    fi
}

install_packages() {
    log "info" "Синхронизация репозиториев..."
    sudo pacman -Sy --noconfirm

    log "info" "Установка пакетов..."
    sudo pacman -S --needed --noconfirm "${REPO_PKGS[@]}" $UCODE $GPU_DRV

    if ! command -v yay &> /dev/null; then
        fetch_resource "https://aur.archlinux.org/yay-bin.git" "/tmp/yay-bin" "AUR помощник (yay)"
        run_cmd "Сборка yay" "cd /tmp/yay-bin && makepkg -si --noconfirm"
    fi

    for pkg in "${AUR_PKGS[@]}"; do
        run_cmd "AUR пакет: $pkg" "yay -S --noconfirm $pkg"
    done
}

setup_zram() {
    run_cmd "Настройка ZRAM" "sudo pacman -S --needed --noconfirm zram-generator && \
    sudo bash -c 'echo -e \"[zram0]\nzram-size = ram / 2\ncompression-algorithm = zstd\" > /etc/systemd/zram-generator.conf' && \
    sudo systemctl daemon-reload && sudo systemctl start /dev/zram0"
}