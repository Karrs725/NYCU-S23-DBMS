<?php
require_once 'db.php';

// 檢查必填欄位是否有值
if (isset($_GET['Movie']) && !empty($_GET['Movie'])) {
  $userId = $_GET['UserID'];
  $movieId = $_GET['Movie'];

  // 執行刪除評分
	$selectSql = "SELECT * FROM ratings WHERE userId = '$userId' AND movieId = '$movieId'";
  $selresult = mysqli_query($link, $selectSql);
	if ($selresult) {
		if (mysqli_num_rows($selresult) > 0) {
			$deleteSql = "DELETE FROM ratings WHERE userId = '$userId' AND movieId = '$movieId'";
			$delresult = mysqli_query($link, $deleteSql);
			if ($delresult) {
				echo '評分刪除成功！' . "<br>";
				$selectUSql = "SELECT * FROM ratings WHERE userId = '$userId'";
				$seluresult = mysqli_query($link, $selectUSql);
				if (mysqli_num_rows($selresult) > 0) {
					while ($row = mysqli_fetch_assoc($seluresult)) {
						echo "UserID:" . $row['userId'] . "<br>";
						echo "MovieID:" . $row['movieId'] . "<br>";
						echo "Rating:" . $row['rating'] . "<br>";
						echo "Timestamp:" . $row['timestamp'] . "<br>";
						echo "<br>";
					}
				}
			} else {
				echo '評分刪除失敗：' . mysqli_error($link);
			}
		}
		else{
			echo '查無此評分';
		}
	}
	else {
		die("query failed：" . mysqli_error($link));
	}
} else {
  echo '請選擇電影！';
}

mysqli_close($link);
?>