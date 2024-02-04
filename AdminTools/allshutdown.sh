#!/bin/bash

# hosts.txt ファイルからホスト名を読み込む
while IFS='|' read -r IP_ADDRESS ID; do
    #Apacheの再起動
    rsh "$IP_ADDRESS" "sudo shutdown -h now" < /dev/null

    #完了メッセージ
    echo "完了：$IP_ADDRESS"
    
done < "IPAddress_DeviceID_Mapping.txt"
