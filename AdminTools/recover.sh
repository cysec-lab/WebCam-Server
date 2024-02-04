#!/bin/bash

# 設定ファイルとターゲットファイルのパス
SETTING_FILE="setting.txt"
TARGET_FILE="target.txt"

# Apache2のインストール場所
apache_dir="/usr/local/apache2"
iot_tools_dir="IoTTools"

# 引数のチェック
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <IP Address>"
    exit 1
fi

# 引数からIPアドレスを取得
IP_ADDRESS="$1"

# 対応表ファイルのパス
MAPPING_FILE="IPAddress_DeviceID_Mapping.txt"

# IPアドレスに対応するIDを検索
ID=$(grep "^$IP_ADDRESS|" "$MAPPING_FILE" | cut -d'|' -f2)

# IDが見つからない場合のエラーメッセージと終了
if [ -z "$ID" ]; then
    echo "Error: No ID found for IP Address $IP_ADDRESS."
    exit 1
fi

echo "Recovering $ID ($IP_ADDRESS)..."

# ディレクトリの削除
rsh "$IP_ADDRESS" "sudo rm -rf $apache_dir/htdocs $apache_dir/cgi-bin $apache_dir/downloads $apache_dir/backup"

# 必要なディレクトリの作成
rsh "$IP_ADDRESS" "sudo mkdir -p $apache_dir/htdocs/images $apache_dir/htdocs/images2 $apache_dir/downloads $apache_dir/backup $apache_dir/cgi-bin"
rsh "$IP_ADDRESS" "sudo chown -R pi:pi $apache_dir/htdocs $apache_dir/downloads $apache_dir/backup $apache_dir/cgi-bin"

# 必要なファイルのコピー
rcp cgi-bin/* "$IP_ADDRESS":$apache_dir/cgi-bin && rcp backup/* "$IP_ADDRESS":$apache_dir/backup && rcp htdocs/* "$IP_ADDRESS":$apache_dir/htdocs

# ID/PW設定
username="user"
password="password"
htpasswd_file="$apache_dir/htdocs/.htpasswd"
rsh "$IP_ADDRESS" "sudo htpasswd -bc $htpasswd_file $username $password"

# setting.txtの3行目を読み込む
LINE_TO_COPY=$(sed -n '3p' "$SETTING_FILE")

# target.txtが存在しない場合は作成する
if [ ! -f "$TARGET_FILE" ]; then
    touch "$TARGET_FILE"
fi

{
    echo "$LINE_TO_COPY"
    echo "$ID"
    echo "$ID"
} >> "$TARGET_FILE"

rcp $TARGET_FILE "$IP_ADDRESS":$apache_dir/cgi-bin
rm $TARGET_FILE

# 権限設定
rsh "$IP_ADDRESS" "sudo chmod -R 775 $apache_dir/downloads $apache_dir/backup $apache_dir/cgi-bin $apache_dir/htdocs"
rsh "$IP_ADDRESS" "sudo chown -R daemon:daemon $apache_dir/downloads $apache_dir/backup $apache_dir/cgi-bin $apache_dir/htdocs"

# Apacheの再起動
rsh "$IP_ADDRESS" "sudo $apache_dir/bin/apachectl restart"


echo "完了：$ID ($IP_ADDRESS)"