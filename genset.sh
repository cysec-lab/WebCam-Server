#!/bin/bash

# For Server Program

# 出力するファイル
OUTPUT_FILE="setting.txt"

# ネットワーク情報ファイルのパス
source ip_addresses.txt

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

cp "$OUTPUT_FILE" /var/www/html
