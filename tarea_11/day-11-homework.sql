-- Tarea 11. Cinco cuentas; una desactivada = 20.00%.
SELECT
    COUNT(*) AS cuentas_totales,
    COUNT(*) FILTER (WHERE is_active = FALSE) AS cuentas_desactivadas,
    ROUND(
        100.0 * (COUNT(*) FILTER (WHERE is_active = FALSE))::NUMERIC
        / NULLIF(COUNT(*)::NUMERIC, 0),
        2
    ) AS porcentaje_desactivadas
FROM core.accounts;

-- Una fila por evento anterior a 2026-09-10 00:00+00.
SELECT
    transaction_id,
    tx_timestamp,
    tx_timestamp + INTERVAL '15 days' AS fecha_revision,
    AGE(TIMESTAMPTZ '2026-10-01 00:00+00', tx_timestamp)
        AS antiguedad_al_corte
FROM core.transactions
WHERE tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00+00'
ORDER BY tx_timestamp, transaction_id;

-- Comprobación de los cuatro eventos de la ventana.
SELECT COUNT(*) AS eventos_esperados_cuatro
FROM core.transactions
WHERE tx_timestamp < TIMESTAMPTZ '2026-09-10 00:00+00';
-- El corte y filtro son constantes: ejecutar otro día no altera el cálculo.
-- Con la semilla, las revisiones corresponden al 16–19 de septiembre.
