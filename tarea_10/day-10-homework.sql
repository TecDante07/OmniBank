-- Tarea 10. Muestra didáctica; NO representa saldos reales.
WITH muestra(valor) AS (
    VALUES (10000::NUMERIC), (0::NUMERIC), (0::NUMERIC), (NULL::NUMERIC)
)
SELECT
    ROUND(AVG(valor), 2) AS promedio_ignorando_null,
    COUNT(valor) AS denominador_ignorando_null,
    ROUND(AVG(COALESCE(valor, 0)), 2) AS promedio_null_como_cero,
    COUNT(*) AS denominador_con_cero
FROM muestra;
-- 10000 / 3 = 3333.33; 10000 / 4 = 2500.00.

-- Grano: una fila por cuenta CREDIT activa que cumpla HAVING.
SELECT
    a.account_number,
    a.balance AS saldo_almacenado,
    COUNT(t.transaction_id) AS numero_movimientos,
    COALESCE(SUM(t.amount), 0) AS volumen_bruto_registrado
FROM core.accounts a
LEFT JOIN core.transactions t ON t.account_id = a.account_id
WHERE a.account_type = 'CREDIT' AND a.is_active = TRUE
GROUP BY a.account_id, a.account_number, a.balance
HAVING COUNT(t.transaction_id) = 0
    OR COALESCE(SUM(t.amount), 0) >= 300
ORDER BY a.account_number;
-- ACCT-3001: balance 0, 1 movimiento y volumen bruto 300.
-- Una cuenta con eventos por menos de 300 no cumple HAVING;
-- una cuenta sin eventos sí se conserva. Volumen no es saldo.
