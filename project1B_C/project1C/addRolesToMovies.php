<html>
<head>
	<title>Add Actor to Movies</title>
	<style type="text/css">
	.sectionheader {font-size: 15px;color:#a58500;margin: 0 0 .5em;padding: 0;font-family: Verdana,Arial,sans-serif;font-weight:bold;}
	.header {color: #202020;font-size: 17px;font-weight: normal;padding-bottom: 0;font-family: Verdana,Arial,sans-serif;}
	.findList {border-collapse: collapse;width: 100%;display: table;border-spacing: 2px;border-color: gray;font-family: Verdana,Arial,sans-serif;color: #333;font-size: 13px;}
	.findResult_odd {background-color: #f6f6f5;border: #fff 1px solid;display: table-row;border-spacing: 2px;padding: 20px}
	.findResult_even {background-color: #fbfbfb;border: #fff 1px solid;display: table-row;padding: 20px}
	body {background: #ECECEC;padding: 5px 0;}
	.wrapper{margin: 0 auto; width: 900px; height: auto;padding: 6px; background: white;border-style:solid; border-color:#C8C8C8 ;border-radius:10px;border-width:2px;}
	.result_Text {color: #3366FF;font-size: 13px;font-weight: normal;padding-bottom: 0;font-family: Verdana,Arial,sans-serif;}
	.error_Text {
		font-size:15px;
		font-weight:normal;
		padding-bottom:0;
		color:#FF0000;
	}
	.input_fields {
		font-size: 12px;
		font-weight: normal;
		padding-bottom: 0;
		font-family: Verdana;
	}
	.image_header {height: 80px; margin: 0px 0 0 0; background-image: url(movies_banner.jpg);}
	.radio_header {padding-left: 220px}
	li {
		display:inline;
	}
	a {
		background-color: rgb(0, 0, 0);
		color: rgb(255, 255, 255);
		cursor: auto;
		display: inline;
		font-family: verdana;
		font-size: 10px;
		font-weight: bold;
		font-style:italic;
		height: 16px;
		line-height: 16.899999618530273px;
		list-style-type: none;
		padding-bottom: 4px;
		padding-left: 4px;
		padding-right: 4px;
		padding-top: 4px;
		text-align: center;
		text-decoration: none solid rgb(255, 255, 255);
		text-transform: uppercase;
		width: 86px;
	}
	</style>
</head>
<body>
	<div class="wrapper">
		<div class="image_header"></div>
		<form action="./search.php" method="GET">		
			<h1 class = "header">Search for actors/movies          
			
			<input type="text" name="keyword" size = "60" autocomplete="off" placeholder="Find Movies and Celebrities..."></input>
			<input type="submit" value="Search"/><BR></h1>
			<div class = "radio_header">
			<input type="radio" name="type" value="actor">Actor
			<input type="radio" name="type" value="actress">Actress
			<input type="radio" name="type" value="movie">Movie
			</div>
		</form>
		<div id="menu">
			<ul>
			<li><a href="addActorDirector.php">Add New Actor/Director</a></li>
			<li><a href="addMovie.php">Add New Movie</a></li>
			<li><a href="addDirectorToMovies.php">Add Director To Movie</a></li>
			<li><a href="addActorToMovies.php">Add Actor To Movie</a></li>
		</ul></div>
	</div>
	<div class= "wrapper">
		<h1 class ="header">Add Actor to Movies</h1>
		<hr/>
		<form action="./addActorDirector.php" method="GET">
			<h1 class="input_fields">
				<div class="error_Text">First Name or Last Name is Required. Date of Birth is required.</div><BR>
				First Name: <input type="text" name="first"/><BR><BR>
				Last Name: <input type="text" name="last"/><BR><BR>
				Sex:<input type="radio" name="sex" value="Male"> Male</input>
				<input type="radio" name="sex" value="Female"> Female</input><BR><BR>
				Date of Birth (yyyy-mm-dd): <input type="text" name="dob">
				<span class="error_Text"> *</span></input><BR><BR>
				Date of Death (yyyy-mm-dd): <input type="text" name="dod"><BR><BR>
				Type:<input type="radio" name="type" value="A"> Actor</input>
				<input type="radio" name="type" value="D"> Director<span class="error_Text"> *</span></input><BR><BR>
				<input type="submit" value="Submit"/><BR>
			</h1>
		</form>
		<hr/>
		<?php
		function customError($errno, $errstr, $errfile, $errline) {}
		set_error_handler("customError", E_ALL);
		if(isset($_GET['first'])){
			if (($_GET['first'] != '' || $_GET['last'] != '') && $_GET['dob'] != '') {
				$first_name = trim($_GET['first']);
				$last_name = trim($_GET['last']);
				$dob = trim($_GET['dob']);
			} elseif ($_GET['first'] == '' && $_GET['last'] == '' && $_GET['dob'] == '') {
				die ("<span class=\"error_Text\">First Name or Last Name is Required. Date of Birth is required.</span>");
			} elseif ($_GET['dob'] == '') {
				die ("<span class=\"error_Text\">Date of Birth is required.</span>");
			} else {
				die ("<span class=\"error_Text\">First Name or Last Name is Required.</span>");
			}
			if ($_GET['dod'] != '') {
				$dod = trim($_GET['dod']);
			}
			if (isset($_GET['sex'])) {
				$sex = $_GET['sex'];
			}
			if (isset($_GET['type'])) {
				$type = $_GET['type'];
			} else {
				die ("<span class=\"error_Text\">Actor / Director not specified.</span>");
			}

			$dob_break = explode('-', $dob);
			$dod_break = explode('-', $dod);
			if((!preg_match('/^\d\d\d\d\-\d\d\-\d\d$/', $dob)) || (!checkdate($dob_break[1], $dob_break[2], $dob_break[0]))) {
				die ("<span class=\"error_Text\">Format of Date of Birth is Invalid.</span>");
			}
			if(($_GET['dod'] != '') && ((!preg_match('/^\d\d\d\d\-\d\d\-\d\d$/', $dod)) || (!checkdate($dod_break[1], $dod_break[2], $dod_break[0])))) {
				die ("<span class=\"error_Text\">Format of Date of Death is Invalid.</span>");
			}
			if($_GET['dod'] != '' && strtotime($dob)>strtotime($dod)) {
				die ("<span class=\"error_Text\">Date of Death less than Date of Birth.</span>");
			}
			
			$db_connection = mysql_connect("localhost", "cs143", "") or die ("<h3 class=\"error_Text\">Database Connection Failed due to: " . mysql_errno() . " : " . mysql_error() . "</h3>");
			$db_selected=mysql_select_db("CS143", $db_connection) or die ("<h3 class=\"error_Text\">Could not connect to the database due to: " . mysql_errno() . " : " . mysql_error() . "</h3>");
			$id = mysql_query('SELECT id FROM MaxPersonID;');
			while ($row = mysql_fetch_row($id)) {
				foreach ($row as $key=>$value) {
					$id=$value;
				}
			}
			$new_id = $id + 1;
			if($type == 'A') {
				$newActor = mysql_query("INSERT INTO Actor VALUES($new_id, '$last_name', '$first_name', '$sex', '$dob', '$dod');");
				if(!$newActor) {
					die ("<h3 class=\"error_Text\">Adding New Actor into database failed due to: " . mysql_errno() . " : " . mysql_error() . "</h3>");
				}
			} else {
				$newDirector = mysql_query("INSERT INTO Director VALUES($new_id, '$last_name', '$first_name', '$dob', '$dod');");
				if(!$newDirector) {
					die ("<h3 class=\"error_Text\">Adding New Director into database failed due to: " . mysql_errno() . " : " . mysql_error() . "</h3>");
				}
			}

			$updateMaxPersonTable = mysql_query("UPDATE MaxPersonID SET id = $new_id;");
			echo "<h1 class =\"header\">Actor/Director Added Successfully</h1>"; 
		}
		?>
	</div>
</body>
