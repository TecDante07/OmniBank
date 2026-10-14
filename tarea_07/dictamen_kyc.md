# Tarea 7. Análisis del pipeline KYC

El patrón `SELECT` previo a cada `INSERT` o `UPDATE` multiplica los viajes de red y el tiempo de espera al procesar un lote masivo. Además, entre comprobar que un correo no existe y realizar la inserción, otro proceso puede insertar ese mismo correo: ambas sesiones toman decisiones basadas en una lectura ya desactualizada, generando una condición de carrera y un conflicto de unicidad.

La sentencia `INSERT ... ON CONFLICT (email) DO UPDATE` delega la resolución atómica al motor PostgreSQL. `EXCLUDED` aporta los datos entrantes para actualizar únicamente nombre, apellido y teléfono. No se sobrescriben `customer_id` ni `created_at`, y `RETURNING customer_id, email` entrega el resultado al backend en la misma operación. El ejemplo SQL usa datos ilustrativos y debe sustituirse por los parámetros del lote KYC real.
