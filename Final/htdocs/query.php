<?php
require_once 'db.php';

// 構建 SQL 查詢語句
$sql = "SELECT * FROM movies INNER JOIN cast ON movies.id = cast.id WHERE 1=1";

if (isset($_GET['Title']) && !empty($_GET['Title'])) {
  $title = $_GET['Title'];
  $sql .= " AND title LIKE '%$title%'";
}

if (isset($_GET['Actor']) && !empty($_GET['Actor'])) {
  $actor = $_GET['Actor'];
  $sql .= " AND cast LIKE '%$actor%'";
}

if (isset($_GET['Director']) && !empty($_GET['Director'])) {
  $director = $_GET['Director'];
  $sql .= " AND director LIKE '%$director%'";
}

if (isset($_GET['Genre']) && !empty($_GET['Genre'])) {
  $genre = $_GET['Genre'];
  $sql .= " AND genres LIKE '%$genre%'";
}

if (isset($_GET['Language']) && !empty($_GET['Language'])) {
  $language = $_GET['Language'];
  $sql .= " AND original_language = '$language'";
}

if (isset($_GET['Year']) && !empty($_GET['Year'])) {
  $year = $_GET['Year'];
  $sql .= " AND release_year = '$year'";
}

if (isset($_GET['Company']) && !empty($_GET['Company'])) {
  $company = $_GET['Company'];
  $sql .= " AND production_companies LIKE '%$company%'";
}

if (isset($_GET['Keyword']) && !empty($_GET['Keyword'])) {
  $keyword = $_GET['Keyword'];
  $sql .= " AND keywords LIKE '%$keyword%'";
}

// 執行查詢
$result = mysqli_query($link, $sql);
if (!$result) {
  
}

// 檢查查詢結果
if ($result) {
	if (mysqli_num_rows($result) > 0) {
		// 遍歷查詢結果並顯示相應的數據
		while ($row = mysqli_fetch_assoc($result)) {
			echo "ID: " . $row['id'] . "<br>";
			echo "片名: " . $row['title'] . "<br>";
			echo "演員: " . $row['cast'] . "<br>";
			echo "導演: " . $row['director'] . "<br>";
			if($row['belongs_to_collection'] == 1) echo "有無系列: 是<br>";
			else echo "有無系列: 否<br>";
			echo "分類: " . $row['genres'] . "<br>";
			echo "語言: " . $row['original_language'] . "<br>";
			echo "大綱: " . $row['overview'] . "<br>";
			echo "人氣指數: " . $row['popularity'] . "<br>";
			echo "海報: " . $row['poster_path'] . "<br>";
			echo "製作公司: " . $row['production_companies'] . "<br>";
			echo "製作國家: " . $row['production_countries'] . "<br>";
			echo "上映日期: " . $row['release_date'] . "<br>";
			echo "預算: $" . $row['budget'] . "<br>";
			echo "收益: $" . $row['revenue'] . "<br>";
			echo "影片時長: " . $row['runtime'] . " 分鐘<br>";
			echo "狀態: " . $row['status'] . "<br>";
			echo "評分: " . $row['vote_average'] . "<br>";
			echo "投票數: " . $row['vote_count'] . "<br>";
			echo "上映年份: " . $row['release_year'] . "<br>";
			echo "關鍵字: " . $row['keywords'] . "<br>";
			echo "<br>";
		}
	}
	else {
		echo "no result";
	}
	// 釋放查詢結果
	mysqli_free_result($result);
}
else {
	die("query failed：" . mysqli_error($link));
}
?>
