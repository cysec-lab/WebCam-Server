#!/bin/bash

# MACアドレスを保存するファイル
MAC_ADDRESS_FILE="/etc/network/eth0.1.mac"

# 初回実行時にMACアドレスを取得して保存
if [ ! -f $MAC_ADDRESS_FILE ]; then
    # eth0.1サブインターフェースを作成
    sudo ip link add link eth0 eth0.1 type macvlan

    # eth0.1サブインターフェースをアクティブにする
    sudo ip link set eth0.1 up

    # MACアドレスを取得してファイルに保存
    ip link show eth0.1 | awk '/ether/ {print $2}' > $MAC_ADDRESS_FILE
fi

# 保存されたMACアドレスを読み込む
DESIRED_MAC=$(cat $MAC_ADDRESS_FILE)

# eth0.1サブインターフェースを削除（存在する場合）
sudo ip link del eth0.1 2> /dev/null

# MACアドレスを使用してeth0.1サブインターフェースを再作成
sudo ip link add link eth0 address $DESIRED_MAC eth0.1 type macvlan

# eth0.1サブインターフェースをアクティブにする
sudo ip link set eth0.1 up
