CREATE DATABASE llantas_db;
USE llantas_db;
-- Tabla clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefono VARCHAR(15),
    direccion TEXT,
    fecha_registro DATE
);
-- Tabla productos
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    precio DECIMAL(10,2),
    stock INT,
    descripcion TEXT
);
-- Tabla ventas
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    fecha_venta DATE,
    total DECIMAL(10,2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Tabla detalle_venta
CREATE TABLE detalle_venta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT,
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);
-- •	Insertar entre 80 y 150 registros reales en cada tabla.
-- Insertar clientes (100 registros) y mostrar
INSERT INTO clientes (nombre, email, telefono, direccion, fecha_registro)
WITH RECURSIVE clientes_cte(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM clientes_cte WHERE n < 100
)
SELECT 
    CONCAT('Cliente ', n),
    CONCAT('cliente', n, '@gmail.com'),
    CONCAT('555-', LPAD(FLOOR(RAND() * 1000), 3, '0'), '-', LPAD(FLOOR(RAND() * 10000), 4, '0')),
    CONCAT('Calle ', FLOOR(RAND() * 100), ', Colonia ', n),
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY)
FROM clientes_cte;

SELECT * FROM clientes LIMIT 20;

-- Insertar productos (90 registros) y mostrar
INSERT INTO productos (nombre, marca, modelo, precio, stock, descripcion)
WITH RECURSIVE productos_cte(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM productos_cte WHERE n < 90
)
SELECT 
    CASE 
        WHEN n % 3 = 0 THEN CONCAT('Llanta ', n, ' - Radial')
        WHEN n % 3 = 1 THEN CONCAT('Llanta ', n, ' - Todo Terreno')
        ELSE CONCAT('Llanta ', n, ' - Deportiva')
    END,
    CASE n % 5
        WHEN 0 THEN 'Michelin'
        WHEN 1 THEN 'Bridgestone'
        WHEN 2 THEN 'Goodyear'
        WHEN 3 THEN 'Pirelli'
        ELSE 'Continental'
    END,
    CONCAT('MOD-', LPAD(n, 3, '0')),
    ROUND(RAND() * 500 + 100, 2),
    FLOOR(RAND() * 100),
    CONCAT('Llanta de alta calidad ', n, ' para todo tipo de camino')
FROM productos_cte;

SELECT * FROM productos LIMIT 20;

-- Insertar ventas (120 registros) y mostrar
INSERT INTO ventas (id_cliente, fecha_venta, total)
WITH RECURSIVE ventas_cte(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM ventas_cte WHERE n < 120
)
SELECT 
    FLOOR(RAND() * 100) + 1,
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY),
    ROUND(RAND() * 2000 + 100, 2)
FROM ventas_cte;

SELECT * FROM ventas LIMIT 20;

-- Insertar detalle_venta (150 registros) y mostrar
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
WITH RECURSIVE detalle_cte(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1 FROM detalle_cte WHERE n < 150
)
SELECT 
    FLOOR(RAND() * 120) + 1,
    FLOOR(RAND() * 90) + 1,
    FLOOR(RAND() * 4) + 1,
    ROUND(RAND() * 500 + 100, 2),
    ROUND(RAND() * 2000 + 50, 2)
FROM detalle_cte;

SELECT * FROM detalle_venta LIMIT 20;
----------------------------------------------------------------------------------------------
-- 2.	Realizar 5 Consultas SQL Básicas 
-- Consulta 1: Clientes registrados en los últimos 30 días
SELECT * FROM clientes 
WHERE fecha_registro >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) 
LIMIT 20;

-- Consulta 2: Productos de la marca Michelin con precio mayor a 300
SELECT * FROM productos 
WHERE marca = 'Michelin' AND precio > 300 
LIMIT 10;

-- Consulta 3: Ventas con total mayor a 1000 realizadas en el último mes
SELECT * FROM ventas 
WHERE total > 1000 AND fecha_venta >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) 
LIMIT 10;
-- LIKE
-- Consulta 1: Clientes cuyo nombre contiene "Cliente 1"
SELECT * FROM clientes 
WHERE nombre LIKE '%Cliente 1%' 
LIMIT 10;

-- Consulta 2: Productos que son "Todo Terreno"
SELECT * FROM productos 
WHERE nombre LIKE '%Todo Terreno%' 
LIMIT 10;

-- Consulta 3: Productos de marcas que empiezan con "P"
SELECT * FROM productos 
WHERE marca LIKE 'P%' 
LIMIT 10;

-- ORDER BY
-- Consulta 1: Productos ordenados por precio de mayor a menor
SELECT * FROM productos 
ORDER BY precio DESC 
LIMIT 10;

-- Consulta 2: Clientes ordenados alfabéticamente por nombre
SELECT * FROM clientes 
ORDER BY nombre ASC 
LIMIT 10;

-- Consulta 3: Ventas ordenadas por fecha
-- más reciente y total más alto
SELECT * FROM ventas 
ORDER BY fecha_venta DESC, total DESC 
LIMIT 10;

-- GROUP BY
-- Consulta 1: Total de ventas por cliente
SELECT id_cliente, COUNT(*) as total_ventas, SUM(total) as monto_total
FROM ventas 
GROUP BY id_cliente 
LIMIT 10;

-- Consulta 2: Cantidad de productos por marca
SELECT marca, COUNT(*) as cantidad_productos, AVG(precio) as precio_promedio
FROM productos 
GROUP BY marca 
LIMIT 10;

-- Consulta 3: Ventas totales por mes
SELECT YEAR(fecha_venta) as año, MONTH(fecha_venta) as mes, 
       COUNT(*) as total_ventas, SUM(total) as monto_total
FROM ventas 
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
LIMIT 10;

-- Consulta: Estadísticas generales de ventas
SELECT 
    COUNT(*) as total_ventas,
    SUM(total) as ingreso_total,
    AVG(total) as promedio_venta,
    MAX(total) as venta_mas_alta,
    MIN(total) as venta_mas_baja
FROM ventas;
------------------------------------------------------------------------------------------
-- 3.	Realizar 3 Subconsultas 
-- Consulta 1: Clientes que han realizado compras superiores a 1500
SELECT * FROM clientes 
WHERE id_cliente IN (
    SELECT id_cliente FROM ventas WHERE total > 1500
) 
LIMIT 10;

-- Consulta 2: Productos que nunca han sido vendidos
SELECT * FROM productos 
WHERE id_producto NOT IN (
    SELECT DISTINCT id_producto FROM detalle_venta
) 
LIMIT 10;

-- Consulta 3: Ventas con monto superior al promedio
SELECT * FROM ventas 
WHERE total > (
    SELECT AVG(total) FROM ventas
) 
LIMIT 10;

-- FROM
-- Consulta 1: Promedio de ventas por cliente con
-- clientes que superan el promedio general
SELECT cliente_ventas.id_cliente, 
       cliente_ventas.promedio_venta
FROM (
    SELECT id_cliente, AVG(total) as promedio_venta
    FROM ventas 
    GROUP BY id_cliente
) as cliente_ventas
WHERE cliente_ventas.promedio_venta > (
    SELECT AVG(total) FROM ventas
)
LIMIT 10;

-- Consulta 2: Productos con stock bajo comparado con el promedio de stock
SELECT productos_stock.*
FROM (
    SELECT id_producto, nombre, stock,
           (SELECT AVG(stock) FROM productos) as promedio_general
    FROM productos
) as productos_stock
WHERE productos_stock.stock < productos_stock.promedio_general
LIMIT 10;

-- Consulta 3: Clientes con mayor cantidad de ventas
SELECT clientes_ventas.*,
       RANK() OVER (ORDER BY clientes_ventas.total_ventas DESC) as ranking
FROM (
    SELECT c.id_cliente, c.nombre, COUNT(v.id_venta) as total_ventas
    FROM clientes c
    LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
    GROUP BY c.id_cliente, c.nombre
) as clientes_ventas
ORDER BY clientes_ventas.total_ventas DESC
LIMIT 10;

-- Funciones Agregadas
-- Consulta 1: Productos con precio mayor al promedio de su marca
SELECT * FROM productos p1
WHERE precio > (
    SELECT AVG(precio) 
    FROM productos p2 
    WHERE p2.marca = p1.marca
)
LIMIT 10;

-- Consulta 2: Clientes con ventas superiores al promedio de ventas por cliente
SELECT * FROM clientes c
WHERE (
    SELECT AVG(total) 
    FROM ventas v 
    WHERE v.id_cliente = c.id_cliente
) > (
    SELECT AVG(total) 
    FROM ventas)
LIMIT 10;

-- Consulta 3: Ventas con monto mayor al doble del promedio de ventas del cliente
SELECT * FROM ventas v1
WHERE total > 2 * (
    SELECT AVG(total) 
    FROM ventas v2 
    WHERE v2.id_cliente = v1.id_cliente
)
LIMIT 10;
------------------------------------------------------------------------------------------
-- 4.	Crear 3 Índices
-- Indice en la tabla ventas para el campo id_cliente
CREATE INDEX idx_ventas_cliente ON ventas(id_cliente);

-- Consulta SIN índice:
SELECT SQL_NO_CACHE * FROM ventas IGNORE INDEX(idx_ventas_cliente) 
WHERE id_cliente = 1;

-- Misma consulta CON índice
CREATE INDEX idx_ventas_cliente ON ventas(id_cliente);
SELECT * FROM ventas WHERE id_cliente = 1;
------------------------------------------------------------------------------------------
-- 5.	Evaluación de Rendimiento con Índices 
-- Consulta lenta 1 SIN índice: Ventas de los últimos 30 días por cliente específico
SELECT SQL_NO_CACHE v.*, c.nombre 
FROM ventas v IGNORE INDEX(idx_ventas_cliente)
JOIN clientes c ON v.id_cliente = c.id_cliente 
WHERE v.id_cliente = 1 
AND v.fecha_venta >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Consulta lenta 2 SIN índice: Estadísticas de ventas agrupadas por cliente
SELECT SQL_NO_CACHE 
    c.id_cliente,
    c.nombre,
    COUNT(v.id_venta) as total_ventas,
    SUM(v.total) as monto_total
FROM ventas v IGNORE INDEX(idx_ventas_cliente)
JOIN clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING COUNT(v.id_venta) > 2;

-- Crear índice compuesto para optimizar ambas consultas
CREATE INDEX idx_ventas_cliente_fecha ON ventas(id_cliente, fecha_venta);

-- Ejecutar Consulta 1 CON índice: Ventas de los últimos 30 días por cliente específico
SELECT SQL_NO_CACHE v.*, c.nombre 
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente 
WHERE v.id_cliente = 1 
AND v.fecha_venta >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Ejecutar Consulta 2 CON índice: Estadísticas de ventas agrupadas por cliente
SELECT SQL_NO_CACHE 
    c.id_cliente,
    c.nombre,
    COUNT(v.id_venta) as total_ventas,
    SUM(v.total) as monto_total
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre
HAVING COUNT(v.id_venta) > 2;
---------------------------------------------------------------------------------------------------------
-- 6.	Crear 3 Vistas 
-- Vista 1: Resumen de ventas por cliente
CREATE VIEW vista_ventas_clientes AS
SELECT 
    c.id_cliente,
    c.nombre as cliente,
    c.email,
    COUNT(v.id_venta) as total_compras,
    SUM(v.total) as monto_total_gastado,
    MAX(v.fecha_venta) as ultima_compra
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre, c.email;

-- Vista 2: Detalle completo de ventas con información de productos
CREATE VIEW vista_detalle_ventas_completo AS
SELECT 
    v.id_venta,
    v.fecha_venta,
    c.nombre as cliente,
    p.nombre as producto,
    p.marca,
    dv.cantidad,
    dv.precio_unitario,
    dv.subtotal,
    v.total as total_venta
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN detalle_venta dv ON v.id_venta = dv.id_venta
JOIN productos p ON dv.id_producto = p.id_producto;

-- Vista 3: Análisis de productos más vendidos
CREATE VIEW vista_productos_populares AS
SELECT 
    p.id_producto,
    p.nombre,
    p.marca,
    p.precio,
    SUM(dv.cantidad) as total_vendido,
    SUM(dv.subtotal) as ingresos_totales,
    COUNT(DISTINCT dv.id_venta) as veces_vendido
FROM productos p
LEFT JOIN detalle_venta dv ON p.id_producto = dv.id_producto
GROUP BY p.id_producto, p.nombre, p.marca, p.precio;

-- 2. CONSULTAS QUE UTILIZAN
-- Consulta Vista 1: Clientes con mayor gasto
SELECT * FROM vista_ventas_clientes 
WHERE monto_total_gastado > 1000 
ORDER BY monto_total_gastado DESC 
LIMIT 10;

-- Consulta Vista 2: Ventas del último mes con detalle
SELECT * FROM vista_detalle_ventas_completo 
WHERE fecha_venta >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) 
ORDER BY fecha_venta DESC 
LIMIT 15;

-- Consulta Vista 3: Productos más rentables
SELECT * FROM vista_productos_populares 
WHERE total_vendido > 0 
ORDER BY ingresos_totales DESC 
LIMIT 10;
--------------------------------------------------------------------------
-- Transacciones 
-- TRANSACCIÓN 1: Proceso de venta completo
START TRANSACTION;
INSERT INTO ventas (id_cliente, fecha_venta, total) 
VALUES (15, CURDATE(), 1850.00);
SET @nueva_venta_id = LAST_INSERT_ID();
SAVEPOINT after_venta;
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
VALUES 
(@nueva_venta_id, 5, 2, 450.00, 900.00),
(@nueva_venta_id, 12, 1, 950.00, 950.00);
UPDATE productos SET stock = stock - 2 WHERE id_producto = 5;
UPDATE productos SET stock = stock - 1 WHERE id_producto = 12;
COMMIT;
-- SALIDA FINAL: Venta completada exitosamente
SELECT 'Transacción 1: Venta procesada correctamente. ID Venta: ' || @nueva_venta_id AS Resultado;


-- TRANSACCIÓN 2: Transferencia de stock entre productos
START TRANSACTION;
-- Operación 1: Reducir stock de producto con exceso
UPDATE productos SET stock = stock - 10 WHERE id_producto = 8;
SAVEPOINT after_stock_reduction;
-- Operación 2: Aumentar stock de producto con falta
UPDATE productos SET stock = stock + 10 WHERE id_producto = 22;
-- Verificación manual (se haría fuera de la transacción)
-- Si hay error, se puede hacer: ROLLBACK TO SAVEPOINT after_stock_reduction;
COMMIT;
SELECT 'Transacción 3: Transferencia de stock completada' AS Resultado;

-- TRANSACCIÓN 1: Proceso de venta completo
START TRANSACTION;

-- Operación 3: Insertar nueva venta
INSERT INTO ventas (id_cliente, fecha_venta, total) 
VALUES (15, CURDATE(), 1850.00);
SET @nueva_venta_id = LAST_INSERT_ID();
SAVEPOINT after_venta;
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
VALUES 
(@nueva_venta_id, 5, 2, 450.00, 900.00),
(@nueva_venta_id, 12, 1, 950.00, 950.00);
UPDATE productos SET stock = stock - 2 WHERE id_producto = 5;
UPDATE productos SET stock = stock - 1 WHERE id_producto = 12;
COMMIT;
SELECT 'Transacción 1: Venta procesada correctamente' AS Resultado;
-------------------------------------------------------------------------------------------------

-- PROCEDIMIENTO 1: Registrar nueva venta
DELIMITER //
CREATE PROCEDURE sp_registrar_venta(
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio_unitario DECIMAL(10,2);
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_id_venta INT;
    SELECT precio INTO v_precio_unitario 
    FROM productos WHERE id_producto = p_id_producto;
    SET v_subtotal = v_precio_unitario * p_cantidad;
    SET v_total = v_subtotal;
    INSERT INTO ventas (id_cliente, fecha_venta, total) 
    VALUES (p_id_cliente, CURDATE(), v_total);
    SET v_id_venta = LAST_INSERT_ID();
    INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario, subtotal)
    VALUES (v_id_venta, p_id_producto, p_cantidad, v_precio_unitario, v_subtotal);
    UPDATE productos SET stock = stock - p_cantidad 
    WHERE id_producto = p_id_producto;
    SELECT CONCAT('Venta registrada exitosamente. ID: ', v_id_venta) AS Mensaje;
END //
DELIMITER ;
-- Ejecución
CALL sp_registrar_venta(5, 10, 2);

-- PROCEDIMIENTO 2: Generar reporte de cliente
DELIMITER //
CREATE PROCEDURE sp_reporte_cliente(
    IN p_id_cliente INT
)
BEGIN
    DECLARE v_nombre_cliente VARCHAR(100);
    DECLARE v_total_ventas INT;
    DECLARE v_monto_total DECIMAL(12,2);
    DECLARE v_ultima_compra DATE;
    SELECT nombre INTO v_nombre_cliente 
    FROM clientes WHERE id_cliente = p_id_cliente;
    SELECT 
        COUNT(*), 
        SUM(total), 
        MAX(fecha_venta)
    INTO v_total_ventas, v_monto_total, v_ultima_compra
    FROM ventas 
    WHERE id_cliente = p_id_cliente;
    IF v_total_ventas IS NULL THEN
        SET v_total_ventas = 0;
        SET v_monto_total = 0;
        SET v_ultima_compra = NULL;
    END IF;
    SELECT 
        v_nombre_cliente AS Cliente,
        v_total_ventas AS 'Total Ventas',
        CONCAT('$', ROUND(v_monto_total, 2)) AS 'Monto Total',
        v_ultima_compra AS 'Última Compra',
        CASE 
            WHEN v_monto_total > 5000 THEN 'Cliente VIP'
            WHEN v_monto_total > 1000 THEN 'Cliente Frecuente'
            ELSE 'Cliente Regular'
        END AS Categoria;
END //
DELIMITER ;
-- Ejecución
CALL sp_reporte_cliente(1);

-- PROCEDIMIENTO 3: Rotación de inventario y reabastecimiento
DELIMITER //
CREATE PROCEDURE sp_gestion_inventario(
    IN p_marca VARCHAR(50),
    IN p_stock_minimo INT
)
BEGIN
    DECLARE v_total_productos INT;
    DECLARE v_productos_bajo_stock INT;
    DECLARE v_inversion_estimada DECIMAL(12,2);
    DECLARE v_producto_mas_vendido VARCHAR(100);
    SELECT COUNT(*) INTO v_total_productos 
    FROM productos WHERE marca = p_marca;
    SELECT COUNT(*) INTO v_productos_bajo_stock
    FROM productos 
    WHERE marca = p_marca AND stock < p_stock_minimo;
    SELECT SUM((p_stock_minimo - stock) * precio) INTO v_inversion_estimada
    FROM productos 
    WHERE marca = p_marca AND stock < p_stock_minimo;
    SELECT p.nombre INTO v_producto_mas_vendido
    FROM productos p
    JOIN detalle_venta dv ON p.id_producto = dv.id_producto
    WHERE p.marca = p_marca
    GROUP BY p.id_producto, p.nombre
    ORDER BY SUM(dv.cantidad) DESC
    LIMIT 1;
    SELECT 
        p_marca AS Marca,
        v_total_productos AS 'Total Productos',
        v_productos_bajo_stock AS 'Productos Bajo Stock',
        CONCAT('$', ROUND(COALESCE(v_inversion_estimada, 0), 2)) AS 'Inversión Estimada',
        COALESCE(v_producto_mas_vendido, 'Sin ventas') AS 'Producto Más Vendido',
        CASE 
            WHEN v_productos_bajo_stock = 0 THEN 'Inventario Óptimo'
            WHEN v_productos_bajo_stock <= 3 THEN 'Revisión Recomendada'
            ELSE 'Reabastecimiento Urgente'
        END AS Estado;
    IF v_productos_bajo_stock > 0 THEN
        UPDATE productos 
        SET descripcion = CONCAT(descripcion, ' - REVISAR STOCK')
        WHERE marca = p_marca AND stock < p_stock_minimo;
        SELECT CONCAT('Se marcaron ', ROW_COUNT(), ' productos para revisión') AS Accion;
    END IF;
END //
DELIMITER ;
-- Ejecución
CALL sp_gestion_inventario('Michelin', 15);