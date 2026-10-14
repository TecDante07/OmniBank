# Day 09 Answer Key — Relaciones reales y ausencia de movimientos

Expected Result

El checkpoint aporta cuatro clientes, cinco cuentas y cuatro movimientos. El recorrido de eventos
devuelve cuatro filas; la consulta de ausencia devuelve ACCT-1002 desactivada y ACCT-3002 activa.
El reporte de titulares con balance>0 conserva a los cuatro clientes, con columnas de cuenta nulas
para Alice y Humberto. La variante con el filtro en WHERE pierde esas dos personas.

Reference Solution

SELECT (SELECT COUNT(*) FROM core.customers) AS customers,

   (SELECT COUNT(*) FROM core.accounts) AS accounts,

   (SELECT COUNT(*) FROM core.transactions) AS movements;



SELECT t.transaction_id,c.first_name,c.last_name,a.account_number,t.tx_type,t.amount

FROM core.transactions t

JOIN core.accounts a ON a.account_id=t.account_id

JOIN core.customers c ON c.customer_id=a.customer_id

ORDER BY t.tx_timestamp,t.transaction_id;



SELECT a.account_number,a.is_active,

    CASE WHEN a.is_active THEN 'ACTIVA SIN MOVIMIENTOS'

      ELSE 'DESACTIVADA SIN MOVIMIENTOS' END AS estado

FROM core.accounts a

LEFT JOIN core.transactions t ON t.account_id=a.account_id

WHERE t.transaction_id IS NULL

ORDER BY a.account_number;



SELECT c.email,a.account_number,a.balance

FROM core.customers c

LEFT JOIN core.accounts a

 ON a.customer_id=c.customer_id AND a.balance>0

ORDER BY c.email,a.account_number;



-- Comparación diagnóstica: WHERE elimina las filas externas sin pareja elegible.

SELECT c.email,a.account_number,a.balance

FROM core.customers c

LEFT JOIN core.accounts a ON a.customer_id=c.customer_id

WHERE a.balance>0

ORDER BY c.email,a.account_number;

La última consulta devuelve solo John y Jane; si se requiere preservar a los titulares, el predicado
de cuenta elegible pertenece a ON. is_active y ausencia de movimiento son atributos diferentes y
no deben codificarse en el enum tx_type.

Common Valid Variations

Se aceptan alias distintos, una etiqueta textual equivalente y un RIGHT JOIN reorientado que
preserve las mismas cuentas. Una solución con NOT EXISTS para la ausencia también es válida si
está claramente explicada, aunque no se exige antes del día 12.

Common Mistakes

Unir movimiento con cliente por un campo descriptivo en vez de recorrer las claves foráneas crea
asociaciones falsas. Filtrar transactions en WHERE después de un LEFT JOIN puede ocultar cuentas
sin eventos. Un INNER JOIN entre clientes y cuentas elimina a Humberto; filtrar balance en WHERE
elimina también a Alice.

Grading Rubric

       25%: recuentos de control y claves reales account_id y customer_id.

       25%: recorrido de cuatro movimientos, una fila por evento y orden estable.

       25%: ausencia de dos cuentas con is_active separado de la existencia de eventos.

       25%: cuatro titulares preservados, comparación ON/WHERE y explicación del grano.
