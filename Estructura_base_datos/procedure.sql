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

SELECT validar_cliente(5);

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
