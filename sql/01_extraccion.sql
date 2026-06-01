-- Etapa E: Extracción

--Crear base de datos
CREATE DATABASE super_store;

-- Conectar a la base de datos
\c super_store;

-- Crear esquemas
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS transformation;
CREATE SCHEMA IF NOT EXISTS analytics;

-- Crear tabla staging para órdenes
DROP TABLE IF EXISTS staging.orders;
CREATE TABLE staging.orders (
    order_id TEXT,
    order_date TEXT,
    ship_date TEXT,
    ship_mode TEXT,
    customer_name TEXT,
    segment TEXT,
    state_name TEXT,
    country TEXT,
    market TEXT,
    region TEXT,
    product_id TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT,
    sales TEXT,
    quantity TEXT,
    discount TEXT,
    profit TEXT,
    shipping_cost TEXT,
    order_priority TEXT,
    order_year TEXT
);

<<<<<<< HEAD
-- Importar datos usando el cliente psql (\copy)
-- NOTA: Debe ir en una sola línea, con diagonales normales (/) y SIN punto y coma al final.
\copy staging.orders FROM 'datos/SuperStoreOrders.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8')
=======
-- Importar datos desde el archivo CSV
\copy staging.orders 
FROM 'datos/SuperStoreOrders.csv' 
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');
>>>>>>> d8ded083bc8014973c5783f920673214d5d4a779

-- Verificar que los datos se hayan importado correctamente
SELECT COUNT(*) FROM staging.orders; -- Esperamos 51290 filas
SELECT * FROM staging.orders LIMIT 5;
