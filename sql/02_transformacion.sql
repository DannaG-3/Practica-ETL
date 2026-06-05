-- Etapa T: Transformación (Versión de Geraldine)

-- Crear tabla de transformación para órdenes

DROP TABLE IF EXISTS transformation.orders;
CREATE TABLE transformation.orders (
    record_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id TEXT,
    order_date DATE,
    ship_date DATE,
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
    sales INTEGER,
    quantity INTEGER,
    discount NUMERIC,
    profit NUMERIC,
    shipping_cost NUMERIC,
    order_priority TEXT,
    order_year INTEGER
);



--insertar datos transformados desde staging.orders a transformation.orders

TRUNCATE TABLE transformation.orders RESTART IDENTITY;
INSERT INTO transformation.orders (
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_name,
    segment,
    state_name,
    country,
    market,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit,
    shipping_cost,
    order_priority,
    order_year
)
SELECT

    NULLIF(TRIM(order_id), '') AS order_id, -- 1. order_id: Eliminar espacios en blanco y convertir a NULL si está vacío

    CASE
        WHEN NULLIF(TRIM(order_date), '') IS NULL THEN NULL
        ELSE TO_DATE(REPLACE(TRIM(order_date), '-', '/'), 'DD/MM/YYYY')
    END AS order_date, -- 2. order_date: Convertir a formato DATE, manejar valores vacíos como NULL
    CASE
        WHEN NULLIF(TRIM(ship_date), '') IS NULL THEN NULL
        ELSE TO_DATE(REPLACE(TRIM(ship_date), '-', '/'), 'DD/MM/YYYY')
    END AS ship_date, -- 3. ship_date: Convertir a formato DATE, manejar valores vacíos como NULL
    
    NULLIF(UPPER(TRIM(ship_mode)), '') AS ship_mode, -- 4. ship_mode: Convertir a mayúsculas, eliminar espacios en blanco y convertir a NULL si está vacío
    NULLIF(TRIM(customer_name), '') AS customer_name, -- 5. customer_name: Eliminar espacios en blanco y convertir a NULL si está vacío
    NULLIF(UPPER(TRIM(segment)), '') AS segment, -- 6. segment: Convertir a mayúsculas, eliminar espacios en blanco y convertir a NULL si está vacío
    NULLIF(UPPER(TRIM(state_name)), '') AS state_name, -- 7. state_name: Convertir a mayúsculas, eliminar espacios en blanco y convertir a NULL si está vacío
    NULLIF(UPPER(TRIM(country)), '') AS country, -- 8. country: Convertir a mayúsculas, eliminar espacios en blanco y convertir a NULL si está vacío
    NULLIF(UPPER(TRIM(market)), '') AS market, -- 9. market: Convertir a mayúsculas, eliminar espacios en blanco y convertir a NULL si está vacío
    NULLIF(UPPER(TRIM(region)), '') AS region, -- 10. region: Convertir a mayúsculas, eliminar espacios en blanco y convertir a NULL si está vacío
    NULLIF(TRIM(product_id), '') AS product_id, -- 11. product_id: Eliminar espacios en blanco y convertir a NULL si está vacío
    NULLIF(UPPER(TRIM(category)), '') AS category, -- 12. category: Convertir a mayúsculas, eliminar espacios en blanco y convertir a NULL si está vacío
    NULLIF(UPPER(TRIM(sub_category)), '') AS sub_category, -- 13. sub_category: Convertir a mayúsculas, eliminar espacios en blanco y convertir a NULL si está vacío
    NULLIF(TRIM(product_name), '') AS product_name, -- 14. product_name: Eliminar espacios en blanco y convertir a NULL si está vacío

    NULLIF(REPLACE(TRIM(sales), ',', ''), '')::INTEGER AS sales, -- 15. sales: Eliminar espacios en blanco, eliminar comas y convertir a INTEGER, manejar valores vacíos como NULL
    NULLIF(REPLACE(TRIM(quantity), ',', ''), '')::INTEGER AS quantity, -- 16. quantity: Eliminar espacios en blanco, eliminar comas y convertir a INTEGER, manejar valores vacíos como NULL
    NULLIF(REPLACE(TRIM(discount), ',', ''), '')::NUMERIC AS discount, -- 17. discount: Eliminar espacios en blanco, eliminar comas y convertir a NUMERIC, manejar valores vacíos como NULL
    NULLIF(REPLACE(TRIM(profit), ',', ''), '')::NUMERIC AS profit, -- 18. profit: Eliminar espacios en blanco, eliminar comas y convertir a NUMERIC, manejar valores vacíos como NULL
    NULLIF(REPLACE(TRIM(shipping_cost), ',', ''), '')::NUMERIC AS shipping_cost, -- 19. shipping_cost: Eliminar espacios en blanco, eliminar comas y convertir a NUMERIC, manejar valores vacíos como NULL

    NULLIF(UPPER(TRIM(order_priority)), '') AS order_priority, -- 20. order_priority: Convertir a mayúsculas, eliminar espacios en blanco y convertir a NULL si está vacío
    NULLIF(REPLACE(TRIM(order_year), ',', ''), '')::INTEGER AS order_year -- 21. order_year: Eliminar espacios en blanco, eliminar comas y convertir a INTEGER, manejar valores vacíos como NULL

FROM staging.orders;


-- Verificar que los datos se hayan transformado correctamente
SELECT
    (SELECT COUNT(*) FROM staging.orders) AS total_staging,
    (SELECT COUNT(*) FROM transformation.orders) AS total_transformation;
-- Esperamos que total_staging y total_transformation sean iguales (51290 filas)
