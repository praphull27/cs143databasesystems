<html>
	<head>
		<title>Search Actor / Movie</title>
		<style type="text/css">
		@import url(cs143style.css);
		</style>
	</head>	
	<body>
			
			
		Search for actors/movies
		<form action="./search.php" method="GET">		
			Search: <input type="text" name="keyword"></input>
			<input type="submit" value="Search"/><BR>
			<input type="radio" name="type" value="actor">Actor
			<input type="radio" name="type" value="actress">Actress
			<input type="radio" name="type" value="movie">Movie
		</form>
		<hr/>
				

	</body>
</html>

<?php
require_once 'SearchQuery.php';
$keyword=trim($_GET['keyword']);
$keywords = preg_split("/\s+/", $keyword);


if($keywords[0]!=''){
	
	$keyLen = count($keywords);
	$type = trim($_GET['type']);


	$category = "";
	$noMovies = false;
	$noActor = false;
	if(strcasecmp($type,"actor")==0){
		$category = "Male";
		$noMovies = true;
		$noActor = false;
	}else if(strcasecmp($type,"actress")==0){
		$category = "Female";
		$noMovies = true;
		$noActor = false;
	}else if(strcasecmp($type,"movie")==0){
		$category = "movie";
		$noMovies = false;
		$noActor = true;
	}else if(strcasecmp($type,"")==0){
		$category = "%%";
		$noMovies = false;
		$noActor = false;
	}


	$keyLen = count($keywords);
	if(!($noActor)){
		$Actor_query1 = "Select id,first,last,dob,dod from Actor where first like '%".$keywords[0]."%' and last like '%".$keywords[1]."%' and sex like '".$category."'";
		$Actor_query2 = "Select id,first,last,dob,dod from Actor where last like '%".$keywords[0]."%' and first like '%".$keywords[1]."%' and sex like '".$category."'";
		$Actor_query3 = "Select id,first,last,dob,dod from Actor where first like '%".$keywords[0]."%' or last like '%".$keywords[1]."%' and sex like '".$category."' UNION Select id,first,last,dob,dod from Actor where last like '%".$keywords[0]."%' or first like '%".$keywords[1]."%' and sex like '".$category."'";
		
	}
	
	$MovieCheck = "";
	for ($x=0; $x<$keyLen; $x++)
	{
	$MovieCheck  = 	$MovieCheck.$keywords[$x]." ";
	}
	$MovieCheck=trim($MovieCheck);
	
	$Movie_query1 = "select id,title,year from Movie where title like '%".$MovieCheck."%'";

	
	// error handling
	function customError($errno, $errstr) {echo $errno.$errstr;};
	set_error_handler("customError", E_ALL);
	
	//establishing a connection
	$db_connection = mysql_connect("localhost", "cs143", "") or die ("<h3 class=\"error\">Database Connection Failed due to: " . mysql_errno() . " : " . mysql_error() . "</h3>");
	//connecting to database	
	$db_selected=mysql_select_db("TEST", $db_connection);
	if (!$db_selected) {
			echo "<h3 class=\"error\">Could not connect to the database due to: " . mysql_errno() . " : " . mysql_error() . "</h3>";
			exit(1);
	}
		
	// if user has provided 1 or 2 keywords and not selected movie as search category
	if($keyLen<3 && !($noActor)){
		$Aresult = mysql_query($Actor_query1, $db_connection);
		if (!$Aresult) {
			echo $Actor_query1."<br />";
			echo "here1";
			customError(mysql_errno(),mysql_error());
			exit(1);
		}
		$Anum_rows = mysql_num_rows($Aresult);
		if($Anum_rows!=0){
		// browsing pages
		//show result
		
		
		}else{
			$Aresult = mysql_query($Actor_query2, $db_connection);
			if (!$Aresult) {
			echo "here2";
			customError(mysql_errno(),mysql_error());
			exit(1);
			}
			$Anum_rows = mysql_num_rows($Aresult);
			if($Anum_rows!=0){
			// browsing pages
			//show result
			}else{
				$Mflag = true;
				$Aresult = mysql_query($Actor_query3, $db_connection);
				if (!$Aresult) {
				echo "here3";
				customError(mysql_errno(),mysql_error());
				exit(1);
				}
				$Anum_rows = mysql_num_rows($Aresult);
				if($Anum_rows!=0){
				// browsing pages
				//show result
				}else{
					$noActor = true;
		
		
				}
		
		
			}
		
		
		}
	
	
	}else{
		$noActor = true;
	}
	
	// get movies data
	if(!($noMovies)){
		$Mresult = mysql_query($Movie_query1, $db_connection);
		if (!$Mresult) {
			echo "here4";
			customError(mysql_errno(),mysql_error());
			exit(1);
		}
		$Mnum_rows = mysql_num_rows($Mresult);
		if($Mnum_rows!=0){
			// browsing pages
			//show result
		}else{
			$noMovies = true;
		}
	}
	
	
	if(!($noMovies && $noActor)){
		echo "Showing results for <B>".$keyword.":</B>";
		if(!($noActor)){
			echo "<BR />".$Anum_rows." Actors/Actress found matching:<BR />";
		//print actor data
		}
		if(!($noMovies)){
			echo "<BR />".$Mnum_rows." Movies found matching:<BR />";
		//print movie data
		}
		
	echo "yupiiee";
	
	
	}else{
	
	echo "Your search - <B>".$keyword."</B> - did not match any records." ;
	echo "<BR /><BR /><B>Suggestions: </B><BR />Make sure all words are spelled correctly.<BR />Try different keywords.";
	echo "<BR />Try more general keywords.<BR />Try fewer keywords.";
	}




}
	
	
	
	


?>
