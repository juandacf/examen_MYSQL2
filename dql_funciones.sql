-- 1. TotalIngresosCliente(ClienteID, Año): Calcula los ingresos generados por un cliente en un año específico.
DELIMITER $$

CREATE FUNCTION TotalIngresosCliente(ClienteID SMALLINT, Año YEAR)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_ingresos DECIMAL(10, 2);
    
    SELECT SUM(p.total) INTO total_ingresos
    FROM pago p
    JOIN alquiler a ON p.id_alquiler = a.id_alquiler
    WHERE a.id_cliente = ClienteID
    AND YEAR(a.fecha_alquiler) = Año;
    
    RETURN total_ingresos;
END$$

DELIMITER ;

-- 2. PromedioDuracionAlquiler(PeliculaID): Retorna la duración promedio de alquiler de una película específica.

DELIMITER $$

CREATE FUNCTION PromedioDuracionAlquiler(PeliculaID SMALLINT)
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    DECLARE promedio_duracion DECIMAL(5, 2);
    
    SELECT AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) INTO promedio_duracion
    FROM alquiler a
    JOIN inventario i ON a.id_inventario = i.id_inventario
    WHERE i.id_pelicula = PeliculaID
    AND a.fecha_devolucion IS NOT NULL;
    
    RETURN promedio_duracion;
END$$

DELIMITER ;

-- 3. IngresosPorCategoria(CategoriaID): Calcula los ingresos totales generados por una  categoría específica de películas.

DELIMITER $$

CREATE FUNCTION IngresosPorCategoria(CategoriaID TINYINT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total_ingresos DECIMAL(10, 2);
    
    SELECT SUM(p.total) INTO total_ingresos
    FROM pago p
    JOIN alquiler a ON p.id_alquiler = a.id_alquiler
    JOIN inventario i ON a.id_inventario = i.id_inventario
    JOIN pelicula p2 ON i.id_pelicula = p2.id_pelicula
    JOIN pelicula_categoria pc ON p2.id_pelicula = pc.id_pelicula
    WHERE pc.id_categoria = CategoriaID;
    
    RETURN total_ingresos;
END$$

DELIMITER ;

--4. DescuentoFrecuenciaCliente(ClienteID): Calcula un descuento --- basado en la frecuencia de alquiler del cliente.
DELIMITER $$

CREATE FUNCTION DescuentoFrecuenciaCliente(ClienteID SMALLINT)
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    DECLARE cantidad_alquileres INT;
    DECLARE descuento DECIMAL(5, 2);

    SELECT COUNT(a.id_alquiler) INTO cantidad_alquileres
    FROM alquiler a
    WHERE a.id_cliente = ClienteID;
    
  
    IF cantidad_alquileres >= 20 THEN
        SET descuento = 0.20; 
    ELSEIF cantidad_alquileres >= 10 THEN
        SET descuento = 0.10; 
    ELSE
        SET descuento = 0.05; 
    END IF;
    
    RETURN descuento;
END$$

DELIMITER ;

--5. EsClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en la cantidad de alquileresb realizados y los ingresos generados.

DELIMITER $$

CREATE FUNCTION EsClienteVIP(ClienteID SMALLINT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE cantidad_alquileres INT;
    DECLARE total_ingresos DECIMAL(10, 2);
    DECLARE es_vip BOOLEAN;
    

    SELECT COUNT(a.id_alquiler) INTO cantidad_alquileres
    FROM alquiler a
    WHERE a.id_cliente = ClienteID;
    

    SELECT SUM(p.total) INTO total_ingresos
    FROM pago p
    JOIN alquiler a ON p.id_alquiler = a.id_alquiler
    WHERE a.id_cliente = ClienteID;

    IF cantidad_alquileres > 15 AND total_ingresos > 500 THEN
        SET es_vip = TRUE;
    ELSE
        SET es_vip = FALSE;
    END IF;
    
    RETURN es_vip;
END$$

DELIMITER ;

