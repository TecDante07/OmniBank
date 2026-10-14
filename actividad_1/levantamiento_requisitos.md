# Actividad 1: Levantamiento de requisitos de OmniBank

## Entidades identificadas
1. **Clientes:** personas que tienen cuentas en OmniBank.
2. **Cuentas:** productos bancarios que pertenecen a un cliente.
3. **Transacciones:** movimientos de dinero registrados entre una cuenta de origen y una de destino.

## Requerimientos funcionales
- **RF-01 (Clientes):** almacenar el nombre completo de cada cliente.
- **RF-02 (Clientes):** almacenar su correo electrónico, teléfono, fecha de nacimiento y número de identificación fiscal (Tax ID).
- **RF-03 (Cuentas):** permitir que un mismo cliente tenga varias cuentas.
- **RF-04 (Cuentas):** guardar número de cuenta, moneda (por ejemplo USD o EUR), tipo (Checking, Savings o Credit), saldo actual y límite de crédito.
- **RF-05 (Transacciones):** registrar la cuenta de origen y la cuenta de destino de cada movimiento de dinero.
- **RF-06 (Transacciones):** guardar el monto, tipo de operación (depósito, retiro o transferencia) y fecha exacta de realización.

## Restricciones clave
- El **Tax ID de cada cliente debe ser único**: no pueden existir dos clientes con el mismo número de identificación fiscal.
- El **correo electrónico también debe ser único**, según el caso de negocio.

## Relación entre entidades
Un cliente puede tener varias cuentas; las transacciones registran movimientos asociados a cuentas de origen y destino.

> Esta actividad es de análisis de requisitos. No se incluye SQL ni se agregan entidades ajenas al caso.
