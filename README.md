![EPN](https://cem.epn.edu.ec/imagenes/logos_institucionales/big_png/EPN_logo_big.png)

## *Base de Datos - README*

# Sistema de Gestión de Llantas - MySQL

## Descripción del Proyecto
Creación de la base de datos *llantas_db* con 4 tablas relacionadas: clientes, productos, ventas y detalle_venta. Incluye claves primarias, foráneas y relaciones correctamente definidas.

##  Estructura de la Base de Datos

`clientes` → Información de clientes (100 registros)

`productos` → Catálogo de llantas (90 registros)

`ventas` → Registro de transacciones (120 registros)

`detalle_venta` → Detalle de productos por venta (150 registros)

---

### Consultas SQL
Implementación de consultas básicas y avanzadas:
- Filtros con WHERE y LIKE

- Ordenamientos con ORDER BY

- Agrupaciones con GROUP BY

- Funciones agregadas (SUM, AVG, COUNT)

- Subconsultas en WHERE y FROM

## Optimización con Índices
### Índices Creados
```sql
-- Índice simple
CREATE INDEX idx_ventas_cliente ON ventas(id_cliente);

-- Índice compuesto
CREATE INDEX idx_ventas_cliente_fecha ON ventas(id_cliente, fecha_venta);
```
### Requerimiento
```sql
-- Crear índice compuesto para optimizar ambas consultas
CREATE INDEX idx_ventas_cliente_fecha ON ventas(id_cliente, fecha_venta);
```

### Resultados de Rendimiento
| Consulta                  | Sin Índice | Con Índice | Mejora           |
|---------------------------|-----------|------------|------------------|
| Ventas por cliente        | 0.031 s   | 0.015 s    | 48x más rápido   |
| Requerimiento  | 0.110 s   | 0.031 s    | 35x más rápido   |

### Vistas
Tres vistas creadas para reportes comunes:
- Resumen de ventas por cliente
- Detalle completo de ventas
- Análisis de productos más vendidos

### Transacciones
Implementación de transacciones seguras con:
- START TRANSACTION
- SAVEPOINT para rollback parcial
- COMMIT para confirmar cambios
-  Operaciones atómicas para procesos de venta y transferencias.

### Procedimientos Almacenados
Tres procedimientos con lógica de negocio:
- Registrar venta con validación de stock
- Generar reporte de cliente con categorización
- Gestionar inventario con análisis de rotación

## Concluciones
### 1. Los índices mejoran 35-48x el rendimiento
La implementación estratégica de índices demostró que las consultas optimizadas son decenas de veces más rápidas que los escaneos completos de tabla, siendo crucial para grandes volúmenes de datos.

### 2. Vistas y procedimientos facilitan el mantenimiento
El uso de vistas simplifica consultas complejas para reportes, mientras que los procedimientos almacenados centralizan la lógica de negocio, mejorando la escalabilidad y consistencia del sistema.

### 3. Las transacciones garantizan integridad de datos
Las operaciones transaccionales con puntos de guardado previenen estados inconsistentes, asegurando que procesos complejos como ventas mantengan la integridad de la información ante posibles errores.

### Muchas gracias por leer
### -- Jossue  Chulde --
