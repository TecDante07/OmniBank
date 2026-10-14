# Day 13 Answer Key — Extensión de CTE y pipeline de métricas por cuenta

Expected Result

La semilla inicial produce una fila USD, cuatro cuentas activas, volumen bruto 800 y promedio de
200 por cuenta.

Reference Solution

WITH movement AS (

SELECT account_id, SUM(amount) AS gross_volume

FROM core.transactions GROUP BY account_id

), account_metrics AS (

SELECT a.account_id, a.currency, COALESCE(m.gross_volume,0) AS gross_volume

FROM core.accounts a LEFT JOIN movement m USING (account_id)

WHERE a.is_active

), by_currency AS (

SELECT currency, COUNT(*) AS account_count, SUM(gross_volume) AS gross_volume

FROM account_metrics GROUP BY currency

)

SELECT currency, account_count, gross_volume,

    ROUND(gross_volume / account_count,2) AS average_per_account

FROM by_currency ORDER BY currency;

SELECT (SELECT COUNT(*) FROM core.accounts WHERE is_active) AS active_accounts,

    (SELECT COALESCE(SUM(amount),0) FROM core.transactions) AS direct_gross_volume,

    (SELECT COUNT(*) FROM core.transactions t JOIN core.accounts a USING (account_id)

    WHERE a.account_number='ACCT-3002') AS empty_account_events;

Lectura de la solución: Finanzas quiere una vista por moneda a partir del mismo pipeline, sin
reescribir el cálculo de movimientos ni perder cuentas activas de volumen cero. La tarea añade una
etapa de agregación sobre el resultado por cuenta; ese cambio de grano debe quedar explícito en
nombres y columnas.

Common Valid Variations

Se puede usar una subconsulta derivada por etapa si el grano y las filas conservadas son
equivalentes; los nombres de las CTE no son parte del resultado.

Common Mistakes

Agregar después de una unión que multiplica eventos o usar INNER JOIN antes de conservar
cuentas vacías altera tanto el total como el denominador del promedio.

Grading Rubric

       35%: Reutiliza la etapa de volumen por cuenta de la actividad y conserva en una CTE
        intermedia las cuentas activas sin eventos con volumen cero.

       30%: Agrupa esa salida por currency para obtener número de cuentas, volumen bruto y
        promedio por cuenta. Redondea solo la presentación del promedio.

       20%: Comprueba el resultado con datos reproducibles: La semilla inicial produce una fila
        USD, cuatro cuentas activas, volumen bruto 800 y promedio de 200 por cuenta.

       15%: Reconoce y evita este error: Agregar después de una unión que multiplica eventos o
        usar INNER JOIN antes de conservar cuentas vacías altera tanto el total como el
        denominador del promedio.
