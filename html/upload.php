<?php

  // POSTと必須パラメータの確認
  if(($_SERVER['REQUEST_METHOD'] != 'POST') || (!isset($_POST['id'])) || (!isset($_POST['apitoken']))) {
    echo "parameter error";
    exit;
  }

  // 資格情報の確認(SQLインジェクションあり)
  $sql = "SELECT * FROM camera WHERE id = '".$_POST["id"]."' AND password = '".$_POST["apitoken"]."'";
  $db = new SQLite3('db/camera.db');
  $result = $db->query($sql);
  $result1 = $result->fetchArray();

  // 失敗
  if($result1 == NULL) {
    echo "id error";
    exit;
  }

  // ファイル確認
  // 拡張子チェックも入れる
  $upload = "files/" . $_POST['id'] . "/upload.jpg";
  if(move_uploaded_file($_FILES['file_upload']['tmp_name'], $upload)) {
    echo "ok";
  } else {
    echo "upload error";
    exit;
  }






?>
