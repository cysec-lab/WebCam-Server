<?php
  // ログイン済みであることを確認
 ini_set('display_errors',1); 
 session_start();
  if(!isset($_SESSION['username'])) {
    header("Location: login.php", TRUE, 302);
    exit;
  }

  // 表示対象の端末ID
  $cameraid = $_SESSION['username'];

  // クライアント情報
  // 脆弱性ポイント：外部入力値をそのまま出力に使用しようとしている。このページではXSSが発生する。
  // 修正アドバイス：HTMLで特別な意味を持つ記号をエスケープする（htmlspecialchars()関数など）。
  $from_ip = isset($_SERVER['REMOTE_ADDR'])? $_SERVER['REMOTE_ADDR'] : '情報なし';
  $from_host = isset($_SERVER['REMOTE_HOST'])? $_SERVER['REMOTE_HOST'] : '情報なし';
  $from_agent = isset($_SERVER['HTTP_USER_AGENT'])? $_SERVER['HTTP_USER_AGENT'] : '情報なし';
?>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="utf-8">
<title>画像表示画面</title>
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<link rel="stylesheet" href="common.css">
<meta http-equiv="refresh" content="10">
</head>

<body>
  <header class=admin>
    <h1>見守りカメラ　クラウドアプリ</h1>
  </header>

  <div>
    <h2 class=admin>■ カメラ映像</h2>
    <div>
<?php
  $base64_data = base64_encode(file_get_contents('files/'.$cameraid.'/upload.jpg'));
  $finfo = new finfo(FILEINFO_MIME_TYPE);
  $mime_type = $finfo->file('files/'.$cameraid.'/upload.jpg');
  echo "<object data=\"data:{$mime_type};base64,{$base64_data}\" width=\"800px\"></object>";
?>
    </div> 
  </div>
<br>
<hr>
<div>
  接続元IPアドレス：<?php echo $from_ip; ?>
</div>
<div>
  接続元ホスト：<?php echo $from_host; ?>
</div>
<div>
  接続元ユーザエージェント：<?php echo $from_agent; ?>
</div>
</body>
</html>
