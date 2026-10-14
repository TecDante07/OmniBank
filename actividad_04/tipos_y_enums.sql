-- Actividad 4: PostgreSQL 16. Ejecutar una vez antes del DDL del día 5.
CREATE SCHEMA IF NOT EXISTS core;
CREATE TYPE core.tipo_moneda AS ENUM ('USD', 'EUR', 'MXN');
CREATE TYPE core.tipo_cuenta AS ENUM ('CHECKING', 'SAVINGS', 'CREDIT');
CREATE TYPE core.tipo_transaccion AS ENUM ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER');

-- Diccionario de datos propuesto:
-- accounts: account_id UUID PK, customer_id UUID FK, account_number VARCHAR(30),
-- currency core.tipo_moneda, account_type core.tipo_cuenta,
-- balance NUMERIC(15,2), credit_limit NUMERIC(15,2),
-- updated_at TIMESTAMPTZ. NUMERIC evita errores de redondeo de FLOAT.
-- transactions: transaction_id UUID PK, account_id UUID FK,
-- amount NUMERIC(15,2), tx_type core.tipo_transaccion,
-- tx_timestamp TIMESTAMPTZ, description TEXT.
-- Los UUID de las FK coinciden exactamente con los UUID de las PK.
-- TIMESTAMPTZ conserva instantes inequívocos entre zonas horarias.
