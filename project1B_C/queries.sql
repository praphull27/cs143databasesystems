-- Names of all the actors in the movie 'Die Another Day'.
SELECT CONCAT(first, " ", last) AS `Actor Name`
FROM Actor A, Movie M, MovieActor MA
WHERE M.id = MA.mid AND MA.aid = A.id AND M.title = 'Die Another Day';


-- Count of all the actors who acted in multiple movies
SELECT COUNT(*) AS `Count Of Actors With Multiple Movies`
FROM (SELECT MA.aid
	FROM MovieActor MA
	GROUP BY MA.aid
	HAVING COUNT(*) > 1) ActorsWithMultipleMovies;


-- Names of actors who acted in movies belonging to 14 or more genres.
SELECT CONCAT(first, " ", last) AS `Actor Name`
FROM Actor A, (SELECT DISTINCT MA.aid as id, MG.genre FROM MovieActor MA, MovieGenre MG WHERE MA.mid = MG.mid ) AG
where A.id = AG.id
GROUP BY AG.id
HAVING COUNT(AG.genre) >=14;
