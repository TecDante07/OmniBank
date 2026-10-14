-- Tarea 4: dominios empresariales en PostgreSQL.
CREATE DOMAIN core.monto_financiero AS NUMERIC(15,2)
    CONSTRAINT chk_monto_financiero_no_negativo CHECK (VALUE >= 0);

CREATE DOMAIN core.texto_obligatorio AS VARCHAR(100)
    CONSTRAINT chk_texto_obligatorio_no_vacio
    CHECK (VALUE <> '' AND LENGTH(TRIM(VALUE)) > 0);

-- Columnas donde usar core.monto_financiero:
-- core.accounts.balance
-- core.accounts.credit_limit
-- core.transactions.amount
