#!/bin/bash

# Setup Bot Telegram
echo "==============================="
echo "    Setup Bot Telegram         "
echo "==============================="
echo -n "Masukkan token bot Telegram: "
read bot_token
echo -n "Masukkan chat ID: "
read chat_id

# Simpan konfigurasi
echo "Token: $bot_token" > bot_config.txt
echo "Chat ID: $chat_id" >> bot_config.txt

echo "Bot Telegram sudah disetup!"
