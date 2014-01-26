-- Loading Data into Tables from the files.

-- Loading Movie Tables

LOAD DATA LOCAL INFILE "/home/cs143/data/movie.del" INTO TABLE Movie
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"';


-- Loading Actor Tables

LOAD DATA LOCAL INFILE "/home/cs143/data/actor1.del" INTO TABLE Actor
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"';

LOAD DATA LOCAL INFILE "/home/cs143/data/actor2.del" INTO TABLE Actor
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"';

LOAD DATA LOCAL INFILE "/home/cs143/data/actor3.del" INTO TABLE Actor
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"';


-- Loading Director Tables

LOAD DATA LOCAL INFILE "/home/cs143/data/director.del" INTO TABLE Director
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"';


-- Loading MovieGenre Tables

LOAD DATA LOCAL INFILE "/home/cs143/data/moviegenre.del" INTO TABLE MovieGenre
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"';


-- Loading MovieDirector Tables

LOAD DATA LOCAL INFILE "/home/cs143/data/moviedirector.del" INTO TABLE MovieDirector
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"';


-- Loading MovieActor Tables

LOAD DATA LOCAL INFILE "/home/cs143/data/movieactor1.del" INTO TABLE MovieActor
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"';

LOAD DATA LOCAL INFILE "/home/cs143/data/movieactor2.del" INTO TABLE MovieActor
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"';


-- Loading MaxPersonID
INSERT INTO MaxPersonID VALUES (69000);


-- Loading MaxMovieID
INSERT INTO MaxMovieID VALUES (4750);