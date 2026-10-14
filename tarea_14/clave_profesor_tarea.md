# Day 14 Answer Key — Extensión de Self JOIN, matriz de productos y anti JOIN

Expected Result

Tres cuentas activas carecen de DEPOSIT: ACCT-1001, ACCT-2001 y ACCT-3002. Las dos primeras sí
tienen otros movimientos.

Reference Solution

SELECT a.account_number, a.account_type

FROM core.accounts a

LEFT JOIN core.transactions t ON t.account_id = a.account_id AND t.tx_type = 'DEPOSIT'

WHERE a.is_active AND t.transaction_id IS NULL

ORDER BY a.account_number;

Lectura de la solución: El catálogo de productos solicita una lista más operativa: cuentas activas
que aún no registran un depósito. La actividad ya estableció cómo expresar ausencia; ahora la
tarea aplica esa técnica a un tipo de evento concreto y conserva la comparación de pares de
movimientos como evidencia.

Common Valid Variations

NOT EXISTS puede reemplazar el anti JOIN y un orden por UUID puede reemplazar el temporal si
evita pares duplicados de manera determinista.

Common Mistakes

Sin desigualdad estricta el self JOIN duplica pares; sin verificar la matriz contra accounts se
reportan productos inexistentes como si fueran cuentas reales.

Grading Rubric

       35%: Desde accounts filtra is_active y usa NOT EXISTS para excluir cuentas que tengan un
        evento DEPOSIT. Muestra número, tipo y titular, sin inferir que carezcan de toda actividad.

       30%: Compara la salida con una lista de cuentas que sí tienen algún movimiento; explica
        por qué ambos conjuntos pueden solaparse.

       20%: Comprueba el resultado con datos reproducibles: Tres cuentas activas carecen de
        DEPOSIT: ACCT-1001, ACCT-2001 y ACCT-3002. Las dos primeras sí tienen otros
        movimientos.

       15%: Reconoce y evita este error: Sin desigualdad estricta el self JOIN duplica pares; sin
        verificar la matriz contra accounts se reportan productos inexistentes como si fueran
        cuentas reales.
