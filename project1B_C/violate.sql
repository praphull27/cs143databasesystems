-- Following query violates Primary Key Constraint of `Movie` table by 
-- inserting a tuple having `id` that is already present in database.
INSERT INTO Movie VALUES (20, 'Violationg Movie Name',2014, NULL, "PP");
-- OUTPUT: ERROR 1062 (23000): Duplicate entry '20' for key 1

-- Following query violates Check Constraint of `Movie` table by 
-- inserting a tuple having `id` less than equal to zero.
-- INSERT INTO Movie VALUES (-1, 'Violationg Movie Name',2014, NULL, "PP");

-- Following query violates NOT NULL constraint of `Movie` table by 
-- inserting a tuple having `title` as NULL.
INSERT INTO Movie  VALUES (4800, NULL,2014, NULL, "PP");
-- OUTPUT: ERROR 1048 (23000): Column 'title' cannot be null



-- Following query violates Primary Key Constraint of `Actor` table by 
-- inserting a tuple having `id` as NULL.
INSERT INTO Actor VALUES (NULL, 'Violationg Actor First Name', 'Violationg Actor Last Name', NULL, '2014-01-25' , NULL);
-- OUTPUT: ERROR 1048 (23000): Column 'id' cannot be null

-- Following query violates Check Constraint of `Actor` table by 
-- inserting a tuple having `id` less than equal to zero.
-- INSERT INTO Actor VALUES (-1, 'Violationg Actor First Name', 'Violationg Actor Last Name', NULL, '2014-01-25' , NULL);

-- Following query violates NOT NULL constraint of `Actor` table by 
-- inserting a tuple having `dob` as NULL.
INSERT INTO Actor VALUES (68800, 'Violationg Actor First Name', 'Violationg Actor Last Name', NULL, NULL, NULL);
-- OUTPUT: ERROR 1048 (23000): Column 'dob' cannot be null

-- Following query violates Check Constraint of `Actor` table by 
-- inserting a tuple having `dob` greater than `dod`.
-- UPDATE Actor SET dob = '2014-01-25' WHERE id = 25;



-- Following query violates Primary Key Constraint of `Director` table by 
-- inserting a tuple having `id` that is already present in database.
INSERT INTO Director VALUES (158,'Violationg Director First Name', 'Violationg Director Last Name', '2014-01-25' , NULL);
-- OUTPUT: ERROR 1062 (23000): Duplicate entry '158' for key 1

-- Following query violates Check Constraint of `Director` table by 
-- inserting a tuple having `id` less than equal to zero.
-- INSERT INTO Director VALUES (-1,'Violationg Director First Name', 'Violationg Director Last Name', '2014-01-25' , NULL);

-- Following query violates NOT NULL constraint of `Director` table by 
-- inserting a tuple having `dob` as NULL.
INSERT INTO Director VALUES (68801,'Violationg Director First Name', 'Violationg Director Last Name', NULL , NULL);
-- OUTPUT: ERROR 1048 (23000): Column 'dob' cannot be null

-- Following query violates Check Constraint of `Director` table by 
-- inserting a tuple having `dob` greater than `dod`.
-- UPDATE Director SET dob = '2014-01-25' WHERE id = 108;



-- Following query violates Primary Key Constraint of `MovieGenre` table by
-- inserting a tuple having same (`mid`, `genre`) that is already present in database.
INSERT INTO MovieGenre VALUES (2,'Comedy');
-- OUTPUT: ERROR 1062 (23000): Duplicate entry '2-Comedy' for key 1

-- Following query violates Foreign Key Constraint of `MovieGenre` table by
-- inserting a tuple with a `mid` that is not present in the `Movie` table
INSERT INTO MovieGenre VALUES (6000,'violate foreign key');
-- OUTPUT: ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`TEST/MovieGenre`, CONSTRAINT `MovieGenre_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`) ON DELETE CASCADE)



-- Following query violates Primary Key Constraint of `MovieDirector` table by
-- inserting a tuple having same (`mid`, `did`) that is already present in database.
INSERT INTO MovieDirector VALUES (3,112);
-- OUTPUT: ERROR 1062 (23000): Duplicate entry '3-112' for key 1

-- Following query violates Foreign Key Constraint of `MovieDirector` table by
-- inserting a tuple with a `mid` that is not present in the `Movie` table
INSERT INTO MovieDirector VALUES (6000,158);
-- OUTPUT: ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`TEST/MovieDirector`, CONSTRAINT `MovieDirector_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`) ON DELETE CASCADE)

-- Following query violates Foreign Key Constraint of `MovieDirector` table by
-- inserting a tuple with a `did` that is not present in the `Director` table
INSERT INTO MovieDirector VALUES (3,68801);
-- OUTPUT: ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`TEST/MovieDirector`, CONSTRAINT `MovieDirector_ibfk_2` FOREIGN KEY (`did`) REFERENCES `Director` (`id`) ON DELETE CASCADE)



-- Following query violates Unique Key Constraint of `MovieActor` table by 
-- inserting a tuple having same (`mid`, `aid`, `role`) that is already present in database.
INSERT INTO MovieActor VALUES (2,162, 'Board Member');
-- OUTPUT: ERROR 1062 (23000): Duplicate entry '2-162-Board Member' for key 1

-- Following query violates NOT NULL constraint of `MovieActor` table by 
-- inserting a tuple having `mid` as NULL.
INSERT INTO MovieActor VALUES (NULL,14, 'Test');
-- OUTPUT: ERROR 1048 (23000): Column 'mid' cannot be null

-- Following query violates NOT NULL constraint of `MovieActor` table by 
-- inserting a tuple having `aid` as NULL.
INSERT INTO MovieActor VALUES (3,NULL, 'Test');
-- ERROR 1048 (23000): Column 'aid' cannot be null

-- Following query violates Foreign Key Constraint of `MovieActor` table by
-- inserting a tuple with a `mid` that is not present in the `Movie` table
INSERT INTO MovieActor VALUES (6000,14, NULL);
-- OUTPUT: ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`TEST/MovieActor`, CONSTRAINT `MovieActor_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`) ON DELETE CASCADE)

-- Following query violates Foreign Key Constraint of `MovieActor` table by
-- inserting a tuple with a `aid` that is not present in the `Actor` table
INSERT INTO MovieActor VALUES (3,68800, NULL);
-- OUTPUT: ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`TEST/MovieActor`, CONSTRAINT `MovieActor_ibfk_2` FOREIGN KEY (`aid`) REFERENCES `Actor` (`id`) ON DELETE CASCADE)



-- Following query violates Primary Key Constraint of `Review` table by
-- inserting a tuple having `mid` as NULL.
INSERT INTO Review VALUES ('Test User', '2014-01-25 03:14:07', NULL, 3, NULL);
-- OUTPUT: ERROR 1048 (23000): Column 'mid' cannot be null

-- Following query violates NOT NULL constraint of `Review` table by 
-- inserting a tuple having `rating` as NULL.
INSERT INTO Review VALUES ('Test User', '2014-01-25 03:14:07', 3, NULL, NULL);
-- OUTPUT: ERROR 1048 (23000): Column 'rating' cannot be null

-- Following query violates Foreign Key Constraint of `Review` table by
-- inserting a tuple with a `mid` that is not present in the `Movie` table
INSERT INTO Review VALUES ('Test User', '2014-01-25 03:14:07', 6000, 3, NULL);
-- OUTPUT: ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails (`TEST/Review`, CONSTRAINT `Review_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`) ON DELETE CASCADE)

-- violates the check constraint in table Review. 
-- Following query tries to update a tuple with a value for rating greater than 5
-- INSERT INTO Review VALUES ('Violate rating check','2014-01-25 03:14:07', 27, 6, NULL);



-- Following query violates Primary Key Constraint of `MaxPersonID` table by
-- inserting a tuple having `id` as NULL.
INSERT INTO MaxMovieID VALUES (NULL);
-- OUTPUT: ERROR 1048 (23000): Column 'id' cannot be null



-- Following query violates Primary Key Constraint of `MaxMovieID` table by
-- inserting a tuple having `id` as NULL.
INSERT INTO MaxPersonID VALUES (NULL);
-- OUTPUT: ERROR 1048 (23000): Column 'id' cannot be null

