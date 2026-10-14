# Day 11 Answer Key — Transformaciones y fechas

Expected Result

El reporte de cuentas contiene cinco filas y el temporal cuatro. Las fechas calculadas caen del 16 al
19 de septiembre de 2026 con el corte fijado.

Reference Solution

SELECT c.email,

    CONCAT(UPPER(TRIM(c.first_name)),' ',UPPER(TRIM(c.last_name))) AS customer_name,

   CONCAT('XXXX-',RIGHT(a.account_number,4)) AS masked_account,

   a.account_type,a.balance::numeric(12,2) AS balance

FROM core.customers c JOIN core.accounts a USING(customer_id)

ORDER BY c.email,a.account_number;



SELECT t.transaction_id,t.amount::numeric(12,2) AS amount,t.tx_timestamp,

   EXTRACT(YEAR FROM t.tx_timestamp)::integer AS event_year,

   EXTRACT(MONTH FROM t.tx_timestamp)::integer AS event_month,

   t.tx_timestamp+INTERVAL '15 days' AS review_on,

   AGE(TIMESTAMPTZ '2026-10-01 00:00+00',t.tx_timestamp) AS age_at_review

FROM core.transactions t

WHERE t.tx_timestamp<TIMESTAMPTZ '2026-09-10 00:00+00'

ORDER BY t.tx_timestamp;

Lectura de la solución: Atención al cliente necesita etiquetas legibles y una agenda de revisión
temporal que pueda repetirse meses después con la misma salida. Un reporte basado en
CURRENT_DATE cambiaría cada día; por eso el corte de revisión se fija en una fecha explícita de
septiembre de 2026. La transformación debe ocurrir en la consulta sin sobrescribir nombres o
marcas de tiempo originales.

Common Valid Variations

Se aceptan CONCAT o el operador de concatenación con tratamiento explícito de NULL, y otra
fecha fija de corte si se recalculan coherentemente las expectativas.

Common Mistakes

CURRENT_DATE vuelve variable un resultado que se presenta como reproducible; dividir enteros
antes de convertir a NUMERIC puede truncar el porcentaje.

Grading Rubric

       35%: Parte de las cinco cuentas del checkpoint y enlaza cada una con su titular. Construye
        una etiqueta de presentación con funciones de texto, conservando por separado los
        identificadores y datos originales.

       30%: Fija la fecha de referencia indicada en la actividad y calcula para cada movimiento
        una fecha de revisión mediante INTERVAL. Proyecta la marca original y la derivada para
        que la operación pueda comprobarse.

       20%: Comprueba el resultado con datos reproducibles: El reporte de cuentas contiene
        cinco filas y el temporal cuatro. Las fechas calculadas caen del 16 al 19 de septiembre de
        2026 con el corte fijado.

       15%: Reconoce y evita este error: CURRENT_DATE vuelve variable un resultado que se
        presenta como reproducible; dividir enteros antes de convertir a NUMERIC puede truncar
        el porcentaje.
