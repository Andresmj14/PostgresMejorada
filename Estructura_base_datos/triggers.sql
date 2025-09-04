## Triggers

### Actualización automática del stock en ventas

> Cada vez que se inserte un registro en la tabla `ventas_detalle`, el sistema debe **descontar automáticamente** la cantidad de productos vendidos del campo `stock` de la tabla `productos`.

- Si el stock es insuficiente, el trigger debe evitar la operación y lanzar un error con `RAISE EXCEPTION`.


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

INSERT INTO ventas (cliente_id, fecha) VALUES (1, NOW());

SELECT * FROM auditoria_ventas;





### Registro de auditoría de ventas

> Al insertar una nueva venta en la tabla `ventas`, se debe generar automáticamente un registro en la tabla `auditoria_ventas` indicando:

- ID de la venta
- Fecha y hora del registro
- Usuario que realizó la transacción (usando `current_user`)


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





INSERT INTO ventas (cliente_id, fecha) VALUES (1, NOW());

SELECT * FROM auditoria_ventas;




### Notificación de productos agotados

> Cuando el stock de un producto llegue a **0** después de una actualización, se debe registrar en la tabla `alertas_stock` un mensaje indicando:

- ID del producto
- Nombre del producto
- Fecha en la que se agotó


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





UPDATE productos SET stock = 1 WHERE id = 1;
INSERT INTO ventas (cliente_id) VALUES (1);
INSERT INTO ventas_detalle (venta_id, producto_id, cantidad, precio_unitario)
VALUES (currval('ventas_id_seq'), 1, 1, 50.00);
SELECT * FROM alertas_stock;


### Validación de datos en clientes

> Antes de insertar un nuevo cliente en la tabla `clientes`, se debe validar que el campo `correo` no esté vacío y que no exista ya en la base de datos (unicidad).

- Si la validación falla, se debe impedir la inserción y lanzar un mensaje de error.

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




-- válida
INSERT INTO clientes (nombre, correo, telefono)
VALUES ('Cliente Test', 'test@email.com', '555-1111');

--inválida (correo vacío)
INSERT INTO clientes (nombre, correo, telefono)
VALUES ('Cliente Sin Correo', '', '555-2222');

-- inválida (correo repetido)
INSERT INTO clientes (nombre, correo, telefono)
VALUES ('Cliente Repetido', 'test@email.com', '555-3333');

