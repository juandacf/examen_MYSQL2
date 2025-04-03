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
SELECT c.id_cliente, c.nombre, c.apellidos
FROM cliente c
WHERE NOT EXISTS (
    SELECT 1
    FROM pelicula_categoria pc
    WHERE pc.id_categoria = 1 -- Cambia el ID de categoría para diferentes categorías
    AND NOT EXISTS (
        SELECT 1
        FROM alquiler a
        JOIN inventario i ON a.id_inventario = i.id_inventario
        WHERE a.id_cliente = c.id_cliente
        AND i.id_pelicula = pc.id_pelicula
    )
);

-- 6. Lista las tres ciudades con más clientes activos en el último trimestre.
SELECT ci.nombre, COUNT(cl.id_cliente) AS clientes_activos
FROM ciudad ci
JOIN direccion d ON ci.id_ciudad = d.id_ciudad
JOIN cliente cl ON d.id_direccion = cl.id_direccion
WHERE cl.activo = 1
AND cl.fecha_creacion >= CURDATE() - INTERVAL 3 MONTH
GROUP BY ci.nombre
ORDER BY clientes_activos DESC
LIMIT 3;

-- 7. Muestra las cinco categorías con menos alquileres registrados en el último año.
SELECT ca.nombre, COUNT(a.id_alquiler) AS alquileres
FROM categoria ca
LEFT JOIN pelicula_categoria pc ON ca.id_categoria = pc.id_categoria
LEFT JOIN pelicula p ON pc.id_pelicula = p.id_pelicula
LEFT JOIN inventario i ON p.id_pelicula = i.id_pelicula
LEFT JOIN alquiler a ON i.id_inventario = a.id_inventario
WHERE a.fecha_alquiler >= CURDATE() - INTERVAL 1 YEAR
GROUP BY ca.nombre
ORDER BY alquileres ASC
LIMIT 5;

-- 8. Calcula el promedio de días que un cliente tarda en devolver las películas alquiladas.
SELECT AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS promedio_dias
FROM alquiler a
WHERE a.fecha_devolucion IS NOT NULL;

-- 9. Encuentra los cinco empleados que gestionaron más alquileres en la categoría de Acción.
SELECT e.nombre, e.apellidos, COUNT(a.id_alquiler) AS alquileres
FROM empleado e
JOIN alquiler a ON e.id_empleado = a.id_empleado
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
WHERE pc.id_categoria = 1 -- Cambia el ID de categoría para la categoría Acción
GROUP BY e.id_empleado
ORDER BY alquileres DESC
LIMIT 5;

-- 10. Genera un informe de los clientes con alquileres más recurrentes.
SELECT cl.id_cliente, cl.nombre, cl.apellidos, COUNT(a.id_alquiler) AS cantidad_alquileres
FROM cliente cl
JOIN alquiler a ON cl.id_cliente = a.id_cliente
GROUP BY cl.id_cliente
ORDER BY cantidad_alquileres DESC;

-- 11. Calcula el costo promedio de alquiler por idioma de las películas.
SELECT i.nombre, AVG(p.rental_rate) AS costo_promedio
FROM idioma i
JOIN pelicula p ON i.id_idioma = p.id_idioma
GROUP BY i.id_idioma;

-- 12. Lista las cinco películas con mayor duración alquiladas en el último año.
SELECT p.titulo, p.duracion, COUNT(a.id_alquiler) AS cantidad_alquileres
FROM pelicula p
JOIN inventario i ON p.id_pelicula = i.id_pelicula
JOIN alquiler a ON i.id_inventario = a.id_inventario
WHERE a.fecha_alquiler >= CURDATE() - INTERVAL 1 YEAR
GROUP BY p.id_pelicula
ORDER BY p.duracion DESC
LIMIT 5;

-- 13. Muestra los clientes que más alquilaron películas de Comedia.
SELECT cl.id_cliente, cl.nombre, cl.apellidos, COUNT(a.id_alquiler) AS cantidad_alquileres
FROM cliente cl
JOIN alquiler a ON cl.id_cliente = a.id_cliente
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
WHERE pc.id_categoria = 2 
GROUP BY cl.id_cliente
ORDER BY cantidad_alquileres DESC;

-- 14. Encuentra la cantidad total de días alquilados por cada cliente en el último mes.
SELECT cl.id_cliente, cl.nombre, cl.apellidos, SUM(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS total_dias_alquilados
FROM cliente cl
JOIN alquiler a ON cl.id_cliente = a.id_cliente
WHERE a.fecha_alquiler >= CURDATE() - INTERVAL 1 MONTH
AND a.fecha_devolucion IS NOT NULL
GROUP BY cl.id_cliente;

-- 15. Muestra el número de alquileres diarios en cada almacén durante el último trimestre.
SELECT al.id_almacen, COUNT(a.id_alquiler) AS alquileres_diarios
FROM almacen al
JOIN alquiler a ON al.id_almacen = a.id_empleado
WHERE a.fecha_alquiler >= CURDATE() - INTERVAL 3 MONTH
GROUP BY al.id_almacen, DATE(a.fecha_alquiler);

-- 16. Calcula los ingresos totales generados por cada almacén en el último semestre.
SELECT al.id_almacen, SUM(p.total) AS ingresos_totales
FROM almacen al
JOIN alquiler a ON al.id_almacen = a.id_empleado
JOIN pago p ON a.id_alquiler = p.id_alquiler
WHERE p.fecha_pago >= CURDATE() - INTERVAL 6 MONTH
GROUP BY al.id_almacen;

-- 17. Encuentra el cliente que ha realizado el alquiler más caro en el último año.
SELECT cl.id_cliente, cl.nombre, cl.apellidos, MAX(p.total) AS alquiler_mas_caro
FROM cliente cl
JOIN alquiler a ON cl.id_cliente = a.id_cliente
JOIN pago p ON a.id_alquiler = p.id_alquiler
WHERE p.fecha_pago >= CURDATE() - INTERVAL 1 YEAR
GROUP BY cl.id_cliente
ORDER BY alquiler_mas_caro DESC
LIMIT 1;

-- 18. Lista las cinco categorías con más ingresos generados durante los últimos tres meses.
SELECT ca.nombre, SUM(p.total) AS ingresos_generados
FROM categoria ca
JOIN pelicula_categoria pc ON ca.id_categoria = pc.id_categoria
JOIN pelicula p ON pc.id_pelicula = p.id_pelicula
JOIN inventario i ON p.id_pelicula = i.id_pelicula
JOIN alquiler a ON i.id_inventario = a.id_inventario
JOIN pago p ON a.id_alquiler = p.id_alquiler
WHERE p.fecha_pago >= CURDATE() - INTERVAL 3 MONTH
GROUP BY ca.id_categoria
ORDER BY ingresos_generados DESC
LIMIT 5;

-- 19. Obtén la cantidad de películas alquiladas por cada idioma en el último mes.
SELECT i.nombre, COUNT(a.id_alquiler) AS cantidad_alquilada
FROM idioma i
JOIN pelicula p ON i.id_idioma = p.id_idioma
JOIN inventario i2 ON p.id_pelicula = i2.id_pelicula
JOIN alquiler a ON i2.id_inventario = a.id_inventario
WHERE a.fecha_alquiler >= CURDATE() - INTERVAL 1 MONTH
GROUP BY i.id_idioma;

-- 20. Lista los clientes que no han realizado ningún alquiler en el último año.
SELECT cl.id_cliente, cl.nombre, cl.apellidos
FROM cliente cl
LEFT JOIN alquiler a ON cl.id_cliente = a.id_cliente
WHERE a.id_alquiler IS NULL
OR a.fecha_alquiler < CURDATE() - INTERVAL 1 YEAR;


