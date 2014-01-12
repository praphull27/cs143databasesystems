<!DOCTYPE html>
<html>
<head><title>Calculator for CS143 - Database Systems Course</title></head>
<body>
	<h1>Calculator</h1>
	(Ver 1.0 01/15/2014 by Praphull Kumar)<br />
	Type an expression in the following box (e.g., 10.5+20*3/25).
	<p>
		<form method="GET">
			<input type="text" name="expression"><input type="submit" value="Calculate">
		</form>
	</p>
	<ul>
		<li>Only numbers and +, -, * and / operators are allowed in the expression.</li>
		<li>The evaluation follows the standard operator precedence.</li>
		<li>Both integers and floating point numbers are allowed.</li>
		<li>The calculator does not support parentheses.</li>
	</ul>
	<?php 
		//Checking if user has provided an expression.
	if($_GET[expression] != '') {

			//Initializing a varaible named 'expression' with the expression provided by the user.
		$expression = $_GET[expression];

			//Setting Error Handler function for Divison by Zero
		$errstring = '';
		function customError($errno, $errstr) {
			global $errstring;
			$errstring = $errstr;
		}
		set_error_handler("customError", E_ALL);

			//Checking for allowed chars in the expression string i.e. numbers, whitespace, +, -, *, / and Decimal point for floating numbers.
		if(!preg_match("/^[0-9\+\-\*\/ \.]+$/", $expression)) {
			$errstring="Invalid Input Expression";
		}

			//Checking for invalid input - Whitespace between digits e.g "1 9"
		if(preg_match("/[0-9]\s+[0-9]/", $expression)) {
			$errstring="Invalid Input Expression";
		}

			//Checking for invalid input - Two operators together. Exceptions: (+-, -+) when between two numbers, (*+, *-, /+, /-) when followd by a number.
		if(preg_match("/[\+\-\*\/][\+\-\*\/]/", $expression) && !preg_match("/[0-9]\s*[\+\-][\+\-][0-9]/", $expression) && !preg_match("/[\*\/][\+\-][0-9]/", $expression)) {
			$errstring="Invalid Input Expression";
		}

		if(preg_match("/\+\+/", $expression) || preg_match("/\-\-/", $expression) || preg_match("/[\*\/]\s*[\*\/]/", $expression)) {
			$errstring="Invalid Input Expression";
		}

		if(preg_match("/^[\*\/]/", $expression) || preg_match("/[\+\-\*\/]$/", $expression)) {
			$errstring="Invalid Input Expression";
		}

		if(preg_match("/\s[\+\-\*\/]\s+[\+\-\*\/]\s*/", $expression) && !preg_match("/[0-9]\s+[\+\-\*\/]\s+[\+\-][0-9]/", $expression)) {
			$errstring="Invalid Input Expression";
		}

		if(preg_match("/\.\./", $expression) || preg_match("/\.[0-9]\./", $expression) || preg_match("/\.\s+[0-9]/", $expression)) {
			$errstring="Invalid Input Expression";
		}

			//Evaluating the expression using PHP's eval() method.
		if ($errstring == '') {
			eval("\$result = $expression;");
		}

			//Echoing the Result
		if ($errstring == '') {
	?> 
	<h2>Result</h2>
	<?php 
			echo "$expression = $result";
		} else {
	?> 
	<h2>Error</h2>
	<?php 
			echo "$errstring $expression";
		}
	}
	?>
</body>
</html>
