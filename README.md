NOMBRES DE LOS PARTICIPANTES:
SANTIAGO ORTIZ ZARATE

JUAN DAVID LIÑAN ARRIOLA
ALEJANDRO STIVEN PEÑATA CORREA

NUMERO DE FICHA: 3491237

FECHA: 31/08/2026



Ora Tech - Sistema de Gestión de Base de Datos Relacional Multi-Motor y ORM
Descripción General del Proyecto
Este repositorio contiene el desarrollo del proyecto final de bases de datos para ora\_tech, una tienda de comercio electrónico especializada en tecnología. El sistema administra de forma normalizada y segura la información de clientes, productos, pedidos y los detalles de las transacciones comerciales. Su arquitectura está diseñada para ser altamente versátil, soportando múltiples motores de bases de datos relacionales como PostgreSQL, MySQL y SQLite, e integrando una capa de abstracción en Python mediante el uso de Peewee ORM.

Paso a Paso del Desarrollo
El proyecto se estructuró siguiendo un flujo técnico riguroso de ingeniería de datos:

Modelado y Diseño Conceptual: Identificación de las entidades de negocio requeridas para la tienda de tecnología (Clientes, Productos, Pedidos y Detalle de Pedidos), determinando sus atributos, restricciones y relaciones lógicas.

Configuración de Entornos y Conectividad: Establecimiento de conexiones para entornos locales con archivos ligeros (SQLite), servidores relacionales locales (MySQL) y bases de datos en la nube (PostgreSQL alojado en Neon y administrado mediante pgAdmin).

Creación de Estructuras (DDL): Definición de las tablas base aplicando reglas estrictas de integridad referencial, claves primarias, claves foráneas con restricciones de borrado y actualización, restricciones CHECK para validar precios y stocks positivos, tipos de datos enumerados y columnas calculadas automáticamente.

Poblamiento de Datos (DML): Inserción de registros iniciales para simular operaciones comerciales reales, incluyendo perfiles de clientes ubicados en distintas ciudades, un catálogo de quince productos tecnológicos, pedidos asociados y sus respectivos desgloses detallados.

Integración Multi-Base de Datos y ORM: Implementación de modelos en Python utilizando Peewee ORM para interactuar de forma unificada con PostgreSQL, MySQL y SQLite, permitiendo la gestión de datos desde la capa de aplicación sin reescribir la lógica del negocio.

Consultas y Reportes (JOINs): Construcción de consultas multitabla para cruzar la información normalizada y visualizar de manera unificada las operaciones completas de la tienda.

Explicación de la Estructura de Tablas (DDL) y Restricciones
La arquitectura de la base de datos se compone de cuatro tablas principales y un tipo personalizado:

Tipo estado\_pedido: Un campo enumerado que define los estados posibles por los que transita una orden de compra, garantizando la consistencia del negocio mediante valores controlados como Pendiente, Pagado, Enviado, Entregado y Cancelado.

Tabla clientes: Almacena los datos personales y de contacto de los compradores. Cuenta con un identificador autoincremental mediante la instrucción SERIAL, nombre obligatorio, teléfono de contacto, red social de procedencia, dirección de envío obligatoria, un correo electrónico único para evitar duplicados y una marca de tiempo con la fecha de registro.

Tabla productos: Contiene el inventario tecnológico disponible en la tienda. Incluye un identificador autoincremental, nombre comercial, descripción detallada, categoría y restricciones de verificación o CHECK que aseguran que tanto el precio unitario como el stock disponible nunca adopten valores negativos.

Tabla pedidos: Registra las compras realizadas por los clientes, relacionándose con la tabla de clientes mediante una clave foránea con restricción de borrado ON DELETE RESTRICT para proteger la integridad histórica de las órdenes. Almacena además la fecha en la que se realizó el pedido, el estado actual de la transacción, el método de pago utilizado y el monto total calculado.

Tabla detalle\_pedidos: Actúa como tabla intermedia para resolver una relación de muchos a muchos entre los pedidos y los productos. Contiene claves foráneas hacia ambas tablas, la cantidad de unidades solicitadas validada con una restricción de valor estrictamente positivo, el precio unitario del producto al momento de la venta y una columna calculada de manera automática que almacena el subtotal multiplicando la cantidad por el precio unitario.

Arquitectura Multi-Motor y Python con Peewee ORM
Para demostrar adaptabilidad tecnológica, el proyecto incorpora scripts en Python utilizando Peewee ORM, permitiendo abstraer la sintaxis SQL y conectar el sistema indistintamente a tres motores de bases de datos diferentes:

SQLite: Ideal para entornos de desarrollo local y pruebas rápidas mediante un archivo de base de datos embebido y ligero.

MySQL: Configurado para despliegues en servidores locales o entornos de prueba integrados como XAMPP.

PostgreSQL: Empleado para producción en la nube mediante servicios de infraestructura como Neon.
Los modelos definidos en Python replican exactamente las tablas relacionales, configurando clases basadas en Model donde cada atributo representa una columna con sus respectivas restricciones de tipo, claves primarias autoincrementables y relaciones mediante campos de clave foránea.

Explicación de las Consultas y Operaciones JOIN
Para extraer información útil y unificada a partir de la normalización estricta de las tablas, se emplean operaciones de tipo JOIN. Dado que los datos de clientes, pedidos, productos y detalles se encuentran separados en distintas estructuras para evitar redundancias y anomalías, las consultas multitabla conectan las claves primarias con sus respectivas claves foráneas de la siguiente manera:

El proceso de unión vincula la tabla de pedidos con la tabla de clientes mediante el campo id\_cliente para identificar al comprador y extraer sus datos personales y de contacto.

Posteriormente, se conecta la tabla de pedidos con la tabla intermedia detalle\_pedidos a través del identificador id\_pedido, permitiendo desplegar cada uno de los ítems específicos que componen la orden de compra.

Finalmente, se cruza la tabla detalle\_pedidos con la tabla de productos mediante el campo id\_producto para recuperar el nombre comercial y las características de cada artículo adquirido.

El resultado de esta estructura de múltiples JOINs combinada con una ordenación secuencial permite obtener un reporte transparente y completo que muestra detalladamente qué cliente compró qué producto, en qué cantidad, bajo qué método de pago, con qué estado actual y cuál fue el valor total de la transacción comercial.

