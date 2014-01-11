<!DOCTYPE html>
<html>
<head><title>Calculator for CS143 - Database Systems Course</title></head>
<body>
	<h1>Calculator</h1>
	(Ver 0.1 01/15/2014 by Praphull Kumar)<br />
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
		<li></li>
	</ul>
	<?php 
		//Checking if user has provided an expression.
		if($_GET[expression] != '') {

			//Initializing a varaible named 'expression' with the expression provided by the user.
			$expression = $_GET[expression];

			//Evaluating the expression using PHP's eval() method.
			eval("\$result = $expression;");
	?> 
	<h2>Result</h2>
	<?php 
		//Echoing the Result
		echo "$expression = $result";
		}
	?>
</body>
</html>