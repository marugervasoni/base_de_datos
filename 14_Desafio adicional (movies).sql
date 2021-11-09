-- DESAFIO ADICIONAL (MOVIES)
-- Consultas
-- Join
-- 1. Utilizando la base de datos de movies, queremos conocer, por un lado, los
-- títulos y el nombre del género de todas las series de la base de datos.
SELECT s.title, g.name
FROM series s
INNER JOIN genres g 
ON g.id = s.genre_id;
-- 6 rows

-- 2. Por otro, necesitamos listar los títulos de los episodios junto con el nombre y
-- apellido de los actores que trabajan en cada uno de ellos.
SELECT e.title, a.first_name, a.last_name 
FROM episodes e
INNER JOIN actor_episode ae ON ae.episode_id = e.id
INNER JOIN actors a ON ae.actor_id = a.id; 
-- 148 rows

-- 3. Para nuestro próximo desafío, necesitamos obtener a todos los actores o
-- actrices (mostrar nombre y apellido) que han trabajado en cualquier película
-- de la saga de La Guerra de las galaxias.
SELECT a.first_name AS nombre, a.last_name  AS apellido, m.title
FROM actors a
INNER JOIN actor_movie am ON am.actor_id = a.id
INNER JOIN movies m ON  am.movie_id = m.id
WHERE m.title LIKE  "%la%guerra%de%las%galaxias%";
-- 6 rows

-- 4. Crear un listado a partir de la tabla de películas, mostrar un reporte de la
-- cantidad de películas por nombre de género.
SELECT COUNT(m.title) AS "cant peliculas por genero", g.name AS "nombre del genero"
FROM movies m
INNER JOIN genres g ON m.genre_id = g.id
GROUP BY g.name;
-- 7 rows
