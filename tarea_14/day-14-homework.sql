-- Tarea 14. Grano: una fila por cuenta activa sin DEPOSIT.
SELECT
    a.account_number,
    a.account_type,
    c.first_name,
    c.last_name
FROM core.accounts a
JOIN core.customers c ON c.customer_id = a.customer_id
WHERE a.is_active = TRUE
  AND NOT EXISTS (
      SELECT 1 FROM core.transactions t
      WHERE t.account_id = a.account_id AND t.tx_type = 'DEPOSIT'
  )
ORDER BY a.account_number;

-- Contraste: cuentas que SÍ tienen algún movimiento.
SELECT DISTINCT a.account_number
FROM core.accounts a
JOIN core.transactions t ON t.account_id = a.account_id
ORDER BY a.account_number;

-- Control de cardinalidad: se esperan 3 cuentas activas sin DEPOSIT.
SELECT
    (SELECT COUNT(*) FROM core.accounts WHERE is_active = TRUE)
        AS cuentas_activas,
    (SELECT COUNT(*) FROM core.accounts a
     WHERE a.is_active = TRUE
       AND NOT EXISTS (
           SELECT 1 FROM core.transactions t
           WHERE t.account_id = a.account_id AND t.tx_type = 'DEPOSIT'
       )) AS activas_sin_deposit,
    (SELECT COUNT(*) FROM core.accounts a
     WHERE a.is_active = TRUE
       AND EXISTS (
           SELECT 1 FROM core.transactions t
           WHERE t.account_id = a.account_id AND t.tx_type = 'DEPOSIT'
       )) AS activas_con_deposit;

-- ACCT-1001 y ACCT-2001 pueden tener TRANSFER/WITHDRAWAL y no DEPOSIT.
-- ACCT-3002 no tiene eventos. Falta de DEPOSIT no implica falta de actividad.
-- El self JOIN de la actividad tiene grano de pareja no ordenada de
-- eventos de una misma cuenta (identificador estricto y <= 48 horas).
