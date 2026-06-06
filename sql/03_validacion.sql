-- ============================================================================
-- Script de validación de datos
-- Generado: 05/06/2026 04:32:35
-- Dialecto: PostgreSQL
-- Tablas:
--   transformation.datos_limpios
--   transformation.datos_cuarentena
-- ============================================================================

-- ============================================================================
-- 1. Validar existencia de tablas
-- ============================================================================
SELECT
    table_schema,
    table_name
FROM information_schema.tables
WHERE table_schema = 'transformation'
  AND table_name IN ('datos_limpios', 'datos_cuarentena')
ORDER BY table_name;

-- ============================================================================
-- 2. Conteo general de registros
-- ============================================================================
SELECT
    'datos_limpios' AS tabla,
    COUNT(*) AS total_registros
FROM transformation.datos_limpios
UNION ALL
SELECT
    'datos_cuarentena' AS tabla,
    COUNT(*) AS total_registros
FROM transformation.datos_cuarentena;

-- ============================================================================
-- 3. Validar estructura de datos_limpios
-- ============================================================================
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'transformation'
  AND table_name = 'datos_limpios'
ORDER BY ordinal_position;

-- ============================================================================
-- 4. Validar estructura de datos_cuarentena
-- ============================================================================
SELECT
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_schema = 'transformation'
  AND table_name = 'datos_cuarentena'
ORDER BY ordinal_position;

-- ============================================================================
-- 5. Validar nulos en datos_limpios
-- ============================================================================
SELECT
    COUNT(*) AS total_filas,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulos,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS order_date_nulos,
    SUM(CASE WHEN ship_date IS NULL THEN 1 ELSE 0 END) AS ship_date_nulos,
    SUM(CASE WHEN ship_mode IS NULL THEN 1 ELSE 0 END) AS ship_mode_nulos,
    SUM(CASE WHEN customer_name IS NULL THEN 1 ELSE 0 END) AS customer_name_nulos,
    SUM(CASE WHEN segment IS NULL THEN 1 ELSE 0 END) AS segment_nulos,
    SUM(CASE WHEN state_name IS NULL THEN 1 ELSE 0 END) AS state_name_nulos,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulos,
    SUM(CASE WHEN market IS NULL THEN 1 ELSE 0 END) AS market_nulos,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS region_nulos,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nulos,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category_nulos,
    SUM(CASE WHEN sub_category IS NULL THEN 1 ELSE 0 END) AS sub_category_nulos,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS product_name_nulos,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS sales_nulos,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_nulos,
    SUM(CASE WHEN discount IS NULL THEN 1 ELSE 0 END) AS discount_nulos,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS profit_nulos,
    SUM(CASE WHEN shipping_cost IS NULL THEN 1 ELSE 0 END) AS shipping_cost_nulos,
    SUM(CASE WHEN order_priority IS NULL THEN 1 ELSE 0 END) AS order_priority_nulos,
    SUM(CASE WHEN order_year IS NULL THEN 1 ELSE 0 END) AS order_year_nulos
FROM transformation.datos_limpios;

-- ============================================================================
-- 6. Validar duplicados por llave de negocio
-- ============================================================================
SELECT
    order_id,
    product_id,
    COUNT(*) AS total_repeticiones
FROM transformation.datos_limpios
GROUP BY order_id, product_id
HAVING COUNT(*) > 1
ORDER BY total_repeticiones DESC, order_id, product_id;

-- ============================================================================
-- 7. Validar consistencia de fechas
-- ============================================================================
SELECT
    COUNT(*) AS fechas_inconsistentes
FROM transformation.datos_limpios
WHERE order_date IS NOT NULL
  AND ship_date IS NOT NULL
  AND ship_date < order_date;

-- ============================================================================
-- 8. Validar consistencia de año
-- ============================================================================
SELECT
    COUNT(*) AS anios_inconsistentes
FROM transformation.datos_limpios
WHERE order_date IS NOT NULL
  AND order_year IS NOT NULL
  AND EXTRACT(YEAR FROM order_date)::INTEGER <> order_year;

-- ============================================================================
-- 9. Validar rangos numéricos
-- ============================================================================
SELECT
    SUM(CASE WHEN sales < 0 THEN 1 ELSE 0 END) AS sales_negativos,
    SUM(CASE WHEN quantity < 0 THEN 1 ELSE 0 END) AS quantity_negativos,
    SUM(CASE WHEN discount < 0 OR discount > 1 THEN 1 ELSE 0 END) AS discount_fuera_rango_0_1,
    SUM(CASE WHEN shipping_cost < 0 THEN 1 ELSE 0 END) AS shipping_cost_negativos
FROM transformation.datos_limpios;

-- ============================================================================
-- 10. Resumen estadístico de campos numéricos
-- ============================================================================
SELECT
    MIN(sales) AS sales_min,
    MAX(sales) AS sales_max,
    AVG(sales) AS sales_avg,
    MIN(quantity) AS quantity_min,
    MAX(quantity) AS quantity_max,
    AVG(quantity) AS quantity_avg,
    MIN(discount) AS discount_min,
    MAX(discount) AS discount_max,
    AVG(discount) AS discount_avg,
    MIN(profit) AS profit_min,
    MAX(profit) AS profit_max,
    AVG(profit) AS profit_avg,
    MIN(shipping_cost) AS shipping_cost_min,
    MAX(shipping_cost) AS shipping_cost_max,
    AVG(shipping_cost) AS shipping_cost_avg
FROM transformation.datos_limpios;

-- ============================================================================
-- 11. Distribución por categoría
-- ============================================================================
SELECT
    category,
    COUNT(*) AS total_registros
FROM transformation.datos_limpios
GROUP BY category
ORDER BY total_registros DESC;

-- ============================================================================
-- 12. Distribución por mercado y región
-- ============================================================================
SELECT
    market,
    region,
    COUNT(*) AS total_registros
FROM transformation.datos_limpios
GROUP BY market, region
ORDER BY total_registros DESC;

-- ============================================================================
-- 13. Distribución por prioridad
-- ============================================================================
SELECT
    order_priority,
    COUNT(*) AS total_registros
FROM transformation.datos_limpios
GROUP BY order_priority
ORDER BY total_registros DESC;

-- ============================================================================
-- 14. Validar cuarentena por columna y categoría
-- ============================================================================
SELECT
    columna_erronea,
    categoria_error,
    COUNT(*) AS total_errores
FROM transformation.datos_cuarentena
GROUP BY columna_erronea, categoria_error
ORDER BY total_errores DESC, columna_erronea;

-- ============================================================================
-- 15. Validar valores originales en cuarentena
-- ============================================================================
SELECT
    columna_erronea,
    categoria_error,
    valor_original,
    COUNT(*) AS repeticiones
FROM transformation.datos_cuarentena
GROUP BY columna_erronea, categoria_error, valor_original
ORDER BY repeticiones DESC, columna_erronea
LIMIT 100;

-- ============================================================================
-- 16. Validar JSON en cuarentena
-- ============================================================================
SELECT
    COUNT(*) AS total_cuarentena,
    SUM(CASE WHEN fila_completa_json IS NULL THEN 1 ELSE 0 END) AS json_nulos,
    SUM(
        CASE
            WHEN fila_completa_json IS NOT NULL
             AND fila_completa_json::jsonb IS NOT NULL
            THEN 1
            ELSE 0
        END
    ) AS json_parseable
FROM transformation.datos_cuarentena;

-- ============================================================================
-- 17. Muestra de registros en cuarentena
-- ============================================================================
SELECT
    id,
    fecha_rechazo,
    columna_erronea,
    categoria_error,
    valor_original,
    fila_completa_json
FROM transformation.datos_cuarentena
ORDER BY id
LIMIT 50;

-- ============================================================================
-- 18. Validación final consolidada
-- ============================================================================
SELECT
    'VALIDACION_FINAL' AS tipo_validacion,
    (SELECT COUNT(*) FROM transformation.datos_limpios) AS total_limpios,
    (SELECT COUNT(*) FROM transformation.datos_cuarentena) AS total_cuarentena,
    (
        SELECT COUNT(*)
        FROM transformation.datos_limpios
        WHERE order_date IS NOT NULL
          AND ship_date IS NOT NULL
          AND ship_date < order_date
    ) AS fechas_inconsistentes,
    (
        SELECT COUNT(*)
        FROM transformation.datos_limpios
        WHERE order_date IS NOT NULL
          AND order_year IS NOT NULL
          AND EXTRACT(YEAR FROM order_date)::INTEGER <> order_year
    ) AS anios_inconsistentes,
    (
        SELECT COUNT(*)
        FROM (
            SELECT order_id, product_id
            FROM transformation.datos_limpios
            GROUP BY order_id, product_id
            HAVING COUNT(*) > 1
        ) duplicados
    ) AS combinaciones_order_product_duplicadas;