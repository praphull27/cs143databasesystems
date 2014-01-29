-- Dropping the existing tables if exists.
DROP TABLE IF EXISTS `Review`;
DROP TABLE IF EXISTS `MovieActor`;
DROP TABLE IF EXISTS `MovieDirector`;
DROP TABLE IF EXISTS `MovieGenre`;
DROP TABLE IF EXISTS `Director`;
DROP TABLE IF EXISTS `Actor`;
DROP TABLE IF EXISTS `Movie`;
DROP TABLE IF EXISTS `MaxPersonID`;
DROP TABLE IF EXISTS `MaxMovieID`;


-- TABLE structure for TABLE `Movie`
-- Movie(id, title, year, rating, company)
-- 1. Primary Key Constraint: `id`
-- 2. Check Constraint on `id` column. `id` > 0
-- 3. `title` column cannot have NULL.
CREATE TABLE `Movie` (
	`id` INT NOT NULL COMMENT 'Movie ID' CHECK (`id` > 0),
	`title` VARCHAR(100) NOT NULL COMMENT 'Movie Title',
	`year` INT DEFAULT NULL COMMENT 'Release Year',
	`rating` VARCHAR(10) DEFAULT NULL COMMENT 'MPAA Rating',
	`company` VARCHAR(50) DEFAULT NULL COMMENT 'Production Company',
	PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;


-- TABLE structure for TABLE `Actor`
-- Actor(id, last, first, sex, dob, dod)
-- 1. Primary Key Constraint: `id`
-- 2. Check Constraint on `id` column. `id` > 0
-- 3. `dob` column cannot have NULL.
-- 4. Check Constraint on `dob` and `dod` columns. `dob` < `dod`
-- 5. Check Constraint on `last` and `first` columns. For a particular tuple both cannot be NULL.
CREATE TABLE `Actor` (
	`id` INT NOT NULL COMMENT 'Actor ID' CHECK (`id` > 0),
	`last` VARCHAR(20) DEFAULT NULL COMMENT 'Last name',
	`first` VARCHAR(20) DEFAULT NULL COMMENT 'First name',
	`sex` VARCHAR(6) DEFAULT NULL COMMENT 'Sex of the actor',
	`dob` DATE NOT NULL COMMENT 'Date of Birth',
	`dod` DATE DEFAULT NULL COMMENT 'Date of Death',
	PRIMARY KEY (`id`),
	CHECK (`dob` < `dod`),
	CHECK (`last` IS NOT NULL OR `first` IS NOT NULL)
) ENGINE=INNODB DEFAULT CHARSET=utf8;


-- TABLE structure for TABLE `Director`
-- Director(id, last, first, dob, dod)
-- 1. Primary Key Constraint: `id`
-- 2. Check Constraint on `id` column. `id` > 0
-- 3. `dob` column cannot have NULL.
-- 4. Check Constraint on `dob` and `dod` columns. `dob` < `dod`
-- 5. Check Constraint on `last` and `first` columns. For a particular tuple both cannot be NULL.
CREATE TABLE `Director` (
	`id` INT NOT NULL COMMENT 'Director ID' CHECK (`id` > 0),
	`last` VARCHAR(20) DEFAULT NULL COMMENT 'Last name',
	`first` VARCHAR(20) DEFAULT NULL COMMENT 'First name',
	`dob` DATE NOT NULL COMMENT 'Date of Birth',
	`dod` DATE DEFAULT NULL COMMENT 'Date of Death',
	PRIMARY KEY (`id`),
	CHECK (`dob` < `dod`),
	CHECK (`last` IS NOT NULL OR `first` IS NOT NULL)
) ENGINE=INNODB DEFAULT CHARSET=utf8;


-- TABLE structure for TABLE `MovieGenre`
-- MovieGenre(mid, genre)
-- 1. Primary Key Constraint: `mid`,`genre`
-- 2. Foreign Key Constraint: `mid` column of `MovieGenre` table refers to `id` column of `Movie` table.
CREATE TABLE `MovieGenre` (
	`mid` INT NOT NULL COMMENT 'Movie ID',
	`genre` VARCHAR(20) NOT NULL COMMENT 'Movie genre',
	PRIMARY KEY (`mid`,`genre`),
	FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8;


-- TABLE structure for TABLE `MovieDirector`
-- MovieDirector(mid, did)
-- 1. Primary Key Constraint: `mid`,`did`
-- 2. Foreign Key Constraint: `mid` column of `MovieDirector` table refers to `id` column of `Movie` table.
-- 3. Foreign Key Constraint: `did` column of `MovieDirector` table refers to `id` column of `Director` table.
CREATE TABLE `MovieDirector` (
	`mid` INT NOT NULL COMMENT 'Movie ID',
	`did` INT NOT NULL COMMENT 'Director ID',
	PRIMARY KEY (`mid`,`did`),
	FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`) ON DELETE CASCADE,
	FOREIGN KEY (`did`) REFERENCES `Director` (`id`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8;


-- TABLE structure for TABLE `MovieActor`
-- MovieActor(mid, aid, role)
-- 1. Unique Key Constraint: `mid`,`aid`,`role`
-- 2. `mid` column cannot have NULL.
-- 3. `aid` column cannot have NULL.
-- 4. Foreign Key Constraint: `mid` column of `MovieActor` table refers to `id` column of `Movie` table.
-- 5. Foreign Key Constraint: `aid` column of `MovieActor` table refers to `id` column of `Actor` table.
CREATE TABLE `MovieActor` (
	`mid` INT NOT NULL COMMENT 'Movie ID',
	`aid` INT NOT NULL COMMENT 'Actor ID',
	`role` VARCHAR(50) DEFAULT NULL COMMENT 'Actor role in movie',
	UNIQUE (`mid`,`aid`,`role`),
	FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`) ON DELETE CASCADE,
	FOREIGN KEY (`aid`) REFERENCES `Actor` (`id`) ON DELETE CASCADE
) ENGINE=INNODB DEFAULT CHARSET=utf8;


-- TABLE structure for TABLE `Review`
-- Review(name, time, mid, rating, comment)
-- 1. Primary Key Constraint: `name`,`mid`
-- 2. `rating` column cannot have NULL.
-- 3. Check Constraint on `rating` column. Rating is always between 0 and 5
-- 4. Foreign Key Constraint: `mid` column of `Review` table refers to `id` column of `Movie` table.
CREATE TABLE `Review` (
	`name` VARCHAR(20) NOT NULL COMMENT 'Reviewer name',
	`time` TIMESTAMP NOT NULL COMMENT 'Review time',
	`mid` INT NOT NULL COMMENT 'Movie ID',
	`rating` INT NOT NULL COMMENT 'Review rating',
	`comment` VARCHAR(500) DEFAULT NULL COMMENT 'Reviewer Comment',
	PRIMARY KEY (`name`,`mid`),
	FOREIGN KEY (`mid`) REFERENCES `Movie` (`id`) ON DELETE CASCADE,
	CHECK (`rating` >= 0 AND `rating` <= 5)
) ENGINE=INNODB DEFAULT CHARSET=utf8; 


-- TABLE structure for TABLE `MaxPersonID`
-- MaxPersonID(id)
-- 1. Primary Key Constraint: `id`
CREATE TABLE `MaxPersonID` (
	`id` INT NOT NULL COMMENT 'Max ID assigned to all persons',
	PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;


-- TABLE structure for TABLE `MaxMovieID`
-- MaxMovieID(id)
-- 1. Primary Key Constraint: `id`
CREATE TABLE `MaxMovieID` (
	`id` INT NOT NULL COMMENT 'Max ID assigned to all movies',
	PRIMARY KEY (`id`)
) ENGINE=INNODB DEFAULT CHARSET=utf8;

