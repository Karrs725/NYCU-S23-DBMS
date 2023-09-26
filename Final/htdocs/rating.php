<?php
	require_once 'db.php';
	$m = "SELECT id, title FROM movies ORDER BY id;";
	$qm = mysqli_query($link, $m);
	$m1 = "SELECT id, title FROM movies ORDER BY id;";
	$qm1 = mysqli_query($link, $m1);
?>

<html lang="en">
<head>
	<!-- Required meta tags -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- Bootstrap CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
	<title>DB Final Project</title>
</head>

<body>
	<nav class="navbar navbar-expand-lg bg-body-tertiary">
		<div class="container-fluid">
			<a class="navbar-brand" href="#">Navbar</a>
			<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav">
					<li class="nav-item">
						<a class="nav-link active" aria-current="page" href="/">Home</a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="rating.php">Rating</a>
					</li>
				</ul>
			</div>
		</div>
	</nav>
	
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="card mt-4">
					<div class="card-header">
						<center><h3>Movie Rating</h3></center>
					</div>
					
					<div class="card-body">
						<div class="row">
							<div class="col-md-7">
							
								<form method="GET" action="rate.php">
									<p>
										<label for="UserID">UserID</label>
										<input type="text" name="UserID" required value="" class="form-control" placeholder="Enter title">
									</p>
									<p>
										<label for="Movie">Movie</label>
										<select name="Movie">
											<?php while($i=mysqli_fetch_array($qm, MYSQLI_NUM)):?>
												<option><?php echo $i[0] . ":" . $i[1];?></option>
											<?php endwhile;?>
										</select>
									</p>
									<p>
										<label for="Rating">Rating</label>
										<input type="text" name="Rating" required value="" class="form-control" placeholder="Enter genre">
									</p>
									<button type="submit" class="btn btn-primary">Rate</button>
								</form>
								
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="container">
		<div class="row">
			<div class="col-md-12">
				<div class="card mt-4">
					<div class="card-header">
						<center><h3>Delete Rating</h3></center>
					</div>
					
					<div class="card-body">
						<div class="row">
							<div class="col-md-7">
							
								<form method="GET" action="delete_rate.php">
									<p>
										<label for="UserID">UserID</label>
										<input type="text" name="UserID" required value="" class="form-control" placeholder="Enter title">
									</p>
									<p>
										<label for="Movie">Movie</label>
										<select name="Movie">
											<?php while($i=mysqli_fetch_array($qm1, MYSQLI_NUM)):?>
												<option><?php echo $i[0] . ":" . $i[1];?></option>
											<?php endwhile;?>
										</select>
									</p>
									<button type="submit" class="btn btn-primary">Delete</button>
								</form>
								
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>