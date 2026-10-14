# Tarea 2. Refinamiento del ERD de OmniBank

**Clientes**
- `cliente_id` **(PK, UUID aleatorio)**
- `nombre_completo` (obligatorio)
- `email` (**UNIQUE**, obligatorio)
- `telefono`
- `fecha_nacimiento`
- `tax_id` (**UNIQUE**, obligatorio)
- `is_active` (**BOOLEAN**, `true` al crear, `false` para baja lógica)

**Cuentas**
- `cuenta_id` **(PK, UUID aleatorio)**
- `cliente_id` **(FK → Clientes.cliente_id, UUID)**
- `numero_cuenta` (**UNIQUE**, obligatorio)
- `moneda`
- `tipo_cuenta`
- `saldo` (**CHECK: saldo >= 0**)
- `limite_credito` (**CHECK: limite_credito >= 0**)
- `updated_at` (**marca de fecha y hora de la última modificación**)

**Transacciones**
- `transaccion_id` **(PK, UUID aleatorio)**
- `cuenta_origen_id` **(FK → Cuentas.cuenta_id, UUID)**
- `cuenta_destino_id` **(FK → Cuentas.cuenta_id, UUID)**
- `monto` (**CHECK: monto > 0**)
- `tipo_transaccion`
- `fecha_transaccion`

**Cardinalidades**
- Clientes (1) — (N) Cuentas.
- Cuentas (1) — (N) Transacciones como origen.
- Cuentas (1) — (N) Transacciones como destino.

Todas las PK y las FK que las referencian usan `UUID` y no enteros autoincrementales. Las transacciones apuntan dos veces a Cuentas para distinguir origen y destino.
