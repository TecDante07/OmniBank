-- Tarea 9. Grano del producto: combinación arbitraria de
-- una fila de customers, una de accounts y una de transactions.
SELECT
    (SELECT COUNT(*) FROM core.customers) AS total_clientes,
    (SELECT COUNT(*) FROM core.accounts) AS total_cuentas,
    (SELECT COUNT(*) FROM core.transactions) AS total_movimientos,
    (SELECT COUNT(*) FROM core.customers)
      * (SELECT COUNT(*) FROM core.accounts)
      * (SELECT COUNT(*) FROM core.transactions) AS producto_calculado;

SELECT COUNT(*) AS producto_cartesiano
FROM core.customers c
CROSS JOIN core.accounts a
CROSS JOIN core.transactions t;
-- Con la semilla de 4 × 5 × 4, el producto es 80;
-- la mayoría de combinaciones no corresponde a relaciones reales.

-- Grano: una fila por movimiento real de titular activo e importe >= 100.
SELECT c.email, a.account_number, t.tx_type, t.amount, t.tx_timestamp
FROM core.transactions t
JOIN core.accounts a ON t.account_id = a.account_id
JOIN core.customers c ON a.customer_id = c.customer_id
WHERE c.is_active = TRUE AND t.amount >= 100
ORDER BY t.tx_timestamp, t.transaction_id;

-- Control de filas tras unir por claves, antes del filtro de importe.
SELECT COUNT(*) AS eventos_con_relaciones_reales
FROM core.transactions t
JOIN core.accounts a ON t.account_id = a.account_id
JOIN core.customers c ON a.customer_id = c.customer_id;

-- Control de filas después de los predicados WHERE.
SELECT COUNT(*) AS eventos_filtrados
FROM core.transactions t
JOIN core.accounts a ON t.account_id = a.account_id
JOIN core.customers c ON a.customer_id = c.customer_id
WHERE c.is_active = TRUE AND t.amount >= 100;
-- Se esperan 3 eventos filtrados. Las uniones eliminan parejas falsas;
-- WHERE restringe la población real a titulares activos y montos >= 100.
