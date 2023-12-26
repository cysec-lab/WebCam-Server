#!/bin/bash

# 既存のスクリプトのパス
EXISTING_SCRIPT_PATH="gen-eth0.1.sh"
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

echo "Systemd service has been created and started."
