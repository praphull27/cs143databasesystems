-- violates the primary key constraint in table Movie. 
--Following Insert tries to add a tuple with a movie ID that is already present in database
INSERT INTO Movie 
VALUES (20,'violating  Movie Unique ID',2014, NULL, "PP");
--OUTPUT:
--ERROR 1062 (23000): Duplicate entry '20' for key 1


-- violates the primary key constraint in table Actor. 
--Following Insert tries to add a tuple with A null Actor ID 
INSERT INTO Actor 
VALUES (NULL,'UniqueID', 'violationg Actor', NULL, '2014-01-25' , NULL);
--OUTPUT
--ERROR 1048 (23000): Column 'id' cannot be null


-- violates the primary key constraint in table Director. 
--Following Insert tries to add a tuple with a Director ID that is already present in database
INSERT INTO Director 
VALUES (158,'UniqueID', 'violationg Director', '2014-01-25' , NULL);
--OUTPUT
--ERROR 1062 (23000): Duplicate entry '158' for key 1


-- violates the foreign key constraint in table MovieGenre. 
-- Following Insert tries to add a tuple with a Movie ID that is not present in the Movie table
INSERT INTO MovieGenre 
VALUES (6000,'violate foreign key');
--OUTPUT
--ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`TEST/MovieGenre`, CONSTRAINT `MovieGenre_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`))


-- violates the foreign key constraint in table MovieDirector. 
-- Following query tries to update a tuple with a Movie ID that is not present in the Movie table
INSERT INTO MovieDirector 
VALUES (6000,158);
--OUTPUT
--ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`TEST/MovieDirector`, CONSTRAINT `MovieDirector_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`))


-- violates the foreign key constraint in table MovieDirector. 
-- Following query tries to update a tuple with a Director ID that is not present in the Director table
INSERT INTO MovieDirector
VALUES (27,80000);
--OUTPUT
--ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`TEST/MovieDirector`, CONSTRAINT `MovieDirector_ibfk_2` FOREIGN KEY (`did`) REFERENCES `Director` (`id`))


-- violates the foreign key constraint in table MovieActor. 
-- Following query tries to update a tuple with an Actor ID that is not present in the Actor table
INSERT INTO MovieActor
VALUES(27,80000,NULL);
--OUTPUT
--ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`TEST/MovieActor`, CONSTRAINT `MovieActor_ibfk_2` FOREIGN KEY (`aid`) REFERENCES `Actor` (`id`))


-- violates the foreign key constraint in table Movie. 
-- Following query tries to delete a tuple in Movie table that is referred by other tables
DELETE FROM Movie where id  = 27;
--OUTPUT
--ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`TEST/MovieGenre`, CONSTRAINT `MovieGenre_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`))


-- violates the foreign key constraint in table Review. 
-- Following query tries to update a tuple with an Movie ID that is not present in the Movie table
INSERT INTO Review
VALUES('violate foreign key','2014-01-25 03:14:07',90000,3,NULL);
--OUTPUT
--ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`TEST/Review`, CONSTRAINT `Review_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`))


-- violates the check constraint in table Actor. 
-- Following query tries to update a tuple with a value for date of birth greater than date of death
--UPDATE Actor
--SET dob = '2014-01-25'
--WHERE id = 21;


-- violates the check constraint in table Director. 
-- Following query tries to update a tuple with a value for date of birth greater than date of death
--UPDATE Director
--SET dob = '2014-01-25'
--WHERE id = 158;


-- violates the check constraint in table Review. 
-- Following query tries to update a tuple with a value for rating greater than 5
--INSERT INTO Review 
--VALUES ('Violate rating check','2014-01-25 03:14:07', 27, 6, NULL);


-- violates the check constraint in table Review. 
-- Following query tries to update a tuple with a value for rating less than 0
--INSERT INTO Review 
--VALUES ('Violate rating check','2014-01-25 03:14:07', 27, -2, NULL);


-- violates the Not Null constraint in table Movie. 
-- Following Insert tries to add a tuple with a Null title for the movie
INSERT INTO Movie 
VALUES (4750, NULL, 2014, NULL, PP);


-- violates the Not Null constraint in table Actor. 
-- Following query tries to update a tuple with a Null date of birth for an actor
UPDATE Actor
SET dob = null
WHERE first = Dan;


-- violates the Not Null constraint in table Actor. 
-- Following query tries to update a tuple with a Null last name for an actor
UPDATE Actor
SET last = null
WHERE id = 21;


-- violates the Not Null constraint in table MaxMovieId. 
-- Following query tries to update a tuple with a Null max movie ID
INSERT INTO MaxMovieID 
VALUES (NULL);


-- violates the Not Null constraint in table MaxPersonID. 
-- Following query tries to update a tuple with a Null max person id
INSERT INTO MaxPersonID 
VALUES (NULL);