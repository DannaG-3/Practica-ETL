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
    -- 1. order_id
    NULLIF(TRIM(order_id), '') AS order_id,

    -- 2. order_date
    CASE
        WHEN NULLIF(TRIM(order_date), '') IS NULL THEN NULL
        ELSE TO_DATE(REPLACE(TRIM(order_date), '-', '/'), 'DD/MM/YYYY')
    END AS order_date,

    -- 3. ship_date
    CASE
        WHEN NULLIF(TRIM(ship_date), '') IS NULL THEN NULL
        ELSE TO_DATE(REPLACE(TRIM(ship_date), '-', '/'), 'DD/MM/YYYY')
    END AS ship_date,

    -- 4. ship_mode
    NULLIF(UPPER(TRIM(ship_mode)), '') AS ship_mode,

    -- 5. customer_name
    NULLIF(TRIM(customer_name), '') AS customer_name,

    -- 6. segment
    NULLIF(UPPER(TRIM(segment)), '') AS segment,

    -- 7. state_name
    NULLIF(UPPER(TRIM(state_name)), '') AS state_name,

    -- 8. country
    NULLIF(UPPER(TRIM(country)), '') AS country,

    -- 9. market
    NULLIF(UPPER(TRIM(market)), '') AS market,

    -- 10. region
    NULLIF(UPPER(TRIM(region)), '') AS region,

    -- 11. product_id
    NULLIF(TRIM(product_id), '') AS product_id,

    -- 12. category
    NULLIF(UPPER(TRIM(category)), '') AS category,

    -- 13. sub_category
    NULLIF(UPPER(TRIM(sub_category)), '') AS sub_category,

    -- 14. product_name
    NULLIF(TRIM(product_name), '') AS product_name,

    -- 15. sales
    NULLIF(REPLACE(TRIM(sales), ',', ''), '')::INTEGER AS sales,

    -- 16. quantity
    NULLIF(REPLACE(TRIM(quantity), ',', ''), '')::INTEGER AS quantity,

    -- 17. discount
    NULLIF(REPLACE(TRIM(discount), ',', ''), '')::NUMERIC AS discount,

    -- 18. profit
    NULLIF(REPLACE(TRIM(profit), ',', ''), '')::NUMERIC AS profit,

    -- 19. shipping_cost
    NULLIF(REPLACE(TRIM(shipping_cost), ',', ''), '')::NUMERIC AS shipping_cost,

    -- 20. order_priority
    NULLIF(UPPER(TRIM(order_priority)), '') AS order_priority,

    -- 21. order_year
    NULLIF(REPLACE(TRIM(order_year), ',', ''), '')::INTEGER AS order_year

FROM staging.orders;

-- Verificar que los datos se hayan transformado correctamente
SELECT
    (SELECT COUNT(*) FROM staging.orders) AS total_staging,
    (SELECT COUNT(*) FROM transformation.orders) AS total_transformation;

-- Esperamos que total_staging y total_transformation sean iguales (51290 filas)
