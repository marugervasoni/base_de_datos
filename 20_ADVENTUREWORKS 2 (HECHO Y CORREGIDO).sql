-- CLASE 20- CONSULTAS COMPLEJAS
USE adventureworks;
SET sql_mode = 'ONLY_FULL_GROUP_BY';

-- Where------------------------------------------------------------------------------------------------------------
-- 1. Mostrar los nombre de los productos que tengan cualquier combinación de
-- ‘mountain bike’
-- Tablas: Product
-- Campos: Name
SELECT Name
FROM product
WHERE Name LIKE "%mountain%bike%";
-- 2 rows
-- -----------------------------------------------
-- SOLUCION ----> esta es  mas adecuada, trae mas resultados.
SELECT Name FROM product
WHERE Name LIKE '%mountain%' OR Name LIKE '%bike%'; 


-- 2. Mostrar las personas cuyo nombre empiece con la letra “y”
-- Tablas: Contact
-- Campos: FirstName
SELECT FirstName
FROM contact
WHERE FirstName LIKE "y%";
-- 37 rows
-- ------------------------------------
-- SOLUCION: --> la hice bien
-- SELECT FirstName FROM contact
-- WHERE FirstName LIKE 'Y%';


-- Order by--------------------------------------------------------------------------------------------------------
-- 1. Mostrar cinco productos más caros y su nombre ordenado en forma alfabética
-- Tablas: Product
-- Campos: Name, ListPrice
SELECT Name, ListPrice
FROM product
ORDER BY ListPrice DESC, Name ASC
LIMIT 5;
-- ---------------------------------------------
-- SOLUCION --> la hice bien
-- SELECT Name, ListPrice FROM product
-- ORDER BY ListPrice DESC, Name ASC LIMIT 5;


-- Operadores & joins----------------------------------------------------------------------------------------------
-- 1. Mostrar el nombre concatenado con el apellido de las personas cuyo apellido sea
-- johnson
-- Tablas: Contact
-- Campos: FirstName, LastName
SELECT CONCAT(FirstName," ",LastName) nombre_y_apellido
FROM contact
WHERE LastName = "johnson";
-- 88 rows
-- ---------------------------------------------
-- SOLUCION --> la hice bien
-- SELECT CONCAT(FirstName, ' ', LastName) FROM contact
-- WHERE LastName = 'johnson';


-- 2. Mostrar todos los productos cuyo precio sea inferior a 150$ de color rojo o cuyo
-- precio sea mayor a 500$ de color negro
-- Tablas: Product
-- Campos: ListPrice, Color
SELECT ListPrice, Color
FROM product
WHERE ListPrice < 150 AND Color = "red" OR ListPrice > 500 AND Color = "black";
-- 41 rows
-- ---------------------------------------------
-- SOLUCION --> la hice bien, pero mas prolijo y especifico si en el where pongo parentesis
-- SELECT ListPrice, Color FROM product
-- WHERE (ListPrice > 150 AND Color = 'Red') OR  (ListPrice > 500 AND Color = 'Black');


-- Funciones de agregación----------------------------------------------------------------------------------------------
-- 1. Mostrar la fecha más reciente de venta
-- Tablas: SalesOrderHeader
-- Campos: OrderDate
SELECT OrderDate
FROM SalesOrderHeader
ORDER BY OrderDate DESC 
LIMIT 1;
-- ---------------------------------------------
-- SOLUCION --> me dio igual, pero la solucion es menos rebuscada
-- SELECT MAX(OrderDate) AS OrderDate FROM salesorderheader;


-- 2. Mostrar el precio más barato de todas las bicicletas
-- Tablas: Product
-- Campos: ListPrice, Name
SELECT MIN(p.ListPrice), p.Name
FROM product p
INNER JOIN productsubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
INNER JOIN productcategory pc on psc.ProductCategoryID = pc.ProductCategoryID
WHERE pc.ProductCategoryID = 1;
-- ---------------------------------------------
-- SOLUCION --> la hice mal, la solucion era mucho mas simple
-- SELECT min(ListPrice) FROM product
-- WHERE Name LIKE '%bike%';

-- Group by-----------------------------------------------------------------------------------------------------
-- 1. Mostrar los productos y la cantidad total vendida de cada uno de ellos
-- Tablas: SalesOrderDetail
-- Campos: ProductID, OrderQty
SELECT ProductID, COUNT(OrderQty) cantidad_vendida
FROM salesorderdetail
GROUP BY ProductID;
-- 21 rows
-- ---------------------------------------------
-- SOLUCION --> todo bien menos la funcion utilizada, debia ser SUM en vez de COUNT.
-- SELECT ProductID, SUM(OrderQty) AS Cantidad FROM salesorderdetail
-- GROUP BY ProductID;

-- Having--------------------------------------------------------------------------------------------------------
-- 1. Mostrar la cantidad de facturas que vendieron más de 20 unidades.
-- Tablas: Sales.SalesOrderDetail
-- Campos: SalesOrderID, OrderQty
SELECT COUNT(SalesOrderID) cant_facturas, OrderQty
FROM salesorderdetail
GROUP BY OrderQty
HAVING OrderQty > 20;
-- ---------------------------------------------
-- SOLUCION --> lo hice mal. lo correcto era sumar las unidades (funcion SUM) y luego ponerlas en el having + 20, y sin aplicar funcion en el ID.
-- SELECT SalesOrderID, SUM(OrderQty) AS Cantidad FROM salesorderdetail
-- GROUP BY SalesOrderID HAVING Cantidad > 20;

-- Joins-----------------------------------------------------------------------------------------------------------
-- 1. Mostrar el código de logueo, número de territorio y sueldo básico de los
-- vendedores
-- Tablas: Employee, SalesPerson
-- Campos: LoginID, TerritoryID, Bonus, BusinessEntityID
SELECT e.LoginID, sp.TerritoryID, sp.Bonus, sp.SalesYTD
FROM employee e
INNER JOIN salesperson sp ON sp.SalesPersonID = EmployeeID;
-- ---------------------------------------------
-- SOLUCION -->  no supe reconocer salesYTD como registro a traer.
-- SELECT LoginID, TerritoryID, Bonus, SalesYTD FROM Employee e
-- INNER JOIN SalesPerson sp ON sp.SalesPersonID = e.employeeid;


-- 2. Mostrar los productos que sean ruedas
-- Tablas: Product, ProductSubcategory
-- Campos: Name, ProductSubcategoryID
SELECT p.Name, p.ProductSubcategoryID, ps.Name AS subcategory
FROM product p 
INNER JOIN productsubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE ps.Name = "wheels";

-- ---------------------------------------------
-- SOLUCION --> lo desarrolle bien, me falto incluir el nombre de la subcategoria y en vez de LIKE ocorrespondia =.
-- SELECT p.Name, p.ProductSubcategoryID, ps.Name AS Subcategory FROM product p
-- INNER JOIN productsubcategory ps USING(ProductSubcategoryID)
-- WHERE ps.Name = 'Wheels';

-- 3. Mostrar los nombres de los productos que no son bicicletas
-- Tablas: Product, ProductSubcategory
-- Campos: Name, ProductSubcategoryID
SELECT p.Name, p.ProductSubcategoryID, ps.Name AS subcategory
FROM product p 
INNER JOIN productsubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE ps.Name NOT LIKE "%Bike%";
-- ---------------------------------------------
-- SOLUCION --> bien, pero debo usar NOT LIKE.
-- SELECT p.Name, p.ProductSubcategoryID, ps.Name AS Subcategory FROM product p
-- INNER JOIN productsubcategory ps ON p.ProductSubcategoryID = ps.ProductSubcategoryID 
-- WHERE ps.Name NOT LIKE '%Bike%';
