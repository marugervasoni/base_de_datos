-- CLASE 16 -DESAFIO: EXTRA JOINS 
USE extra_joins;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

-- Reportes - JOINS
-- Consignas:
-- 1. Obtener los artistas que han actuado en una o más películas.
SELECT CONCAT(a.nombre," ",a.apellido) Artista, count(ap.pelicula_id)
FROM artista a
INNER JOIN artista_x_pelicula ap ON a.id = ap.artista_id
GROUP BY Artista
HAVING count(ap.pelicula_id) >= 1;
-- 6 rows


-- 2. Obtener las películas donde han participado más de un artista según nuestra
-- base de datos.
SELECT p.titulo, COUNT(ap.artista_id)
FROM pelicula p
INNER JOIN artista_x_pelicula ap ON p.id = ap.pelicula_id
GROUP BY p.titulo
HAVING COUNT(ap.artista_id) > 1;
-- 3 ROWS

-- 3. Obtener aquellos artistas que han actuado en alguna película, incluso
-- aquellos que aún no lo han hecho, según nuestra base de datos.
SELECT CONCAT(a.nombre," ",a.apellido) Artista, ap.pelicula_id
FROM artista a
LEFT JOIN artista_x_pelicula ap ON a.id = ap.artista_id
LEFT JOIN pelicula p ON ap.pelicula_id = p.id;
-- 10 ROWS

-- 4. Obtener las películas que no se le han asignado artistas en nuestra base de
-- datos.
SELECT p.titulo
FROM pelicula p
LEFT JOIN artista_x_pelicula ap ON p.id = ap.pelicula_id
LEFT JOIN artista a ON ap.artista_id = a.id
WHERE ap.artista_id IS NULL;
-- 6 rows

-- 5. Obtener aquellos artistas que no han actuado en alguna película, según
-- nuestra base de datos.
SELECT CONCAT(a.nombre," ",a.apellido) Artista       
FROM artista a 
LEFT JOIN artista_x_pelicula ap ON a.id = ap.artista_id
LEFT JOIN pelicula p ON ap.pelicula_id = p.id
WHERE ap.pelicula_id IS NULL;
-- 2 rows

-- 6. Obtener aquellos artistas que han actuado en dos o más películas según
-- nuestra base de datos.
SELECT CONCAT(a.nombre," ",a.apellido) Artista, count(ap.pelicula_id)
FROM artista a
INNER JOIN artista_x_pelicula ap ON a.id = ap.artista_id
GROUP BY Artista
HAVING count(ap.pelicula_id) >= 2;
-- 2 ROWS

-- 7. Obtener aquellas películas que tengan asignado uno o más artistas, incluso
-- aquellas que aún no le han asignado un artista en nuestra base de datos.
SELECT p.titulo, COUNT(a.id)
FROM pelicula p
LEFT JOIN artista_x_pelicula ap ON p.id = ap.pelicula_id
LEFT JOIN artista a ON ap.artista_id = a.id
GROUP BY p.titulo;
-- 11 rows