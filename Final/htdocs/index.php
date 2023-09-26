<?php
	require_once 'db.php';
	$y = "SELECT DISTINCT release_year FROM movies ORDER BY release_year;";
	$qy = mysqli_query($link, $y);
	$l = "SELECT DISTINCT original_language FROM movies;";
	$ql = mysqli_query($link, $l);
	$m = "SELECT id, title FROM movies ORDER BY id;";
	$qm = mysqli_query($link, $m);
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
						<center><h3>Movie Filter</h3></center>
					</div>
					
					<div class="card-body">
						<div class="row">
							<div class="col-md-7">
							
								<form method="GET" action="query.php">
									<p>
										<label for="Title">Title</label>
										<input type="text" name="Title" value="" class="form-control" placeholder="Enter title">
									</p>
									<p>
										<label for="Actor">Actor</label>
										<input type="text" name="Actor" value="" class="form-control" placeholder="Enter actor">
									</p>
									<p>
										<label for="Director">Director</label>
										<input type="text" name="Director" value="" class="form-control" placeholder="Enter director">
									</p>
									<p>
										<label for="Genre">Genre</label>
										<input type="text" name="Genre" value="" class="form-control" placeholder="Enter genre">
									</p>
									<p>
										<label for="Language">Language</label>
										<select name="Language">
											<option value="">--- Select ---</option>
											<?php while($i=mysqli_fetch_array($ql, MYSQLI_NUM)):?>
												<option><?php echo $i[0];?></option>
											<?php endwhile;?>
										</select>
									</p>
									<p>
										<label for="Year">Release Year</label>
										<select name="Year">
											<option value="">--- Select ---</option>
											<?php while($i=mysqli_fetch_array($qy, MYSQLI_NUM)):?>
												<option><?php echo $i[0];?></option>
											<?php endwhile;?>
										</select>
									</p>
									<p>
										<label for="Company">Conpany</label>
										<input type="text" name="Company" value="" class="form-control" placeholder="Enter Company">
									</p>
									<p>
										<label for="Keyword">Keyword</label>
										<input type="text" name="Keyword" value="" class="form-control" placeholder="Enter genre">
									</p>
									<button type="submit" class="btn btn-primary">Search</button>
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