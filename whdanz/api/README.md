# WhDanz API

API REST para la aplicación WhDanz. Maneja autenticación y operaciones de base de datos.

## Requisitos

- Node.js 18+
- Firebase Admin SDK credentials

## Configuración

### 1. Obtener credenciales de Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ir a **Configuración del proyecto** (ícono de engranaje)
4. Selecciona **Cuentas de servicio**
5. Click en **Generar nueva clave privada**
6. Descarga el archivo JSON
7. Renómbralo a `service-account-key.json` y colócalo en la raíz de `api/`

### 2. Configurar variables de entorno

Copia el archivo `.env.example` a `.env`:

```bash
cd whdanz/api
cp .env.example .env
```

Edita `.env` con tu configuración:

```env
PORT=3000
GOOGLE_APPLICATION_CREDENTIALS=./service-account-key.json
```

### 3. Instalar dependencias

```bash
cd whdanz/api
npm install
```

### 4. Iniciar el servidor

Desarrollo (con hot reload):
```bash
npm run dev
```

Producción:
```bash
npm start
```

El servidor correrá en `http://localhost:3000`

## Endpoints

### Autenticación

| Método | Endpoint | Descripción |
|--------|----------|--------------|
| POST | `/api/auth/register` | Registrar nuevo usuario |
| POST | `/api/auth/login` | Iniciar sesión |
| GET | `/api/auth/verify` | Verificar token |

### Usuarios

| Método | Endpoint | Descripción |
|--------|----------|--------------|
| GET | `/api/users/profile` | Obtener perfil del usuario actual |
| PUT | `/api/users/profile` | Actualizar perfil del usuario |
| GET | `/api/users/:uid` | Obtener usuario por ID |

## Uso desde Flutter

La URL base de la API está configurada en `lib/core/services/api_service.dart`:

```dart
static const String baseUrl = 'http://10.0.2.2:3000/api';
```

**Nota:** `10.0.2.2` es el alias para localhost del emulador de Android. Para dispositivo físico, usa la IP de tu computadora.

## Formato de respuestas

Éxito:
```json
{
  "success": true,
  "user": { ... },
  "token": "..."
}
```

Error:
```json
{
  "error": "Mensaje de error"
}
```
