-- CLASE 17: SAKILA - VISTAS
USE sakila;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

-- Consultas
-- Views:
-- 1. a) Crear una vista denominada “vista_mostrar_pais” que devuelva un reporte
-- de los países.
CREATE VIEW v_vista_mostrar_pais AS
SELECT * FROM country;

-- b) Invocar la vista creada.
SELECT * FROM v_vista_mostrar_pais;


-- 2. a) Crear una vista que devuelva un resumen con el apellido y nombre (en una
-- sola columna denominada “artista”) de los artistas y la cantidad de
-- filmaciones que tienen. Traer solo aquellos que tengan más de 25
-- filmaciones y ordenarlos por apellido.
CREATE VIEW v_artistas_y_filmaciones AS
SELECT CONCAT(a.last_name," ",a.first_name) AS Artista, COUNT(fa.film_id) AS Cant_Filmaciones
FROM actor a
INNER JOIN film_actor fa ON fa.actor_id = a.actor_id
GROUP BY Artista
HAVING COUNT(fa.film_id) > 25
ORDER BY Artista;
-- 125 rows

-- b) Invocar la vista creada.
-- c) En la misma invocación de la vista, traer aquellos artistas que tienen
-- menos de 33 filmaciones.
SELECT * FROM v_artistas_y_filmaciones
WHERE Cant_Filmaciones < 33;
-- 95 rows

-- d) Con la misma sentencia anterior, ahora, mostrar el apellido y nombre de
-- los artistas en minúsculas y traer solo aquellos artistas cuyo apellido
-- comience con la letra "a".
SELECT LOWER(Artista) FROM v_artistas_y_filmaciones
WHERE Cant_Filmaciones < 33 AND Artista LIKE "a%";
-- 3 rows

-- e) Eliminar la vista creada.
DROP VIEW v_artistas_y_filmaciones;


-- 3. a) Crear una vista que devuelva un reporte del título de la película, el apellido
-- y nombre (en una sola columna denominada “artista”) de los artistas y el
-- costo de reemplazo. Traer solo aquellas películas donde su costo de
-- reemplazo es entre 15 y 27 dólares, ordenarlos por costo de reemplazo.
CREATE VIEW v_peli_artista_costo AS
SELECT f.title AS Titulo, CONCAT(a.last_name," ",a.first_name) AS Artista, f.replacement_cost AS costo_reemplazo
FROM film f
INNER JOIN film_actor fa ON fa.film_id = f.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id
HAVING costo_reemplazo BETWEEN 15 AND 27
ORDER BY costo_reemplazo;

-- b) Invocar la vista creada.
SELECT * FROM v_peli_artista_costo;

-- c) En la misma invocación de la vista, traer aquellas películas que comienzan
-- con la letra "b".
SELECT * FROM v_peli_artista_costo
WHERE Titulo LIKE "b%";
-- 207 rows

-- d) Modificar la vista creada agregando una condición que traiga los artistas
-- cuyo nombre termine con la letra "a" y ordenarlos por mayor costo de
-- reemplazo.
ALTER VIEW v_peli_artista_costo AS
SELECT f.title AS Titulo, CONCAT(a.last_name," ",a.first_name) AS Artista, f.replacement_cost AS costo_reemplazo
FROM film f
INNER JOIN film_actor fa ON fa.film_id = f.film_id
INNER JOIN actor a ON fa.actor_id = a.actor_id
HAVING Artista LIKE "%a"
ORDER BY costo_reemplazo DESC;

-- e) Invocar la vista creada.
SELECT * FROM v_peli_artista_costo;
