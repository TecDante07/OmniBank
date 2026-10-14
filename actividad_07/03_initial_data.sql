-- Actividad 7: carga inicial idempotente compatible con core.transactions del día 5.
-- El texto del día 7 menciona FEE, COMPLETED y to_account_id, que NO existen
-- en el contrato posterior (ENUM de 3 valores y una sola FK account_id).
-- Se representa el cobro como WITHDRAWAL con description NULL.
BEGIN;
INSERT INTO core.customers (customer_id,first_name,last_name,email,phone,tax_id,birth_date)
VALUES
 ('11111111-1111-1111-1111-111111111111','John','Doe','john.doe@email.com','555-0100','TAX-100','1985-04-12'),
 ('22222222-2222-2222-2222-222222222222','Jane','Smith','jane.smith@email.com','555-0200','TAX-200','1990-08-25'),
 ('33333333-3333-3333-3333-333333333333','Alice','Johnson','alice.j@email.com','555-0300','TAX-300','1978-11-05')
ON CONFLICT (email) DO NOTHING;
INSERT INTO core.accounts (account_id,customer_id,account_number,currency,account_type,balance,credit_limit)
VALUES
 ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','11111111-1111-1111-1111-111111111111','ACCT-1001','USD','CHECKING',5000,0),
 ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','22222222-2222-2222-2222-222222222222','ACCT-2001','USD','SAVINGS',15000,0),
 ('cccccccc-cccc-cccc-cccc-cccccccccccc','33333333-3333-3333-3333-333333333333','ACCT-3001','USD','CREDIT',0,10000)
ON CONFLICT (account_number) DO NOTHING;
-- UUIDs estáticos permiten ON CONFLICT por transaction_id.
INSERT INTO core.transactions (transaction_id,account_id,amount,tx_type,tx_timestamp,description)
VALUES
 ('10000000-0000-0000-0000-000000000001','aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',150,'TRANSFER','2026-09-01 12:00+00','Pago de cena a Jane'),
 ('10000000-0000-0000-0000-000000000002','cccccccc-cccc-cccc-cccc-cccccccccccc',300,'DEPOSIT','2026-09-02 12:00+00','Abono a tarjeta Alice'),
 ('10000000-0000-0000-0000-000000000003','aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',50,'WITHDRAWAL','2026-09-03 12:00+00',NULL)
ON CONFLICT (transaction_id) DO NOTHING;
-- Solo descontar si la comisión todavía no se había aplicado.
-- La condición usa el balance de inicio para proteger reejecuciones.
UPDATE core.accounts
SET balance = balance - 50, updated_at = CURRENT_TIMESTAMP
WHERE account_number = 'ACCT-1001' AND balance = 5000
RETURNING account_number,balance;
COMMIT;
-- En la primera ejecución devuelve 4950.00; en la siguiente no repite el descuento.
-- Para reproducir el checkpoint de 4 clientes, 5 cuentas y 4 eventos se requiere
-- una carga adicional que el documento no especifica completamente.
