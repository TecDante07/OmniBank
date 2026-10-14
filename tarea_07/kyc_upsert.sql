-- Tarea 7: UPSERT atómico por email.
-- El índice/constraint UNIQUE sobre email es requisito previo.
-- Se conservan customer_id y created_at en los registros ya existentes.
INSERT INTO core.customers
    (first_name, last_name, email, phone, tax_id)
VALUES
    ('Ana', 'López', 'ana.lopez@ejemplo.com', '5551234567', 'TAX-KYC-001')
ON CONFLICT (email)
DO UPDATE SET
    first_name = EXCLUDED.first_name,
    last_name  = EXCLUDED.last_name,
    phone      = EXCLUDED.phone
RETURNING customer_id, email;
