SELECT CONCAT(first, " ", last)
FROM Actor A, Movie M, MovieActor MA
WHERE M.id = MA.mid AND MA.aid = A.id AND M.title = 'Die Another Day';

SELECT COUNT(*) 
FROM (SELECT MA.aid
		FROM MovieActor MA
        GROUP BY MA.aid
        HAVING COUNT(*) > 1) ActorsWithMultipleMovies;

SELECT CONCAT(first, " ", last)
FROM Actor A, (SELECT DISTINCT MA.aid as id, MG.genre FROM MovieActor MA, MovieGenre MG WHERE MA.mid = MG.mid ) AG
where A.id = AG.id
GROUP BY AG.id
HAVING COUNT(AG.genre) >=12 ;