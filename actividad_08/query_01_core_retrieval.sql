-- Actividad 8: reportes de solo lectura; sin SELECT *.
-- Reporte 1: una fila por cuenta, dos mayores saldos elegibles.
SELECT account_number,account_type,balance
FROM core.accounts
WHERE (balance >= 1000.00 OR account_type = 'SAVINGS')
ORDER BY balance DESC,account_number LIMIT 2;
-- Reporte 2: una fila por cliente cuyo correo contiene el dominio solicitado.
SELECT first_name,last_name,email
FROM core.customers
WHERE email ILIKE '%@email.com%'
ORDER BY email;
-- Reporte 3: transacciones sin descripción. La comparación description = NULL
-- no devuelve TRUE; se utiliza IS NULL para identificar el valor ausente.
SELECT transaction_id,account_id,amount,tx_type,
 COALESCE(description,'COBRO INSTITUCIONAL O COMISIÓN - SIN RECEPTOR') AS descripcion_visible
FROM core.transactions
WHERE description IS NULL
ORDER BY tx_timestamp,transaction_id;
