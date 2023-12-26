#!/bin/bash
# wlan0とwlan1のIPアドレスを取得し、SERVER_ADDRとFAKE_SERVER_ADDRとしてファイルに出力する

# インターフェースを事前に定義
interface_for_server_addr="eth0"
interface_for_fake_server_addr="eth0.1"

# 出力ファイル名を設定
output_file="ip_addresses.txt"

# ファイルを初期化
> $output_file

# SERVER_ADDR用のインターフェースのIPアドレスを取得しファイルに出力
ip_address_server=$(ip -f inet addr show $interface_for_server_addr | grep -Po 'inet \K[\d.]+')
echo "SERVER_ADDR=$ip_address_server" >> $output_file

# FAKE_SERVER_ADDR用のインターフェースのIPアドレスを取得しファイルに出力
ip_address_fake=$(ip -f inet addr show $interface_for_fake_server_addr | grep -Po 'inet \K[\d.]+')
echo "FAKE_SERVER_ADDR=$ip_address_fake" >> $output_file
