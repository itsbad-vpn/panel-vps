#!/bin/bash

# Konfigurasi Bot Telegram
BOT_TOKEN="123456789:YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"

# Informasi VPS
OS=$(uname -a)
RAM=$(free -m | awk '/Mem:/ {print $2}')
SWAP=$(free -m | awk '/Swap:/ {print $2}')
CITY=$(curl -s ipinfo.io/city)
ISP=$(curl -s ipinfo.io/org)
IP=$(curl -s ifconfig.me)
DOMAIN="VIP.itsbad-vpn.my.id"

# Fungsi untuk menampilkan informasi VPS
show_vps_info() {
    echo "==============================="
    echo "       Itsbad VPN               "
    echo "==============================="
    echo "OS      : $OS"
    echo "RAM     : ${RAM}M"
    echo "SWAP    : ${SWAP}M"
    echo "CITY    : $CITY"
    echo "ISP     : $ISP"
    echo "IP      : $IP"
    echo "DOMAIN  : $DOMAIN"
    echo "==============================="
}

# Menu utama
while true; do
    show_vps_info
    echo "1. Menu SSH"
    echo "2. Menu Vmess"
    echo "3. Menu Vless"
    echo "4. Menu Trojan"
    echo "5. Setup Bot Telegram"
    echo "6. Menu Features"
    echo "7. Exit"
    echo -n "Pilih menu: "
    read option

    case $option in
        1) ./ssh_menu.sh ;;  # Menu SSH, panggil ssh_menu.sh
        2) ./vmess_menu.sh ;;  # Menu Vmess
        3) ./vless_menu.sh ;;  # Menu Vless
        4) ./trojan_menu.sh ;;  # Menu Trojan
        5) ./setup_bot.sh ;;  # Setup Bot Telegram
        6) ./features_menu.sh ;;  # Menu Features
        7) exit ;;  # Exit
        *) echo "Pilihan tidak valid!"; sleep 2 ;;  # Handle invalid options
    esac
done
