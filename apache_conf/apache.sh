#!/bin/bash

SERVER_ADDR=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
FAKE_SERVER_ADDR=$(ip addr show eth0.1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

# Apacheの設定ファイルで正規サーバーのIPアドレスを置換
sed -i "s/<VirtualHost SERVER_ADDR:80>/<VirtualHost $SERVER_ADDR:80>/" 000-default.conf
sed -i "s/<VirtualHost SERVER_ADDR:443>/<VirtualHost $SERVER_ADDR:443>/" 001-normal.conf

# Apacheの設定ファイルで不正なのサーバーのIPアドレスを置換
sed -i "s/<VirtualHost FAKE_SERVER_ADDR:80>/<VirtualHost $FAKE_SERVER_ADDR:80>/" 000-default.conf
sed -i "s/<VirtualHost FAKE_SERVER_ADDR:443>/<VirtualHost $FAKE_SERVER_ADDR:443>/" 002-trap.conf




