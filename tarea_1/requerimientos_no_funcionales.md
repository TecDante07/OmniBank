# Tarea 1: Requerimientos no funcionales de OmniBank

1. **NFR-01 — Consistencia del saldo:** La base de datos debe impedir que el saldo (balance) de una cuenta sea negativo, incluso si el backend intenta guardar un valor inválido. Esta regla deberá aplicarse a nivel de motor mediante una restricción `CHECK`.

2. **NFR-02 — Auditoría y eliminación lógica (soft delete):** La base de datos debe impedir la eliminación definitiva de los registros de clientes. Cuando un cliente deje de estar activo, se conservarán sus datos para auditoría y se marcará su estado mediante una bandera booleana `is_active`.

3. **NFR-03 — Rastreo de modificaciones:** La base de datos debe registrar la fecha y hora exactas de la última actualización de cada fila de cuentas. El campo `updated_at` deberá actualizarse automáticamente cada vez que se modifique una cuenta.

Estos tres requisitos corresponden a la consistencia matemática, la preservación del historial y la trazabilidad temporal solicitadas en el caso OmniBank.
