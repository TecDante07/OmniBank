-- Actividad 14. Reporte 1: una fila por pareja no ordenada de eventos
-- de la misma cuenta con distancia temporal de hasta 48 horas.
SELECT a.account_number,t1.transaction_id AS evento_1,
 t2.transaction_id AS evento_2,t1.tx_timestamp AS instante_1,
 t2.tx_timestamp AS instante_2,
 ABS(EXTRACT(EPOCH FROM (t2.tx_timestamp-t1.tx_timestamp)))/3600 AS horas_entre_eventos
FROM core.transactions t1
JOIN core.transactions t2 ON t2.account_id=t1.account_id
 AND t1.transaction_id<t2.transaction_id
 AND ABS(EXTRACT(EPOCH FROM (t2.tx_timestamp-t1.tx_timestamp)))<=48*3600
JOIN core.accounts a ON a.account_id=t1.account_id
ORDER BY a.account_number,t1.transaction_id,t2.transaction_id;
-- Reporte 2: una fila por combinación cliente-tipo no registrada.
WITH tipos AS (
 SELECT unnest(enum_range(NULL::core.tipo_cuenta)) AS account_type
)
SELECT c.customer_id,c.email,tipos.account_type
FROM core.customers c CROSS JOIN tipos
WHERE NOT EXISTS (
 SELECT 1 FROM core.accounts a
 WHERE a.customer_id=c.customer_id AND a.account_type=tipos.account_type
)
ORDER BY c.email,tipos.account_type;
-- Controles: universo, combinaciones ocupadas, ausencias y par de John.
SELECT COUNT(*) AS posibilidades
FROM core.customers c CROSS JOIN unnest(enum_range(NULL::core.tipo_cuenta)) t;
SELECT COUNT(*) AS combinaciones_ocupadas FROM (
 SELECT DISTINCT customer_id,account_type FROM core.accounts
) x;
SELECT COUNT(*) AS posibilidades_ausentes
FROM core.customers c CROSS JOIN unnest(enum_range(NULL::core.tipo_cuenta)) AS tipos(account_type)
WHERE NOT EXISTS (SELECT 1 FROM core.accounts a
 WHERE a.customer_id=c.customer_id AND a.account_type=tipos.account_type);
SELECT COUNT(*) AS pares_john
FROM core.transactions t1 JOIN core.transactions t2
 ON t1.account_id=t2.account_id AND t1.transaction_id<t2.transaction_id
 AND ABS(EXTRACT(EPOCH FROM (t2.tx_timestamp-t1.tx_timestamp)))<=48*3600
JOIN core.accounts a ON a.account_id=t1.account_id
WHERE a.account_number='ACCT-1001';
-- El checkpoint indica 12 posibilidades y 5 ocupadas (7 faltantes).
