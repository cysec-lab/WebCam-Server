#!/bin/bash

# hosts.txt ファイルからホスト名を読み込む
while IFS=' ' read -r IP_ADDRESS ID; do

    #権限の変更（要らないかも）
    rsh "$IP_ADDRESS" "sudo chown -R pi:pi /usr/local/apache2/htdocs" < /dev/null

    #HTML,CSS,JavaScriptファイルの削除
    rsh "$IP_ADDRESS" "sudo rm /usr/local/apache2/htdocs/*.{html,js,css}" < /dev/null

    #必要ファイルのコピー
    rcp htdocs/* "$IP_ADDRESS":/usr/local/apache2/htdocs

    #権限を適切に設定し直す
    rsh "$IP_ADDRESS" "sudo chown -R daemon:daemon /usr/local/apache2/htdocs/*" < /dev/null
    rsh "$IP_ADDRESS" "sudo chmod -R 755 /usr/local/apache2/htdocs/*" < /dev/null

    #Apacheの再起動
    rsh "$IP_ADDRESS" "sudo /usr/local/apache2/bin/apachectl restart" < /dev/null
    
    #完了メッセージ
    echo "完了：$IP_ADDRESS: $ID"

done < "IPAddress_DeviceID_Mapping.txt"
