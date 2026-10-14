-- Tarea 13. Grano 1: una fila por cuenta con eventos.
WITH movimientos_por_cuenta AS (
    SELECT account_id, COUNT(*) AS eventos,
           SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS volumen_bruto
    FROM core.transactions
    GROUP BY account_id
),
-- Grano 2: una fila por cuenta activa, incluso sin eventos.
cuentas_activas AS (
    SELECT a.account_id, a.account_number, a.currency,
           COALESCE(m.eventos, 0) AS eventos,
           COALESCE(m.volumen_bruto, 0) AS volumen_bruto
    FROM core.accounts a
    LEFT JOIN movimientos_por_cuenta m ON m.account_id = a.account_id
    WHERE a.is_active = TRUE
),
-- Grano 3: una fila por moneda.
resumen_por_moneda AS (
    SELECT currency,
           COUNT(*) AS numero_cuentas,
           SUM(volumen_bruto) AS volumen_bruto_total,
           ROUND(AVG(volumen_bruto), 2) AS promedio_por_cuenta
    FROM cuentas_activas
    GROUP BY currency
)
SELECT currency, numero_cuentas, volumen_bruto_total, promedio_por_cuenta
FROM resumen_por_moneda ORDER BY currency;
-- COALESCE introduce el cero de ACCT-3002 en cuentas_activas.
-- AVG se calcula después, usando las cuatro cuentas en el denominador.
-- Semilla: USD | 4 cuentas | 800 volumen | 200.00 promedio.

-- Verificación independiente del denominador.
SELECT COUNT(*) AS cuentas_activas
FROM core.accounts WHERE is_active = TRUE;

-- Verificación independiente del numerador.
SELECT COUNT(*) AS movimientos, SUM(amount) AS volumen_bruto
FROM core.transactions;

-- Verificación de la cuenta sin eventos.
SELECT a.account_number, COUNT(t.transaction_id) AS eventos,
       COALESCE(SUM(t.amount), 0) AS volumen_bruto
FROM core.accounts a
LEFT JOIN core.transactions t ON t.account_id = a.account_id
WHERE a.account_number = 'ACCT-3002'
GROUP BY a.account_number;
