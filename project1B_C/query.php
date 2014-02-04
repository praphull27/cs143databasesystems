<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8" />
	<title>CS 143 - Database Systems - Project 1B</title>
	<style>
	.common {font-family: serif; font-weight: bold;background-color:#eef;}
	.error {font-family: serif; font-weight: bold; background-color:#F62817;font-style:italic;}
	.header {font-size: 15px;color:#a58500;margin: 0 0 .5em;padding: 0;font-family: Verdana,Arial,sans-serif;font-weight: bold;}
	#x01 {font-size:xx-large; background-color:#eef; text-align: center; padding: 1ex;}
	</style>
</head>
<body>
	<h3 class="common" id="x01">CS 143 - Database Systems - Project 1B</h3>
	<p>Version 1.1 01/29/2014<br />
		Group Members:<br />
		1) Pankuri Aggarwal - 604271339<br />
		2) Praphull Kumar - 204271732<br /><br />
		Type an SQL query in the following box:
		<form method="GET" action ="./query.php">
			<textarea name="query" cols="60" rows="8"><?php 
			$var = (isset($_GET['query'])) ? $_GET['query'] : ' '; 
			echo trim($var); 
			?></textarea>
		</br>
		<input type="submit" value="Submit">
	</form>
</p>
<p>
	<small>Note: tables and fields are case sensitive. Run "show tables" to see the list of available tables.</small>
</p>
</body>
</html>

<?php
@$query=trim($_GET['query']);

if ($query != '') {

	$input_pattern = '/^(select|show)/i';

	if (preg_match($input_pattern, $query)) {
		
		function customError($errno, $errstr) {};
		set_error_handler("customError", E_ALL);

		$db_connection = mysql_connect("localhost", "cs143", "") or die ("<h3 class=\"error\">Database Connection Failed due to: " . mysql_errno() . " : " . mysql_error() . "</h3>");
		
		$db_selected=mysql_select_db("CS143", $db_connection);
		if (!$db_selected) {
			echo "<h3 class=\"error\">Could not connect to the database due to: " . mysql_errno() . " : " . mysql_error() . "</h3>";
			exit(1);
		}

		$result = mysql_query($query, $db_connection);
		if (!$result) {
			echo "<h3 class=\"error\">Query couldn't be run due to : " . mysql_errno(). " : " . mysql_error() . "</h3>" ;
			exit(1);
		}

		$num_rows = mysql_num_rows($result);

		echo "<h3 class=\"common\">Result of the Query is:</h3>";
		echo "Number of Rows returned is: <b>".$num_rows."</b></br></br>";
		echo "<table cellpadding=3 border=2>";
		$column_size=mysql_num_fields($result);
		$i=0;
		echo '<tr>';
		while ($i < $column_size) {
			$meta = mysql_fetch_field($result, $i);
			echo '<td><b>' . $meta->name . '</b></td>';
			$i = $i + 1;
		}
		echo '</tr>';
		while ($row = mysql_fetch_row($result)) {
			echo '<tr>';
			foreach ($row as $key=>$value) {
				if ($value) {
					echo '<td>', $value, '</td>';
				} else {
					echo '<td>', "N/A", '</td>';
				}
			}
			echo '</tr>';
		}
		echo "</table>";
		mysql_close($db_connection);
	}
	else {
		echo "<h3 class=\"error\">Only SELECT and SHOW queries are allowed</h3>" ;
	}
}
?>
