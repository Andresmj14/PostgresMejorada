# Examen de PostgresSQL

La tienda **TechZone** es un negocio dedicado a la venta de productos tecnológicos, desde laptops y teléfonos hasta accesorios y componentes electrónicos. Con el crecimiento del comercio digital y la alta demanda de dispositivos electrónicos, la empresa ha notado la necesidad de mejorar la gestión de su inventario y ventas. Hasta ahora, han llevado el control de productos y transacciones en hojas de cálculo, lo que ha generado problemas como:

🔹 **Errores en el control de stock:** No saben con certeza qué productos están por agotarse, lo que ha llevado a problemas de desabastecimiento o acumulación innecesaria de productos en bodega.

🔹 **Dificultades en el seguimiento de ventas:** No cuentan con un sistema eficiente para analizar qué productos se venden más, en qué períodos del año hay mayor demanda o quiénes son sus clientes más frecuentes.

🔹 **Gestión manual de proveedores:** Los pedidos a proveedores se han realizado sin un historial claro de compras y ventas, dificultando la negociación de mejores precios y la planificación del abastecimiento.

🔹 **Falta de automatización en el registro de compras:** Cada vez que un cliente realiza una compra, los empleados deben registrar manualmente los productos vendidos y actualizar el inventario, lo que consume tiempo y es propenso a errores.

Para solucionar estos problemas, **TechZone** ha decidido implementar una base de datos en **PostgreSQL** que le permita gestionar de manera eficiente su inventario, las ventas, los clientes y los proveedores.

## **📋 Especificaciones del Sistema**

La empresa necesita un sistema que registre **todos los productos** disponibles en la tienda, clasificándolos por categoría y manteniendo un seguimiento de la cantidad en stock. Cada producto tiene un proveedor asignado, por lo que también es fundamental llevar un registro de los proveedores y los productos que suministran.

Cuando un cliente realiza una compra, el sistema debe registrar la venta y actualizar automáticamente el inventario, asegurando que no se vendan productos que ya están agotados. Además, la tienda quiere identificar **qué productos se venden más, qué clientes compran con mayor frecuencia y cuánto se ha generado en ventas en un período determinado**.



El nuevo sistema deberá cumplir con las siguientes funcionalidades:

​	1️⃣ **Registro de Productos:** Cada producto debe incluir su nombre, categoría, precio, stock disponible y proveedor.

​	2️⃣ **Registro de Clientes:** Se debe almacenar la información de cada cliente, incluyendo nombre, correo electrónico y número de teléfono.

​	3️⃣ **Registro de Ventas:** Cada venta debe incluir qué productos fueron vendidos, en qué cantidad y a qué cliente.

​	4️⃣ **Registro de Proveedores:** La tienda obtiene productos de diferentes proveedores, por lo que es necesario almacenar información sobre cada 	uno.

​	5️⃣ **Consultas avanzadas:** Se requiere la capacidad de analizar datos clave como productos más vendidos, ingresos por proveedor y clientes más 	frecuentes.

​	6️⃣ **Procedimiento almacenado con transacciones:** Para asegurar que no se vendan productos sin stock, el sistema debe validar la disponibilidad 	de inventario antes de completar una venta.

## tablas:

```postgresql
CREATE TABLE IF NOT EXISTS clientes (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  correo TEXT NOT NULL UNIQUE,
  telefono TEXT,
  estado TEXT NOT NULL DEFAULT 'activo' CHECK (estado IN ('activo','inactivo'))
);

CREATE TABLE IF NOT EXISTS proveedores (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS productos (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  categoria TEXT NOT NULL,
  precio NUMERIC(12,2) NOT NULL CHECK (precio >= 0),
  stock INTEGER NOT NULL CHECK (stock >= 0),
  proveedor_id INTEGER NOT NULL,
  FOREIGN KEY proveedor_id REFERENCES proveedores(id)
);

CREATE TABLE IF NOT EXISTS historial_precios (
  id BIGSERIAL PRIMARY KEY,
  producto_id INTEGER NOT NULL,
  precio_anterior NUMERIC(12,2) NOT NULL,
  precio_nuevo NUMERIC(12,2) NOT NULL,
  cambiado_en TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY producto_id REFERENCES productos(id)
);

CREATE TABLE IF NOT EXISTS alertas_stock (
  id BIGSERIAL PRIMARY KEY,
  producto_id INTEGER NOT NULL,
  nombre_producto TEXT NOT NULL,
  mensaje TEXT NOT NULL,
  generado_en TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY producto_id REFERENCES productos(id)
);

CREATE TABLE IF NOT EXISTS ventas (
  id SERIAL PRIMARY KEY,
  cliente_id INTEGER NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY cliente_id REFERENCES clientes(id)
);

CREATE TABLE IF NOT EXISTS ventas_detalle (
  id SERIAL PRIMARY KEY,
  venta_id INTEGER NOT NULL,
  producto_id INTEGER NOT NULL,
  cantidad INTEGER NOT NULL CHECK (cantidad > 0),
  precio_unitario NUMERIC(12,2) NOT NULL CHECK (precio_unitario >= 0),
  FOREIGN KEY venta_id REFERENCES ventas(id) ON DELETE CASCADE,
  FOREIGN KEY producto_id REFERENCES productos(id)
);

CREATE TABLE IF NOT EXISTS auditoria_ventas (
  id BIGSERIAL PRIMARY KEY,
  venta_id INTEGER NOT NULL,
  usuario TEXT CURRENT_USER NOT NULL,
  registrado_en TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY venta_id REFERENCES ventas(id) ON DELETE CASCADE
);
```

## inserts:

```postgresql
INSERT INTO clientes (nombre, correo, telefono, estado) VALUES
('Juan Pérez','juan.perez@example.com','555-111-1111','activo'),
('María Gómez','maria.gomez@example.com','555-222-2222','activo'),
('Carlos Ruiz','carlos.ruiz@example.com','555-333-3333','inactivo'),
('Ana López','ana.lopez@example.com','555-444-4444','activo'),
('Luis Torres','luis.torres@example.com','555-555-5555','activo'),
('Elena Rivas','elena.rivas@example.com','555-666-6666','activo'),
('Pedro Méndez','pedro.mendez@example.com','555-777-7777','activo'),
('Lucía Herrera','lucia.herrera@example.com','555-888-8888','inactivo'),
('Andrés Silva','andres.silva@example.com','555-999-9999','activo'),
('Carmen Díaz','carmen.diaz@example.com','555-123-4567','activo'),
('Raúl Castro','raul.castro@example.com','555-234-5678','activo'),
('Isabel Vega','isabel.vega@example.com','555-345-6789','activo'),
('Sofía Romero','sofia.romero@example.com','555-456-7890','inactivo'),
('Diego Navarro','diego.navarro@example.com','555-567-8901','activo'),
('Valeria Ortega','valeria.ortega@example.com','555-678-9012','activo');

INSERT INTO proveedores (nombre) VALUES
('Tech Distribution S.A.'),
('ElectroWorld Ltda.'),
('Innovatek Global'),
('MegaTech Solutions'),
('DigitalStore Corp'),
('HardwareXpress'),
('GamerZone Importaciones'),
('SmartTech Proveedores'),
('PC Componentes LATAM'),
('ElectroMart'),
('SupplyTech SAS'),
('Chip & Parts'),
('InfoMax Distribuciones'),
('Electronix Global'),
('NextGen Importadores');


INSERT INTO productos (nombre, categoria, precio, stock, proveedores_id) VALUES
('Laptop Gamer ASUS ROG', 'Computadores', 5200.00, 12, 1),
('iPhone 15 Pro', 'Celulares', 4800.00, 18, 2),
('Monitor LG 27" 4K', 'Monitores', 1600.00, 25, 3),
('Teclado Mecánico Logitech', 'Periféricos', 350.00, 60, 4),
('Mouse Gamer Razer', 'Periféricos', 220.00, 100, 5),
('Audífonos Sony WH-1000XM5', 'Audio', 1800.00, 30, 6),
('SSD NVMe 1TB Samsung', 'Almacenamiento', 750.00, 50, 7),
('Impresora HP LaserJet', 'Impresoras', 1200.00, 15, 8),
('Tablet Samsung Galaxy Tab', 'Tablets', 2100.00, 35, 9),
('Smartwatch Garmin Forerunner', 'Wearables', 1700.00, 20, 10),
('Placa Madre ASUS PRIME', 'Componentes', 900.00, 40, 11),
('Memoria RAM DDR5 32GB', 'Componentes', 650.00, 70, 12),
('Router Wi-Fi 6 TP-Link', 'Redes', 400.00, 45, 13),
('Tarjeta de Video RTX 4080', 'Componentes', 6200.00, 8, 14),
('Cámara Web Logitech 1080p', 'Periféricos', 280.00, 50, 15);


INSERT INTO historial_precios (producto_id, precio_anterior, precio_nuevo) VALUES
(1,800.00,850.00),
(2,14.00,15.50),
(3,50.00,45.00),
(4,190.00,200.00),
(5,110.00,120.00),
(6,260.00,250.00),
(7,600.00,650.00),
(8,170.00,180.00),
(9,70.00,75.00),
(10,55.00,60.00),
(11,100.00,95.00),
(12,50.00,45.00),
(13,125.00,130.00),
(14,480.00,500.00),
(15,30.00,25.00);

INSERT INTO alertas_stock (producto_id, nombre_producto, mensaje) VALUES
(1,'Laptop X','Stock bajo, quedan 10 unidades'),
(2,'Mouse Óptico','Stock suficiente'),
(3,'Teclado Mecánico','Stock adecuado'),
(4,'Monitor 24"','Revisar stock, menos de 20 unidades'),
(5,'Silla Ergonómica','Stock crítico, solo 15'),
(6,'Escritorio Gamer','Pocas unidades en stock'),
(7,'Teléfono Móvil','Stock moderado'),
(8,'Impresora Láser','Reabastecer pronto'),
(9,'Cámara Web','Stock en buen nivel'),
(10,'Audífonos Bluetooth','Bajo stock, menos de 30'),
(11,'Cafetera Automática','Revisar inventario'),
(12,'Ventilador','Stock normal'),
(13,'Microondas','Stock bajo, 10 restantes'),
(14,'Sofá 3 Plazas','Stock crítico: 3 piezas'),
(15,'Lámpara LED','Stock alto, no hay problema');

INSERT INTO ventas (cliente_id, fecha) VALUES
(1, '2025-09-01 10:15:00'),
(2, '2025-09-02 15:30:00'),
(3, '2025-09-03 11:20:00'),
(4, '2025-09-04 14:00:00'),
(5, '2025-09-05 09:45:00'),
(1, '2025-09-06 16:10:00'),
(2, '2025-09-07 13:25:00'),
(3, '2025-09-08 17:50:00'),
(4, '2025-09-09 19:15:00'),
(5, '2025-09-10 12:40:00'),
(1, '2025-09-11 10:30:00'),
(2, '2025-09-12 16:00:00'),
(3, '2025-09-13 18:25:00'),
(4, '2025-09-14 19:50:00'),
(5, '2025-09-15 09:10:00');


INSERT INTO ventas (cliente_id, fecha, cantidad, precio_unitario) VALUES
(1, '2025-09-01 10:15:00', 2, 220.00),
(2, '2025-09-02 15:30:00', 1, 4800.00),
(3, '2025-09-03 11:20:00', 3, 350.00),
(4, '2025-09-04 14:00:00', 1, 5200.00),
(5, '2025-09-05 09:45:00', 2, 2100.00),
(1, '2025-09-06 16:10:00', 1, 1600.00),
(2, '2025-09-07 13:25:00', 4, 220.00),
(3, '2025-09-08 17:50:00', 1, 1800.00),
(4, '2025-09-09 19:15:00', 5, 220.00),
(5, '2025-09-10 12:40:00', 1, 750.00),
(1, '2025-09-11 10:30:00', 2, 350.00),
(2, '2025-09-12 16:00:00', 1, 6200.00),
(3, '2025-09-13 18:25:00', 3, 650.00),
(4, '2025-09-14 19:50:00', 1, 1700.00),
(5, '2025-09-15 09:10:00', 1, 400.00);



INSERT INTO auditoria_ventas (venta_id) VALUES
(1),(2),(3),(4),(5),
(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15);

```



## modelo E-R

![](https://media.discordapp.net/attachments/1337463162940817490/1413187496409563167/image.png?ex=68bb04ea&is=68b9b36a&hm=00dba1955bc2e092b8ce3c3fcef38ae3b828ab645d6ac152155bd7282aed92bb&=&format=webp&quality=lossless)

## consultas:

###  Listar los productos con stock menor a 5 unidades.

```postgresql
SELECT id, nombre as producto_casi_acabandose, stock
FROM productos
WHERE stock < 5;
```

###  Calcular ventas totales de un mes específico.

```postgresql
SELECT SUM(v.cantidad * v.precio_unitario) AS ventas_totales 
FROM ventas v
JOIN clientes c ON v.cliente_id = c.id
WHERE  EXTRACT(YEAR FROM v.fecha) = 2025 AND EXTRACT(MONTH FROM v.fecha) = 8 
LIMIT 5
```

###  Obtener el cliente con más compras realizadas.

```postgresql
SELECT c.nombre, COUNT(v.id) as numero_ventas
FROM clientes c
JOIN ventas v ON v.cliente_id = c.id
GROUP BY c.id, c.nombre
ORDER BY numero_ventas DESC
LIMIT 1;
```

###  Listar los 5 productos más vendidos.

```postgresql
SELECT 
    p.nombre AS producto,
    COALESCE(SUM(vd.cantidad), 0) AS cantidad_vendida
FROM productos p
LEFT JOIN ventas_detalle vd ON vd.producto_id = p.id
GROUP BY p.id, p.nombre
ORDER BY cantidad_vendida DESC
LIMIT 15;
```

### Consultar ventas realizadas en un rango de fechas de tres Días y un Mes.

```postgresql
SELECT SUM(vd.cantidad * vd.precio_unitario) AS ventas_totales
FROM ventas v
JOIN ventas_detalle vd ON vd.venta_id = v.id
WHERE v.fecha::date BETWEEN CURRENT_DATE - INTERVAL '1 month'AND CURRENT_DATE - INTERVAL '3 days';
```

###  Identificar clientes que no han comprado en los últimos 6 meses.

```postgresql
SELECT c.nombre AS cliente_nocompra_hace_6meses
FROM clientes c
LEFT JOIN ventas v ON v.cliente_id = c.id AND v.fecha >= CURRENT_DATE - INTERVAL '6 months'
WHERE v.id IS NULL;
```

## Procedimientos y Funciones 

1. Un procedimiento almacenado para registrar una venta.

2. Validar que el cliente exista.

3. Verificar que el stock sea suficiente antes de procesar la venta.

4. Si no hay stock suficiente, Notificar por medio de un mensaje en consola usando RAISE.

5. Si hay stock, se realiza el registro de la venta.

```postgresql
-- 1.REGISTRO DE VENTA
CREATE OR REPLACE FUNCTION public.registrar_venta(p_cliente_id integer, p_fecha timestamp with time zone, p_producto_id integer, p_cantidad integer, p_precio_unitario numeric)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_venta_id INTEGER;
BEGIN
    
    IF (SELECT stock FROM productos WHERE id = p_producto_id) < p_cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto %', p_producto_id;
    END IF;

    
    INSERT INTO ventas (cliente_id, fecha, cantidad, precio_unitario)
    VALUES (p_cliente_id, p_fecha, p_cantidad, p_precio_unitario)
    RETURNING id INTO v_venta_id;

    
    INSERT INTO ventas_detalle (venta_id, producto_id, cantidad, precio_unitario)
    VALUES (v_venta_id, p_producto_id, p_cantidad, p_precio_unitario);

    
    UPDATE productos
    SET stock = stock - p_cantidad
    WHERE id = p_producto_id;

    RETURN format('Venta registrada exitosamente con ID: %s', v_venta_id);
END;
$function$

-- 2.VALIDAR QUE EL CLIENTE EXISTE
CREATE OR REPLACE FUNCTION public.validar_cliente(c_id integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    cliente_existe BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM clientes WHERE id = c_id)
    INTO cliente_existe;

    IF NOT cliente_existe THEN
        RAISE EXCEPTION 'El cliente con ID % no existe', c_id;
    END IF;

    RETURN format('Cliente con ID %s existe', c_id);
END;
$function$

--3, 4, 5 Verificar que el stock sea suficiente antes de procesar la venta,Si no hay stock suficiente, Notificar por medio de un mensaje en consola usando RAISE.Si hay stock, se realiza el registro de la venta.

CREATE OR REPLACE FUNCTION verificar_stock(
    p_producto_id INTEGER,
    p_cantidad INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
    v_stock INTEGER;
BEGIN
    
    SELECT stock INTO v_stock
    FROM productos
    WHERE id = p_producto_id;

    IF v_stock IS NULL THEN
        RAISE EXCEPTION 'El producto con ID % no existe', p_producto_id;
    END IF;

    IF v_stock < p_cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente. Disponible: %, solicitado: %', v_stock, p_cantidad;
    END IF;

    RAISE NOTICE 'Stock suficiente: %, solicitado: %', v_stock, p_cantidad;

    RETURN TRUE; 
END;
$$ LANGUAGE plpgsql;

SELECT verificar_stock(5, 3); -
```

## Triggers

### Actualización automática del stock en ventas

> Cada vez que se inserte un registro en la tabla `ventas_detalle`, el sistema debe **descontar automáticamente** la cantidad de productos vendidos del campo `stock` de la tabla `productos`.

- Si el stock es insuficiente, el trigger debe evitar la operación y lanzar un error con `RAISE EXCEPTION`.

```postgresql
CREATE OR REPLACE FUNCTION f_registro_audiventa()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE productos
  SET stock = stock - NEW.cantidad
  WHERE id = NEW.producto_id;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_registro_audiventa
AFTER INSERT ON ventas --cambio
FOR EACH ROW
EXECUTE FUNCTION f_registro_audiventa();

```





```postgresql
INSERT INTO ventas (cliente_id, fecha) VALUES (1, NOW());

SELECT * FROM auditoria_ventas;

```



### Registro de auditoría de ventas

> Al insertar una nueva venta en la tabla `ventas`, se debe generar automáticamente un registro en la tabla `auditoria_ventas` indicando:

- ID de la venta
- Fecha y hora del registro
- Usuario que realizó la transacción (usando `current_user`)

```postgresql
CREATE OR REPLACE FUNCTION f_registro_audiventa()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO auditoria_ventas (venta_id, usuario, registrado_en)
  VALUES (NEW.id, CURRENT_USER, NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_registro_audiventa
AFTER INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION f_registro_audiventa();

```



```postgresql
INSERT INTO ventas (cliente_id, fecha) VALUES (1, NOW());

SELECT * FROM auditoria_ventas;
```



### Notificación de productos agotados

> Cuando el stock de un producto llegue a **0** después de una actualización, se debe registrar en la tabla `alertas_stock` un mensaje indicando:

- ID del producto
- Nombre del producto
- Fecha en la que se agotó

```postgresql
CREATE OR REPLACE FUNCTION f_alert_stock()
RETURNS TRIGGER AS $$
BEGIN  
  IF (SELECT stock 
      FROM productos 
      WHERE id = NEW.producto_id) = 0
  	THEN
        INSERT INTO alertas_stock (producto_id, nombre_producto, mensaje, generado_en)
        VALUES (NEW.producto_id,(
            SELECT nombre FROM productos WHERE id = NEW.producto_id),'Producto agotado',NOW()
            );
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_alert_stock
AFTER INSERT ON ventas_detalle
FOR EACH ROW
EXECUTE FUNCTION f_alert_stock();
```



```postgresql
UPDATE productos SET stock = 1 WHERE id = 1;
INSERT INTO ventas (cliente_id) VALUES (1);
INSERT INTO ventas_detalle (venta_id, producto_id, cantidad, precio_unitario)
VALUES (currval('ventas_id_seq'), 1, 1, 50.00);
SELECT * FROM alertas_stock;
```

### Validación de datos en clientes

> Antes de insertar un nuevo cliente en la tabla `clientes`, se debe validar que el campo `correo` no esté vacío y que no exista ya en la base de datos (unicidad).

- Si la validación falla, se debe impedir la inserción y lanzar un mensaje de error.

```postgresql
CREATE OR REPLACE FUNCTION f_validatos_clientes()
RETURNS TRIGGER AS $$
DECLARE
  existe INT;
BEGIN
  IF NEW.correo IS NULL OR NEW.correo = '' THEN
    RAISE EXCEPTION 'El correo no puede estar vacío';
  END IF;
  SELECT COUNT(*) INTO existe
  FROM clientes
  WHERE correo = NEW.correo;
  IF existe > 0 THEN
    RAISE EXCEPTION 'El correo % ya está registrado en la base de datos', NEW.correo;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validatos_clientes
BEFORE INSERT OR UPDATE ON clientes
FOR EACH ROW
EXECUTE FUNCTION f_validatos_clientes();
```



```postgresql
-- válida
INSERT INTO clientes (nombre, correo, telefono)
VALUES ('Cliente Test', 'test@email.com', '555-1111');

--inválida (correo vacío)
INSERT INTO clientes (nombre, correo, telefono)
VALUES ('Cliente Sin Correo', '', '555-2222');

-- inválida (correo repetido)
INSERT INTO clientes (nombre, correo, telefono)
VALUES ('Cliente Repetido', 'test@email.com', '555-3333');

```

# integrantes el grupo:

- hadassa galindo
- hector mejia
