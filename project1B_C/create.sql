DROP TABLE IF EXISTS MovieGenre;
DROP TABLE IF EXISTS MovieDirector;
DROP TABLE IF EXISTS MovieActor;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS MaxPersonID;
DROP TABLE IF EXISTS MaxMovieID;
DROP TABLE IF EXISTS Movie;
DROP TABLE IF EXISTS Actor;
DROP TABLE IF EXISTS Director;

CREATE TABLE `Movie` (
	`id` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Movie ID',
	`title` VARCHAR(100) NOT NULL COLLATE utf8_general_ci COMMENT 'Movie Title',
	`year` INT COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Release Year',
	`rating` VARCHAR(10) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'MPAA Rating',
	`company` VARCHAR(50) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Production Company',
	PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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

Create Table `Director` (
	`id` INT NOT NULL  COLLATE utf8_general_ci COMMENT 'Director ID',
	`last` VARCHAR(20) NOT NULL  COLLATE utf8_general_ci COMMENT 'Last name',
	`first` VARCHAR(20) NOT NULL  COLLATE utf8_general_ci COMMENT 'First name',
	`dob` DATE NOT NULL COMMENT 'Date of Birth',
	`dod` DATE DEFAULT NULL COMMENT 'Date of Death',
	PRIMARY KEY (id),
	CHECK (dob < dod )
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

Create Table `MovieGenre` (
	`mid` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Movie ID',
	`genre` VARCHAR(20) NOT NULL COLLATE utf8_general_ci COMMENT 'Movie genre',
	FOREIGN KEY (mid) REFERENCES Movie( id ),
	UNIQUE(mid,genre)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

Create Table `MovieDirector` (
	`mid` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Movie ID',
	`did` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Director ID',
	FOREIGN KEY (mid) REFERENCES Movie( id ),
	FOREIGN KEY (did) REFERENCES Director( id ),
	UNIQUE(mid,did)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

Create Table `MovieActor` (
	`mid` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Movie ID',
	`aid` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Actor ID',
	`role` VARCHAR(50) COLLATE utf8_general_ci DEFAULT NULL COMMENT 'Actor role in movie',
	FOREIGN KEY (mid) REFERENCES Movie( id ),
	FOREIGN KEY (aid) REFERENCES Actor( id ),
	UNIQUE(mid,aid,role)
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

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

Create Table `MaxPersonID` (
	`id` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Max ID assigned to all persons'
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

Create Table `MaxMovieID` (
	`id` INT NOT NULL COLLATE utf8_general_ci COMMENT 'Max ID assigned to all movies'
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

