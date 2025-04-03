-- Realiza las siguientes consultas en SQL relacionadas con el sistema de alquiler de películas:
-- 1. Encuentra el cliente que ha realizado la mayor cantidad de alquileres en los últimos 6 meses.

SELECT a.id_cliente,  COUNT(a.id_alquiler) AS total_alquileres FROM alquiler a
GROUP BY a.id_cliente 
ORDER BY COUNT(a.id_alquiler) DESC;

-- 2. Lista las cinco películas más alquiladas durante el último año.
SELECT p.titulo, COUNT(a.id_alquiler) as total_alquileres FROM inventario i
INNER JOIN alquiler a ON a.id_inventario = i.id_inventario
INNER JOIN pelicula p ON i.id_pelicula  = p.id_pelicula 
group by p.titulo
ORDER BY COUNT(a.id_alquiler) DESC
LIMIT 5;

-- 3. Obtén el total de ingresos y la cantidad de alquileres realizados por cada categoría de
-- película.

SELECT c.nombre, SUM(p.total) AS total_ingresos, COUNT(a.id_alquiler) AS cantidad_alquileres  FROM pago p
INNER JOIN alquiler a ON p.id_alquiler = a.id_alquiler 
INNER JOIN inventario i ON i.id_inventario = a.id_inventario 
INNER JOIN pelicula p2 ON p2.id_pelicula = i.id_pelicula 
INNER JOIN pelicula_categoria pc  ON pc.id_pelicula = p2.id_pelicula 
INNER JOIN categoria c  ON c.id_categoria = pc.id_categoria 
GROUP BY c.nombre ;


-- 4. Calcula el número total de clientes que han realizado alquileres por cada idioma disponible
-- en un mes específico.

SELECT id.nombre, COUNT(c.id_cliente)  AS alquiler_por_idioma  FROM cliente c 
INNER JOIN alquiler a ON c.id_cliente = a.id_cliente 
INNER JOIN inventario i ON a.id_inventario = i.id_inventario 
INNER JOIN pelicula p ON p.id_pelicula = i.id_pelicula 
INNER JOIN idioma id ON id.id_idioma = p.id_idioma 
GROUP BY (id.nombre);

-- 5. Encuentra a los clientes que han alquilado todas las películas de una misma categoría.
-- 6. Lista las tres ciudades con más clientes activos en el último trimestre.
-- 7. Muestra las cinco categorías con menos alquileres registrados en el último año.
-- 8. Calcula el promedio de días que un cliente tarda en devolver las películas alquiladas.
-- 9. Encuentra los cinco empleados que gestionaron más alquileres en la categoría de Acción.
-- 10. Genera un informe de los clientes con alquileres más recurrentes.
-- 11. Calcula el costo promedio de alquiler por idioma de las películas.
-- 12. Lista las cinco películas con mayor duración alquiladas en el último año.
-- 13. Muestra los clientes que más alquilaron películas de Comedia.
-- 14. Encuentra la cantidad total de días alquilados por cada cliente en el último mes.
-- 15. Muestra el número de alquileres diarios en cada almacén durante el último trimestre.
-- 16. Calcula los ingresos totales generados por cada almacén en el último semestre.
-- 17. Encuentra el cliente que ha realizado el alquiler más caro en el último año.
-- 18. Lista las cinco categorías con más ingresos generados durante los últimos tres meses.
-- 19. Obtén la cantidad de películas alquiladas por cada idioma en el último mes.
-- 20. Lista los clientes que no han realizado ningún alquiler en el último año.
