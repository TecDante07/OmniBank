-- Actividad 13: CTE reutilizable, grano anotado en cada etapa.
WITH movimientos_por_cuenta AS ( -- una fila por cuenta con eventos
 SELECT account_id,COUNT(transaction_id) AS eventos,
        SUM(CASE WHEN amount>0 THEN amount ELSE 0 END) AS volumen_bruto
 FROM core.transactions GROUP BY account_id
), cuentas_activas AS ( -- una fila por cuenta activa, incluso sin eventos
 SELECT a.account_id,a.account_number,a.customer_id,a.currency,
        COALESCE(m.eventos,0) AS eventos,
        COALESCE(m.volumen_bruto,0) AS volumen_bruto
 FROM core.accounts a LEFT JOIN movimientos_por_cuenta m ON m.account_id=a.account_id
 WHERE a.is_active
), cuentas_con_titular AS ( -- una fila por cuenta activa
 SELECT ca.account_id,ca.account_number,c.first_name,c.last_name,
        ca.currency,ca.eventos,ca.volumen_bruto
 FROM cuentas_activas ca JOIN core.customers c ON c.customer_id=ca.customer_id
)
SELECT account_number,first_name,last_name,currency,eventos,volumen_bruto,
 CASE WHEN eventos=0 THEN 'SIN ACTIVIDAD'
      WHEN eventos=1 THEN 'BAJA' ELSE 'ALTA' END AS banda_actividad
FROM cuentas_con_titular ORDER BY account_number;
-- Controles directos sin duplicar movimientos.
SELECT COUNT(*) AS cuentas_activas FROM core.accounts WHERE is_active;
SELECT COUNT(*) AS movimientos,SUM(amount) AS volumen_bruto FROM core.transactions;
SELECT account_id,COUNT(*) AS eventos,SUM(amount) AS volumen_bruto
FROM core.transactions GROUP BY account_id ORDER BY account_id;
-- ACCT-3002 aparece con cero eventos gracias a LEFT JOIN + COALESCE.
