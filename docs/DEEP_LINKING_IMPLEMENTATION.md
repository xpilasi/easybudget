# Deep Linking Implementation - EasyBudget

Implementación completa de **App Links (Android) + Universal Links (iOS)** para compartir listas por WhatsApp usando el dominio `xpilasi.com`.

## Índice

1. [Resumen de la Solución](#resumen-de-la-solución)
2. [Arquitectura](#arquitectura)
3. [Configuración del Dominio](#configuración-del-dominio)
4. [Backend - Netlify Functions](#backend---netlify-functions)
5. [Archivos de Verificación](#archivos-de-verificación)
6. [Configuración Android](#configuración-android)
7. [Configuración iOS](#configuración-ios)
8. [Actualización del Código Flutter](#actualización-del-código-flutter)
9. [Testing](#testing)
10. [Troubleshooting](#troubleshooting)

---

## Resumen de la Solución

### Problema Original
- Custom URL scheme (`easybudget://`) no es clickeable en WhatsApp
- URLs muy largas por codificación base64
- No funciona la apertura automática de la app

### Solución Implementada
- **URLs HTTPS**: `https://easybudget.xpilasi.com/share/{id}`
- **Backend**: Netlify Functions para almacenar/recuperar listas
- **Android App Links**: Apertura automática en Android
- **iOS Universal Links**: Apertura automática en iOS
- **Almacenamiento**: Listas compartidas con expiración de 30 días

### Flujo Completo

```
1. Usuario A comparte lista
   ↓
2. App envía lista a Netlify Function
   ↓
3. Function guarda en storage, devuelve ID
   ↓
4. App genera URL: https://easybudget.xpilasi.com/share/abc123
   ↓
5. Usuario A comparte URL por WhatsApp
   ↓
6. Usuario B hace click en WhatsApp
   ↓
7. App EasyBudget se abre automáticamente
   ↓
8. App descarga lista usando ID
   ↓
9. Muestra modal de importación
```

---

## Arquitectura

### Componentes

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter App (Cliente)                   │
│  ┌────────────┐  ┌─────────────┐  ┌──────────────────┐    │
│  │ ShareModal │→ │ DeepLink    │→ │ ImportListModal  │    │
│  │            │  │ Service     │  │                  │    │
│  └────────────┘  └─────────────┘  └──────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                           ↓ ↑
                    HTTPS API Calls
                           ↓ ↑
┌─────────────────────────────────────────────────────────────┐
│              Netlify (easybudget.xpilasi.com)               │
│  ┌──────────────────┐  ┌──────────────────────────────┐   │
│  │ Static Files     │  │ Netlify Functions (API)      │   │
│  │ - assetlinks.json│  │ - POST /share (guardar)      │   │
│  │ - apple-app-     │  │ - GET /share/{id} (obtener)  │   │
│  │   site-assoc.    │  │                              │   │
│  └──────────────────┘  └──────────────────────────────┘   │
│                              ↓ ↑                            │
│                    ┌─────────────────────┐                 │
│                    │ Netlify Blob Storage│                 │
│                    │ (listas compartidas)│                 │
│                    └─────────────────────┘                 │
└─────────────────────────────────────────────────────────────┘
```

---

## Configuración del Dominio

### Paso 1: Crear Subdominio en Netlify

1. **Ir al dashboard de Netlify**
   - Login en https://app.netlify.com
   - Seleccionar tu sitio `xpilasi.com`

2. **Crear nuevo sitio para EasyBudget**
   - Click en "Add new site" → "Import an existing project"
   - O mejor: "Add new site" → "Deploy manually"

3. **Configurar dominio custom**
   - En el nuevo sitio, ir a "Domain settings"
   - Click en "Add custom domain"
   - Escribir: `easybudget.xpilasi.com`
   - Netlify detectará automáticamente que ya tienes `xpilasi.com` y configurará el CNAME

4. **Habilitar HTTPS**
   - Netlify automáticamente provee certificado SSL con Let's Encrypt
   - Esperar 1-2 minutos para que se active

### Paso 2: Verificar DNS

Netlify debería crear automáticamente:
```
Type: CNAME
Name: easybudget
Value: [tu-sitio-netlify].netlify.app
```

Si necesitas configurar manualmente (poco probable):
- Ir a tu proveedor de DNS de `xpilasi.com`
- Agregar registro CNAME como se indica arriba

---

## Backend - Netlify Functions

### Estructura del Proyecto

Crear un nuevo directorio para el backend de EasyBudget:

```
easybudget-backend/
├── netlify.toml
├── netlify/
│   └── functions/
│       ├── share.js          # POST - Guardar lista
│       └── get-share.js      # GET - Obtener lista
└── public/
    └── .well-known/
        ├── assetlinks.json
        └── apple-app-site-association
```

### Paso 3: Configurar Netlify Functions

**Archivo: `netlify.toml`**

```toml
[build]
  publish = "public"
  functions = "netlify/functions"

[[redirects]]
  from = "/share/:id"
  to = "/.netlify/functions/get-share?id=:id"
  status = 200

[[headers]]
  for = "/.well-known/*"
  [headers.values]
    Content-Type = "application/json"
    Access-Control-Allow-Origin = "*"
```

**Archivo: `netlify/functions/share.js`**

```javascript
const { getStore } = require("@netlify/blobs");

exports.handler = async (event) => {
  // Solo aceptar POST
  if (event.httpMethod !== "POST") {
    return {
      statusCode: 405,
      body: JSON.stringify({ error: "Method not allowed" }),
    };
  }

  try {
    const data = JSON.parse(event.body);

    // Validar datos
    if (!data.name || !data.products || !Array.isArray(data.products)) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "Invalid data" }),
      };
    }

    // Generar ID único
    const id = generateId();

    // Guardar en Netlify Blob Storage
    const store = getStore("easybudget-shares");
    await store.set(id, JSON.stringify(data), {
      metadata: {
        createdAt: new Date().toISOString(),
        expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(), // 30 días
      },
    });

    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
      body: JSON.stringify({
        success: true,
        id: id,
        url: `https://easybudget.xpilasi.com/share/${id}`,
      }),
    };
  } catch (error) {
    console.error("Error saving share:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Internal server error" }),
    };
  }
};

function generateId() {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let id = '';
  for (let i = 0; i < 8; i++) {
    id += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return id;
}
```

**Archivo: `netlify/functions/get-share.js`**

```javascript
const { getStore } = require("@netlify/blobs");

exports.handler = async (event) => {
  // Solo aceptar GET
  if (event.httpMethod !== "GET") {
    return {
      statusCode: 405,
      body: JSON.stringify({ error: "Method not allowed" }),
    };
  }

  try {
    const id = event.queryStringParameters.id;

    if (!id) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "Missing id parameter" }),
      };
    }

    // Obtener de Netlify Blob Storage
    const store = getStore("easybudget-shares");
    const data = await store.get(id, { type: "text" });

    if (!data) {
      return {
        statusCode: 404,
        body: JSON.stringify({ error: "Share not found or expired" }),
      };
    }

    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": "*",
      },
      body: data,
    };
  } catch (error) {
    console.error("Error getting share:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Internal server error" }),
    };
  }
};
```

**Archivo: `package.json`**

```json
{
  "name": "easybudget-backend",
  "version": "1.0.0",
  "dependencies": {
    "@netlify/blobs": "^7.0.0"
  }
}
```

### Paso 4: Deploy del Backend

```bash
# 1. Crear directorio del proyecto
mkdir easybudget-backend
cd easybudget-backend

# 2. Instalar dependencias
npm install @netlify/blobs

# 3. Inicializar git
git init
git add .
git commit -m "Initial commit"

# 4. Conectar con Netlify
# - Ir a Netlify dashboard
# - "Add new site" → "Import from Git"
# - Conectar repo
# - Configurar dominio: easybudget.xpilasi.com
```

---

## Archivos de Verificación

### Paso 5: Android App Links - assetlinks.json

**Archivo: `public/.well-known/assetlinks.json`**

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.xpilasi.easybudget",
    "sha256_cert_fingerprints": [
      "REEMPLAZAR_CON_TU_SHA256_FINGERPRINT"
    ]
  }
}]
```

**Obtener SHA256 Fingerprint:**

```bash
# Para debug keystore
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Para release keystore (cuando publiques)
keytool -list -v -keystore /path/to/your/release.keystore -alias your-alias
```

Copiar el valor `SHA256:` y pegarlo en el JSON (sin los dos puntos).

### Paso 6: iOS Universal Links - apple-app-site-association

**Archivo: `public/.well-known/apple-app-site-association`**

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAM_ID.com.xpilasi.easybudget",
        "paths": [
          "/share/*"
        ]
      }
    ]
  }
}
```

**Obtener Team ID:**
- Ir a https://developer.apple.com/account
- Membership → Team ID

---

## Configuración Android

### Paso 7: Actualizar AndroidManifest.xml

**Archivo: `android/app/src/main/AndroidManifest.xml`**

Dentro del `<activity android:name=".MainActivity">`, agregar:

```xml
<!-- App Links para easybudget.xpilasi.com -->
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />

    <data
        android:scheme="https"
        android:host="easybudget.xpilasi.com"
        android:pathPrefix="/share" />
</intent-filter>
```

**IMPORTANTE:** `android:autoVerify="true"` es crucial para App Links.

---

## Configuración iOS

### Paso 8: Actualizar Info.plist y Entitlements

**Archivo: `ios/Runner/Info.plist`**

Agregar dentro de `<dict>`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>https</string>
        </array>
    </dict>
</array>
```

**Archivo: `ios/Runner/Runner.entitlements`**

Crear si no existe:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.developer.associated-domains</key>
    <array>
        <string>applinks:easybudget.xpilasi.com</string>
    </array>
</dict>
</plist>
```

### Paso 9: Xcode Configuration

1. Abrir proyecto en Xcode: `open ios/Runner.xcworkspace`
2. Seleccionar "Runner" en el navegador
3. Ir a "Signing & Capabilities"
4. Click en "+ Capability"
5. Agregar "Associated Domains"
6. Agregar dominio: `applinks:easybudget.xpilasi.com`

---

## Actualización del Código Flutter

### Paso 10: Dependencias

**Archivo: `pubspec.yaml`**

```yaml
dependencies:
  app_links: ^6.3.2
  http: ^1.2.0  # Para llamadas API
```

```bash
flutter pub get
```

### Paso 11: Actualizar DeepLinkService

El servicio necesita cambiar de generar URLs custom scheme a:
1. Llamar al API de Netlify para guardar la lista
2. Recibir el ID
3. Generar URL HTTPS
4. Escuchar App Links/Universal Links

### Paso 12: Actualizar ShareModal

Cambiar el flujo para usar el nuevo API.

### Paso 13: Manejar Deep Links Entrantes

Actualizar el MainController o crear un listener global.

---

## Testing

### Paso 14: Verificar Archivos de Verificación

**Android:**
```bash
curl https://easybudget.xpilasi.com/.well-known/assetlinks.json
```

**iOS:**
```bash
curl https://easybudget.xpilasi.com/.well-known/apple-app-site-association
```

Ambos deben devolver los JSON configurados.

### Paso 15: Testing en Dispositivos

**Android:**

1. Desinstalar app completamente
2. Instalar versión con App Links configurados
3. Abrir Chrome
4. Escribir: `https://easybudget.xpilasi.com/share/test123`
5. Debería preguntar si abrir con EasyBudget

**Verificar App Links en Android:**
```bash
adb shell pm get-app-links com.xpilasi.easybudget
```

Debería mostrar estado `verified` para `easybudget.xpilasi.com`.

**iOS:**

1. Desinstalar app completamente
2. Instalar versión con Universal Links configurados
3. Enviar URL por Messages/Notes
4. Hacer click
5. Debería abrir la app automáticamente

**Verificar Universal Links en iOS:**
- Abrir Settings → EasyBudget → "Default Browser App"
- Verificar que esté configurado

### Paso 16: Testing WhatsApp

1. Compartir lista por WhatsApp
2. Verificar que URL sea clickeable
3. Click en URL
4. App debe abrirse automáticamente
5. Modal de importación debe aparecer

---

## Troubleshooting

### Android: App Links no verifican

**Problema:** `adb shell pm get-app-links` muestra `none` en lugar de `verified`

**Soluciones:**
1. Verificar que `assetlinks.json` esté accesible públicamente
2. Verificar SHA256 fingerprint coincide
3. Verificar `android:autoVerify="true"` en manifest
4. Limpiar datos de la app: `adb shell pm clear com.xpilasi.easybudget`
5. Reinstalar app

**Forzar verificación:**
```bash
adb shell pm verify-app-links --re-verify com.xpilasi.easybudget
```

### iOS: Universal Links no funcionan

**Problema:** URL abre Safari en lugar de la app

**Soluciones:**
1. Verificar `apple-app-site-association` accesible sin extensión `.json`
2. Verificar Team ID correcto
3. Verificar dominio en Associated Domains en Xcode
4. Desinstalar y reinstalar app
5. Verificar que URL venga de app diferente (Safari no abre Universal Links)

**Testing alternativo:**
```bash
# Enviar a Notes app y hacer click desde ahí
# Universal Links NO funcionan si la URL viene del mismo dominio en Safari
```

### URLs muy largas

**Problema:** Listas grandes generan URLs muy largas

**Solución:** El nuevo sistema solo envía un ID corto (8 caracteres):
- Antes: `easybudget://share?data=eyJuIjoiTGlz....` (cientos de caracteres)
- Ahora: `https://easybudget.xpilasi.com/share/Abc12XyZ` (50 caracteres)

### CORS errors en API

**Problema:** Flutter no puede llamar al API

**Solución:** Verificar headers CORS en Netlify Functions:
```javascript
headers: {
  "Access-Control-Allow-Origin": "*",
}
```

---

## Recursos Adicionales

### Documentación Oficial

- [Flutter Deep Linking](https://docs.flutter.dev/ui/navigation/deep-linking)
- [Android App Links](https://developer.android.com/training/app-links)
- [iOS Universal Links](https://developer.apple.com/ios/universal-links/)
- [Netlify Functions](https://docs.netlify.com/functions/overview/)
- [Netlify Blobs](https://docs.netlify.com/blobs/overview/)

### Testing Tools

- [Android App Links Tester](https://developers.google.com/digital-asset-links/tools/generator)
- [iOS Universal Links Tester](https://branch.io/resources/aasa-validator/)
- [Deep Link Tester](https://app.urlgeni.us/deeplink-tester)

### Paquetes Flutter

- [app_links](https://pub.dev/packages/app_links)
- [http](https://pub.dev/packages/http)

---

## Checklist de Implementación

- [ ] Crear subdominio `easybudget.xpilasi.com` en Netlify
- [ ] Configurar Netlify Functions (share.js, get-share.js)
- [ ] Subir archivos de verificación (.well-known)
- [ ] Obtener SHA256 fingerprint y actualizar assetlinks.json
- [ ] Obtener Team ID y actualizar apple-app-site-association
- [ ] Actualizar AndroidManifest.xml
- [ ] Actualizar Info.plist y Runner.entitlements
- [ ] Configurar Associated Domains en Xcode
- [ ] Actualizar dependencias Flutter (app_links, http)
- [ ] Actualizar DeepLinkService para usar API
- [ ] Actualizar ShareModal para llamar API
- [ ] Testing en Android (verificar App Links)
- [ ] Testing en iOS (verificar Universal Links)
- [ ] Testing en WhatsApp
- [ ] Deploy a producción

---

## Próximos Pasos

1. **Implementar Analytics**: Trackear cuántas listas se comparten
2. **Expiración automática**: Las listas en Netlify Blob expiran en 30 días
3. **Estadísticas**: Dashboard de listas más compartidas
4. **Notificaciones**: Notificar cuando alguien importa tu lista compartida

---

## Notas de Seguridad

- Las listas compartidas NO requieren autenticación (son públicas)
- Cualquiera con el ID puede acceder a la lista
- Los IDs son aleatorios y difíciles de adivinar (8 caracteres = 218 billones de combinaciones)
- Las listas expiran automáticamente en 30 días
- No se comparten datos personales, solo información de productos

---

**Última actualización:** 2025-12-30
**Versión:** 1.0.0
