PRAGMA foreign_keys = ON;


CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    telefono TEXT NOT NULL,
    red_social TEXT,
    direccion_envio TEXT NOT NULL,
    email TEXT UNIQUE,
    -- Usa datetime('now', 'localtime') para que guarde la hora de tu país y no la de Greenwich (UTC)
    fecha_registro TEXT DEFAULT (datetime('now', 'localtime'))
);

CREATE TABLE IF NOT EXISTS productos (
    id_producto INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    precio REAL NOT NULL CONSTRAINT chk_precio_positivo CHECK (precio >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CONSTRAINT chk_stock_positivo CHECK (stock >= 0),
    categoria TEXT
);

CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cliente INTEGER NOT NULL,
    fecha_pedido TEXT DEFAULT (datetime('now', 'localtime')),
    estado TEXT DEFAULT 'Pendiente' CONSTRAINT chk_estado_valido CHECK (estado IN ('Pendiente', 'Pagado', 'Enviado', 'Entregado', 'Cancelado')),
    metodo_pago TEXT NOT NULL,
    monto_total REAL NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_pedidos_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS detalle_pedidos (
    id_detalle INTEGER PRIMARY KEY AUTOINCREMENT,
    id_pedido INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    cantidad INTEGER NOT NULL CONSTRAINT chk_cantidad_positiva CHECK (cantidad > 0),
    precio_unitario REAL NOT NULL,
    subtotal REAL GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    CONSTRAINT fk_detalle_pedidos FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_productos FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE
);
