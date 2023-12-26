#!/bin/bash

# ネットワーク情報ファイルのパス
source ip_addresses.txt

# Apacheの設定ファイルで正規サーバーのIPアドレスを置換
sed -i "s/<VirtualHost SERVER_ADDR:80>/<VirtualHost $SERVER_ADDR:80>/" /etc/apache2/sites-available/000-default.conf

# Apacheの設定ファイルで不正なのサーバーのIPアドレスを置換
#sed -i "s/<VirtualHost FAKE_SERVER_ADDR:80>/<VirtualHost $FAKE_SERVER_ADDR:80>/" /etc/apache2/sites-available/000-default.conf