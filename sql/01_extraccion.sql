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

-- Importar datos desde el archivo CSV
\copy staging.orders 
FROM 'C:/datos/SuperStoreOrders.csv' 
WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

-- Verificar que los datos se hayan importado correctamente
SELECT COUNT(*) FROM staging.orders; -- Esperamos 51290 filas
SELECT * FROM staging.orders LIMIT 5;
