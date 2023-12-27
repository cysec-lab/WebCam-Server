#!/bin/bash
#サーバー証明書の仕組みが完成したら修正

# 既存のスクリプトのパス
EXISTING_SCRIPT_PATH="gen_eth0.1.sh"
sudo sh "$EXISTING_SCRIPT_PATH"
# スクリプトの新しいパス
NEW_SCRIPT_PATH="/usr/local/bin/recreate_eth0.1.sh"

# スクリプトを新しい場所にコピーし、実行可能にする
sudo cp "$EXISTING_SCRIPT_PATH" "$NEW_SCRIPT_PATH"
sudo chmod +x "$NEW_SCRIPT_PATH"

# systemd サービスファイルの内容
SERVICE_FILE_CONTENT="[Unit]
Description=Recreate eth0.1 interface on startup
After=network.target

[Service]
Type=oneshot
ExecStart=$NEW_SCRIPT_PATH

[Install]
WantedBy=multi-user.target"

# systemd サービスファイルのパス
SERVICE_FILE="/etc/systemd/system/recreate-eth0.1.service"

# サービスファイルを作成し、配置する
echo "$SERVICE_FILE_CONTENT" | sudo tee "$SERVICE_FILE" > /dev/null

# 新しいサービスを有効にして起動
sudo systemctl enable recreate-eth0.1.service
sudo systemctl start recreate-eth0.1.service

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

# Apacheの設定ファイルで不正なサーバーのIPアドレスを置換
#sed -i "s/<VirtualHost FAKE_SERVER_ADDR:80>/<VirtualHost $FAKE_SERVER_ADDR:80>/" /etc/apache2/sites-available/000-default.conf

# 設定ファイルを/var/www/htmlにコピー
cp "$OUTPUT_FILE" /var/www/html
sudo chown -R www-data:www-data /var/www/html/setting.txt

# スクリプトの実行が完了したことを示すメッセージ
echo "****************************************************"
echo "*Network settings have been successfully completed.*"
echo "****************************************************"