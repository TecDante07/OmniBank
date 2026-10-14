-- Tarea 8: detección de patrones de riesgo AML.
SELECT
    transaction_id,
    amount,
    tx_type,
    tx_timestamp,
    COALESCE(description,
       'EXCLUSIÓN OPORTUNAMENTE DETECTADA - SIN MOTIVO DE PAGO')
       AS descripcion_monitoreada
FROM core.transactions
WHERE
    (
        amount >= 10000.00
        AND tx_type IN ('TRANSFER', 'WITHDRAWAL')
    )
    OR
    (
        description ILIKE '%crypto%'
        OR description ILIKE '%offshore%'
        OR description ILIKE '%shell%'
        OR description ILIKE '%casino%'
        OR (
            NULLIF(TRIM(description), '') IS NULL
            AND tx_type <> 'DEPOSIT'
        )
    )
ORDER BY amount DESC, tx_timestamp, transaction_id;
