<?php

// セマフォキーを生成（例としてファイルパスとプロジェクトIDを使用）
$semKey = ftok(__FILE__, 'b');
$semaphore = sem_get($semKey, 1, 0666, 1);

// セマフォを取得
sem_acquire($semaphore);

// カウンターを保存するファイルのパス
$settingFile = 'setting.txt';

// setting.txtファイルの読み込み
$settingContent = file_get_contents($settingFile);
$lines = explode("\n", $settingContent);

// ファイルダウンロード用のヘッダーを設定
header('Content-Type: text/plain');

// アクセスしてきた機器のIPアドレスを取得
$ipAddress = $_SERVER['REMOTE_ADDR'];

// ip.txtファイルから既存のIPアドレスを読み込み、重複をチェック
$file = 'IPAddress_DeviceID_Mapping.txt';
// ファイルが存在しない場合は新規作成
if (!file_exists($file)) {
    file_put_contents($file, '');
}

$existingEntries = file($file, FILE_IGNORE_NEW_LINES);

foreach ($existingEntries as $entry) {
    list($existingIP, $existingID) = explode('|', $entry);
    if ($ipAddress === $existingIP) {
        echo "$lines[0]\n";
        echo "$lines[1]\n";
        echo "$lines[2]\n";
        echo "$lines[3]\n";
        echo "$existingID\n";
        echo "$existingID\n";
        exit;
    }
}

// 新しいIDを設定
$ID = intval($lines[4]);

// テキストファイルにIPアドレスとIDを追記
$ipIdEntry = $ipAddress . '|' . $ID . PHP_EOL;
file_put_contents($file, $ipIdEntry, FILE_APPEND);

// 新しいIDと同名のフォルダを作成
$folder = 'files/' . $ID;
if (!file_exists($folder)) {
    mkdir($folder, 0755, true); // より安全なパーミッション設定
}

// camera.dbにデータを追記
try {
    $database = new SQLite3('db/camera.db');
    $database->exec("INSERT INTO camera (id, password) VALUES ('$ID', '$ID')");
} catch (Exception $e) {
    echo "DB ERROR: " . $e->getMessage();
    exit;
}

// setting.txtファイルの内容を出力
echo $settingContent;

// setting.txtの5.6行目の値を更新
$ID++;
$lines[4] = strval($ID);
$lines[5] = strval($ID);

// 更新されたsetting.txtの内容を保存
$settingContent = implode("\n", $lines);
file_put_contents($settingFile, $settingContent);

// セマフォを解放
sem_release($semaphore);

?>