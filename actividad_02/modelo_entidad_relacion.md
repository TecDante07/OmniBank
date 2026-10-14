# Actividad 2 — Modelo entidad-relación de OmniBank

## Clientes
- `cliente_id` (PK)
- `nombre_completo`
- `email`
- `telefono`
- `fecha_nacimiento`
- `tax_id`

## Cuentas
- `cuenta_id` (PK)
- `cliente_id` (FK → Clientes.cliente_id)
- `numero_cuenta`
- `moneda`
- `tipo_cuenta`
- `saldo`
- `limite_credito`

## Transacciones
- `transaccion_id` (PK)
- `cuenta_origen_id` (FK → Cuentas.cuenta_id)
- `cuenta_destino_id` (FK → Cuentas.cuenta_id)
- `monto`
- `tipo_transaccion`
- `fecha_transaccion`

## Cardinalidades
- **Clientes (1) — (N) Cuentas:** un cliente puede tener varias cuentas y cada cuenta pertenece a un único cliente.
- **Cuentas (1) — (N) Transacciones como origen:** una cuenta puede originar muchas transacciones.
- **Cuentas (1) — (N) Transacciones como destino:** una cuenta puede recibir muchas transacciones.

Las dos relaciones con Cuentas son distintas: una representa el origen y otra el destino. Para conocer al titular de una transacción, se sigue cualquiera de las FK de cuenta hasta Cuentas y de allí la FK `cliente_id` hasta Clientes.

Esta actividad solo identifica llaves y cardinalidades; no asigna tipos de datos SQL.
