#!/usr/bin/env bash
sync_assets() {
    local wall_url="https://github.com/dhrruvsharma/wallpapers.git"
    local wall_dir="$HOME/Pictures/Wallpapers"
    
    fetch_resource "$wall_url" "$wall_dir" "Обои Tokyo Night"
}