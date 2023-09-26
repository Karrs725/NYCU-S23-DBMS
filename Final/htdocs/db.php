<?php
  // 建立資料庫連接
  $host = 'localhost';
  $dbuser ='root';
  $dbpassword = 'K920725s';
  $dbname = 'dbfinal';
  $link = mysqli_connect($host, $dbuser, $dbpassword, $dbname);
  if(!$link){
    die("Could not connect: " . mysqli_connect_error());
  }
  mysqli_set_charset($link, 'utf8');
?>
