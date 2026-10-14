-- Tarea 12. Conjunto A: cuentas ACTIVAS sin ningún movimiento.
SELECT a.account_number, a.is_active
FROM core.accounts a
WHERE a.is_active = TRUE
  AND NOT EXISTS (
      SELECT 1 FROM core.transactions t
      WHERE t.account_id = a.account_id
  )
ORDER BY a.account_number;

-- Control A: 1 cuenta (ACCT-3002).
SELECT COUNT(*) AS activas_sin_eventos
FROM core.accounts a
WHERE a.is_active = TRUE
  AND NOT EXISTS (
      SELECT 1 FROM core.transactions t WHERE t.account_id = a.account_id
  );

-- Conjunto B: TODAS las cuentas sin DEPOSIT.
SELECT a.account_number, a.is_active
FROM core.accounts a
WHERE NOT EXISTS (
    SELECT 1 FROM core.transactions t
    WHERE t.account_id = a.account_id AND t.tx_type = 'DEPOSIT'
)
ORDER BY a.account_number;

-- Control B: 4 cuentas (ACCT-1001, 1002, 2001, 3002).
SELECT COUNT(*) AS cuentas_sin_deposit
FROM core.accounts a
WHERE NOT EXISTS (
    SELECT 1 FROM core.transactions t
    WHERE t.account_id = a.account_id AND t.tx_type = 'DEPOSIT'
);

-- Demostración aislada, no usa tablas bancarias.
WITH muestra(valor) AS (
    VALUES (1), (2), (NULL::INTEGER)
)
SELECT
    3 NOT IN (SELECT valor FROM muestra) AS not_in_con_null,
    NOT EXISTS (
        SELECT 1 FROM muestra WHERE valor = 3
    ) AS not_exists_equivalente;
-- 3 NOT IN (1,2,NULL) devuelve UNKNOWN (NULL), no FALSE.
-- NOT EXISTS devuelve TRUE porque no hay ninguna fila igual a 3.
-- Una cuenta con TRANSFER puede estar en B pero no en A.
