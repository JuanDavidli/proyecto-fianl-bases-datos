
INSERT INTO clientes (nombre, telefono, red_social, direccion_envio, email) VALUES
('Carlos Mendoza', '+573001234567', '@carlosm', 'Calle 10 #43-12, Medellín', 'carlos.mendoza@email.com'),
('Laura Gómez', '+573119876543', '@laurag', 'Carrera 7 #85-10, Bogotá', 'laura.gomez@email.com'),
('Andrés Torres', '+573204567890', '@andrest', 'Avenida 4 Norte #12-30, Cali', 'andres.torres@email.com'),
('Mariana Ríos', '+573156789012', '@marianar', 'Calle 50 #20-15, Manizales', 'mariana.rios@email.com'),
('Diego Fernández', '+573012345678', '@diegof', 'Carrera 15 #100-45, Bogotá', 'diego.fernandez@email.com'),
('Sofia Castro', '+573123456789', '@sofiac', 'Calle 33 #65-20, Medellín', 'sofia.castro@email.com'),
('Javier Ramírez', '+573187654321', '@javierr', 'Carrera 43A #1-50, Envigado', 'javier.ramirez@email.com'),
('Valentina Morales', '+573045678901', '@valem', 'Calle 70 #10-05, Barranquilla', 'valentina.morales@email.com'),
('Mateo Vargas', '+573165432109', '@mateov', 'Carrera 5 #15-30, Pereira', 'mateo.vargas@email.com'),
('Camila Salazar', '+573029876543', '@camilas', 'Avenida El Poblado #10-12, Medellín', 'camila.salazar@email.com');

	

INSERT INTO productos (nombre, descripcion, precio, stock, categoria) VALUES
('Laptop Pro 15', 'Laptop de alto rendimiento con 16GB RAM y 512GB SSD', 1200.00, 15, 'Portátiles'),
('Mouse Inalámbrico RGB', 'Mouse ergonómico con sensor óptico de alta precisión', 25.50, 50, 'Accesorios'),
('Teclado Mecánico', 'Teclado mecánico retroiluminado switch red', 75.00, 30, 'Accesorios'),
('Monitor Gaming 27"', 'Monitor 144Hz IPS 1ms Full HD', 280.00, 20, 'Monitores'),
('Audífonos Bluetooth', 'Audífonos over-ear con cancelación de ruido activa', 95.00, 40, 'Audio'),
('Silla Ergonómica', 'Silla de oficina con soporte lumbar ajustable', 180.00, 10, 'Muebles'),
('Disco Duro Externo 2TB', 'Almacenamiento portátil USB 3.0', 65.00, 25, 'Almacenamiento'),
('SSD NVMe 1TB', 'Unidad de estado sólido M.2 de alta velocidad', 110.00, 35, 'Almacenamiento'),
('Webcam Full HD 1080p', 'Cámara web con micrófono integrado para streaming', 45.00, 30, 'Accesorios'),
('Micrófono Condensador USB', 'Micrófono profesional para podcast y voz', 85.00, 15, 'Audio'),
('Tarjeta Gráfica RTX 4060', 'GPU de 8GB GDDR6 para videojuegos', 400.00, 8, 'Componentes'),
('Memoria RAM 16GB DDR4', 'Módulo de memoria RAM 3200MHz', 55.00, 60, 'Componentes'),
('Fuente de Poder 750W', 'Fuente 80 Plus Gold modular', 105.00, 18, 'Componentes'),
('Gabinete ATX Cristal', 'Torre para PC con vidrio templado y 3 ventiladores RGB', 90.00, 12, 'Componentes'),
('Soporte Monitor Doble', 'Brazo articulado para dos pantallas de hasta 32"', 50.00, 22, 'Accesorios');

INSERT INTO pedidos (id_cliente, estado, metodo_pago, monto_total) VALUES
(1, 'Entregado', 'Tarjeta de Crédito', 1275.00),
(2, 'Pagado', 'Transferencia PSE', 280.00),
(3, 'Enviado', 'Tarjeta de Débito', 205.00),
(4, 'Pendiente', 'Efectivo', 95.00),
(5, 'Entregado', 'Tarjeta de Crédito', 510.00);


INSERT INTO detalle_pedidos (id_pedido, id_producto, cantidad, precio_unitario) VALUES

(1, 1, 1, 1200.00),
(1, 3, 1, 75.00),


(2, 4, 1, 280.00),


(3, 8, 1, 110.00),
(3, 5, 1, 95.00),


(4, 5, 1, 95.00),

-- Detalles del Pedido 5
(5, 11, 1, 400.00),
(5, 8, 1, 110.00);
SELECT 
    p.id_pedido,
    c.nombre AS cliente,
    c.telefono,
    p.estado,
    p.metodo_pago,
    pr.nombre AS producto,
    dp.cantidad,
    dp.precio_unitario,
    dp.subtotal,
    p.monto_total AS total_pedido
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN detalle_pedidos dp ON p.id_pedido = dp.id_pedido
JOIN productos pr ON dp.id_producto = pr.id_producto
ORDER BY p.id_pedido;