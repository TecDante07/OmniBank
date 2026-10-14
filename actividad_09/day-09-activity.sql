-- Actividad 9. Punto de control: clientes=4, cuentas=5, eventos=4.
SELECT COUNT(*) AS clientes FROM core.customers;
SELECT COUNT(*) AS cuentas FROM core.accounts;
SELECT COUNT(*) AS movimientos FROM core.transactions;
-- Reporte 1: una fila por movimiento.
SELECT t.transaction_id,c.first_name,c.last_name,a.account_number,t.tx_type,t.amount
FROM core.transactions t
INNER JOIN core.accounts a ON a.account_id=t.account_id
INNER JOIN core.customers c ON c.customer_id=a.customer_id
ORDER BY t.tx_timestamp,t.transaction_id;
-- Reporte 2: una fila por cuenta sin movimientos.
SELECT a.account_number,a.is_active,
 CASE WHEN a.is_active THEN 'Activa sin movimientos' ELSE 'Desactivada sin movimientos' END AS etiqueta
FROM core.accounts a
LEFT JOIN core.transactions t ON t.account_id=a.account_id
WHERE t.transaction_id IS NULL
ORDER BY a.account_number;
-- Reporte 3: una fila por titular y cuenta elegible; conserva titulares sin pareja.
SELECT c.email,a.account_number,a.balance
FROM core.customers c
LEFT JOIN core.accounts a ON a.customer_id=c.customer_id AND a.balance>0
ORDER BY c.email,a.account_number;
-- Control ON vs WHERE: esta variante descarta titulares sin cuenta elegible.
SELECT c.email,a.account_number,a.balance
FROM core.customers c
LEFT JOIN core.accounts a ON a.customer_id=c.customer_id
WHERE a.balance>0
ORDER BY c.email,a.account_number;
-- ACCT-1002: desactivada; ACCT-3002: activa; ambas sin eventos.
