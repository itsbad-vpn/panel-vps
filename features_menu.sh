#!/bin/bash

# Menu Features
echo "==============================="
echo "        Features Menu           "
echo "==============================="
echo "1. Check Bandwidth"
echo "2. Speed Test VPS"
echo "3. Reboot VPS"
echo "4. Set Auto Reboot"
echo "5. Kembali"
echo -n "Pilih menu: "
read option

case $option in
  1) check_bandwidth ;;
  2) speed_test ;;
  3) reboot_vps ;;
  4) set_auto_reboot ;;
  5) exit ;;
  *) echo "Pilihan tidak valid"; exit ;;
esac
