USE emarket;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

-- Vistas - Parte I
-- Clientes-------------------------------------------------------------------------------
-- 1. Crear una vista con los siguientes datos de los clientes: ID, contacto, y el
-- Fax. En caso de que no tenga Fax, colocar el teléfono, pero aclarándolo. Por
-- ejemplo: “TEL: (01) 123-4567”.
CREATE VIEW v_datos_clientes AS
SELECT c.ClienteID, c.Contacto, CASE WHEN FAX= " "
	THEN CONCAT("TEL ", c.Telefono)
    ELSE CONCAT("FAX ", Fax)
    END AS num_contacto
FROM clientes c;

-- 2. Se necesita listar los números de teléfono de los clientes que no tengan
-- fax. Hacerlo de dos formas distintas:
-- a. Consultando la tabla de clientes.
SELECT Contacto, Fax, Telefono
FROM clientes
WHERE Fax = " "; 
-- 22 ROWS

-- b. Consultando la vista de clientes.
SELECT * FROM v_datos_clientes
WHERE num_contacto LIKE "TEL%";
-- 22ROWS

-- SELECT * FROM v_datos_cliente WHERE numeroDeContacto NOT LIKE "FAX:%" ;1


-- Proveedores-----------------------------------------------------------------------------
-- 1. Crear una vista con los siguientes datos de los proveedores: ID,
-- contacto, compañía y dirección. Para la dirección tomar la dirección,
-- ciudad, código postal y país.
CREATE VIEW v_datos_proveedores AS
SELECT ProveedorID, Contacto, Compania, CONCAT(Direccion,", ", Ciudad,", CP: ", CodigoPostal, ", ", Pais) AS Direccion
FROM proveedores;

-- 2. Listar los proveedores que vivan en la calle Americanas en Brasil. Hacerlo
-- de dos formas distintas:
-- a. Consultando la tabla de proveedores.
SELECT ProveedorID, Contacto, Direccion, Pais FROM proveedores
WHERE Direccion LIKE "%Americanas%" AND Pais = "Brazil";
-- b. Consultando la vista de proveedores.
SELECT* FROM v_datos_proveedores
WHERE Direccion LIKE "%Americanas%Brazil%";

-- -----------------------------------------------------------------------------------------
-- Vistas - Parte II----------------------------------------------------------------------
-- 1. Crear una vista de productos que se usará para control de stock. Incluir el ID
-- y nombre del producto, el precio unitario redondeado sin decimales, las
-- unidades en stock y las unidades pedidas. Incluir además una nueva
-- columna PRIORIDAD con los siguientes valores:
-- ■ BAJA: si las unidades pedidas son cero.
-- ■ MEDIA: si las unidades pedidas son menores que las unidades
-- en stock.
-- ■ URGENTE: si las unidades pedidas no duplican el número de
-- unidades.
-- ■ SUPER URGENTE: si las unidades pedidas duplican el número
-- de unidades en caso contrario.
CREATE VIEW v_stock_productos AS
SELECT ProductoID, ProductoNombre, CEILING(PrecioUnitario) AS Precio_unitario, UnidadesStock, UnidadesPedidas, 
CASE 
	WHEN UnidadesPedidas = "0" THEN("BAJA")
    WHEN UnidadesPedidas < UnidadesStock THEN("MEDIA")
    WHEN UnidadesPedidas < (UnidadesStock*2) THEN("URGENTE")
    WHEN UnidadesPedidas > (UnidadesStock*2) THEN("SUPER URGENTE")
    END AS Prioridad
FROM productos;

-- 2. Se necesita un reporte de productos para identificar problemas de stock.
-- PARA CADA PRIORIDAD indicar cuántos productos hay y su precio promedio.
-- No incluir las prioridades para las que haya menos de 5 productos.
SELECT Prioridad, AVG(Precio_unitario) AS precio_promedio, COUNT(UnidadesStock) AS total_productos 
FROM v_stock_productos
GROUP BY Prioridad
HAVING total_productos > 5;
