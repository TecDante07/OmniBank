-- Actividad 5: estructura física compatible con los reportes de los días 9–14.
-- Prerrequisito: ejecutar actividad 4 (ENUMs).
CREATE SCHEMA IF NOT EXISTS core;
CREATE TABLE core.customers (
 customer_id UUID DEFAULT gen_random_uuid(),
 first_name VARCHAR(100) NOT NULL,
 last_name VARCHAR(100) NOT NULL,
 email VARCHAR(255) NOT NULL,
 phone VARCHAR(30), tax_id VARCHAR(50) NOT NULL,
 birth_date DATE,
 created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
 is_active BOOLEAN NOT NULL DEFAULT TRUE,
 CONSTRAINT pk_customers_customer_id PRIMARY KEY (customer_id),
 CONSTRAINT uq_customers_email UNIQUE (email),
 CONSTRAINT uq_customers_tax_id UNIQUE (tax_id)
);
CREATE TABLE core.accounts (
 account_id UUID DEFAULT gen_random_uuid(),
 customer_id UUID NOT NULL,
 account_number VARCHAR(30) NOT NULL,
 currency core.tipo_moneda NOT NULL,
 account_type core.tipo_cuenta NOT NULL,
 balance NUMERIC(15,2) NOT NULL DEFAULT 0,
 credit_limit NUMERIC(15,2) NOT NULL DEFAULT 0,
 is_active BOOLEAN NOT NULL DEFAULT TRUE,
 updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT pk_accounts_account_id PRIMARY KEY (account_id),
 CONSTRAINT uq_accounts_account_number UNIQUE (account_number),
 CONSTRAINT fk_accounts_customer_id FOREIGN KEY (customer_id)
   REFERENCES core.customers(customer_id) ON DELETE RESTRICT,
 CONSTRAINT chk_accounts_balance_nonnegative CHECK (balance >= 0),
 CONSTRAINT chk_accounts_credit_limit_nonnegative CHECK (credit_limit >= 0)
);
CREATE TABLE core.loans (
 loan_id UUID DEFAULT gen_random_uuid(),
 customer_id UUID NOT NULL,
 amount NUMERIC(15,2) NOT NULL,
 interest_rate NUMERIC(5,4) NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
 CONSTRAINT pk_loans_loan_id PRIMARY KEY (loan_id),
 CONSTRAINT fk_loans_customer_id FOREIGN KEY (customer_id)
   REFERENCES core.customers(customer_id) ON DELETE RESTRICT,
 CONSTRAINT chk_loans_amount_positive CHECK (amount > 0),
 CONSTRAINT chk_loans_interest_rate_nonnegative CHECK (interest_rate >= 0)
);
CREATE TABLE core.transactions (
 transaction_id UUID DEFAULT gen_random_uuid(),
 account_id UUID NOT NULL,
 amount NUMERIC(15,2) NOT NULL,
 tx_type core.tipo_transaccion NOT NULL,
 tx_timestamp TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
 description TEXT,
 CONSTRAINT pk_transactions_transaction_id PRIMARY KEY (transaction_id),
 CONSTRAINT fk_transactions_account_id FOREIGN KEY (account_id)
   REFERENCES core.accounts(account_id) ON DELETE RESTRICT,
 CONSTRAINT chk_transactions_amount_positive CHECK (amount > 0)
);
-- Contrato del día 5: una transacción tiene una cuenta asociada (account_id).
-- No se crean destinatarios ni status de transacción que el contrato posterior no contempla.
