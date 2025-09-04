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
  proveedores_id serial NOT NULL,
  FOREIGN KEY (proveedores_id) REFERENCES proveedores(id)
);

CREATE TABLE IF NOT EXISTS historial_precios (
  id BIGSERIAL PRIMARY KEY,
  producto_id INTEGER NOT NULL,
  precio_anterior NUMERIC(12,2) NOT NULL,
  precio_nuevo NUMERIC(12,2) NOT NULL,
  cambiado_en TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY (producto_id) REFERENCES productos(id)
);

CREATE TABLE IF NOT EXISTS alertas_stock (
  id BIGSERIAL PRIMARY KEY,
  producto_id INTEGER NOT NULL,
  nombre_producto TEXT NOT NULL,
  mensaje TEXT NOT NULL,
  generado_en TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY (producto_id) REFERENCES productos(id)
);

CREATE TABLE IF NOT EXISTS ventas (
  id SERIAL PRIMARY KEY,
  cliente_id INTEGER NOT NULL,
  fecha TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE IF NOT EXISTS ventas_detalle (
  id SERIAL PRIMARY KEY,
  venta_id INTEGER NOT NULL,
  producto_id INTEGER NOT NULL,
  cantidad INTEGER NOT NULL CHECK (cantidad > 0),
  precio_unitario NUMERIC(12,2) NOT NULL CHECK (precio_unitario >= 0),
  FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE,
  FOREIGN KEY (producto_id) REFERENCES productos(id)
);

CREATE TABLE IF NOT EXISTS auditoria_ventas (
  id BIGSERIAL PRIMARY KEY,
  venta_id INTEGER NOT NULL,
  usuario TEXT NOT NULL DEFAULT CURRENT_USER,
  registrado_en TIMESTAMP NOT NULL DEFAULT NOW(),
  FOREIGN KEY (venta_id) REFERENCES ventas(id) ON DELETE CASCADE
);

