#!/bin/bash

# Apache2のインストール
sudo apt-get update
sudo apt-get install -y apache2

# PHP、Apache2のPHPモジュール、およびPHPのSQLite3拡張のインストール
sudo apt-get install -y php libapache2-mod-php php-sqlite3

# PHPのバージョンを取得し、適切なモジュールを有効にする
PHP_VERSION=$(php -v | head -n 1 | cut -d ' ' -f 2 | cut -d '.' -f 1,2)
echo "Detected PHP version: $PHP_VERSION"
sudo a2enmod "php$PHP_VERSION"
sudo systemctl restart apache2

# Dnsmasqのインストール
sudo apt-get install -y dnsmasq

# SQLite3のインストール
sudo apt-get install -y sqlite3

# /var/www/html内に必要なディレクトリを作成
sudo mkdir -p /var/www2/html/downloads
sudo mkdir -p /var/www/html/db
sudo mkdir -p /var/www/html/files
sudo mkdir -p /var/www/html/downloads

# Serverディレクトリからupdatefile.tar.gzを/var/www/html/downloadsへコピー
sudo cp Server/updatefile.tar.gz /var/www/html/downloads
sudo cp FakeServer/updatefile.tar.gz /var/www2/html/downloads

# htmlディレクトリからファイルを/var/www/htmlへコピー
sudo cp html/* /var/www/html

# SQLite3を使用してcamera.dbを作成し、cameraテーブルを作成
sudo sqlite3 /var/www/html/db/camera.db <<EOF
CREATE TABLE IF NOT EXISTS camera (
    id INTEGER PRIMARY KEY,
    password TEXT NOT NULL
);
EOF

# スクリプトの実行が完了したことを示すメッセージ
echo "***************************************************************"
echo "*Server-Setup have been successfully installed and configured.*"
echo "***************************************************************"