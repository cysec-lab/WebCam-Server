#!/bin/bash

# ネットワーク情報ファイルのパス
source ip_addresses.txt

# Import the sed command
import sed

# Apacheの設定ファイルで不正なのサーバーのIPアドレスを置換
sed -i "s/<VirtualHost FAKE_SERVER_ADDR:80>/<VirtualHost $FAKE_SERVER_ADDR:80>/" 000-default.conf
sed -i "s/<VirtualHost FAKE_SERVER_ADDR:443>/<VirtualHost $FAKE_SERVER_ADDR:443>/" 002-trap.conf

# 設定
DOMAIN="fakeserver.com"
PRIVATE_KEY="/etc/ssl/private/fakeserver.key"
CERTIFICATE="/etc/ssl/certs/fakeserver.crt"
CSR="fakeserver.csr"
APACHE_CONF="/etc/apache2/sites-available/fakeserver.com.conf"

# 秘密鍵の生成
openssl genrsa -out $PRIVATE_KEY 2048

# 証明書署名要求（CSR）の作成
openssl req -new -key $PRIVATE_KEY -out $CSR -subj "/CN=$DOMAIN"

# 自己署名証明書の生成
openssl x509 -req -days 1825 -in $CSR -signkey $PRIVATE_KEY -out $CERTIFICATE

# Apache Virtual Hostの設定
sed -i "s/SSLCertificateFile SSLCertificateFile_PATH/SSLCertificateFile $CERTIFICATE/" 002-trap.conf
sed -i "s/SSLCertificateKeyFile SSLCertificateKeyFile_PATH/SSLCertificateKeyFile $PRIVATE_KEY/" 002-trap.conf

# Apache設定の有効化とSSLモジュールの有効化
sudo a2ensite fakeserver.com.conf
sudo a2enmod ssl

# Apacheの再起動
sudo systemctl restart apache2

echo "自己署名証明書の設定が完了しました。"