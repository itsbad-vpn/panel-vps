#!/bin/bash

# Menu V2Ray
echo "==============================="
echo "        V2Ray Menu             "
echo "==============================="
echo "1. Vmess"
echo "2. Vless"
echo "3. Trojan"
echo "4. Kembali"
echo -n "Pilih menu: "
read option

case $option in
  1) setup_vmess ;;
  2) setup_vless ;;
  3) setup_trojan ;;
  4) exit ;;
  *) echo "Pilihan tidak valid"; exit ;
