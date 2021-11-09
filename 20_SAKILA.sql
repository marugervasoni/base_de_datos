-- CLASE 20- SAKILA

USE sakila;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

-- EndPoints
-- Parte 1:-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ¡Estos reportes ya los conoces! Pero te pedimos que en este caso no utilices los
-- identificadores, sino que los reemplaces por su correspondiente descripción. Para
-- esto, vas a tener que realizar JOINS.
-- Por ejemplo, si quiero mostrar un reporte de películas más alquiladas, en lugar de
-- mostrar el ID de película, debemos mostrar el título.
-- Manos a la obra:
-- 1. Generar un reporte que responda la pregunta: ¿cuáles son los diez clientes
-- que más dinero gastan y en cuantos alquileres lo hacen?
SELECT c.first_name, c.last_name, SUM(p.amount) Dinero_gastado, COUNT(r.rental_id) Cantidad_Alquileres
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN rental r ON p.rental_id = r.rental_id
GROUP BY c.first_name, c.last_name
ORDER BY Dinero_gastado DESC
LIMIT 10;

-- 2. Generar un reporte que indique: el id del cliente, la cantidad de alquileres y
-- el monto total para todos los clientes que hayan gastado más de 150 dólares
-- en alquileres.
SELECT c.customer_id,c.first_name, c.last_name,  COUNT(r.rental_id) AS cantidad_alquileres, SUM(p.amount) AS monto_total
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN rental r ON p.rental_id = r.rental_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING monto_total > 150;
-- 46 ROWS 

-- 3. Generar un reporte que responda a la pregunta: ¿cómo se distribuyen la
-- cantidad y el monto total de alquileres en los meses pertenecientes al año
-- 2005? (tabla payment).
SELECT COUNT(payment_id) AS Cantidad_alq, SUM(amount) AS Monto_total, DATE_FORMAT(payment_date, "%m/%Y") AS mes_y_anio
FROM payment
WHERE YEAR(payment_date) = 2005
GROUP BY mes_y_anio;
-- 4rows

-- 4. Generar un reporte que responda a la pregunta: ¿cuáles son los 5 inventarios
-- más alquilados? (columna inventory_id en la tabla rental) Para cada una de
-- ellas, indicar la cantidad de alquileres.
SELECT inventory_id, COUNT(rental_id) Cantidad_alquileres
FROM rental 
GROUP BY inventory_id
order by Cantidad_alquileres DESC
LIMIT 5;


-- Parte 2:----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1. Generar un reporte que responda a la pregunta: Para cada tienda
-- (store), ¿cuál es la cantidad de alquileres y el monto total del dinero
-- recaudado por mes?
SELECT s.store_id AS Tienda, COUNT(p.rental_id) AS Cant_alquileres, SUM(p.amount) AS Monto_total, MONTH(p.payment_date) AS Mes
FROM store s
INNER JOIN inventory i ON s.store_id = i.store_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY Tienda, Mes
ORDER BY Mes;
-- 18 rows

-- 2. Generar un reporte que responda a la pregunta: ¿cuáles son las 10 películas
-- que generan más ingresos? ¿ Y cuáles son las que generan menos ingresos?
-- Para cada una de ellas indicar la cantidad de alquileres.
SELECT f.title Titulo, COUNT(r.rental_id) Cant_alquileres, SUM(f.rental_rate) Monto_total
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY Titulo
ORDER BY Monto_total DESC
LIMIT 10;

SELECT f.title Titulo, COUNT(r.rental_id) Cant_alquileres, SUM(f.rental_rate) Monto_total
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY Titulo
ORDER BY Monto_total
LIMIT 10;

-- 3. ¿Existen clientes que no hayan alquilado películas?
SELECT c.first_name Nombre, c.last_name Apellido, r.customer_id
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
WHERE r.customer_id IS NULL;

-- 4. Nivel avanzado: El jefe de stock quiere discontinuar las películas (film) con
-- menos alquileres (rental). ¿Qué películas serían candidatas a discontinuar?
-- Recordemos que pueden haber películas con 0 (Cero) alquileres.
SELECT f.title Titulo_pelicula, COUNT(r.rental_id) Cant_alquileres
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY Titulo_pelicula
ORDER BY Cant_alquileres;
