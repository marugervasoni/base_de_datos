-- CLASE 16- SAKILA, VOLVER AL FUTURO.

USE sakila;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

-- Reportes
-- Reportes parte 1:-----------------------------------------------------------------------------------------------------
-- 1. Obtener el nombre y apellido de los primeros 5 actores disponibles. Utilizar
-- alias para mostrar los nombres de las columnas en español.
SELECT first_name nombre, last_name apellido
FROM actor
LIMIT 5;
-- 5 ROWS

-- 2. Obtener un listado que incluya nombre, apellido y correo electrónico de los
-- clientes (customers) inactivos. Utilizar alias para mostrar los nombres de las
-- columnas en español.
SELECT first_name nombre, last_name apellido, email correo_electronico
FROM customer 
WHERE active = 0;
-- 15 ROWS

-- 3. Obtener un listado de films incluyendo título, año y descripción de los films
-- que tienen un rental_duration mayor a cinco. Ordenar por rental_duration de
-- mayor a menor. Utilizar alias para mostrar los nombres de las columnas en
-- español.
SELECT title titulo, release_year año, description descripcion
FROM film
WHERE rental_duration > 5
ORDER BY rental_duration DESC;
-- 403 ROWS

-- 4. Obtener un listado de alquileres (rentals) que se hicieron durante el mes de
-- mayo de 2005, incluir en el resultado todas las columnas disponibles.
SELECT *
FROM rental
WHERE rental_date BETWEEN "2005-05-01" AND "2005-05-31";
-- 993 ROWS

-- Reportes parte 2: Sumemos complejidad--------------------------------------------------------------------------------
-- Si llegamos hasta acá, tenemos en claro la estructura básica de un
-- SELECT. En los siguientes reportes vamos a sumar complejidad.
-- ¿Probamos?
-- 1. Obtener la cantidad TOTAL de alquileres (rentals). Utilizar un alias para
-- mostrarlo en una columna llamada “cantidad”.
SELECT COUNT(*) AS cantidad
FROM rental;
-- 16044

-- 2. Obtener la suma TOTAL de todos los pagos (payments). Utilizar un alias para
-- mostrarlo en una columna llamada “total”, junto a una columna con la
-- cantidad de alquileres con el alias “Cantidad” y una columna que indique el
-- “Importe promedio” por alquiler.
SELECT SUM(p.amount) AS Total, COUNT(r.rental_id) AS Cantidad, AVG(p.amount)AS importe_promedio
FROM payment p
INNER JOIN rental r ON r.rental_id = p.rental_id;

-- 3. Generar un reporte que responda la pregunta: ¿cuáles son los diez clientes
-- que más dinero gastan y en cuántos alquileres lo hacen?
SELECT CONCAT(c.first_name, " ", c.last_name) Nombre_y_Apellido, SUM(p.amount) Dinero_gastado, COUNT(r.rental_id) Cantidad_Alquileres
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
INNER JOIN rental r ON r.rental_id = p.rental_id
GROUP BY Nombre_y_Apellido
ORDER BY SUM(p.amount) DESC
LIMIT 10;

-- 4. Generar un reporte que indique: ID de cliente, cantidad de alquileres y monto
-- total para todos los clientes que hayan gastado más de 150 dólares en
-- alquileres.
SELECT c.customer_id AS id_cliente, COUNT(r.rental_id) AS cantidad_alquileres, SUM(p.amount) AS monto_total
FROM customer c
INNER JOIN rental r ON r.customer_id = c.customer_id
INNER JOIN payment p ON p.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING SUM(p.amount) > 150
ORDER BY SUM(p.amount) DESC;
-- 599 ROWS 

-- 5. Generar un reporte que muestre por mes de alquiler (rental_date de tabla
-- rental), la cantidad de alquileres y la suma total pagada (amount de tabla
-- payment) para el año de alquiler 2005 (rental_date de tabla rental).
SELECT MONTH(r.rental_date) AS mes_de_alquiler, COUNT(r.rental_id) AS cant_alquileres, SUM(p.amount) AS suma_total_pagada, YEAR(r.rental_date) AS anio_alquiler
FROM rental r
INNER JOIN payment p ON p.rental_id = r.rental_id
GROUP BY  mes_de_alquiler, anio_alquiler  
HAVING anio_alquiler = 2005;
-- 4rows

-- 6. Generar un reporte que responda a la pregunta: ¿cuáles son los 5
-- inventarios más alquilados? (columna inventory_id en la tabla rental). Para
-- cada una de ellas indicar la cantidad de alquileres.
SELECT r.inventory_id Mas_alquilados, COUNT(r.rental_id) Cantidad_alquileres
FROM rental r
GROUP BY r.inventory_id
order by Cantidad_alquileres DESC
LIMIT 5;
