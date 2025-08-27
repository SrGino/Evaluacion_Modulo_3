CREATE DATABASE GestionInventario;
USE GestionInventario;

CREATE TABLE Producto (
    producto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    cantidad_inventario INT NOT NULL
);

CREATE TABLE Proveedor (
    proveedor_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE ProductoProveedor (
    producto_id INT,
    proveedor_id INT,
    PRIMARY KEY (producto_id, proveedor_id),
    FOREIGN KEY (producto_id) REFERENCES Producto(producto_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (proveedor_id) REFERENCES Proveedor(proveedor_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Transaccion (
    transaccion_id INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('compra', 'venta') NOT NULL,
    fecha DATE NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    producto_id INT,
    proveedor_id INT,
    FOREIGN KEY (producto_id) REFERENCES Producto(producto_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    FOREIGN KEY (proveedor_id) REFERENCES Proveedor(proveedor_id) 
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Insertar productos
INSERT INTO Producto (nombre, descripcion, precio, cantidad_inventario) VALUES
('Laptop', 'Portátil 15 pulgadas, 16GB RAM', 899.99, 50),
('Ratón Inalámbrico', 'Ratón óptico 2.4GHz', 25.50, 100),
('Teclado Mecánico', 'Teclado RGB, switches blue', 89.90, 30);

-- Insertar proveedores
INSERT INTO Proveedor (nombre, direccion, telefono, email) VALUES
('Tecnosupply S.A.', 'Calle Falsa 123, Ciudad', '123456789', 'ventas@tecnosupply.com'),
('ElectroGlobal', 'Avenida Central 456', '987654321', 'contacto@electroglobal.com');

-- Asociar productos con proveedores 
INSERT INTO ProductoProveedor (producto_id, proveedor_id) VALUES
(1, 1), -- Laptop → Tecnosupply
(2, 1), -- Ratón → Tecnosupply
(2, 2), -- Ratón → ElectroGlobal
(3, 2); -- Teclado → ElectroGlobal

-- Registrar transacciones
INSERT INTO Transaccion (tipo, fecha, cantidad, producto_id, proveedor_id) VALUES
('compra', '2025-04-01', 20, 1, 1),
('venta', '2025-04-02', 5, 1, NULL),
('compra', '2025-04-03', 30, 2, 2),
('venta', '2025-04-04', 10, 2, NULL),
('venta', '2025-04-05', 2, 1, NULL);

-- Consultas.

-- 1. Todos los productos
SELECT * FROM Producto;

-- 2. Proveedores que suministran el producto "Ratón Inalámbrico"
SELECT p.nombre AS proveedor
FROM Proveedor p
JOIN ProductoProveedor pp ON p.proveedor_id = pp.proveedor_id
JOIN Producto pr ON pp.producto_id = pr.producto_id
WHERE pr.nombre = 'Ratón Inalámbrico';

-- 3. Transacciones de una fecha específica
SELECT * FROM Transaccion WHERE fecha = '2025-04-02';

-- 4. Total de productos vendidos
SELECT SUM(cantidad) AS total_vendido
FROM Transaccion
WHERE tipo = 'venta';

-- 5. Valor total de compras (precio × cantidad)
SELECT 
    pr.nombre,
    t.cantidad,
    pr.precio,
    (t.cantidad * pr.precio) AS valor_total
FROM Transaccion t
JOIN Producto pr ON t.producto_id = pr.producto_id
WHERE t.tipo = 'compra';

-- 6. Ventas del mes anterior
SELECT 
    pr.nombre,
    SUM(t.cantidad) AS unidades_vendidas
FROM Transaccion t
JOIN Producto pr ON t.producto_id = pr.producto_id
WHERE t.tipo = 'venta'
  AND t.fecha >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY pr.producto_id, pr.nombre;

-- 7. Productos que no se han vendido en el último mes
SELECT nombre
FROM Producto
WHERE producto_id NOT IN (
    SELECT DISTINCT producto_id
    FROM Transaccion
    WHERE tipo = 'venta'
      AND fecha >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
);

--Transaccion

START TRANSACTION;

-- Registrar compra
INSERT INTO Transaccion (tipo, fecha, cantidad, producto_id, proveedor_id)
VALUES ('compra', CURDATE(), 10, 1, 1);

-- Actualizar inventario
UPDATE Producto
SET cantidad_inventario = cantidad_inventario + 10
WHERE producto_id = 1;

-- Si todo va bien:
COMMIT;
-- Si hay error: 
ROLLBACK;