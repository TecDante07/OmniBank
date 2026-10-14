-- Actividad 6: evolución sin DROP TABLE.
BEGIN;
CREATE TYPE core.loan_status_enum AS ENUM ('ACTIVE', 'PAID', 'DEFAULTED', 'CANCELLED');
ALTER TABLE core.customers
 ADD COLUMN credit_score INTEGER,
 ADD CONSTRAINT chk_customers_credit_score_range CHECK (credit_score BETWEEN 300 AND 850);
ALTER TABLE core.accounts
 ADD COLUMN iban VARCHAR(34) NULL,
 ADD CONSTRAINT uq_accounts_iban UNIQUE (iban);
ALTER TABLE core.loans
 ALTER COLUMN status TYPE core.loan_status_enum USING status::core.loan_status_enum;
COMMIT;
-- La creación del ENUM está dentro del bloque para que toda la migración sea atómica.
-- Revisar los valores preexistentes de status antes de ejecutar la migración.
