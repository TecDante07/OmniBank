# Tarea 6. Reporte forense: bloqueo por DDL

## 1. Causa raíz
El comando `ALTER TABLE ... ADD CONSTRAINT ... CHECK (...)` sin `NOT VALID` necesita validar las filas existentes. Sobre 75 millones de transacciones, ese recorrido puede ser prolongado. La operación de `ALTER TABLE` adquiere un bloqueo `ACCESS EXCLUSIVE`, incompatible con las lecturas y escrituras concurrentes sobre esa tabla. Además, las sesiones que esperan el bloqueo pueden formar una cola y agravar el incidente. En el caso descrito, las operaciones quedaron bloqueadas durante 14 minutos hasta que se canceló la sesión del DBA.

## 2. Corrección en dos etapas
Primero se instala la regla para nuevas inserciones y actualizaciones **sin recorrer el histórico**:

```sql
ALTER TABLE core.transactions
ADD CONSTRAINT chk_transactions_description_valid
CHECK (LENGTH(TRIM(description)) >= 5) NOT VALID;
```

En una operación posterior e independiente se revisan los datos existentes:

```sql
ALTER TABLE core.transactions
VALIDATE CONSTRAINT chk_transactions_description_valid;
```

La primera orden todavía necesita un bloqueo exclusivo, pero normalmente breve porque evita el escaneo inicial. La validación posterior usa un bloqueo `SHARE UPDATE EXCLUSIVE`, que permite lecturas y escrituras ordinarias concurrentes, aunque puede entrar en conflicto con otras operaciones de mantenimiento.

## 3. Prevención
Ejecutar migraciones en una ventana planificada, usar `lock_timeout` y monitorear bloqueos. Revisar previamente los datos históricos: si existen descripciones de menos de cinco caracteres, la validación fallará y será necesario corregirlas. En PostgreSQL, un `CHECK` acepta resultados `NULL`; si se deben rechazar descripciones nulas, hace falta una regla adicional. `NOT VALID` reduce el riesgo de indisponibilidad, pero no garantiza por sí solo cero interrupciones.
