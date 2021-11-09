-- 1) Cálculo de edad-------------------------------------------------------------------------- 
-- a) Crear un SP que muestre apellidos, nombres y edad de cada empleado, 
-- debe calcular la edad de los empleados a partir de la fecha de nacimiento y que
-- tengan entre n y n años de edad. 

DELIMITER $$
CREATE PROCEDURE sp_calculoEdad(IN edad_inicial int, in edad_final int )
BEGIN
SELECT CONCAT(empleados.Apellido, ' ', empleados.Nombre, ' ', TIMESTAMPDIFF(YEAR, empleados.fechaNacimiento, NOW())) AS 'empleado' FROM emarket.empleados
WHERE TIMESTAMPDIFF(YEAR, empleados.fechaNacimiento, NOW()) between edad_inicial and edad_final;
end $$ 

-- -- b
CALL sp_calculoEdad(50,60); 

-- 2) Actualización de productos------------------------------------------------------------- 
-- a) Crear un SP que reciba un porcentaje y un nombre de categoría y actualice 
-- los productos pertenecientes a esa categoría, incrementando las unidades pedidas
-- según el porcentaje indicado. Por ejemplo: si un producto de la categoría Seafood 
-- tiene 30 unidades pedidas, al invocar el SP con categoría Seafood y porcentaje 10%, 
-- el SP actualizará el valor de unidades pedidas con el nuevo valor 33. 
DELIMITER $$
CREATE PROCEDURE sp_incrementar_porcentaje (IN porcentaje INT,  IN nombre_categoria VARCHAR(15) )
BEGIN 
UPDATE productos p JOIN categorias c ON p.CategoriaID = c.CategoriaID
SET p.UnidadesPedidas= p.UnidadesPedidas *(1+ (0.01 * porcentaje))
WHERE categorias.CategoriaNombre = nombre_categoria;
select categorias.CategoriaNombre, prodcutos.UnidadesPedidas FROM productos
join categorias c on prodcutos.CategoriaID=c.CategoriaID;
END$$

CALL sp_actualizacion_productos ('Seafood', 15);

-- b) Listar los productos de la categoría Beverages para ver cuántas unidades pedidas hay de 
-- cada uno de ellos. 

DROP VIEW IF EXISTS view_listar_productos;

CREATE VIEW view_listar_productos AS
SELECT p.ProductoNombre Producto, p.UnidadesPedidas UnidadesPedidas, c.CategoriaNombre CategoriaNombre
FROM productos p
INNER JOIN categorias c
ON p.CategoriaID = c.CategoriaID
WHERE c.CategoriaNombre = "Beverages";

SELECT * FROM view_listar_productos;

-- c) Invocar al SP con los valores Beverages como categoría y 15 como porcentaje.
SET SQL_SAFE_UPDATES = 0;
CALL sp_actualizacion_productos ('Seafood', 15);
SET SQL_SAFE_UPDATES = 1;

-- d) Volver a listar los productos como en (a), y validar los resultados.
SELECT * FROM view_listar_productos;

-- 3) Actualización de empleados-----------------------------------------------------------
-- a) Crear un SP que cree una tabla con los nombres, apellidos y teléfono de contacto de
-- todos los empleados que hayan sido contratados con fecha anterior a una fecha
-- dada.
DELIMITER $$
CREATE PROCEDURE sp_empleados_contratados_x_fecha(IN fecha DATETIME)
BEGIN
SELECT CONCAT(empleados.Nombre, " " , empleados.Apellido, " " ,empleados.Telefono) AS datos_empleado 
FROM empleados
WHERE empleados.FechaContratacion < fecha;
END $$ 

-- b) Ejecutar el SP para generar una tabla de empleados con fecha de contratación
-- anterior a 01/01/1994.
CALL sp_empleados_contratados_x_fecha("1994-01-02 00:00:00");

-- c) Consultar la tabla generada y validar los resultados.
SELECT CONCAT(empleados.Nombre, " " , empleados.Apellido, " " ,empleados.Telefono) AS datos_empleado, empleados.FechaContratacion 
FROM empleados
WHERE empleados.FechaContratacion < "1994-01-02 00:00:00";
