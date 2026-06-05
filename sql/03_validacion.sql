-- Etapa L - Carga de datos

--Crear tabla analytics
DROP TABLE IF EXISTS analytics.orders;
CREATE TABLE analytics.orders (
    record_id BIGINT PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,
    order_date DATE NOT NULL,
    ship_date DATE NOT NULL,
    ship_mode VARCHAR(50) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    segment VARCHAR(50) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    market VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    sub_category VARCHAR(50) NOT NULL,
    product_name TEXT NOT NULL,
    sales INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    discount NUMERIC(4,3) NOT NULL,
    profit NUMERIC(12,5) NOT NULL,
    shipping_cost NUMERIC(8,2) NOT NULL,
    order_priority VARCHAR(50) NOT NULL,
    order_year INTEGER NOT NULL,

    CONSTRAINT chk_sales_non_negative
        CHECK (sales >= 0), -- Las ventas no pueden ser negativas

    CONSTRAINT chk_quantity_positive
        CHECK (quantity > 0), -- La cantidad debe ser mayor que cero

    CONSTRAINT chk_discount_range
        CHECK (discount BETWEEN 0 AND 1), -- El descuento debe estar entre 0 y 1

    CONSTRAINT chk_shipping_cost_non_negative
        CHECK (shipping_cost >= 0), -- El costo de envío no puede ser negativo

    CONSTRAINT chk_order_year_four_digits
        CHECK (order_year BETWEEN 1000 AND 9999) -- El año del pedido debe ser un número de cuatro dígitos
);