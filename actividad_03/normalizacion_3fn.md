# Actividad 3 — Normalización a 3FN

## 1FN
Separar `cliente_nombre_y_contacto` en `cliente_nombre`, `cliente_email`, `cliente_telefono` y separar `moneda_y_tipo` en `moneda`, `tipo_cuenta`. Cada celda contiene un valor atómico.

## 2FN
Con `transaccion_id` como clave primaria simple, no existen dependencias parciales respecto de una clave compuesta. La repetición de datos de clientes y sucursales es redundante, pero **no constituye por sí misma una infracción de 2FN**; el problema se analiza principalmente en 3FN.

## 3FN
- **Clientes:** `cliente_id (PK)`, `tax_id`, `nombre`, `email`, `telefono`, `fecha_nacimiento`.
- **Sucursales:** `sucursal_id (PK)`, `sucursal_nombre`, `sucursal_direccion`.
- **Cuentas:** `cuenta_id (PK)`, `cliente_id (FK → Clientes)`, `sucursal_id (FK → Sucursales)`, `numero_cuenta`, `moneda`, `tipo_cuenta`, `saldo`, `limite_credito`.
- **Transacciones:** `transaccion_id (PK)`, `cuenta_origen_id (FK → Cuentas)`, `cuenta_destino_id (FK → Cuentas)`, `monto`, `tipo_transaccion`, `fecha_transaccion`.

## Dependencias
`cliente_id → tax_id, nombre, email, telefono, fecha_nacimiento`; `sucursal_id → sucursal_nombre, sucursal_direccion`; `cuenta_id → cliente_id, sucursal_id, numero_cuenta, moneda, tipo_cuenta, saldo, limite_credito`; `transaccion_id → cuenta_origen_id, cuenta_destino_id, monto, tipo_transaccion, fecha_transaccion`.

`cliente_nombre` depende de `cliente_id`, y `sucursal_direccion` depende de `sucursal_id`; no deben repetirse por transacción. Si cambia el teléfono o dirección, se actualiza una sola fila.

**Nota:** el enunciado de esta actividad incorpora sucursales al prototipo; el DDL de la actividad 5 cambia explícitamente a cuatro tablas `customers`, `accounts`, `loans`, `transactions`.
