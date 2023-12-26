<?php
  // 表示メッセージ
  ini_set('display_errors',1);
  $message = "";

  // ログインボタンを押された時の処理（成功時は画像表示画面へリダイレクト）
  // 演習教材ではセッション有無に関係なくログイン処理を行う
  if(($_SERVER['REQUEST_METHOD'] == 'POST') && (isset($_POST['command']))) {
    if($_POST['command'] == "ログイン") {

      if((isset($_POST["username"])) && (isset($_POST["password"]))) {
        
        // 脆弱性ポイント：外部入力値をそのまま使用してSQL文を組み立てている。
        // 修正アドバイス：プレースホルダを利用する。(外部入力値以外でも想定していない値で
        // 　　　　　　　　リテラルが壊れることもあるため、全てのSQL文で利用する)
        $data= "SELECT * FROM camera WHERE id = '".$_POST["username"]."' AND password = '".$_POST["password"]."'";
        $db = new SQLite3('db/camera.db');
        $result = $db->query($data);
        $result1 = $result->fetchArray();

        // ログイン成功
        if($result1 != NULL) {
          // 脆弱性ポイント：セッションIDを再生成していないので、セッション固定攻撃が可能。
          // 修正アドバイス：セッションIDを新しい値にする（session_regenerate_id()関数など）。
          session_start();
          $_SESSION['username'] = $_POST["username"];
          header("Location: view.php", TRUE, 302);
          exit;
        }
      }

      // ログイン失敗(パラメータ不足か誤り)
      $message = "ユーザ名またはパスワードが違います。";
    }
  } // ログインボタンを押された時の処理 ここまで
?>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="utf-8">
<title>見守りカメラクラウドアプリ　ログイン画面</title>
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<link rel="stylesheet" href="common.css">
</head>

<body>
    <header class=admin>
        <h1>見守りカメラ　クラウドアプリ</h1>
    </header>

    <div >
      ログインが必要です。
      <p class=message>
	      <?php echo $message; ?>
      </p>
      <hr>
      <table>
        <form method="POST" action="login.php">
          <tr>
            <th>カメラ端末ID：</th>
            <td>
              <input type="text" name="username" value="" size="24">
            </td>
          </tr>
          <tr>
            <th>パスワード：　</th>
            <td>
              <input type="password" name="password" value="" size="24">
            </td>
          </tr>
          <tr>
            <td colspan="2">
              <input type="submit" name="command" value="ログイン">
            </td>
          </tr>
        </form>
      </table>
      
            <br>
            <hr>
            <div class=submenu>
	      カメラにユニークな端末IDと初期パスワードが割り当てられている想定です。
<p>教材では、端末ID=1000101〜1000110を使用します。初期パスワードも端末IDと同じ値に設定してあります。</p>
            </div>
    </div>
</body>
</html>
