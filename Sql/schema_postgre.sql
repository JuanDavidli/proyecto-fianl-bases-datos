Tabla: CLIENTES
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    red_social VARCHAR(50), -- Instagram, Facebook, WhatsApp, TikTok, etc.
    direccion_envio TEXT NOT NULL,
    email VARCHAR(100) UNIQUE,
    fecha_registro TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabla: PRODUCTOS
CREATE TABLE IF NOT EXISTS productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10, 2) NOT NULL CONSTRAINT chk_precio_positivo CHECK (precio >= 0),
    stock INT NOT NULL DEFAULT 0 CONSTRAINT chk_stock_positivo CHECK (stock >= 0),
    categoria VARCHAR(50)
);

-- 4. Tabla: PEDIDOS
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_pedido TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    estado estado_pedido DEFAULT 'Pendiente',
    metodo_pago VARCHAR(50) NOT NULL,
    monto_total NUMERIC(10, 2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_pedidos_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- 5. Tabla: DETALLE_PEDIDOS
CREATE TABLE IF NOT EXISTS detalle_pedidos (
    id_detalle SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CONSTRAINT chk_cantidad_positiva CHECK (cantidad > 0),
    precio_unitario NUMERIC(10, 2) NOT NULL,
    subtotal NUMERIC(10, 2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    CONSTRAINT fk_detalle_pedidos
        FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_productos
        FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);