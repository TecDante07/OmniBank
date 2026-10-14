-- Actividad 12. Grano: un evento cuyo importe supera su propia media.
SELECT t.transaction_id,a.account_number,t.amount,
 (SELECT AVG(t2.amount) FROM core.transactions t2
  WHERE t2.account_id=t.account_id) AS promedio_cuenta
FROM core.transactions t
JOIN core.accounts a ON a.account_id=t.account_id
WHERE t.amount>(SELECT AVG(t3.amount) FROM core.transactions t3
                WHERE t3.account_id=t.account_id)
ORDER BY a.account_number,t.transaction_id;
-- Control: una fila por cuenta que tenga movimientos.
SELECT a.account_number,COUNT(t.transaction_id) AS eventos,
 AVG(t.amount) AS promedio_cuenta
FROM core.accounts a JOIN core.transactions t ON t.account_id=a.account_id
GROUP BY a.account_id,a.account_number ORDER BY a.account_number;
-- Ausencias: una fila por cuenta sin ningún evento.
SELECT a.account_number,a.is_active FROM core.accounts a
WHERE NOT EXISTS (SELECT 1 FROM core.transactions t WHERE t.account_id=a.account_id)
ORDER BY a.account_number;
-- ACCT-1001: (150+50)/2=100; solo 150 supera 100.
-- ACCT-1002 y ACCT-3002 no tienen promedio: no tienen filas de eventos.
