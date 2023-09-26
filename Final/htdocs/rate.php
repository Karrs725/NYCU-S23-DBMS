<?php
require_once 'db.php';

// 檢查必填欄位是否有值
if (isset($_GET['Movie']) && !empty($_GET['Movie'])) {
  $userId = $_GET['UserID'];
  $movieId = $_GET['Movie'];
  $rating = $_GET['Rating'];
  $timestamp = time();

  // 執行新增評分
	$selectSql = "SELECT * FROM ratings WHERE userId = '$userId' AND movieId = '$movieId'";
  $selresult = mysqli_query($link, $selectSql);
	if ($selresult) {
		if (mysqli_num_rows($selresult) > 0) {
			$updateSql = "UPDATE ratings SET rating = '$rating' WHERE userId = '$userId' AND movieId = '$movieId'";
			$updresult = mysqli_query($link, $updateSql);
			if ($updresult) {
				echo '評分更新成功！' . "<br>";
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
				echo '評分更新失敗：' . mysqli_error($link);
			}
		}
		else{
			$insertSql = "INSERT INTO ratings (userId, movieId, rating, timestamp) VALUES ('$userId', '$movieId', '$rating', '$timestamp')";
			$insresult = mysqli_query($link, $insertSql);
			if ($insresult) {
				echo '評分新增成功！' . "<br>";
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
				echo '評分新增失敗：' . mysqli_error($link);
			}
		}
		// 釋放查詢結果
		mysqli_free_result($selresult);
	}
	else {
		die("query failed：" . mysqli_error($link));
	}
} else {
  echo '請選擇電影！';
}
?>