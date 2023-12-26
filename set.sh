#!/bin/bash
#サーバー証明書の仕組みが完成したら修正

# IPアドレス取得用のコード
# インターフェースを事前に定義
interface_for_server_addr="eth0"
interface_for_fake_server_addr="eth0.1"

# SERVER_ADDR用のインターフェースのIPアドレスを取得しファイルに出力
SERVER_ADDR=$(ip -f inet addr show $interface_for_server_addr | grep -Po 'inet \K[\d.]+')

# FAKE_SERVER_ADDR用のインターフェースのIPアドレスを取得しファイルに出力
FAKE_SERVER_ADDR=$(ip -f inet addr show $interface_for_fake_server_addr | grep -Po 'inet \K[\d.]+')

# 出力するファイル
OUTPUT_FILE="setting.txt"

# 証明書ファイルのパス
#certFile="cert.pem"
#CN=$(openssl x509 -in "$certFile" -noout -subject | sed -n 's/.*CN = \([^/]*\).*/\1/p')

# 設定ファイルの作成
cat <<EOF > "$OUTPUT_FILE"
DNS_ADDR=${SERVER_ADDR}
SERVER_ADDR=${SERVER_ADDR}
http://${CN}
1000101
1000101
EOF

# Apacheの設定ファイルで正規サーバーのIPアドレスを置換
#sed -i "s/<VirtualHost SERVER_ADDR:80>/<VirtualHost $SERVER_ADDR:80>/" /etc/apache2/sites-available/000-default.conf

# Apacheの設定ファイルで不正なのサーバーのIPアドレスを置換
#sed -i "s/<VirtualHost FAKE_SERVER_ADDR:80>/<VirtualHost $FAKE_SERVER_ADDR:80>/" /etc/apache2/sites-available/000-default.conf

# 設定ファイルを/var/www/htmlにコピー
cp "$OUTPUT_FILE" /var/www/html
sudo chown -R www-data:www-data /var/www/html/setting.txt

# スクリプトの実行が完了したことを示すメッセージ
echo "********************************************"
echo "*Settings have been successfully completed.*"
echo "********************************************"