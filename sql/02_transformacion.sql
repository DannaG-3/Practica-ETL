-- ============================================================================
-- Script SQL generado para limpieza y carga segura
-- Generado: 05/06/2026 02:35:38
-- Dialecto: PostgreSQL
-- ============================================================================

-- ============================================================================
-- 1. Crear tabla limpia
-- ============================================================================
CREATE TABLE IF NOT EXISTS "transformation"."datos_limpios" (
    "id_registro" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,    "order_id" TEXT,    "order_date" DATE,    "ship_date" DATE,    "ship_mode" TEXT,    "customer_name" TEXT,    "segment" TEXT,    "state_name" TEXT,    "country" TEXT,    "market" TEXT,    "region" TEXT,    "product_id" TEXT,    "category" TEXT,    "sub_category" TEXT,    "product_name" TEXT,    "sales" INTEGER,    "quantity" INTEGER,    "discount" NUMERIC(10,3),    "profit" NUMERIC(10,5),    "shipping_cost" NUMERIC(10,2),    "order_priority" TEXT,    "order_year" INTEGER);

CREATE INDEX IF NOT EXISTS "idx_datos_limpios_business_keys"
    ON "transformation"."datos_limpios" ("order_id", "product_id");

-- ============================================================================
-- 2. Crear tabla de cuarentena
-- ============================================================================
CREATE TABLE IF NOT EXISTS "transformation"."datos_cuarentena" (
    "id" BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha_rechazo TIMESTAMP,
    columna_erronea TEXT,
    categoria_error TEXT,
    valor_original TEXT,
    fila_completa_json TEXT
);

-- ============================================================================
-- 3. Insertar filas válidas en tabla limpia
-- ============================================================================
WITH cleaned_data AS (
    SELECT        TRIM(CAST(src."order_id" AS TEXT)) AS order_id_value,
        TRUE AS order_id_ok,
        CAST(src."order_id" AS TEXT) AS order_id_raw_text,        CASE WHEN (src."order_date" IS NULL OR TRIM(CAST(src."order_date" AS TEXT)) = '') THEN NULL WHEN (TRIM(CAST(src."order_date" AS TEXT)) ~ '^\d{1,4}[-/]\d{1,2}[-/]\d{1,4}( \d{1,2}:\d{1,2}:\d{1,2})?$') THEN CAST(TRIM(CAST(src."order_date" AS TEXT)) AS DATE) ELSE NULL END AS order_date_value,
        ((src."order_date" IS NULL OR TRIM(CAST(src."order_date" AS TEXT)) = '') OR (TRIM(CAST(src."order_date" AS TEXT)) ~ '^\d{1,4}[-/]\d{1,2}[-/]\d{1,4}( \d{1,2}:\d{1,2}:\d{1,2})?$')) AS order_date_ok,
        CAST(src."order_date" AS TEXT) AS order_date_raw_text,        CASE WHEN (src."ship_date" IS NULL OR TRIM(CAST(src."ship_date" AS TEXT)) = '') THEN NULL WHEN (TRIM(CAST(src."ship_date" AS TEXT)) ~ '^\d{1,4}[-/]\d{1,2}[-/]\d{1,4}( \d{1,2}:\d{1,2}:\d{1,2})?$') THEN CAST(TRIM(CAST(src."ship_date" AS TEXT)) AS DATE) ELSE NULL END AS ship_date_value,
        ((src."ship_date" IS NULL OR TRIM(CAST(src."ship_date" AS TEXT)) = '') OR (TRIM(CAST(src."ship_date" AS TEXT)) ~ '^\d{1,4}[-/]\d{1,2}[-/]\d{1,4}( \d{1,2}:\d{1,2}:\d{1,2})?$')) AS ship_date_ok,
        CAST(src."ship_date" AS TEXT) AS ship_date_raw_text,        TRIM(CAST(src."ship_mode" AS TEXT)) AS ship_mode_value,
        TRUE AS ship_mode_ok,
        CAST(src."ship_mode" AS TEXT) AS ship_mode_raw_text,        TRIM(CAST(src."customer_name" AS TEXT)) AS customer_name_value,
        TRUE AS customer_name_ok,
        CAST(src."customer_name" AS TEXT) AS customer_name_raw_text,        TRIM(CAST(src."segment" AS TEXT)) AS segment_value,
        TRUE AS segment_ok,
        CAST(src."segment" AS TEXT) AS segment_raw_text,        TRIM(CAST(src."state_name" AS TEXT)) AS state_value,
        TRUE AS state_ok,
        CAST(src."state_name" AS TEXT) AS state_raw_text,        TRIM(CAST(src."country" AS TEXT)) AS country_value,
        TRUE AS country_ok,
        CAST(src."country" AS TEXT) AS country_raw_text,        TRIM(CAST(src."market" AS TEXT)) AS market_value,
        TRUE AS market_ok,
        CAST(src."market" AS TEXT) AS market_raw_text,        TRIM(CAST(src."region" AS TEXT)) AS region_value,
        TRUE AS region_ok,
        CAST(src."region" AS TEXT) AS region_raw_text,        TRIM(CAST(src."product_id" AS TEXT)) AS product_id_value,
        TRUE AS product_id_ok,
        CAST(src."product_id" AS TEXT) AS product_id_raw_text,        TRIM(CAST(src."category" AS TEXT)) AS category_value,
        TRUE AS category_ok,
        CAST(src."category" AS TEXT) AS category_raw_text,        TRIM(CAST(src."sub_category" AS TEXT)) AS sub_category_value,
        TRUE AS sub_category_ok,
        CAST(src."sub_category" AS TEXT) AS sub_category_raw_text,        TRIM(CAST(src."product_name" AS TEXT)) AS product_name_value,
        TRUE AS product_name_ok,
        CAST(src."product_name" AS TEXT) AS product_name_raw_text,        CASE WHEN (src."sales" IS NULL OR TRIM(CAST(src."sales" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."sales" AS TEXT)), ',', '') ~ '^-?[0-9]+$') THEN CAST(REPLACE(TRIM(CAST(src."sales" AS TEXT)), ',', '') AS INTEGER) ELSE NULL END AS sales_value,
        ((src."sales" IS NULL OR TRIM(CAST(src."sales" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."sales" AS TEXT)), ',', '') ~ '^-?[0-9]+$')) AS sales_ok,
        CAST(src."sales" AS TEXT) AS sales_raw_text,        CASE WHEN (src."quantity" IS NULL OR TRIM(CAST(src."quantity" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."quantity" AS TEXT)), ',', '') ~ '^-?[0-9]+$') THEN CAST(REPLACE(TRIM(CAST(src."quantity" AS TEXT)), ',', '') AS INTEGER) ELSE NULL END AS quantity_value,
        ((src."quantity" IS NULL OR TRIM(CAST(src."quantity" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."quantity" AS TEXT)), ',', '') ~ '^-?[0-9]+$')) AS quantity_ok,
        CAST(src."quantity" AS TEXT) AS quantity_raw_text,        CASE WHEN (src."discount" IS NULL OR TRIM(CAST(src."discount" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."discount" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$') THEN CAST(REPLACE(TRIM(CAST(src."discount" AS TEXT)), ',', '') AS NUMERIC(10,3)) ELSE NULL END AS discount_value,
        ((src."discount" IS NULL OR TRIM(CAST(src."discount" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."discount" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$')) AS discount_ok,
        CAST(src."discount" AS TEXT) AS discount_raw_text,        CASE WHEN (src."profit" IS NULL OR TRIM(CAST(src."profit" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."profit" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$') THEN CAST(REPLACE(TRIM(CAST(src."profit" AS TEXT)), ',', '') AS NUMERIC(10,5)) ELSE NULL END AS profit_value,
        ((src."profit" IS NULL OR TRIM(CAST(src."profit" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."profit" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$')) AS profit_ok,
        CAST(src."profit" AS TEXT) AS profit_raw_text,        CASE WHEN (src."shipping_cost" IS NULL OR TRIM(CAST(src."shipping_cost" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."shipping_cost" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$') THEN CAST(REPLACE(TRIM(CAST(src."shipping_cost" AS TEXT)), ',', '') AS NUMERIC(10,2)) ELSE NULL END AS shipping_cost_value,
        ((src."shipping_cost" IS NULL OR TRIM(CAST(src."shipping_cost" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."shipping_cost" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$')) AS shipping_cost_ok,
        CAST(src."shipping_cost" AS TEXT) AS shipping_cost_raw_text,        TRIM(CAST(src."order_priority" AS TEXT)) AS order_priority_value,
        TRUE AS order_priority_ok,
        CAST(src."order_priority" AS TEXT) AS order_priority_raw_text,        CASE WHEN (src."order_year" IS NULL OR TRIM(CAST(src."order_year" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."order_year" AS TEXT)), ',', '') ~ '^-?[0-9]+$') THEN CAST(REPLACE(TRIM(CAST(src."order_year" AS TEXT)), ',', '') AS INTEGER) ELSE NULL END AS year_value,
        ((src."order_year" IS NULL OR TRIM(CAST(src."order_year" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."order_year" AS TEXT)), ',', '') ~ '^-?[0-9]+$')) AS year_ok,
        CAST(src."order_year" AS TEXT) AS year_raw_text,        CAST(ROW_TO_JSON(src) AS TEXT) AS fila_completa_json_raw
    FROM "staging"."orders" AS src
)
INSERT INTO "transformation"."datos_limpios" (    "order_id",    "order_date",    "ship_date",    "ship_mode",    "customer_name",    "segment",    "state_name",    "country",    "market",    "region",    "product_id",    "category",    "sub_category",    "product_name",    "sales",    "quantity",    "discount",    "profit",    "shipping_cost",    "order_priority",    "order_year")
SELECT    order_id_value,    order_date_value,    ship_date_value,    ship_mode_value,    customer_name_value,    segment_value,    state_value,    country_value,    market_value,    region_value,    product_id_value,    category_value,    sub_category_value,    product_name_value,    sales_value,    quantity_value,    discount_value,    profit_value,    shipping_cost_value,    order_priority_value,    year_value FROM cleaned_data
WHERE    order_id_ok AND    order_date_ok AND    ship_date_ok AND    ship_mode_ok AND    customer_name_ok AND    segment_ok AND    state_ok AND    country_ok AND    market_ok AND    region_ok AND    product_id_ok AND    category_ok AND    sub_category_ok AND    product_name_ok AND    sales_ok AND    quantity_ok AND    discount_ok AND    profit_ok AND    shipping_cost_ok AND    order_priority_ok AND    year_ok;

-- ============================================================================
-- 4. Insertar filas inválidas en cuarentena
-- ============================================================================
WITH cleaned_data AS (
    SELECT        TRIM(CAST(src."order_id" AS TEXT)) AS order_id_value,
        TRUE AS order_id_ok,
        CAST(src."order_id" AS TEXT) AS order_id_raw_text,        CASE WHEN (src."order_date" IS NULL OR TRIM(CAST(src."order_date" AS TEXT)) = '') THEN NULL WHEN (TRIM(CAST(src."order_date" AS TEXT)) ~ '^\d{1,4}[-/]\d{1,2}[-/]\d{1,4}( \d{1,2}:\d{1,2}:\d{1,2})?$') THEN CAST(TRIM(CAST(src."order_date" AS TEXT)) AS DATE) ELSE NULL END AS order_date_value,
        ((src."order_date" IS NULL OR TRIM(CAST(src."order_date" AS TEXT)) = '') OR (TRIM(CAST(src."order_date" AS TEXT)) ~ '^\d{1,4}[-/]\d{1,2}[-/]\d{1,4}( \d{1,2}:\d{1,2}:\d{1,2})?$')) AS order_date_ok,
        CAST(src."order_date" AS TEXT) AS order_date_raw_text,        CASE WHEN (src."ship_date" IS NULL OR TRIM(CAST(src."ship_date" AS TEXT)) = '') THEN NULL WHEN (TRIM(CAST(src."ship_date" AS TEXT)) ~ '^\d{1,4}[-/]\d{1,2}[-/]\d{1,4}( \d{1,2}:\d{1,2}:\d{1,2})?$') THEN CAST(TRIM(CAST(src."ship_date" AS TEXT)) AS DATE) ELSE NULL END AS ship_date_value,
        ((src."ship_date" IS NULL OR TRIM(CAST(src."ship_date" AS TEXT)) = '') OR (TRIM(CAST(src."ship_date" AS TEXT)) ~ '^\d{1,4}[-/]\d{1,2}[-/]\d{1,4}( \d{1,2}:\d{1,2}:\d{1,2})?$')) AS ship_date_ok,
        CAST(src."ship_date" AS TEXT) AS ship_date_raw_text,        TRIM(CAST(src."ship_mode" AS TEXT)) AS ship_mode_value,
        TRUE AS ship_mode_ok,
        CAST(src."ship_mode" AS TEXT) AS ship_mode_raw_text,        TRIM(CAST(src."customer_name" AS TEXT)) AS customer_name_value,
        TRUE AS customer_name_ok,
        CAST(src."customer_name" AS TEXT) AS customer_name_raw_text,        TRIM(CAST(src."segment" AS TEXT)) AS segment_value,
        TRUE AS segment_ok,
        CAST(src."segment" AS TEXT) AS segment_raw_text,        TRIM(CAST(src."state_name" AS TEXT)) AS state_value,
        TRUE AS state_ok,
        CAST(src."state_name" AS TEXT) AS state_raw_text,        TRIM(CAST(src."country" AS TEXT)) AS country_value,
        TRUE AS country_ok,
        CAST(src."country" AS TEXT) AS country_raw_text,        TRIM(CAST(src."market" AS TEXT)) AS market_value,
        TRUE AS market_ok,
        CAST(src."market" AS TEXT) AS market_raw_text,        TRIM(CAST(src."region" AS TEXT)) AS region_value,
        TRUE AS region_ok,
        CAST(src."region" AS TEXT) AS region_raw_text,        TRIM(CAST(src."product_id" AS TEXT)) AS product_id_value,
        TRUE AS product_id_ok,
        CAST(src."product_id" AS TEXT) AS product_id_raw_text,        TRIM(CAST(src."category" AS TEXT)) AS category_value,
        TRUE AS category_ok,
        CAST(src."category" AS TEXT) AS category_raw_text,        TRIM(CAST(src."sub_category" AS TEXT)) AS sub_category_value,
        TRUE AS sub_category_ok,
        CAST(src."sub_category" AS TEXT) AS sub_category_raw_text,        TRIM(CAST(src."product_name" AS TEXT)) AS product_name_value,
        TRUE AS product_name_ok,
        CAST(src."product_name" AS TEXT) AS product_name_raw_text,        CASE WHEN (src."sales" IS NULL OR TRIM(CAST(src."sales" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."sales" AS TEXT)), ',', '') ~ '^-?[0-9]+$') THEN CAST(REPLACE(TRIM(CAST(src."sales" AS TEXT)), ',', '') AS INTEGER) ELSE NULL END AS sales_value,
        ((src."sales" IS NULL OR TRIM(CAST(src."sales" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."sales" AS TEXT)), ',', '') ~ '^-?[0-9]+$')) AS sales_ok,
        CAST(src."sales" AS TEXT) AS sales_raw_text,        CASE WHEN (src."quantity" IS NULL OR TRIM(CAST(src."quantity" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."quantity" AS TEXT)), ',', '') ~ '^-?[0-9]+$') THEN CAST(REPLACE(TRIM(CAST(src."quantity" AS TEXT)), ',', '') AS INTEGER) ELSE NULL END AS quantity_value,
        ((src."quantity" IS NULL OR TRIM(CAST(src."quantity" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."quantity" AS TEXT)), ',', '') ~ '^-?[0-9]+$')) AS quantity_ok,
        CAST(src."quantity" AS TEXT) AS quantity_raw_text,        CASE WHEN (src."discount" IS NULL OR TRIM(CAST(src."discount" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."discount" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$') THEN CAST(REPLACE(TRIM(CAST(src."discount" AS TEXT)), ',', '') AS NUMERIC(10,3)) ELSE NULL END AS discount_value,
        ((src."discount" IS NULL OR TRIM(CAST(src."discount" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."discount" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$')) AS discount_ok,
        CAST(src."discount" AS TEXT) AS discount_raw_text,        CASE WHEN (src."profit" IS NULL OR TRIM(CAST(src."profit" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."profit" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$') THEN CAST(REPLACE(TRIM(CAST(src."profit" AS TEXT)), ',', '') AS NUMERIC(10,5)) ELSE NULL END AS profit_value,
        ((src."profit" IS NULL OR TRIM(CAST(src."profit" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."profit" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$')) AS profit_ok,
        CAST(src."profit" AS TEXT) AS profit_raw_text,        CASE WHEN (src."shipping_cost" IS NULL OR TRIM(CAST(src."shipping_cost" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."shipping_cost" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$') THEN CAST(REPLACE(TRIM(CAST(src."shipping_cost" AS TEXT)), ',', '') AS NUMERIC(10,2)) ELSE NULL END AS shipping_cost_value,
        ((src."shipping_cost" IS NULL OR TRIM(CAST(src."shipping_cost" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."shipping_cost" AS TEXT)), ',', '') ~ '^-?[0-9]+(\.[0-9]+)?$')) AS shipping_cost_ok,
        CAST(src."shipping_cost" AS TEXT) AS shipping_cost_raw_text,        TRIM(CAST(src."order_priority" AS TEXT)) AS order_priority_value,
        TRUE AS order_priority_ok,
        CAST(src."order_priority" AS TEXT) AS order_priority_raw_text,        CASE WHEN (src."order_year" IS NULL OR TRIM(CAST(src."order_year" AS TEXT)) = '') THEN NULL WHEN (REPLACE(TRIM(CAST(src."order_year" AS TEXT)), ',', '') ~ '^-?[0-9]+$') THEN CAST(REPLACE(TRIM(CAST(src."order_year" AS TEXT)), ',', '') AS INTEGER) ELSE NULL END AS year_value,
        ((src."order_year" IS NULL OR TRIM(CAST(src."order_year" AS TEXT)) = '') OR (REPLACE(TRIM(CAST(src."order_year" AS TEXT)), ',', '') ~ '^-?[0-9]+$')) AS year_ok,
        CAST(src."order_year" AS TEXT) AS year_raw_text,        CAST(ROW_TO_JSON(src) AS TEXT) AS fila_completa_json_raw
    FROM "staging"."orders" AS src
)
INSERT INTO "transformation"."datos_cuarentena" (
    fecha_rechazo,
    columna_erronea,
    categoria_error,
    valor_original,
    fila_completa_json
)SELECT
    CURRENT_TIMESTAMP,
    'order_id',
    'VALOR_INVALIDO',
    order_id_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT order_id_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'order_date',
    'FORMATO_FECHA_INVALIDO',
    order_date_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT order_date_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'ship_date',
    'FORMATO_FECHA_INVALIDO',
    ship_date_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT ship_date_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'ship_mode',
    'VALOR_INVALIDO',
    ship_mode_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT ship_mode_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'customer_name',
    'VALOR_INVALIDO',
    customer_name_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT customer_name_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'segment',
    'VALOR_INVALIDO',
    segment_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT segment_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'state_name',
    'VALOR_INVALIDO',
    state_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT state_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'country',
    'VALOR_INVALIDO',
    country_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT country_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'market',
    'VALOR_INVALIDO',
    market_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT market_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'region',
    'VALOR_INVALIDO',
    region_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT region_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'product_id',
    'VALOR_INVALIDO',
    product_id_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT product_id_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'category',
    'VALOR_INVALIDO',
    category_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT category_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'sub_category',
    'VALOR_INVALIDO',
    sub_category_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT sub_category_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'product_name',
    'VALOR_INVALIDO',
    product_name_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT product_name_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'sales',
    'TIPO_DATO_NUMERICO',
    sales_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT sales_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'quantity',
    'TIPO_DATO_NUMERICO',
    quantity_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT quantity_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'discount',
    'TIPO_DATO_NUMERICO',
    discount_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT discount_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'profit',
    'TIPO_DATO_NUMERICO',
    profit_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT profit_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'shipping_cost',
    'TIPO_DATO_NUMERICO',
    shipping_cost_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT shipping_cost_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'order_priority',
    'VALOR_INVALIDO',
    order_priority_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT order_priority_ok UNION ALL SELECT
    CURRENT_TIMESTAMP,
    'order_year',
    'TIPO_DATO_NUMERICO',
    year_raw_text,
    fila_completa_json_raw
FROM cleaned_data
WHERE NOT year_ok;

-- ============================================================================
-- 5. Validaciones posteriores
-- ============================================================================

SELECT COUNT(*) AS registros_cargados
FROM "transformation"."datos_limpios";

SELECT COUNT(*) AS registros_en_cuarentena
FROM "transformation"."datos_cuarentena";

SELECT
    columna_erronea,
    categoria_error,
    COUNT(*) AS total_errores
FROM "transformation"."datos_cuarentena"
GROUP BY columna_erronea, categoria_error
ORDER BY total_errores DESC;

SELECT    SUM(CASE WHEN "order_id" IS NULL THEN 1 ELSE 0 END) AS "order_id_nulos",    SUM(CASE WHEN "order_date" IS NULL THEN 1 ELSE 0 END) AS "order_date_nulos",    SUM(CASE WHEN "ship_date" IS NULL THEN 1 ELSE 0 END) AS "ship_date_nulos",    SUM(CASE WHEN "ship_mode" IS NULL THEN 1 ELSE 0 END) AS "ship_mode_nulos",    SUM(CASE WHEN "customer_name" IS NULL THEN 1 ELSE 0 END) AS "customer_name_nulos",    SUM(CASE WHEN "segment" IS NULL THEN 1 ELSE 0 END) AS "segment_nulos",    SUM(CASE WHEN "state_name" IS NULL THEN 1 ELSE 0 END) AS "state_nulos",    SUM(CASE WHEN "country" IS NULL THEN 1 ELSE 0 END) AS "country_nulos",    SUM(CASE WHEN "market" IS NULL THEN 1 ELSE 0 END) AS "market_nulos",    SUM(CASE WHEN "region" IS NULL THEN 1 ELSE 0 END) AS "region_nulos",    SUM(CASE WHEN "product_id" IS NULL THEN 1 ELSE 0 END) AS "product_id_nulos",    SUM(CASE WHEN "category" IS NULL THEN 1 ELSE 0 END) AS "category_nulos",    SUM(CASE WHEN "sub_category" IS NULL THEN 1 ELSE 0 END) AS "sub_category_nulos",    SUM(CASE WHEN "product_name" IS NULL THEN 1 ELSE 0 END) AS "product_name_nulos",    SUM(CASE WHEN "sales" IS NULL THEN 1 ELSE 0 END) AS "sales_nulos",    SUM(CASE WHEN "quantity" IS NULL THEN 1 ELSE 0 END) AS "quantity_nulos",    SUM(CASE WHEN "discount" IS NULL THEN 1 ELSE 0 END) AS "discount_nulos",    SUM(CASE WHEN "profit" IS NULL THEN 1 ELSE 0 END) AS "profit_nulos",    SUM(CASE WHEN "shipping_cost" IS NULL THEN 1 ELSE 0 END) AS "shipping_cost_nulos",    SUM(CASE WHEN "order_priority" IS NULL THEN 1 ELSE 0 END) AS "order_priority_nulos"FROM "transformation"."datos_limpios";

SELECT
    "order_id", "order_date", "ship_date",
    COUNT(*) AS count_duplicates
FROM "transformation"."datos_limpios"
GROUP BY "order_id", "order_date", "ship_date"
HAVING COUNT(*) > 1;
