-- Actividad 10. Reporte 1: una fila por tipo de cuenta activo.
SELECT account_type,COUNT(*) AS cuentas,
 SUM(balance) AS saldo_almacenado_total,
 MIN(balance) AS saldo_almacenado_minimo,
 MAX(balance) AS saldo_almacenado_maximo,
 ROUND(AVG(balance),2) AS saldo_almacenado_promedio
FROM core.accounts WHERE is_active
GROUP BY account_type
ORDER BY saldo_almacenado_total DESC,account_type;
-- Reporte 2: una fila por titular elegible; movimientos contados por ID.
SELECT c.customer_id,c.email,COUNT(t.transaction_id) AS movimientos,
 COALESCE(SUM(t.amount),0) AS volumen_bruto_registrado
FROM core.customers c
LEFT JOIN core.accounts a ON a.customer_id=c.customer_id
LEFT JOIN core.transactions t ON t.account_id=a.account_id
GROUP BY c.customer_id,c.email
HAVING COUNT(t.transaction_id)>=2 OR COALESCE(SUM(t.amount),0)>100
ORDER BY volumen_bruto_registrado DESC,c.email;
-- Controles independientes.
SELECT COUNT(*) AS cuentas_activas,SUM(balance) AS saldo_total_activo
FROM core.accounts WHERE is_active;
SELECT account_id,COUNT(transaction_id) AS eventos,SUM(amount) AS volumen_bruto
FROM core.transactions GROUP BY account_id ORDER BY account_id;
SELECT COUNT(*) AS eventos,SUM(amount) AS volumen_bruto
FROM core.transactions;
-- CREDIT puede tener balance=0 y volumen histórico=300: no son la misma medida.
