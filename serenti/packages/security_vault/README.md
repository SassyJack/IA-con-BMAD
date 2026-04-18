# Security Vault Package (Serenti)

Módulo encargado de la protección de acceso y manejo de credenciales para Serenti. Implementa la seguridad biométrica y PIN cifrado siguiendo la normativa de protección de datos colombiana (Ley 1581).

## Responsabilidades
- Protección de acceso mediante PIN y biometría (FaceID/Huella).
- Almacenamiento seguro de llaves de cifrado en Keystore/Keychain.
- Gestión de estados de bloqueo automático de sesión.

## Dependencias Clave
- `flutter_secure_storage`
- `local_auth`
