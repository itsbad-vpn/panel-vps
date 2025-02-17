#!/bin/bash

VMESS_DIR="/etc/vmess"
VMESS_USERS="$VMESS_DIR/users.db"
BOT_TOKEN="123456:ABCDEF-TOKEN-BOT"  # Ganti dengan token bot Telegram
CHAT_ID="123456789"  # Ganti dengan ID chat Telegram

# Buat folder jika belum ada
mkdir -p $VMESS_DIR
touch $VMESS_USERS

# Fungsi Kirim Notifikasi ke Telegram
send_telegram() {
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$1" > /dev/null
}

# Fungsi untuk menghasilkan link VMess dalam format base64
generate_vmess_link() {
    local uuid=$1
    local domain="VIP.itsbad-vpn.my.id"
    local port_tls="443"
    local port_no_tls="80"
    local alterid="0"
    local network="ws"
    local path_ws="/vmess"
    local security="auto"
    
    local config="{\"v\":\"2\",\"ps\":\"dilan\",\"add\":\"$domain\",\"port\":\"$port_tls\",\"id\":\"$uuid\",\"aid\":\"$alterid\",\"net\":\"$network\",\"path\":\"$path_ws\",\"type\":\"none\",\"host\":\"$domain\",\"tls\":\"tls\"}"
    local encoded=$(echo -n "$config" | base64)
    
    echo "$encoded"
}

# Fungsi Membuat Akun VMess
create_vmess() {
    echo "================= CREATE VMESS ACCOUNT ================="

    # Validasi Username (Min 5, Max 17 karakter)
    while true; do
        read -p "Masukkan Username (5-17 karakter): " username
        if [[ ${#username} -ge 5 && ${#username} -le 17 ]]; then
            break
        else
            echo "⚠️ Username harus antara 5-17 karakter!"
        fi
    done

    # Generate UUID
    uuid=$(cat /proc/sys/kernel/random/uuid)

    read -p "Masukkan Durasi Akun (hari): " days
    read -p "Masukkan Quota Limit (GB): " quota
    read -p "Masukkan Limit IP: " limit_ip

    # Set tanggal expired
    exp_date=$(date -d "$days days" +"%Y-%m-%d")

    # Simpan data akun ke database
    echo "$username $uuid $exp_date $quota $limit_ip 0GB offline" >> $VMESS_USERS

    # Generate link VMess
    encoded_vmess_ws_tls=$(generate_vmess_link $uuid)

    # Tampilkan Akun di Terminal
    clear
    echo "======================================================="
    echo "✅ Akun VMess berhasil dibuat!"
    echo "======================================================="
    echo "🔹 Username    : $username"
    echo "🔹 UUID        : $uuid"
    echo "🔹 Expired     : $exp_date"
    echo "🔹 Quota Limit : ${quota}GB"
    echo "🔹 Limit IP    : $limit_ip"
    echo "🔹 Status      : offline"
    echo "======================================================="

    # Tampilkan link VMess
    echo "————————————————————————————————————"
    echo "               VMESS"
    echo "————————————————————————————————————"
    echo "Remarks        : $username"
    echo "CITY           : $city"
    echo "ISP            : $isp"
    echo "Domain         : $domain"
    echo "Port TLS       : 443,8443"
    echo "Port none TLS  : 80,8080"
    echo "Port any       : 2052,2053,8880"
    echo "id             : $uuid"
    echo "alterId        : 0"
    echo "Security       : auto"
    echo "network        : ws,grpc,upgrade"
    echo "path ws        : /vmess - /whatever"
    echo "serviceName    : vmess"
    echo "path upgrade   : /upvmess"
    echo "Expired On     : $exp_date"
    echo "————————————————————————————————————"
    echo "           VMESS WS TLS"
    echo "————————————————————————————————————"
    echo "vmess://$encoded_vmess_ws_tls"
    echo "————————————————————————————————————"

    # Kirim ke Telegram
    send_telegram "🔥 *Akun VMess Baru Dibuat!* 🔥%0A%0A🔹 *Username* : $username%0A🔹 *UUID* : $uuid%0A🔹 *Expired* : $exp_date%0A🔹 *Quota* : ${quota}GB%0A🔹 *IP Limit* : $limit_ip%0A🔹 *Status* : offline"
}

# Fungsi Menampilkan Daftar Akun VMess
list_vmess() {
    echo "================= LIST AKUN VMESS ================="
    printf "%-15s %-36s %-12s %-10s %-8s %-10s\n" "Username" "UUID" "Exp Date" "Quota" "IP Limit" "Status"
    echo "---------------------------------------------------------------------------------------------------"
    cat $VMESS_USERS | while read user uuid exp quota ip_limit usage status; do
        printf "%-15s %-36s %-12s %-10s %-8s %-10s\n" "$user" "$uuid" "$exp" "${quota}GB" "$ip_limit" "$status"
    done
}

# Fungsi Cek Akun VMess (Online/Offline)
check_vmess() {
    echo "================= CHECK VMESS ACCOUNTS ================="
    printf "%-15s %-12s %-10s %-8s %-10s\n" "Username" "Exp Date" "Quota" "IP Limit" "Status"
    echo "--------------------------------------------------"
    cat $VMESS_USERS | while read user uuid exp quota ip_limit usage status; do
        if [[ $status == "offline" ]]; then
            color="\e[31m"  # Merah untuk offline
        else
            color="\e[32m"  # Hijau untuk online
        fi
        printf "$color%-15s %-12s %-10s %-8s %-10s\e[0m\n" "$user" "$exp" "${quota}GB" "$ip_limit" "$status"
    done
}

# Fungsi Menghapus Akun VMess
delete_vmess() {
    echo "================= DELETE VMESS ACCOUNT ================="
    read -p "Masukkan Username: " username
    if grep -q "^$username " $VMESS_USERS; then
        sed -i "/^$username /d" $VMESS_USERS
        echo "✅ Akun $username berhasil dihapus!"
    else
        echo "❌ Akun $username tidak ditemukan!"
    fi
}

# Fungsi Recovery Akun VMess (Mengaktifkan kembali akun expired)
recovery_vmess() {
    echo "================= RECOVERY VMESS ACCOUNT ================="
    read -p "Masukkan Username: " username
    if grep -q "^$username " $VMESS_USERS; then
        # Set tanggal expired baru (perpanjangan 7 hari)
        sed -i "s/^$username .*$/$(echo "$username $(date -d '+7 days' +"%Y-%m-%d") 10 1 0GB offline")/" $VMESS_USERS
        echo "✅ Akun $username berhasil diperpanjang 7 hari!"
    else
        echo "❌ Akun $username tidak ditemukan!"
    fi
}

# Menu VMess
while true; do
    clear
    echo "==============================="
    echo "        VMess Menu"
    echo "==============================="
    echo "1. Create Akun VMess"
    echo "2. Delete Akun VMess"
    echo "3. List Akun VMess"
    echo "4. Cek Akun VMess (Online/Offline)"
    echo "5. Recovery Akun VMess"
    echo "6. Back to Menu"
    echo -n "Pilih menu: "
    read option

    case $option in
        1) create_vmess ;;
        2) delete_vmess ;;
        3) list_vmess ;;
        4) check_vmess ;;
        5) recovery_vmess ;;
        6) exit ;;
        *) echo "Pilihan tidak valid!"; sleep 2 ;;
    esac
done
