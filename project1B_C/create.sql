-- Dropping all the existing tables.

DROP TABLE IF EXISTS MovieGenre;
DROP TABLE IF EXISTS MovieDirector;
DROP TABLE IF EXISTS MovieActor;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS MaxPersonID;
DROP TABLE IF EXISTS MaxMovieID;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Actor;
DROP TABLE IF EXISTS Director;

-- Creating table "Movie" with following constraints:
-- 1. Primay Key = id
-- 2. "id" column can not have NULL
-- 3. "title" column can not have NULL
CREATE TABLE `Movie` (
	`id` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Movie ID',
	`title` VARCHAR(100) NOT NULL COLLATE utf8_general_ci COMMENT 'Movie Title',
	`year` INT COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Release Year',
	`rating` VARCHAR(10) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'MPAA Rating',
	`company` VARCHAR(50) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Production Company',
	PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- Creating table "Actor" with following constraints:
-- 1. Primay Key = id
-- 2. "id" column can not have NULL
-- 3. "last" column can not have NULL
-- 4. "first" column can not have NULL
-- 5. "dob" column can not have NULL
-- 6. Date of Birth is always less than Date of Death
Create Table `Actor` (
	`id` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Actor ID',
	`last` VARCHAR(20) NOT NULL COLLATE utf8_general_ci COMMENT 'Last name',
	`first` VARCHAR(20) NOT NULL COLLATE utf8_general_ci COMMENT 'First name',
	`sex` VARCHAR(6) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Sex of the actor',
	`dob` DATE NOT NULL COMMENT 'Date of Birth',
	`dod` DATE DEFAULT NULL COMMENT 'Date of Death',
	PRIMARY KEY (id),
	CHECK (dob < dod )
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- Creating table "Director" with following constraints:
-- 1. Primay Key = id
-- 2. "id" column can not have NULL
-- 3. "last" column can not have NULL
-- 4. "first" column can not have NULL
-- 5. "dob" column can not have NULL
-- 6. Date of Birth is always less than Date of Death
Create Table `Director` (
	`id` INT NOT NULL  COLLATE utf8_general_ci COMMENT 'Director ID',
	`last` VARCHAR(20) NOT NULL  COLLATE utf8_general_ci COMMENT 'Last name',
	`first` VARCHAR(20) NOT NULL  COLLATE utf8_general_ci COMMENT 'First name',
	`dob` DATE NOT NULL COMMENT 'Date of Birth',
	`dod` DATE DEFAULT NULL COMMENT 'Date of Death',
	PRIMARY KEY (id),
	CHECK (dob < dod )
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- Creating table "MovieGenre" with following constraints:
-- 1. Primary Key = (mid,genre)
-- 2. "mid" column can not have NULL
-- 3. "genre" column can not have NULL
-- 4. Foreign Key : "mid" column refers to "id" column of Movie table
Create Table `MovieGenre` (
	`mid` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Movie ID',
	`genre` VARCHAR(20) NOT NULL COLLATE utf8_general_ci COMMENT 'Movie genre',
	FOREIGN KEY (mid) REFERENCES Movie( id ),
	PRIMARY KEY (mid,genre)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- Creating table "MovieDirector" with following constraints:
-- 1. Primary Key = (mid,did)
-- 2. "mid" column can not have NULL
-- 3. "did" column can not have NULL
-- 4. Foreign Key : "mid" column refers to "id" column of Movie table
-- 4. Foreign Key : "did" column refers to "id" column of Director table
Create Table `MovieDirector` (
	`mid` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Movie ID',
	`did` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Director ID',
	FOREIGN KEY (mid) REFERENCES Movie( id ),
	FOREIGN KEY (did) REFERENCES Director( id ),
	PRIMARY KEY (mid,did)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- Creating table "MovieActor" with following constraints:
-- 1. Unique Constraint on (mid,aid,role)
-- 2. "mid" column can not have NULL
-- 3. "aid" column can not have NULL
-- 4. Foreign Key : "mid" column refers to "id" column of Movie table
-- 5. Foreign Key : "aid" column refers to "id" column of Actor table
Create Table `MovieActor` (
	`mid` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Movie ID',
	`aid` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Actor ID',
	`role` VARCHAR(50) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Actor role in movie',
	FOREIGN KEY (mid) REFERENCES Movie( id ),
	FOREIGN KEY (aid) REFERENCES Actor( id ),
	UNIQUE(mid,aid,role)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- Creating table "Review" with following constraints:
-- 1. Primary Key = (name, mid)
-- 2. "name" column can not have NULL
-- 3. "time" column can not have NULL
-- 4. "mid" column can not have NULL
-- 5. "rating" column can not have NULL
-- 6. Rating is always between 0 and 5
-- 7. Foreign Key : "mid" column refers to "id" column of Movie table
Create Table `Review` (
	`name` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Reviewer name',
	`time` TIMESTAMP NOT NULL COMMENT 'Review time',
	`mid` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Movie ID',
	`rating` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Review rating',
	`comment` VARCHAR(500) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Reviewer Comment',
	PRIMARY KEY (name, mid),
	FOREIGN KEY (mid) REFERENCES Movie( id ),
	CHECK ( rating >= 0 AND rating <= 5)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci; 


-- Creating table "MaxPersonID" with following constraints:
-- 1. "id" column can not have NULL
Create Table `MaxPersonID` (
	`id` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Max ID assigned to all persons'
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;


-- Creating table "MaxMovieID" with following constraints:
-- 1. "id" column can not have NULL
Create Table `MaxMovieID` (
	`id` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Max ID assigned to all movies'
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

