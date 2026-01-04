# Configuración de Firebase para EasyBudget - Guía Única

Esta es la ÚNICA guía que necesitas seguir. Todo está aquí.

---

## ✅ Lo que YA está hecho (no necesitas hacer esto)

1. ✅ Dependencias de Firebase agregadas a `pubspec.yaml`
2. ✅ Código de Firebase preparado en `DeepLinkService`
3. ✅ `main.dart` preparado para inicializar Firebase
4. ✅ Android App Links configurado
5. ✅ Dominio `easybudget.xpilasi.com` funcionando

---

## 📋 Pasos que TÚ debes seguir (20 minutos)

### Paso 1: Crear Proyecto Firebase (3 min)

1. Ve a https://console.firebase.google.com/
2. Click **"Agregar proyecto"** (o "Add project")
3. Nombre: **`easybudget`** (o el que prefieras)
4. Click **"Continuar"**
5. **Desactivar** Google Analytics (no es necesario)
6. Click **"Crear proyecto"**
7. Espera unos segundos
8. Click **"Continuar"**

---

### Paso 2: Registrar App Android (3 min)

1. En el dashboard de Firebase, click en el ícono **Android** (🤖)
2. Completa el formulario:
   - **Package name**: `com.example.easy_budget`
   - **App nickname** (opcional): `EasyBudget`
   - **SHA-1** (opcional): Dejar vacío por ahora
3. Click **"Registrar app"**

---

### Paso 3: Descargar google-services.json (1 min)

1. Click en **"Descargar google-services.json"**
2. **IMPORTANTE**: Guarda el archivo en esta ubicación EXACTA:
   ```
   /Users/macbook/Desktop/proyectos/easy-budget/easy_budget/android/app/google-services.json
   ```

3. **IGNORA** las instrucciones que Firebase te muestra sobre "Agregar SDK"
4. Click **"Siguiente"** hasta que termine el wizard

**Verificar que el archivo está en el lugar correcto:**
```bash
ls -la /Users/macbook/Desktop/proyectos/easy-budget/easy_budget/android/app/google-services.json
```

---

### Paso 4: Crear Realtime Database (2 min)

1. En Firebase Console, menú lateral → **"Realtime Database"**
2. Click **"Crear base de datos"** (o "Create database")
3. **Ubicación**: Elige la más cercana (ej: `europe-west1`)
4. **Modo de seguridad**: Selecciona **"Comenzar en modo de prueba"**
5. Click **"Habilitar"** (o "Enable")

6. **IMPORTANTE - COPIA LA URL**:

   Verás una URL como esta:
   ```
   https://easybudget-xxxxx-default-rtdb.europe-west1.firebasedatabase.app/
   ```

   **COPIA ESTA URL COMPLETA** - La necesitarás más tarde.

---

### Paso 5: Configurar Reglas de Seguridad (2 min)

1. Dentro de Realtime Database, ve a la pestaña **"Reglas"** (o "Rules")
2. **REEMPLAZA** todo el contenido con esto:

```json
{
  "rules": {
    "shared_lists": {
      "$listId": {
        ".write": true,
        ".read": true,
        ".validate": "newData.hasChildren(['name', 'categoryName', 'currency', 'products'])",
        "createdAt": {
          ".validate": "newData.isNumber()"
        },
        "expiresAt": {
          ".validate": "newData.isNumber()"
        }
      }
    }
  }
}
```

3. Click **"Publicar"** (o "Publish")

**¿Por qué estas reglas?**
- Permiten lectura/escritura pública porque las listas compartidas son públicas por diseño
- Validan que los datos tengan la estructura correcta
- Solo afectan la ruta `shared_lists/`, no toda la base de datos

---

### Paso 6: Configurar FlutterFire CLI (5 min)

Este paso genera automáticamente el archivo `firebase_options.dart`.

```bash
# 1. Instalar FlutterFire CLI (solo una vez)
dart pub global activate flutterfire_cli

# 2. Ir al proyecto
cd /Users/macbook/Desktop/proyectos/easy-budget/easy_budget

# 3. Configurar Firebase (esto abre un browser para seleccionar el proyecto)
flutterfire configure
```

**Durante `flutterfire configure`:**
- Te pedirá seleccionar el proyecto → Elige **`easybudget`** (el que creaste)
- Te preguntará qué plataformas → Selecciona **Android** (espacio para marcar, enter para continuar)
- Generará automáticamente `lib/firebase_options.dart`

**Verificar que se creó:**
```bash
ls -la lib/firebase_options.dart
```

---

### Paso 7: Actualizar build.gradle.kts (3 min)

Ahora SÍ vamos a configurar Gradle (lo que Firebase Console pedía antes).

#### 7.1 Archivo raíz

Edita: `android/build.gradle.kts`

```bash
code android/build.gradle.kts
# o
open android/build.gradle.kts
```

**Busca la sección `plugins`** y agrégale esta línea:

```kotlin
plugins {
    id("com.android.application") version "8.1.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.0" apply false
    id("com.google.gms.google-services") version "4.4.0" apply false  // ⭐ AGREGAR
}
```

#### 7.2 Archivo de la app

Edita: `android/app/build.gradle.kts`

```bash
code android/app/build.gradle.kts
# o
open android/app/build.gradle.kts
```

**Busca la sección `plugins`** al principio del archivo y agrégale esta línea AL FINAL:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")  // ⭐ AGREGAR ESTA LÍNEA
}
```

---

### Paso 8: Instalar dependencias (1 min)

```bash
cd /Users/macbook/Desktop/proyectos/easy-budget/easy_budget
flutter pub get
```

---

### Paso 9: Verificar compilación (2 min)

Verifica que todo compila correctamente:

```bash
flutter clean
flutter run
```

Si compila sin errores, ¡Firebase está configurado! 🎉

---

## ✋ DETENTE AQUÍ Y AVÍSAME

Una vez que hayas completado los Pasos 1-9, **avísame** y proporcióname:

1. ✅ Confirmación de que `google-services.json` está en su lugar
2. ✅ La **URL de tu Realtime Database** (del Paso 4)

Ejemplo: `https://easybudget-xxxxx-default-rtdb.europe-west1.firebasedatabase.app/`

**Con esa información, yo activaré el código de Firebase en 2 minutos.**

---

## 🔧 Troubleshooting

### Error: "google-services.json not found"
**Solución**: Verifica que esté exactamente en `android/app/google-services.json`

### Error: "Failed to apply plugin 'com.google.gms.google-services'"
**Solución**:
1. Verifica que agregaste el plugin en **ambos** archivos build.gradle.kts
2. Verifica el orden (debe estar AL FINAL de la sección plugins)
3. Limpia: `cd android && ./gradlew clean && cd ..`

### Error: "flutterfire: command not found"
**Solución**:
```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
# Luego vuelve a ejecutar
dart pub global activate flutterfire_cli
```

### Firebase Console muestra "Esperando conexión de la app"
**Solución**: Es normal. Ignora ese mensaje. Cuando ejecutes la app la primera vez, desaparecerá.

---

## 🎯 Beneficios finales

Una vez activado Firebase:

- ✅ URLs HTTPS cortas: `https://easybudget.xpilasi.com/share/Abc12XyZ`
- ✅ **Clickeables en WhatsApp** (aparecen en azul, no como texto)
- ✅ Apertura automática de la app al hacer click
- ✅ Almacenamiento gratis (1GB y 100K descargas/día)
- ✅ Expiración automática en 30 días
- ✅ Sin servidor propio necesario

---

## ⏱️ Tiempo Total

- **Primera vez**: 20-25 minutos
- **Si ya tienes proyecto Firebase**: 5-10 minutos

---

**Última actualización**: 2025-12-31
**Guía creada por**: Claude (Anthropic)
