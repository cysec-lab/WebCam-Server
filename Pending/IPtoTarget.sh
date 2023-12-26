#!/bin/bash

# ホストのIPアドレスの最初の部分を取得
IP_ADDRESS=$(hostname -I | awk '{print $1}')

# IPアドレスの最後の部分を抽出
HOST_PART=$(echo $IP_ADDRESS | cut -d. -f4)

# 新しいホスト部分を作成
NEW_HOST_PART="1000${HOST_PART}"

# target.txtの2行目と3行目を置換
sed -i "2s/.*/${NEW_HOST_PART}/" /home/pi/target.txt
sed -i "3s/.*/${NEW_HOST_PART}/" /home/pi/target.txt
