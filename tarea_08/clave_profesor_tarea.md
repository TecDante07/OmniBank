# Day 08 Answer Key —
         Candidatos de revisión
Expected Result
Tres movimientos de revisión didáctica, sin atribuir fraude ni
        destinatario.
Reference Solution
SELECT transaction_id,account_id,tx_type,amount,
COALESCE(NULLIF(TRIM(description),''),'SIN DESCRIPCIÓN') AS
        visible_description
FROM core.transactions
WHERE (tx_type IN ('TRANSFER','WITHDRAWAL') AND amount>=100)
OR (tx_type='WITHDRAWAL' AND NULLIF(TRIM(description),'') IS NULL)
ORDER BY amount DESC,transaction_id;
Los dos TRANSFER superan el umbral didáctico. El retiro de 50 entra por
        descripción faltante. El depósito no cumple ninguno de los dos bloques.
        Una alerta exploratoria requiere revisión adicional y no constituye una
        acusación ni un reporte legal.
Common Valid Variations
Se acepta btrim y una CTE que calcule la descripción normalizada antes
        de filtrar.
Common Mistakes
Omitir paréntesis cambia la precedencia. Tratar description NULL como
        prueba de fraude confunde una observación incompleta con una
        conclusión.
