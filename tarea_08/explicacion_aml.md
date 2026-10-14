# Tarea 8. Explicación del filtro AML

En SQL, `AND` tiene mayor precedencia que `OR`. Por ello, el filtro defectuoso `amount >= 10000 AND tx_type = 'TRANSFER' OR tx_type = 'WITHDRAWAL'` no exige el umbral de 10,000 para los retiros: la condición de retiro queda como alternativa independiente. Además, las condiciones de descripción deben evaluarse en su propio bloque para evitar mezclas lógicas no deseadas.

La consulta separa dos criterios: operaciones de al menos 10,000 de tipo transferencia o retiro, y descripciones que contienen palabras de riesgo o están ausentes. La ausencia de descripción se comprueba con `NULLIF(TRIM(description), '') IS NULL` y se excluyen de ese caso los depósitos ordinarios. `COALESCE` ofrece un texto legible para descripciones nulas. Los depósitos con palabras de riesgo sí se mantienen, porque el criterio textual no los excluye.
