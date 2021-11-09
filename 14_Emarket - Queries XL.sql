-- CLASE 14, QUERIES XL (E-MARKET)
-- Vamos a practicar sobre consultas SELECT, enfocándonos en group by, having y distinct
-- Clientes---------------------------------------------------------------------------------
-- 1) ¿Cuántos clientes existen?
SELECT COUNT(*) FROM clientes;
-- 1 row (91 clientes)

-- 2) ¿Cuántos clientes hay por ciudad?
SELECT COUNT(*), Ciudad 
FROM clientes
GROUP BY Ciudad;
-- 69 rows

-- Facturas--------------------------------------------------------------------------------
-- 1) ¿Cuál es el total de transporte?
SELECT SUM(Transporte)
FROM facturas;
-- 1 row (64942.69000000006)

-- 2) ¿Cuál es el total de transporte por EnvioVia (empresa de envío)?
SELECT SUM(Transporte), EnvioVia AS empresa_de_envio
FROM facturas
GROUP BY EnvioVia;
-- 3 rows(16185.329999999998 (1), 28244.849999999988(2), 20512.50999999998(3))

-- 3) Calcular la cantidad de facturas por cliente. Ordenar descendentemente por
-- cantidad de facturas.
SELECT COUNT(FacturaID), ClienteID
FROM facturas 
GROUP BY ClienteID
ORDER BY count(FacturaID) DESC;
-- 89 rows (31 facturas tiene el cliente que mas facturas tiene)

-- 4) Obtener el Top 5 de clientes de acuerdo a su cantidad de facturas.
SELECT COUNT(FacturaID), ClienteID
FROM facturas 
GROUP BY ClienteID
ORDER BY count(FacturaID) DESC
LIMIT 5;
-- 5 rows

-- 5) ¿Cuál es el país de envío menos frecuente de acuerdo a la cantidad de facturas?
SELECT COUNT(FacturaID), ClienteID, PaisEnvio
FROM facturas 
GROUP BY PaisEnvio
ORDER BY count(FacturaID)
LIMIT 1;
-- 1 row (Norway, 6 facturas)

-- 6) Se quiere otorgar un bono al empleado con más ventas. ¿Qué ID de empleado
-- realizó más operaciones de ventas?
SELECT COUNT(FacturaID), EmpleadoID
FROM facturas 
GROUP BY EmpleadoID
ORDER BY count(FacturaID) DESC
LIMIT 1;
-- 1 row (el empleado 4, realizó 156 ventas)

-- Factura detalle-----------------------------------------------------------------------
-- 1) ¿Cuál es el producto que aparece en más líneas de la tabla Factura Detalle
SELECT  COUNT(*), ProductoID 
FROM facturadetalle
GROUP BY ProductoID
ORDER BY count(*) DESC
LIMIT 1;
-- 1row (54 del producto 59)
-- SELECT * FROM productos WHERE ProductoID = "59"; --> (raclette courdavault)

-- 2) ¿Cuál es el total facturado? Considerar que el total facturado es la suma de
-- cantidad por precio unitario.
SELECT SUM(PrecioUnitario * Cantidad) as 'Total facturado' FROM facturadetalle;
-- 1 row

-- 3) ¿Cuál es el total facturado para los productos ID entre 30 y 50?
SELECT SUM(PrecioUnitario * Cantidad) as 'Total facturado' 
FROM facturadetalle 
WHERE ProductoID BETWEEN 30 AND 50;
-- 1 row

-- 4) ¿Cuál es el precio unitario promedio de cada producto?
SELECT AVG(PrecioUnitario) AS precio_unitario_promedio
FROM facturadetalle
GROUP BY ProductoID;
-- 77 rows

-- 5) ¿Cuál es el precio unitario máximo?
SELECT MAX(PrecioUnitario) AS precio_unitario_maximo
FROM facturadetalle;
-- 1 row (263.5)

-- ------------------------------------------------------------------------------------- 
-- Consultas queries XL parte II - JOIN----------------------------------------------
-- En esta segunda parte vamos a intensificar la práctica de consultas con JOIN.
-- 1) Generar un listado de todas las facturas del empleado 'Buchanan'.
SELECT F. *
FROM facturas f
INNER JOIN empleados e ON e.EmpleadoID = f.EmpleadoID
WHERE e.Apellido = "Buchanan";
-- 42 rows-- 

-- 2) Generar un listado con todos los campos de las facturas del correo 'Speedy
-- Express'.
SELECT * FROM facturas f
INNER JOIN correos c ON f.EnvioVia = c.CorreoID
WHERE c.Compania = 'Speedy Express';
-- 249 rows 

-- 3) Generar un listado de todas las facturas con el nombre y apellido de los
-- empleados.
SELECT f.FacturaID, e.Apellido, e.Nombre FROM facturas f
INNER JOIN empleados e ON e.EmpleadoID = f.EmpleadoID;
-- 830 rows

-- 4) Mostrar un listado de las facturas de todos los clientes “Owner” y país de envío
-- “USA”.
SELECT * FROM facturas f
INNER JOIN clientes c ON c.ClienteID = f.ClienteID
WHERE f.PaisEnvio = "usa" AND c.Titulo = "Owner";
-- 49 rows

-- 5) Mostrar todos los campos de las facturas del empleado cuyo apellido sea
-- “Leverling” o que incluyan el producto id = “42”.
SELECT f.* FROM facturas f
INNER JOIN empleados e ON f.EmpleadoID = e.EmpleadoID
INNER JOIN facturadetalle fd ON fd.FacturaID = f.FacturaID
WHERE e.Apellido = "Leverling" OR fd.ProductoID = "42";
-- 346 rows

-- 6) Mostrar todos los campos de las facturas del empleado cuyo apellido sea
-- “Leverling” y que incluya los producto id = “80” o ”42”.
SELECT f.* FROM facturas f
INNER JOIN empleados e ON f.EmpleadoID = e.EmpleadoID
INNER JOIN facturadetalle fd ON fd.FacturaID = f.FacturaID
WHERE e.Apellido = "Leverling" AND fd.ProductoID IN (80, 42);
-- 5 rows

-- 7) Generar un listado con los cinco mejores clientes, según sus importes de
-- compras total (PrecioUnitario * Cantidad).
SELECT c.ClienteID, SUM(fd.PrecioUnitario * fd.Cantidad) AS importe_total_de_compras FROM clientes c
INNER JOIN facturas f ON f.ClienteID = c.ClienteID
INNER JOIN facturadetalle fd ON fd.FacturaID = f.FacturaID
GROUP BY c.ClienteID
ORDER BY SUM(fd.PrecioUnitario * fd.Cantidad) DESC
LIMIT 5;
-- 5 rows