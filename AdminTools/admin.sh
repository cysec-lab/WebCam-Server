#!/bin/bash

HTDOCS_RECOVER_script_path="htdocsrecover.sh"
RECOVER_script_path="recover.sh"
Shutdown_script_path="allshutdown.sh"
CHANGE_HOSTS="changehosts.sh"
REVERT_HOSTS="reverthosts.sh"

sudo cp /var/www/html/IPAddress_DeviceID_Mapping.txt /home/pi/WebCam-Server/AdminTools/
sudo cp /var/www/html/setting.txt /home/pi/WebCam-Server/AdminTools/

while true; do
    echo "以下のオプションから選択してください:"
    echo "1) リカバリー（特定のリモートホストに対して）"
    echo "2) 簡易リカバリー（すべてのリモートホストに対して）"
    echo "3) リモートホストの一斉終了"
    echo "4) プログラムを終了"
    read -p "選択 (1/2/3/4/5/6): " option

    case $option in
        1)
            echo "特定のリモートホストに対してリカバリーを実行します。"
            read -p "リモートホストのアドレスを入力してください (例:192.168.3.100): " ip_address
            sh "$RECOVER_script_path" "$ip_address"
            ;;
        2)
            echo "すべてのリモートホストに対してリカバリーを実行します。"
            sh "$HTDOCS_RECOVER_script_path"
            echo "リカバリーの完了"
            ;;
        3)
            echo "リモートホストを一斉終了します。"
            sh "$Shutdown_script_path"
            echo "リモートホストの一斉終了を完了"
            ;;
        4)
            echo "プログラムを終了します。"
            break
            ;;
        *)
            echo "無効な選択です。もう一度選んでください。"
            ;;
    esac
done
