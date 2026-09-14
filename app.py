from decimal import Decimal
from peewee import *

# ==========================================
# 1. CONFIGURACIÓN DE CONEXIÓN
# ==========================================
# Opciones: "sqlite" | "mysql_aiven" | "postgres_neon" | "postgres_render"
MOTOR_ACTIVO = "sqlite"

if MOTOR_ACTIVO == "sqlite":
    db = SqliteDatabase("ORAtech")

elif MOTOR_ACTIVO == "mysql_aiven":
    db = MySQLDatabase(
        "deafaultdb",
        user="avnadmin",
        host="ora-tech-penataalejandro01-5270.l.aivencloud.com",
        port=24523,
        ssl={"ssl_mode": "REQUIRED"}
    )

elif MOTOR_ACTIVO == "postgres_neon":
    db = PostgresqlDatabase(
        "neondb",
        user="neondb_owner",
        host="ep-little-pond-a5mm6ebd-pooler.us-east-2.aws.neon.tech",
        port=5432,
        sslmode="require",
        channel_binding="require"
    )   

# ==========================================
# 2. MODELOS RELACIONALES (ORM)
# ==========================================
class BaseModel(Model):
    class Meta:
        database = db

class Cliente(BaseModel):
    nombre = CharField(max_length=100)
    telefono = CharField(max_length=20, null=True)
    red_social = CharField(max_length=50, null=True)
    direccion_envio = TextField(null=True)
    email = CharField(max_length=100, unique=True)

class Producto(BaseModel):
    nombre = CharField(max_length=100)
    descripcion = TextField(null=True)
    precio = DecimalField(max_digits=10, decimal_places=2)
    stock = IntegerField(default=0)
    categoria = CharField(max_length=50) # Mantenido como texto según tus inserts SQL originales

class Pedido(BaseModel):
    id_cliente = ForeignKeyField(Cliente, backref="pedidos", on_delete="CASCADE")
    estado = CharField(max_length=50, default="Pendiente")
    metodo_pago = CharField(max_length=50)
    monto_total = DecimalField(max_digits=10, decimal_places=2)

class DetallePedido(BaseModel):
    id_pedido = ForeignKeyField(Pedido, backref="detalles", on_delete="CASCADE")
    id_producto = ForeignKeyField(Producto, backref="detalles", on_delete="CASCADE")
    cantidad = IntegerField(default=1)
    precio_unitario = DecimalField(max_digits=10, decimal_places=2)

# ==========================================
# 3. OPERACIONES CRUD Y PRUEBAS
# ==========================================
def ejecutar_pruebas():
    # Conectar y crear tablas de todo el negocio si no existen
    db.connect()
    db.create_tables([Cliente, Producto, Pedido, DetallePedido], safe=True)
    print(f"--- CONECTADO EXITOSAMENTE A: {MOTOR_ACTIVO.upper()} ---")

    # 1. CREATE (Poblar datos iniciales basados en tus SQL)
    print("\n[CREATE] Insertando registros de prueba...")
    
    # Crear un cliente y un producto
    cliente_1 = Cliente.get_or_create(
        email="carlos.mendoza@email.com",
        defaults={
            "nombre": "Carlos Mendoza", 
            "telefono": "+573001234567", 
            "red_social": "@carlosm", 
            "direccion_envio": "Calle 10 #43-12, Medellín"
        }
    )[0]
    
    prod_1 = Producto.get_or_create(
        nombre="Laptop Pro 15",
        defaults={
            "descripcion": "Laptop de alto rendimiento con 16GB RAM y 512GB SSD",
            "precio": Decimal("1200.00"),
            "stock": 15,
            "categoria": "Portátiles"
        }
    )[0]

    prod_2 = Producto.get_or_create(
        nombre="Teclado Mecánico",
        defaults={
            "descripcion": "Teclado mecánico retroiluminado switch red",
            "precio": Decimal("75.00"),
            "stock": 30,
            "categoria": "Accesorios"
        }
    )[0]

    # Crear un pedido con sus detalles
    pedido_1 = Pedido.create(
        id_cliente=cliente_1,
        estado="Entregado",
        metodo_pago="Tarjeta de Crédito",
        monto_total=Decimal("1275.00")
    )
    
    DetallePedido.create(id_pedido=pedido_1, id_producto=prod_1, cantidad=1, precio_unitario=prod_1.precio)
    DetallePedido.create(id_pedido=pedido_1, id_producto=prod_2, cantidad=1, precio_unitario=prod_2.precio)
    print(f"-> Pedido ID {pedido_1.id} creado exitosamente para {cliente_1.nombre}.")

    # 2. READ (Consulta adaptada con múltiples JOINs equivalente a tu Query original)
    print("\n[READ] Listando detalles de todos los pedidos:")
    query = (DetallePedido
             .select(DetallePedido, Pedido, Cliente, Producto)
             .join(Pedido)
             .join(Cliente)
             .switch(DetallePedido) # Volver al nodo raíz para unir el producto correctamente
             .join(Producto)
             .order_by(Pedido.id))

    for dp in query:
        subtotal = dp.cantidad * dp.precio_unitario
        print(f"- Pedido #{dp.id_pedido.id} | Cliente: {dp.id_pedido.id_cliente.nombre} | "
              f"Producto: {dp.id_producto.nombre} | Cantidad: {dp.cantidad} | "
              f"Subtotal: ${subtotal} | Total Pedido: ${dp.id_pedido.monto_total}")

    # 3. UPDATE (Actualización de stock y precio)
    print("\n[UPDATE] Modificando información del producto...")
    prod_2.precio = Decimal("80.00")
    prod_2.stock = 25
    prod_2.save()
    print(f"-> Nuevo precio de {prod_2.nombre}: ${prod_2.precio} (Stock restante: {prod_2.stock})")

    # 4. DELETE (Eliminación limpia controlada)
    print("\n[DELETE] Limpiando el pedido simulado...")
    pedido_1.delete_instance(recursive=True) # Borra el pedido y automáticamente sus detalles en cascada
    print(f"-> Pedido ID {pedido_1.id} y sus sub-detalles fueron eliminados correctamente.")

    db.close()

if __name__ == "__main__":
    ejecutar_pruebas()
