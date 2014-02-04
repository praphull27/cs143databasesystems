<html>
	<head>
		<title>Actor Information</title>
		<style type="text/css">
		.wrapper{margin: 0 auto; width: 900px; height: auto;padding: 8px; background: white;border-style:solid; border-color:#C8C8C8 ;border-radius:10px;border-width:2px;}
		.header {color: #686868 ;font-size: 17px;font-weight: normal;padding-bottom: 0;font-family: Verdana,Arial,sans-serif;}
		.radio_header {padding-left: 220px;color: #686868;font-size: 13px;font-weight: normal;padding-bottom: 0;font-family: Verdana,Arial,sans-serif;}
		.sectionheader {font-size: 15px;color:#a58500;margin: 0 0 .5em;padding: 0;font-family: Verdana,Arial,sans-serif;font-weight:bold;}
		
		.findList {border-collapse: collapse;width: 100%;display: table;border-spacing: 2px;border-color: gray;font-family: Verdana,Arial,sans-serif;color: #333;font-size: 13px;}
		.findResult_odd {background-color: #f6f6f5;border: #fff 1px solid;display: table-row;border-spacing: 2px;padding: 20px}
		.findResult_even {background-color: #fbfbfb;border: #fff 1px solid;display: table-row;padding: 20px}
		body {background: #ECECEC;padding: 5px 0;}
		
		.result_Text {color: #3366FF;font-size: 13px;font-weight: normal;padding-bottom: 0;font-family: Verdana,Arial,sans-serif;}
		.error_Text {font-size: 13px;font-weight: normal;padding-bottom: 0;font-family: Verdana,Arial,sans-serif;}
		.image_header {height: 80px; margin: 0px 0 0 0; background-image: url(movies_banner.jpg);}
		.info_header {color: #202020;font-size: 27px;font-weight: normal;padding-bottom: 0;font-family: Verdana,Arial,sans-serif;}
		.Info_Text {font-size: 17px;font-weight: normal;padding-bottom: 0;font-family: Verdana,Arial,sans-serif;}
		.year_col {float: right;text-align: right;font-size: 13px;font-family: Verdana,Arial,sans-serif;font-weight: normal;color: #000000}
		.movieInfo_odd {color: #3366FF;vertical-align: middle;padding: 5px 10px 6px;background-color: #f6f6f5;border: #fff 1px solid;display: block;}
		.movieInfo_even {color: #3366FF;vertical-align: middle;padding: 5px 10px 6px;background-color: #fbfbfb;border: #fff 1px solid;display: block;}
		.header2 {box-shadow: 10px 10px 5px #F8F8F8 inset;background-color: #Eee;border-top: #e8e8e8 1px solid;cursor: pointer;font-size: 15px;color: #a58500;margin: 0 0 1px 0;padding: 6px 10px;display: block;font-family: Verdana,Arial,sans-serif;}
		.text2 {color: #3366FF;font-size: 15px;font-weight: normal;padding-top: 6px;font-family: Verdana,Arial,sans-serif;}
		.subwrapper{margin: 0 auto; width: 890px; height: auto;padding: 3px; background: white;border-style:solid; border-color:#C8C8C8 ;border-radius:10px;border-width:1px;}
		
		</style>
	</head>	
	<body>
			
			<div class= "wrapper">
			<div class = image_header> <p></p></div>
			
		
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
		</div>
		<div class= "wrapper">
<?php
require_once 'ActorQuery.php';
	if (isset($_GET['id'])) {
		$aid=trim($_GET['id']);
		if($aid>0){
			$Aresult = getActorInfo($aid);
			if($Aresult!=""){
				$Mresult = getMovieInfo($aid);
				//display actor Info
				while ($row = mysql_fetch_row($Aresult)) {
					
					if($row[2]=="Male"){
						$type = "Actor";
					}else{
						$type = "Actress";
					}
					echo "<div><div class = \"info_header\"><B>".$row[0]." ".$row[1]."</B></div><div style=\"padding-left: 5px;color: #a58500;font-family: Verdana,Arial,sans-serif;\">(".$type.")</div></div>";
					echo "<h1 class = \"text2\"><B>Born On:  </B>".$row[3]."</h1>";
					if($row[4]!=""){
						echo "<h1 class = \"text2\"><B>Died On:  </B>".$row[4]."</h1>";
					}		
				}
				//get Movie Count
				$Cresult = getMovieCount($aid);
				while ($Crow = mysql_fetch_row($Cresult)) {
					$mcount = $Crow[0];
				}
				if($Mresult!=""){
					echo "<br><div class = \"subwrapper\"><div class = \"header2\"><B>Movies </B>(".$mcount." credits)</div>";
					$i=1;
					
					while ($Mrow = mysql_fetch_row($Mresult)) {
						
						if($i%2==1){
							echo "<div class = \"movieInfo_odd\"><span class = \"year_col\">".$Mrow[2]."</span><a href=\"http://192.168.56.20/~cs143/project1B_C/project1C/MovieInfo.php?id=".$Mrow[0]."\" style=\"text-decoration: none\" color: \"#3366FF\"; font-family:Verdana>".$Mrow[1]."</a><br>(".$Mrow[3].")</div>";
						
						}else{
							echo "<div class = \"movieInfo_even\"><span class = \"year_col\">".$Mrow[2]."</span><a href=\"http://192.168.56.20/~cs143/project1B_C/project1C/MovieInfo.php?id=".$Mrow[0]."\" style=\"text-decoration: none\" color: \"#3366FF\"; font-family:Verdana>".$Mrow[1]."</a><br>(".$Mrow[3].")</div>";
						}
						
					$i = $i+1;
				
					}	
					echo "</div>";
				
				
				}
			}
			else{
				echo "<div class = \"movieInfo_odd\"><B>Actor Information Not Available!!</B></div>";
			}
		}
		else{
			echo "<div class = \"movieInfo_odd\"><B>Actor Information Not Available!!</B></div>";
		}
	}else
	{
		echo "<div class = \"movieInfo_odd\"><B>Actor Information Not Available!!</B></div>";
	}


?>		

		
</div>
	</body>
</html>			

