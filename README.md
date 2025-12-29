# EasyBudget - ListShare

<div align="center">
  <h3>Organiza y comparte tus listas de compras fácilmente</h3>
  <p>Una aplicación móvil intuitiva para gestionar listas de compras, controlar presupuestos y compartir con quien quieras</p>
</div>

## Características Principales

### Gestión de Listas
- Crear, editar y eliminar listas de compras
- Organizar listas por categorías personalizadas
- Cálculo automático de totales y subtotales
- Visualización de cantidad de productos e items
- Soporte para múltiples monedas

### Gestión de Productos
- Agregar productos con nombre, precio y cantidad
- Editar y eliminar productos de las listas
- Carga de imágenes para productos
- Cálculo automático de subtotales (precio × cantidad)
- Filtros avanzados de productos

### Compartir e Importar
- Compartir listas mediante deep links
- Integración con WhatsApp para compartir
- Importar listas compartidas por otros usuarios
- Enlaces optimizados con codificación Base64

### Categorías Personalizadas
- Crear y gestionar categorías
- Asignar colores e iconos a categorías
- Filtrar listas por categoría
- Editar y eliminar categorías

### Interfaz de Usuario
- Tema claro y oscuro
- Diseño moderno y responsivo
- Tipografía con Google Fonts
- Iconos de Font Awesome y Cupertino
- Componentes reutilizables y consistentes
- Estados de carga, error y vacío

### Autenticación
- Sistema de login seguro
- Gestión de sesiones de usuario
- Perfil de usuario personalizable

## Arquitectura

El proyecto sigue los principios de **Clean Architecture**, garantizando:
- Separación de responsabilidades
- Código mantenible y escalable
- Facilidad para testing
- Independencia de frameworks

### Estructura de Capas

```
lib/
├── app/                      # Configuración de la aplicación
│   ├── config/              # Constantes y strings
│   ├── routes/              # Navegación y rutas
│   ├── services/            # Servicios globales (Deep linking)
│   └── theme/               # Temas, colores, estilos
│
├── core/                    # Utilidades del core
│   └── utils/              # Helpers y utilidades
│
├── data/                    # Capa de datos
│   ├── models/             # Modelos de datos (JSON serializable)
│   ├── providers/          # Proveedores de datos (Mock, API)
│   └── repositories/       # Implementación de repositorios
│
├── domain/                  # Capa de dominio
│   ├── entities/           # Entidades de negocio
│   └── use_cases/          # Casos de uso
│
└── presentation/            # Capa de presentación
    ├── controllers/        # Controladores GetX
    ├── pages/              # Páginas de la app
    └── widgets/            # Widgets reutilizables
```

## Stack Tecnológico

### Framework
- **Flutter** ^3.10.4 - Framework multiplataforma
- **Dart** ^3.10.4 - Lenguaje de programación

### Gestión de Estado
- **GetX** ^4.6.6 - State management, routing y dependency injection

### Networking & Serialización
- **Dio** ^5.4.0 - Cliente HTTP
- **json_annotation** ^4.9.0 - Anotaciones para serialización
- **json_serializable** ^6.7.1 - Generación de código para JSON

### Almacenamiento Local
- **shared_preferences** ^2.2.2 - Almacenamiento de preferencias
- **get_storage** ^2.1.1 - Almacenamiento rápido key-value

### UI/UX
- **google_fonts** ^6.1.0 - Tipografías de Google
- **flutter_svg** ^2.0.9 - Soporte para SVG
- **cached_network_image** ^3.3.1 - Carga y caché de imágenes
- **font_awesome_flutter** ^10.7.0 - Iconos Font Awesome

### Utilidades
- **intl** ^0.19.0 - Internacionalización y formateo
- **uuid** ^4.3.3 - Generación de IDs únicos
- **share_plus** ^7.2.2 - Compartir contenido
- **url_launcher** ^6.2.4 - Abrir URLs y enlaces
- **equatable** ^2.0.5 - Comparación de objetos
- **app_links** ^6.3.2 - Deep linking
- **image_picker** ^1.0.7 - Selección de imágenes

### Desarrollo
- **flutter_lints** ^6.0.0 - Reglas de linting
- **build_runner** ^2.4.8 - Generación de código

## Casos de Uso Implementados

### Autenticación
- Login de usuario
- Logout de usuario

### Listas de Compras
- Obtener todas las listas
- Crear nueva lista
- Actualizar lista existente
- Eliminar lista
- Agregar producto a lista
- Actualizar producto en lista
- Eliminar producto de lista

### Categorías
- Obtener categorías
- Crear categoría
- Actualizar categoría
- Eliminar categoría

## Comenzar

### Prerrequisitos

- Flutter SDK ^3.10.4
- Dart SDK ^3.10.4
- Android Studio / VS Code con extensiones de Flutter
- Emulador Android/iOS o dispositivo físico

### Instalación

1. Clonar el repositorio:
```bash
git clone <repository-url>
cd easy_budget
```

2. Instalar dependencias:
```bash
flutter pub get
```

3. Generar archivos de serialización:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Ejecutar la aplicación:
```bash
flutter run
```

## Configuración de Deep Links

### Android
Agregar en `android/app/src/main/AndroidManifest.xml`:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="easybudget" android:host="share" />
</intent-filter>
```

### iOS
Agregar en `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>easybudget</string>
        </array>
    </dict>
</array>
```

## Scripts Útiles

```bash
# Ejecutar análisis estático
flutter analyze

# Ejecutar tests
flutter test

# Generar código (modelos JSON)
flutter pub run build_runner build

# Limpiar proyecto
flutter clean

# Construir APK (Android)
flutter build apk --release

# Construir IPA (iOS)
flutter build ios --release
```

## Estructura de Navegación

- `/splash` - Pantalla de inicio
- `/login` - Autenticación
- `/main` - Contenedor principal con bottom navigation
  - `/home` - Dashboard principal
  - `/lists` - Gestión de listas
  - `/profile` - Perfil de usuario
- `/list-detail` - Detalle de una lista específica
- `/categories` - Gestión de categorías
- `/notifications` - Notificaciones
- `/help` - Ayuda
- `/about` - Acerca de

## Características de Compartir

EasyBudget permite compartir listas mediante:

1. **Deep Links**: Genera enlaces `easybudget://share?data=<encoded_data>`
2. **WhatsApp**: Mensaje optimizado con resumen de la lista
3. **Otras apps**: Mediante Share Sheet nativo

El formato de datos compartidos incluye:
- Nombre de la lista
- Categoría
- Moneda
- Productos (nombre, precio, cantidad)

## Estado del Proyecto

Versión actual: **1.0.0+1**

## Licencia

Este proyecto es privado y no está publicado en ningún repositorio público.

## Soporte

Para reportar bugs o solicitar nuevas características, por favor contacta al equipo de desarrollo.
