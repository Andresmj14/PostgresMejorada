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