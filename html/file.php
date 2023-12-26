<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="utf-8">
<title>ファイルアップロードテスト</title>
<meta name="viewport" content="width=device-width,initial-scale=1.0">
</head>

<body>
    <div>
       ファイルアップロードテスト用
      <hr>
      <table>
	<form method="POST" action="upload.php" enctype="multipart/form-data">
	 <tr>
           <th>端末ID</th>
	   <td>
             <input type="text" name="id" value="" size="20">
           </td>
         </tr>
	 <tr>
           <th>apitoken(端末IDと同じ)</th>
	   <td>
             <input type="text" name="apitoken" value="" size="20">
           </td>
         </tr>
         <tr>
            <th>画像ファイル(jpgのみ)：</th>
            <td>
              <input type="file" name="file_upload" value="" size="24">
	    </td>
         </tr>
         <tr>
            <td colspan="2">
              <input type="submit" name="command" value="アップロード">
            </td>
         </tr>
        </form>
      </table>
      
    </div>
</body>
</html>
