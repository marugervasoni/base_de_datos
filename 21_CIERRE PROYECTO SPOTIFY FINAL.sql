-- CLASE 21: CIERRE DE PROYECTO SPOTIFY

-- Responder las siguientes preguntas---------------------------------------------------------------------------------
-- 1. ¿Cuál es la diferencia entre LEFT y RIGHT JOIN?
-- --RESPUESTA:
-- Los registros que trae en la consulta, LEFT incluirá registros de la 1er y 2da tabla aunque los registros de la 2da tabla
--  no se crucen entre si. RIGHT hará lo mismo pero trayendo aquellos registros de la 1er tabla y la segunda aunque no se crucen 
-- entre si. JOIN traera solamente aquellos registros de la 1er y 2da tabla que si se crucen, y solo esos.
   
-- 2. ¿Cuál es el orden en el que se procesan las queries SELECT, FROM, WHERE,
-- GROUP BY, HAVING y ORDER BY? 
-- RESPUESTA:
-- 1) FROM, 2) WHERE, 3) GROUP BY, 4) HAVING, 5) SELECT, 6) ORDER BY.

-- 3. ¿Qué función podríamos utilizar si quisiéramos traer el promedio de likes de
-- todas las canciones?
-- RESPUESTA:
-- Función AVG --> SELECT AVG(likes) FROM cancion;

-- 4. Si tenemos una query que trae un listado ordenado por el ID de usuarios la cual
-- cuenta con un LIMIT 20 OFFSET 27, ¿cuál sería el primer ID de los registros y cuál
-- el último?
-- RESPUESTA:
-- comenzaria desde el id 28 Y Finalizaria con los registros correspondientes al id 47


-- 5. ¿Por qué no se recomienda utilizar en exceso DISTINCT, ORDER BY y GROUP BY?
-- RESPUESTA: 
-- porque consumen muchos recursos


-- Realizar los siguientes informes------------------------------------------------------------------------------------
-- 1. Mostrar la cantidad de canciones que pertenecen a ambos géneros pop y rock
-- cuyo nombre contiene la letra “m”.
SELECT c.idCancion Cantidad, g.Genero genero
FROM cancion c
INNER JOIN generoxcancion gc ON c.IdCancion = gc.IdCancion
INNER JOIN genero g ON g.idGenero = gc.idGenero
WHERE (g.idGenero = 9 or g.idGenero = 11) AND c.titulo LIKE "%m%"
GROUP BY g.idGenero;

-- 2. Listar todas las canciones que pertenezcan a más de una playlist. Incluir en el
-- listado el nombre de la canción, el código y a cuántas playlists pertenecen.
SELECT c.titulo nombre, c.IdCancion codigo, COUNT(pc.IdPlaylist) Cantidad_playlist
FROM cancion c
INNER JOIN playlistxcancion pc ON c.IdCancion = pc.IdCancion
GROUP BY c.IdCancion
HAVING COUNT(pc.IdPlaylist) > 1;
-- 12 rows

-- 3. Generar un reporte con el nombre del artista y el nombre de la canción que no
-- pertenecen a ninguna lista, ordenados alfabéticamente por el nombre del
-- artista.
SELECT a.nombre nombre_artista, c.titulo nombre_cancion
FROM cancion c
LEFT JOIN playlistxcancion pc on pc.Idcancion = c.idCancion
LEFT JOIN playlist p on pc.IdPlaylist = p.idPlaylist
LEFT JOIN album al on al.idAlbum = c.IdAlbum
LEFT JOIN artista a on a.idArtista = al.idArtista
GROUP BY c.titulo, a.Nombre
HAVING COUNT(p.idPlaylist) = 0 OR COUNT(p.idPlaylist) IS NULL
ORDER BY nombre_artista;
-- 94 rows

-- 4. Modificar el país de todos los usuarios con el código postal “7600” a “Argentina”.
UPDATE usuario 
SET pais_idPais = 1
WHERE CP = "7600";

-- 5. Listar todos los álbumes que tengan alguna canción que posea más de un
-- género.
SELECT a.idAlbum Album, c.titulo Cancion, count(g.idGenero) Generos 
FROM album a
INNER JOIN cancion c on c.IdAlbum = a.idAlbum
INNER JOIN generoxcancion gc on gc.IdCancion = c.idCancion
INNER JOIN genero g ON g.idGenero = gc.IdGenero
GROUP BY a.idAlbum, c.titulo
HAVING Generos > 1;

-- 6. Crear un índice agrupado para las canciones cuyo identificador sea el ID
CREATE INDEX idx_canciones on cancion (idCancion);