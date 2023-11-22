use movies_database;


# Query: ¿En qué año se estrenaron más pelis? 

SELECT anio_estreno, COUNT(*) as cantidad_peliculas
	FROM movies_database.peliculas
	WHERE tipo = 'movie'
	GROUP BY anio_estreno
	ORDER BY cantidad_peliculas DESC
	LIMIT 1;


# Query 2: ¿En qué año se estrenaron más cortos?

SELECT anio_estreno, COUNT(*) as cantidad_cortos
	FROM movies_database.peliculas
	WHERE tipo = 'short'
	GROUP BY anio_estreno
	ORDER BY cantidad_cortos DESC
	LIMIT 1;


-- BONUS

# Query 3: Lista de estrenos por año de más a menos

SELECT anio_estreno, COUNT(*) as cantidad_peliculas
	FROM movies_database.peliculas
	WHERE tipo = 'movie'
	GROUP BY anio_estreno
	ORDER BY cantidad_peliculas DESC;


# Query 4: ¿Cuántas pelis de cada género se han estrenado cada año?

SELECT anio_estreno,
       SUM(genero = 'drama') AS drama,
       SUM(genero = 'fantasy') AS fantasy,
       SUM(genero = 'action') AS action,
       SUM(genero = 'horror') AS horror,
       SUM(genero = 'thriller') AS thriller,
       SUM(genero = 'comedy') AS comedy,
       SUM(genero = 'romance') AS romance,
       SUM(genero = 'mystery') AS mystery
FROM movies_database.peliculas
WHERE tipo = 'movie'
GROUP BY anio_estreno
ORDER BY anio_estreno;




# Query 5: Mejoremos la query anterior. ¿Cual ha sido el total de pelis por año?

SELECT anio_estreno,
       SUM(genero = 'drama') AS drama,
       SUM(genero = 'fantasy') AS fantasy,
       SUM(genero = 'action') AS action,
       SUM(genero = 'horror') AS horror,
       SUM(genero = 'thriller') AS thriller,
       SUM(genero = 'comedy') AS comedy,
       SUM(genero = 'romance') AS romance,
       SUM(genero = 'mystery') AS mystery,
       COUNT(*) AS total_por_año
FROM movies_database.peliculas
WHERE tipo = 'movie'
GROUP BY anio_estreno
ORDER BY anio_estreno DESC;


# Query 6: Mejoremos la query 4. ¿Cual ha sido el total de pelis por género?
-- Por curiosidad nuestra,yo esta no la pondría porque se ve la descompensación de los porcentajes

SELECT  genero, COUNT(*) AS total_por_genero
	FROM movies_database.peliculas
	WHERE tipo = 'movie'
	GROUP BY genero;



USE movies_database;

## 1. Oscars por géneros##

SELECT `peliculas`. `genero`, COUNT(`oscars`.`mejor_pelicula`) AS `oscars_por_generos` 
	FROM `peliculas`
    JOIN  `oscars`
	  ON `peliculas`. `id_pelicula`= `oscars`. `id_pelicula`
	WHERE
    `peliculas`.`genero` IN ('Drama', 'Comedy', 'Action', 'Fantasy', 'Horror', 'Mystery', 'Romance', 'Thriller')
 GROUP BY
    `peliculas`.`genero`;     

## 2. Mes más común de estreno por géneros.

## Esta primera me dice qué género estrena más según el género pero me da el resultado del mes como NULL

SELECT 
    MONTH(mes_estreno) AS Mes, 
    COUNT(*) AS Cantidad,  
    Genero
FROM 
    Peliculas
WHERE 
    Genero IN ('Drama', 'Comedy', 'Action', 'Fantasy', 'Horror', 'Mystery', 'Romance', 'Thriller')
GROUP BY 
    MONTH(mes_estreno), Genero
ORDER BY 
    Cantidad DESC, Mes, Genero;
    
## Esta segunda es la válida porque me da la cantidad de películas relacionadas con el mes y el género.

WITH ranked_genres AS (
    SELECT
        `genero`,
        `mes_estreno`,
        COUNT(*) AS `cantidad_peliculas_en_mes_y_genero`,
        ROW_NUMBER() OVER (PARTITION BY `genero` ORDER BY COUNT(*) DESC) AS row_num
    FROM
        `peliculas`
    WHERE
        `genero` IN ('Drama', 'Comedy', 'Action', 'Fantasy', 'Horror', 'Mystery', 'Romance', 'Thriller')
    GROUP BY
        `genero`,
        `mes_estreno`
)
SELECT
    `genero`,
    `mes_estreno`,
    `cantidad_peliculas_en_mes_y_genero`
FROM
    ranked_genres
WHERE
    row_num = 1
ORDER BY
    `genero`;
    
##2.b. Month top de estreno y qué género es el que triunfa.
  
WITH ranked_genres AS (
    SELECT
        `genero`,
        `mes_estreno`,
        COUNT(*) AS `cantidad_peliculas_en_mes_y_genero`,
        ROW_NUMBER() OVER (PARTITION BY `genero` ORDER BY COUNT(*) DESC) AS row_num
    FROM
        `peliculas`
    WHERE
        `genero` IN ('Drama', 'Comedy', 'Action', 'Fantasy', 'Horror', 'Mystery', 'Romance', 'Thriller')
    GROUP BY
        `genero`,
        `mes_estreno`
)
, total_ranked AS (
    SELECT
        `mes_estreno`,
        `genero`,
        `cantidad_peliculas_en_mes_y_genero`,
        ROW_NUMBER() OVER (ORDER BY SUM(`cantidad_peliculas_en_mes_y_genero`) DESC) AS row_num_total
    FROM
        ranked_genres
    WHERE
        row_num = 1
    GROUP BY
        `mes_estreno`,
        `genero`
)
SELECT
    `mes_estreno`,
    `genero`,
    `cantidad_peliculas_en_mes_y_genero`
FROM
    total_ranked
WHERE
    row_num_total = 1;

##4 Duración de las películas por décadas.  

SELECT
    CASE
        WHEN `peliculas`.`anio_estreno` BETWEEN 1990 AND 1999 THEN '1990-1999'
        WHEN `peliculas`.`anio_estreno` BETWEEN 2000 AND 2009 THEN '2000-2009'
        WHEN `peliculas`.`anio_estreno` BETWEEN 2010 AND 2019 THEN '2010-2019'
        WHEN `peliculas`.`anio_estreno` BETWEEN 2020 AND 2023 THEN '2020-2023'
        ELSE 'Otro'
    END AS `decada`,
    AVG(`imdb`.`duracion`) AS `media_duracion`
FROM
    `peliculas`
INNER JOIN
    `imdb` ON `imdb`.`peliculas_id_pelicula` = `peliculas`.`id_pelicula`
WHERE
    `imdb`.`duracion` > 0
    AND (`peliculas`.`anio_estreno` BETWEEN 1990 AND 1999
        OR `peliculas`.`anio_estreno` BETWEEN 2000 AND 2009
        OR `peliculas`.`anio_estreno` BETWEEN 2010 AND 2019
        OR `peliculas`.`anio_estreno` BETWEEN 2020 AND 2023)
GROUP BY
    `decada`
ORDER BY
    `media_duracion` DESC;  

-- ¿Qué actor/actriz ha hecho más pelis? De esos, ¿cuál ha ganado más Oscars?
USE movies_database;

-- -------------------------------------------------------
-- Pelis en distintas tablas 
-- -------------------------------------------------------
-- En tabla películas: 89,685 - Sin el distinct es la misma cifra ya que eliminamos las pelis duplicadas cdo insertamos datos
SELECT COUNT(distinct id_pelicula)
FROM peliculas;

-- En tabla imdb: 8,226 -- Si quitasemos el "distinct" aparecen 9,021 -hay duplicados
SELECT COUNT(distinct peliculas_id_pelicula)
FROM imdb;
-- Sale lo mismo
SELECT COUNT(distinct peliculas_id_pelicula)
from imdb as i
left join peliculas as p ON i.peliculas_id_pelicula = p.id_pelicula
where peliculas_id_pelicula is not null;

-- En tabla actores - 2,232 pelis (tenemos 22,402 registros en tabla actores)
SELECT COUNT(distinct peliculas_id_pelicula)
FROM actor;

-- En tabla oscars - 34 pelis
SELECT COUNT(distinct id_pelicula)
FROM oscars;


-- -------------------------------------------------------
-- Nro. de actores en BDD
-- -------------------------------------------------------
-- Actores (únicos) -- 16,352 actores
SELECT COUNT(distinct nombre_actor) AS "N. de actores"
FROM actor
where nombre_actor is not null;

-- Actores que han actuado en más de una peli - 1,726
SELECT nombre_actor, COUNT(peliculas_id_pelicula) as "nro_pelis"
FROM actor
where nombre_actor is not null
group by nombre_actor
having COUNT(peliculas_id_pelicula) > 1
ORDER BY nro_pelis DESC;

-- los 10 actores mas populares -- y ninguno es mujer
SELECT nombre_actor, COUNT(peliculas_id_pelicula) as "nro_pelis"
FROM actor
where nombre_actor is not null
group by nombre_actor
having COUNT(peliculas_id_pelicula) > 1
ORDER BY nro_pelis DESC
LIMIT 20;
-- Brian Cox, Lou Diamond Philipis, Christopher Plummer - Quién los conoce?

-- Ganó alguno de los 20 más populares, un oscar? -- De los 20 más pulares, 6 han ganado óscars (1 ó 2 oscars)
SELECT nombre_actor, COUNT(peliculas_id_pelicula) as "nro_pelis", premios
FROM actor
where nombre_actor is not null
group by nombre_actor, premios
having COUNT(peliculas_id_pelicula) > 1
ORDER BY nro_pelis DESC
LIMIT 20;

-- Edas media de los actores que han ganado al menos 1 óscar: 66 años (cogiendo 19 años como edad límite)
WITH tabla2 as (with tabla as (SELECT nombre_actor, 2023 - nacimiento AS "edad", COUNT(peliculas_id_pelicula) as "nro_pelis", premios
FROM actor
where nombre_actor is not null
group by nombre_actor, premios, edad
having premios >= 1
ORDER BY nro_pelis DESC)
SELECT nombre_actor, edad, nro_pelis, premioS
from tabla
where edad BETWEEN 15 AND 95)
SELECT AVG(edad)
from tabla2;

-- 2 o más óscar:72 años
WITH tabla2 as (with tabla as (SELECT nombre_actor, 2023 - nacimiento AS "edad", COUNT(peliculas_id_pelicula) as "nro_pelis", premios
FROM actor
where nombre_actor is not null
group by nombre_actor, premios, edad
having premios >= 2
ORDER BY nro_pelis DESC)
SELECT nombre_actor, edad, nro_pelis, premioS
from tabla
where edad BETWEEN 15 AND 95)
SELECT AVG(edad)
from tabla2;

-- 3 o más óscar 82 años
WITH tabla2 as (with tabla as (SELECT nombre_actor, 2023 - nacimiento AS "edad", COUNT(peliculas_id_pelicula) as "nro_pelis", premios
FROM actor
where nombre_actor is not null
group by nombre_actor, premios, edad
having premios >= 3
ORDER BY nro_pelis DESC)
SELECT nombre_actor, edad, nro_pelis, premioS
from tabla
where edad BETWEEN 15 AND 95)
SELECT AVG(edad)
from tabla2;

-- Los 3 más jóvenes que han ganado algún óscar - tienen entre 31 y 35 años y 2 son mujeres - La industria del cine está cambiando
with tabla as (SELECT nombre_actor, 2023 - nacimiento AS "edad", COUNT(peliculas_id_pelicula) as "nro_pelis", premios
FROM actor
where nombre_actor is not null
group by nombre_actor, premios, edad
having premios >= 1
ORDER BY nro_pelis DESC)
SELECT nombre_actor, edad, nro_pelis, premioS
from tabla
where edad BETWEEN 15 AND 95
order by edad ASC
LIMIT 3;


-- Media de puntuación por géneros (tomatomter e imdb) 

-- IMDB 

SELECT peliculas.genero, AVG(imdb.puntuacion) AS promedio_puntuacion
FROM peliculas
LEFT JOIN imdb ON peliculas.id_pelicula = imdb.peliculas_id_pelicula
WHERE imdb.puntuacion IS NOT NULL AND imdb.puntuacion > 0 AND imdb.puntuacion <= 5
GROUP BY peliculas.genero;

-- TOMATOMETER 

SELECT peliculas.genero, AVG(imdb.tomatometer) AS promedio_puntuacion
FROM peliculas
LEFT JOIN imdb ON peliculas.id_pelicula = imdb.peliculas_id_pelicula
WHERE imdb.tomatometer IS NOT NULL AND imdb.tomatometer > 0 
GROUP BY peliculas.genero;


