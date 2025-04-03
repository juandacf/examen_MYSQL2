-- 1. TotalIngresosCliente(ClienteID, Año): Calcula los ingresos generados por un cliente en un
-- año específico.

DELIMITER $$
CREATE FUNCTION TotalIngresosCliente(
	ClienteID SMALLINT,
	AÑO       YEAR
)
RETURNS INTEGER 
DETERMINISTIC 

BEGIN 
DECLARE total_ingresos;

SELECT SUM(p.total) INTO total_ingresos FROM  pago p  
INNER JOIN cliente c ON c.id_cliente = p.id_cliente 
GROUP BY p.id_cliente 
HAVING p.id_cliente = ClienteID
AND  p.fecha_pago > AÑO;


RETURN total_ingresos;

END $$

DELIMITER ;
-- 2. PromedioDuracionAlquiler(PeliculaID): Retorna la duración promedio de alquiler de una
-- película específica.
-- 3. IngresosPorCategoria(CategoriaID): Calcula los ingresos totales generados por una
-- categoría específica de películas.4. DescuentoFrecuenciaCliente(ClienteID): Calcula un descuento --- basado en la frecuencia de
-- alquiler del cliente.
--5. EsClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en la cantidad de alquileres
--realizados y los ingresos generados.
