#!/bin/bash

# 設定ファイルとターゲットファイルのパス
SETTING_FILE="setting.txt"
TARGET_FILE="target.txt"

ID=1000101

# setting.txtの3行目を読み込む
LINE_TO_COPY=$(sed -n '3p' "$SETTING_FILE")

# target.txtが存在しない場合は作成する
if [ ! -f "$TARGET_FILE" ]; then
    touch "$TARGET_FILE"
fi

{
    echo "$LINE_TO_COPY"
    echo "$ID"
    echo "$ID"
} >> "$TARGET_FILE"

rm $TARGET_FILE