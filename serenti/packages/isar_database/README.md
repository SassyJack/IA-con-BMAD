# Isar Database Package (Serenti)

Módulo encargado de la persistencia de datos local para Serenti. Utiliza la base de datos Isar con cifrado AES-256 activo para proteger la privacidad de los usuarios (Zero-Cloud Policy).

## Responsabilidades
- Gestión del ciclo de vida de la base de datos Isar.
- Configuración y manejo de esquemas cifrados.
- Repositorio base para acceso a datos.

## Dependencias Clave
- `isar`
- `isar_flutter_libs`
- `path_provider`
