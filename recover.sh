#!/bin/bash
# 引数からホストアドレスを取得
host=$1

# Apache2のインストール場所
apache_dir="/usr/local/apache2"

# 引数が提供されているか確認
if [ -z "$host" ]; then
    echo "使用方法: sudo sh recover.sh 対象のIPアドレス"
    exit 1
fi

# ディレクトリの削除
rsh "$host" "sudo rm -rf $apache_dir/htdocs $apache_dir/cgi-bin $apache_dir/downloads $apache_dir/backup"

# 必要なディレクトリの作成
rsh "$host" "sudo mkdir -p $apache_dir/htdocs/images $apache_dir/htdocs/images2 $apache_dir/downloads $apache_dir/backup"

# 必要なファイルのコピー
rcp cgi-bin/* "$host":$apache_dir/cgi-bin/ && rcp backup/* "$host":$apache_dir/backup/ && rcp htcdocs/* "$host":$apache_dir/htdocs/

# target.txtのコピーと編集
rcp target.txt "$host":/home/pi
rcp IPtoTarget.sh "$host":/home/pi

#IPアドレスをもとにtarget.txtを修正
rsh "$host" 'sudo chmod +x /home/pi/IPtoTarget.sh && sudo bash /home/pi/IPtoTarget.sh'

# target.txtの移動
rsh "$host" 'cp /home/pi/target.txt $apache_dir/cgi-bin/ && cp /home/pi/target.txt $apache_dir/backup/'

# ID/PW設定
username="user"
password="password"
htpasswd_file="$apache_dir/htdocs/.htpasswd"
rsh "$host" "sudo htpasswd -bc $htpasswd_file $username $password"

# 権限設定
rsh "$host" "sudo chmod 775 $apache_dir/downloads $apache_dir/backup && sudo chmod -R 755 $apache_dir/cgi-bin $apache_dir/htdocs"
rsh "$host" "sudo chown daemon:daemon $apache_dir/downloads $apache_dir/backup && sudo chown -R daemon:daemon $apache_dir/cgi-bin $apache_dir/htdocs"

# Apacheの再起動
rsh "$host" "sudo $apache_dir/bin/apachectl restart"

echo "完了：$host"

