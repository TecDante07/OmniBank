# Day 14 Answer Key — Self JOIN, matriz de productos y anti JOIN

Expected Result

John ofrece un par de movimientos iniciales en la misma cuenta. La matriz muestra posibilidades
faltantes sin inventar sucursales ni relaciones por moneda.

Reference Solution

SELECT t1.account_id, t1.transaction_id AS earlier_id, t2.transaction_id AS later_id

FROM core.transactions t1 JOIN core.transactions t2

ON t1.account_id = t2.account_id

AND (t1.tx_timestamp,t1.transaction_id) < (t2.tx_timestamp,t2.transaction_id)

AND t2.tx_timestamp <= t1.tx_timestamp + INTERVAL '48 hours'

ORDER BY t1.account_id, t1.tx_timestamp;



WITH types AS (

SELECT unnest(enum_range(NULL::core.tipo_cuenta)) AS account_type

)

SELECT c.customer_id, c.email, ty.account_type

FROM core.customers c CROSS JOIN types ty

LEFT JOIN core.accounts a ON a.customer_id = c.customer_id AND a.account_type =
ty.account_type

WHERE a.account_id IS NULL ORDER BY c.email, ty.account_type;

Lectura de la solución: Producto quiere comparar movimientos de una misma cuenta y conocer
qué combinaciones de titular y tipo de cuenta aún no existen. Son dos preguntas distintas: el self
JOIN examina pares de eventos reales; la matriz de productos enumera posibilidades y el anti JOIN
señala ausencias. Compartir moneda no convierte dos cuentas en sucursales ni en la misma
relación.

Common Valid Variations

NOT EXISTS puede reemplazar el anti JOIN y un orden por UUID puede reemplazar el temporal si
evita pares duplicados de manera determinista.

Common Mistakes

Sin desigualdad estricta el self JOIN duplica pares; sin verificar la matriz contra accounts se
reportan productos inexistentes como si fueran cuentas reales.

Grading Rubric

       35%: Construye un self JOIN de transactions limitado a eventos de la misma account_id y a
        un orden estricto de identificadores o marcas temporales. Evita emparejar una fila consigo
        misma y duplicar el par en sentido inverso.

       30%: Obtén de los valores reales del enum la lista pequeña de tipos de cuenta. Combínala
        con los clientes para formar una matriz de posibilidades, sin afirmar que cada combinación
        exista.

       20%: Comprueba el resultado con datos reproducibles: John ofrece un par de movimientos
        iniciales en la misma cuenta. La matriz muestra posibilidades faltantes sin inventar
        sucursales ni relaciones por moneda.

       15%: Reconoce y evita este error: Sin desigualdad estricta el self JOIN duplica pares; sin
        verificar la matriz contra accounts se reportan productos inexistentes como si fueran
        cuentas reales.
