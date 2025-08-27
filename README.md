# Informe de Diseño de Base de Datos  
## Sistema: GestionInventario

### 1. Introducción

Este informe describe el diseño de una base de datos relacional destinada a la gestión eficiente de inventario en un entorno comercial. El sistema, denominado **GestionInventario**, permite registrar productos, proveedores, sus relaciones comerciales y los movimientos asociados a compras y ventas. El objetivo principal es garantizar la integridad, consistencia y disponibilidad de la información, facilitando la toma de decisiones operativas y estratégicas.

La base de datos fue desarrollada bajo principios de modelado relacional, normalización y control de transacciones, lo que asegura un funcionamiento confiable y escalable.

### 2. Modelo Entidad-Relación (ER)

El modelo conceptual se basa en tres entidades principales y una relación muchos a muchos que se resuelve mediante una tabla de asociación.

#### Entidades del Sistema

- **Producto**: Representa los artículos gestionados en el inventario. Cada producto tiene un nombre, descripción, precio unitario y cantidad disponible en stock.

- **Proveedor**: Almacena la información de los proveedores que suministran los productos. Incluye datos como nombre, dirección, teléfono y correo electrónico.

- **Transaccion**: Registra los movimientos de entrada (compras) y salida (ventas) de productos. Cada transacción tiene un tipo, fecha, cantidad y referencias al producto y, en el caso de compras, al proveedor involucrado.

#### Relación entre Entidades

- Existe una relación muchos a muchos entre **Producto** y **Proveedor**, ya que un producto puede ser suministrado por varios proveedores y un proveedor puede ofrecer múltiples productos. Esta relación se resuelve mediante una tabla intermedia llamada **ProductoProveedor**.

- Las transacciones están asociadas a un producto y, opcionalmente, a un proveedor (solo en compras).

Este modelo permite representar con precisión las operaciones diarias de un sistema de inventario, facilitando la trazabilidad de los productos y sus orígenes.

### 3. Modelo Relacional

El modelo conceptual se transformó en un esquema relacional compuesto por cuatro tablas:

- **Producto**: Almacena la información detallada de cada producto, con identificador único y atributos clave como nombre, precio y cantidad en inventario.

- **Proveedor**: Contiene los datos de contacto y ubicación de cada proveedor. El correo electrónico es único para evitar duplicados.

- **ProductoProveedor**: Tabla de asociación que enlaza productos con sus respectivos proveedores. Su clave primaria es compuesta, formada por los identificadores del producto y del proveedor.

- **Transaccion**: Registra cada movimiento de inventario, indicando si es una compra o venta, la fecha, la cantidad afectada, y las referencias al producto y proveedor correspondientes.

Las relaciones entre tablas se establecen mediante claves foráneas, aplicando políticas de actualización y eliminación en cascada para mantener la integridad referencial. Este enfoque asegura que las modificaciones en registros principales se reflejen coherentemente en las tablas relacionadas.

### 4. Normalización

El diseño del modelo cumple con las tres primeras formas normales:

- **Primera Forma Normal (1FN)**: Todos los atributos son atómicos y no contienen grupos repetitivos. Cada campo almacena un solo valor.

- **Segunda Forma Normal (2FN)**: No existen dependencias parciales. Todos los atributos no clave dependen completamente de la clave primaria en cada tabla.

- **Tercera Forma Normal (3FN)**: No se presentan dependencias transitivas. Los atributos no clave dependen únicamente de la clave primaria, no de otros atributos no clave.

La relación muchos a muchos entre producto y proveedor se normaliza mediante la creación de la tabla intermedia, evitando redundancias y asegurando un diseño limpio y eficiente. Este nivel de normalización previene anomalías durante inserciones, actualizaciones y eliminaciones.

### 5. Datos de Ejemplo

Para validar el correcto funcionamiento del sistema, se cargaron datos de prueba representativos:

- Se registraron tres productos: una laptop, un ratón inalámbrico y un teclado mecánico, con sus respectivos precios y niveles de inventario iniciales.

- Se incorporaron dos proveedores: una empresa tecnológica local y una distribuidora internacional.

- Se establecieron relaciones entre productos y proveedores, reflejando que algunos productos tienen múltiples fuentes de abastecimiento.

- Se registraron transacciones de compra y venta en fechas consecutivas, simulando operaciones reales del negocio.

Estos datos permiten probar consultas, transacciones y análisis sin afectar un entorno productivo, facilitando la verificación del comportamiento esperado del sistema.

### 6. Consultas Avanzadas

Se diseñaron consultas complejas para extraer información relevante y apoyar la toma de decisiones:

- **Listado completo de productos** para revisión del inventario.
- **Identificación de proveedores por producto**, útil para gestionar abastecimiento.
- **Filtrado de transacciones por fecha**, permitiendo auditorías diarias.
- **Cálculo del total de productos vendidos**, para análisis de desempeño.
- **Valor económico de las compras realizadas**, facilitando el control de gastos.
- **Reporte de ventas por producto en el último mes**, para evaluar rotación de inventario.
- **Identificación de productos no vendidos recientemente**, ayudando a detectar artículos obsoletos o de baja demanda.

Estas consultas combinan técnicas como uniones (JOIN), agrupaciones (GROUP BY), funciones agregadas y subconsultas, demostrando la potencia del modelo para generar reportes útiles y oportunos.

### 7. Manejo de Transacciones

El sistema implementa control transaccional para operaciones críticas, especialmente aquellas que afectan el inventario. Mediante el uso de bloques de transacción, se garantiza que una compra o venta se registre completamente o no se registre en absoluto.

Este mecanismo asegura que, al realizar una compra, tanto el registro de la transacción como la actualización del inventario se ejecuten de forma atómica. En caso de error, todos los cambios se revierten, evitando inconsistencias como aumentos de stock sin registro de compra.

Este enfoque es fundamental para mantener la confiabilidad del sistema ante fallos o interrupciones, y asegura que el estado del inventario siempre refleje con precisión la realidad operativa.

### 8. Conclusiones

El sistema **GestionInventario** presenta un diseño robusto, bien estructurado y listo para ser utilizado en entornos reales. Sus principales fortalezas incluyen:

- Un modelo conceptual claro y fácil de entender.
- Alta normalización, que previene anomalías en los datos.
- Soporte para transacciones seguras y operaciones críticas.
- Consultas poderosas para análisis operativo y comercial.
- Facilidad de mantenimiento y potencial de escalabilidad.

Este sistema puede integrarse con aplicaciones frontend, sistemas de facturación o paneles de análisis, y sirve como base para soluciones más complejas como ERP o POS. Su diseño modular y coherente lo convierte en una herramienta eficaz para la gestión eficiente del inventario.
