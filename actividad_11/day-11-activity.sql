-- Actividad 11: transformación de presentación sin modificar datos.
-- Grano: una fila por cuenta, incluidas desactivadas.
SELECT a.account_id,a.account_number,c.email,a.is_active,a.balance,
 UPPER(c.first_name||' '||c.last_name)||' · '||RIGHT(a.account_number,4) AS etiqueta,
 CASE WHEN a.is_active THEN 'ACTIVA' ELSE 'DESACTIVADA' END AS estado_visible
FROM core.accounts a JOIN core.customers c ON c.customer_id=a.customer_id
ORDER BY a.account_number;
-- Grano: una fila por evento anterior a 2026-09-10 UTC.
SELECT t.transaction_id,t.account_id,t.tx_timestamp,
 EXTRACT(YEAR FROM t.tx_timestamp AT TIME ZONE 'UTC') AS anio_utc,
 EXTRACT(MONTH FROM t.tx_timestamp AT TIME ZONE 'UTC') AS mes_utc,
 TO_CHAR(t.amount,'FM999999999990.00') AS importe_visible,
 t.tx_timestamp+INTERVAL '15 days' AS fecha_revision,
 AGE(TIMESTAMPTZ '2026-10-01 00:00+00',t.tx_timestamp) AS antiguedad_al_corte
FROM core.transactions t
WHERE t.tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00+00'
ORDER BY t.tx_timestamp,t.transaction_id;
SELECT COUNT(*) AS cuentas FROM core.accounts;
SELECT COUNT(*) AS eventos_en_ventana FROM core.transactions
WHERE tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00+00';
-- Ejemplo del registro 2026-09-01 12:00+00: revisión 2026-09-16 12:00+00.
-- ACCT-1002 desactivada no significa necesariamente ausencia de movimientos.
