#!/bin/bash

# Konfigurasi Bot Telegram (Ganti TOKEN & CHAT_ID dengan yang sesuai)
BOT_TOKEN="123456789:YOUR_BOT_TOKEN"
CHAT_ID="YOUR_CHAT_ID"

# Fungsi membuat akun SSH
create_ssh() {
    echo "================= SSH ACCOUNT CREATION ================="
    while true; do
        read -p "Masukkan Username (Min 4, Max 17 karakter): " username
        if [[ ${#username} -ge 4 && ${#username} -le 17 ]]; then
            break
        else
            echo "⚠️ Username harus antara 4-17 karakter!"
        fi
    done
    
    read -p "Masukkan Password: " password
    read -p "Masukkan Quota Limit (GB): " quota
    read -p "Masukkan Limit IP: " limit_ip
    read -p "Masukkan Durasi Akun (hari): " days

    # Membuat akun SSH
    useradd -M -s /bin/false -e $(date -d "$days days" +"%Y-%m-%d") $username
    echo -e "$password\n$password" | passwd $username > /dev/null

    # Tanggal Expired
    exp_date=$(date -d "$days days" +"%Y-%m-%d")

    # Informasi VPS
    OS=$(lsb_release -ds)
    RAM=$(free -m | awk '/Mem:/ {print $2}')
    SWAP=$(free -m | awk '/Swap:/ {print $2}')
    CITY=$(curl -s ipinfo.io/city)
    ISP=$(curl -s ipinfo.io/org)
    IP=$(curl -s ifconfig.me)
    DOMAIN="VIP.itsbad-vpn.my.id"

    # Menampilkan Output di Terminal
    clear
    echo "======================================================="
    echo "📌 **Informasi Akun SSH**"
    echo "======================================================="
    echo "🔹 **Username**    : $username"
    echo "🔹 **Password**    : $password"
    echo "🔹 **Quota Limit** : ${quota}GB"
    echo "🔹 **Limit IP**    : $limit_ip"
    echo "🔹 **Expired**     : $exp_date"
    echo "======================================================="
    echo "🔹 **Host**        : $DOMAIN"
    echo "🔹 **TLS Ports**   : 443, 8443"
    echo "🔹 **Non-TLS**     : 80, 8080"
    echo "🔹 **OpenSSH**     : 444"
    echo "🔹 **Dropbear**    : 90"
    echo "🔹 **SlowDNS**     : 53, 5300"
    echo "🔹 **UDP-Custom**  : 1-65535"
    echo "🔹 **Squid Proxy** : 3128"
    echo "🔹 **OHP + SSH**   : 9080"
    echo "🔹 **OpenVPN TCP** : 80, 1194"
    echo "🔹 **OpenVPN UDP** : 25000"
    echo "🔹 **OpenVPN SSL** : 443"
    echo "🔹 **OpenVPN DNS** : 53"
    echo "🔹 **OHP + OVPN**  : 9088"
    echo "======================================================="
    echo "🔗 **Download OpenVPN Config**: "
    echo "http://$DOMAIN:81/myvpn-config.zip"
    echo "======================================================="
    
    # Mengirim Data ke Bot Telegram
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d parse_mode="Markdown" \
        -d text="✅ *Account Created Successfully*
—————————————————————*Itsbad-VPN*———————————————
📌 *Informasi Akun SSH*
────────────────────────────────────────
🔹 *Username*    : $username
🔹 *Password*    : $password
🔹 *Quota Limit* : ${quota}GB
🔹 *Limit IP*    : $limit_ip
🔹 *Expired*     : $exp_date
────────────────────────────────────────
🔹 *Host*        : $DOMAIN
🔹 *TLS Ports*   : 443, 8443
🔹 *Non-TLS*     : 80, 8080
🔹 *OpenSSH*     : 444
🔹 *Dropbear*    : 90
🔹 *SlowDNS*     : 53, 5300
🔹 *UDP-Custom*  : 1-65535
🔹 *Squid Proxy* : 3128
🔹 *OHP + SSH*   : 9080
🔹 *OpenVPN TCP* : 80, 1194
🔹 *OpenVPN UDP* : 25000
🔹 *OpenVPN SSL* : 443
🔹 *OpenVPN DNS* : 53
🔹 *OHP + OVPN*  : 9088
────────────────────────────────────────
🔗 *Download OpenVPN Config*:
http://$DOMAIN:81/myvpn-config.zip"
}

# Menu SSH
while true; do
    clear
    echo "==============================="
    echo "        SSH Menu               "
    echo "==============================="
    echo "1. Create Akun"
    echo "2. Hapus Akun"
    echo "3. Check Akun"
    echo "4. Cek IP Login"
    echo "5. Edit Akun"
    echo "6. Restore Akun"
    echo "7. List Akun"
    echo "8. Kembali"
    echo -n "Pilih menu: "
    read option

    case $option in
        1) create_ssh ;;
        2) echo "Fitur hapus akun belum dibuat!" ;;
        3) echo "Fitur check akun belum dibuat!" ;;
        4) echo "Fitur cek IP login belum dibuat!" ;;
        5) echo "Fitur edit akun belum dibuat!" ;;
        6) echo "Fitur restore akun belum dibuat!" ;;
        7) echo "Fitur list akun belum dibuat!" ;;
        8) exit ;;
        *) echo "Pilihan tidak valid!"; sleep 2 ;;
    esac
done
