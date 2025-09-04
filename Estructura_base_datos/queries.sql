## consultas:

###  Listar los productos con stock menor a 5 unidades.


SELECT id, nombre as producto_casi_acabandose, stock
FROM productos
WHERE stock < 5;


###  Calcular ventas totales de un mes específico.


SELECT SUM(v.cantidad * v.precio_unitario) AS ventas_totales 
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
WHERE  EXTRACT(YEAR FROM v.fecha) = 2025 AND EXTRACT(MONTH FROM v.fecha) = 8 
LIMIT 5


###  Obtener el cliente con más compras realizadas.


SELECT c.nombre, COUNT(v.id) as numero_ventas
FROM clientes c
JOIN ventas v ON v.cliente_id = c.id
GROUP BY c.id, c.nombre
ORDER BY numero_ventas DESC
LIMIT 1;


###  Listar los 5 productos más vendidos.


SELECT 
    p.nombre AS producto,
    COALESCE(SUM(vd.cantidad), 0) AS cantidad_vendida
FROM productos p
LEFT JOIN ventas_detalle vd ON vd.producto_id = p.id
GROUP BY p.id, p.nombre
ORDER BY cantidad_vendida DESC
LIMIT 15;


### Consultar ventas realizadas en un rango de fechas de tres Días y un Mes.

SELECT SUM(vd.cantidad * vd.precio_unitario) AS ventas_totales
FROM ventas v
JOIN ventas_detalle vd ON vd.venta_id = v.id
WHERE v.fecha::date BETWEEN CURRENT_DATE - INTERVAL '1 month'AND CURRENT_DATE - INTERVAL '3 days';


###  Identificar clientes que no han comprado en los últimos 6 meses.


SELECT c.nombre AS cliente_nocompra_hace_6meses
FROM clientes c
LEFT JOIN ventas v ON v.cliente_id = c.id AND v.fecha >= CURRENT_DATE - INTERVAL '6 months'
WHERE v.id IS NULL;

