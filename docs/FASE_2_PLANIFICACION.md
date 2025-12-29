# Fase 2 - Planificación de Implementación
## Easy Budget App - Historial y Analytics

---

## 1. RESUMEN EJECUTIVO

Esta fase implementa funcionalidades avanzadas de historial, análisis de datos y visualización de información para convertir Easy Budget en una herramienta completa de seguimiento de gastos.

### Objetivos de la Fase 2
- Implementar sistema de historial de compras completadas
- Agregar visualización de variaciones de precio
- Crear módulo de analytics y estadísticas
- Mejorar la experiencia del usuario con gráficos interactivos

---

## 2. ANÁLISIS DE ARQUITECTURA ACTUAL

### 2.1 Estructura del Proyecto

```
lib/
├── app/
│   ├── config/          # Constantes y configuración
│   ├── routes/          # Definición de rutas
│   ├── services/        # Servicios (deep links)
│   └── theme/           # Temas y estilos
├── bindings/            # Bindings de GetX
├── core/
│   └── utils/           # Utilidades
├── data/
│   ├── models/          # Modelos de datos (JSON serializable)
│   ├── providers/       # Providers (storage, mock data)
│   └── repositories/    # Implementación de repositorios
├── domain/
│   ├── entities/        # Entidades del dominio
│   └── use_cases/       # Casos de uso
└── presentation/
    ├── controllers/     # Controladores GetX
    ├── pages/           # Páginas de la app
    └── widgets/         # Widgets reutilizables
```

### 2.2 Tecnologías Utilizadas

- **Framework**: Flutter 3.x
- **Gestión de Estado**: GetX
- **Persistencia**: GetStorage (local storage)
- **Arquitectura**: Clean Architecture
- **Serialización**: json_annotation / json_serializable
- **Patrones**: Repository Pattern, Use Cases

### 2.3 Entidades Actuales

#### ShoppingList
```dart
class ShoppingList {
  final String id;
  final String name;
  final String categoryId;
  final String currency;
  final List<Product> products;
  final DateTime createdAt;
}
```

#### Product
```dart
class Product {
  final String id;
  final String name;
  final double price;
  final int quantity;
}
```

### 2.4 Flujo de Datos Actual

1. **Presentación** → Controller (GetX)
2. **Controller** → Use Case
3. **Use Case** → Repository
4. **Repository** → LocalStorageProvider (GetStorage)

---

## 3. HISTORIAS DE USUARIO

### HU-1: Guardar compra completada
**Como** usuario
**Quiero** poder marcar una lista como "compra completada" y guardarla
**Para** tener un registro de mis compras pasadas

**Criterios de Aceptación:**
- Botón de "Completar Compra" visible en el detalle de la lista
- Dialog de confirmación antes de completar
- La lista se mueve al historial automáticamente
- Se guarda la fecha de finalización
- No se puede editar una lista completada
- Los precios de los productos se guardan en el historial

---

### HU-2: Ver historial de compras
**Como** usuario
**Quiero** ver un historial de todas mis compras completadas
**Para** revisar qué compré anteriormente

**Criterios de Aceptación:**
- Nuevo tab "Historial" en el bottom navigation
- Lista de compras ordenadas por fecha (más reciente primero)
- Mostrar fecha de compra, nombre de lista y total
- Al hacer tap, ver detalle de la compra (solo lectura)
- Filtros: por fecha, por categoría, por rango de precio
- Búsqueda por nombre de lista o producto

---

### HU-3: Ver variaciones de precio de productos
**Como** usuario
**Quiero** ver cómo ha variado el precio de un producto en el tiempo
**Para** identificar tendencias y mejores momentos de compra

**Criterios de Aceptación:**
- Gráfico de líneas mostrando la evolución del precio
- Eje X: fechas de compras
- Eje Y: precio del producto
- Mostrar precio mínimo, máximo y promedio
- Poder ver el detalle de cada punto (fecha y precio)
- Filtrar por rango de fechas
- Disponible desde el detalle del producto en historial

---

### HU-4: Ver totales de compras
**Como** usuario
**Quiero** ver el resumen de mis gastos totales
**Para** analizar mis patrones de consumo

**Criterios de Aceptación:**
- Página de "Estadísticas" o "Analytics"
- Vista de lista: mostrar total por cada compra
- Vista de gráfico: barras con totales por periodo
- Periodos: semanal, mensual, anual
- Mostrar total general, promedio, compra más alta/baja
- Gráfico circular por categorías
- Filtros por fecha y categoría

---

## 4. MODELO DE DATOS - CAMBIOS REQUERIDOS

### 4.1 Modificaciones a Entidades Existentes

#### ShoppingList (modificada)
```dart
class ShoppingList {
  final String id;
  final String name;
  final String categoryId;
  final String currency;
  final List<Product> products;
  final DateTime createdAt;

  // NUEVOS CAMPOS
  final bool isCompleted;           // Si está en el historial
  final DateTime? completedAt;      // Fecha de finalización
  final double? completedTotal;     // Total al momento de completar
}
```

### 4.2 Nueva Entidad: PriceHistoryEntry

```dart
class PriceHistoryEntry {
  final String id;
  final String productName;        // Nombre del producto
  final double price;              // Precio registrado
  final DateTime date;             // Fecha de la compra
  final String listId;             // ID de la lista donde se compró
  final String listName;           // Nombre de la lista
}
```

### 4.3 Estructura de Storage

```
GetStorage keys:
- 'lists'                    # Listas activas
- 'completed_lists'          # Listas completadas (historial)
- 'price_history'            # Array de PriceHistoryEntry
```

---

## 5. PLAN DE IMPLEMENTACIÓN

### 5.1 Fase 2.1 - Sistema de Historial (HU-1, HU-2)

#### Tarea 2.1.1: Actualizar modelo de datos
- **Archivos a modificar:**
  - `lib/domain/entities/shopping_list.dart`
  - `lib/data/models/shopping_list_model.dart`
  - `lib/data/models/shopping_list_model.g.dart` (regenerar)

- **Subtareas:**
  1. Agregar campos `isCompleted`, `completedAt`, `completedTotal` a ShoppingList
  2. Actualizar método `copyWith`
  3. Actualizar props de Equatable
  4. Actualizar ShoppingListModel con nuevos campos
  5. Actualizar serialización JSON
  6. Ejecutar `flutter pub run build_runner build --delete-conflicting-outputs`

#### Tarea 2.1.2: Crear entidad PriceHistoryEntry
- **Archivos a crear:**
  - `lib/domain/entities/price_history_entry.dart`
  - `lib/data/models/price_history_entry_model.dart`
  - `lib/data/models/price_history_entry_model.g.dart`

- **Subtareas:**
  1. Crear entidad de dominio
  2. Crear modelo serializable
  3. Ejecutar build_runner

#### Tarea 2.1.3: Actualizar LocalStorageProvider
- **Archivo a modificar:**
  - `lib/data/providers/local_storage_provider.dart`

- **Subtareas:**
  1. Agregar métodos para listas completadas
     - `saveCompletedLists()`
     - `getCompletedLists()`
  2. Agregar métodos para historial de precios
     - `savePriceHistory()`
     - `getPriceHistory()`
     - `addPriceHistoryEntry()`

#### Tarea 2.1.4: Actualizar ShoppingListRepository
- **Archivos a modificar:**
  - `lib/data/repositories/shopping_list_repository.dart`
  - `lib/data/repositories/shopping_list_repository_impl.dart`

- **Subtareas:**
  1. Agregar método `completeList(String listId)`
  2. Agregar método `getCompletedLists()`
  3. Implementar lógica de completar compra:
     - Marcar lista como completada
     - Guardar fecha y total
     - Mover de listas activas a completadas
     - Registrar precios en historial

#### Tarea 2.1.5: Crear Use Cases de Historial
- **Archivos a crear:**
  - `lib/domain/use_cases/shopping_list/complete_list_use_case.dart`
  - `lib/domain/use_cases/shopping_list/get_completed_lists_use_case.dart`

- **Subtareas:**
  1. Implementar CompleteListUseCase
  2. Implementar GetCompletedListsUseCase

#### Tarea 2.1.6: Actualizar ListDetailController
- **Archivo a modificar:**
  - `lib/presentation/controllers/list_detail_controller.dart`

- **Subtareas:**
  1. Agregar método `completeList()`
  2. Agregar confirmación de completar compra
  3. Mostrar botón solo si lista no está completada
  4. Navegar al historial después de completar

#### Tarea 2.1.7: Crear página de Historial
- **Archivos a crear:**
  - `lib/presentation/pages/history/history_page.dart`
  - `lib/presentation/pages/history/history_binding.dart`
  - `lib/presentation/controllers/history_controller.dart`

- **Subtareas:**
  1. Crear estructura de página
  2. Implementar lista de compras completadas
  3. Agregar ordenamiento por fecha
  4. Implementar búsqueda
  5. Agregar filtros (fecha, categoría, precio)
  6. Al hacer tap, navegar a detalle (solo lectura)

#### Tarea 2.1.8: Actualizar MainPage
- **Archivo a modificar:**
  - `lib/presentation/pages/main/main_page.dart`
  - `lib/presentation/controllers/main_controller.dart`

- **Subtareas:**
  1. Agregar 4to tab "Historial"
  2. Actualizar NavigationBar con nuevo destino
  3. Agregar HistoryPage al switch de páginas

#### Tarea 2.1.9: Actualizar rutas
- **Archivos a modificar:**
  - `lib/app/routes/app_routes.dart`
  - `lib/app/routes/app_pages.dart`

- **Subtareas:**
  1. Agregar ruta `/history`
  2. Configurar binding

---

### 5.2 Fase 2.2 - Gráficos de Precio (HU-3)

#### Tarea 2.2.1: Agregar dependencia de gráficos
- **Archivo a modificar:**
  - `pubspec.yaml`

- **Subtareas:**
  1. Agregar `fl_chart: ^0.69.0` (o versión más reciente)
  2. Ejecutar `flutter pub get`

#### Tarea 2.2.2: Crear repositorio de historial de precios
- **Archivos a crear:**
  - `lib/data/repositories/price_history_repository.dart`
  - `lib/data/repositories/price_history_repository_impl.dart`

- **Subtareas:**
  1. Crear interfaz del repositorio
  2. Implementar métodos:
     - `getPriceHistoryForProduct(String productName)`
     - `getPriceHistoryInDateRange(DateTime start, DateTime end)`
     - `addPriceHistoryEntry(PriceHistoryEntry entry)`

#### Tarea 2.2.3: Crear Use Cases de historial de precios
- **Archivos a crear:**
  - `lib/domain/use_cases/price_history/get_product_price_history_use_case.dart`

- **Subtareas:**
  1. Implementar GetProductPriceHistoryUseCase
  2. Calcular estadísticas (min, max, promedio)

#### Tarea 2.2.4: Crear página de detalle de precio de producto
- **Archivos a crear:**
  - `lib/presentation/pages/product_price_detail/product_price_detail_page.dart`
  - `lib/presentation/pages/product_price_detail/product_price_detail_binding.dart`
  - `lib/presentation/controllers/product_price_detail_controller.dart`

- **Subtareas:**
  1. Crear estructura de página
  2. Implementar gráfico de líneas con fl_chart
  3. Mostrar estadísticas (min, max, promedio)
  4. Agregar filtro de rango de fechas
  5. Mostrar tooltips con información de cada punto

#### Tarea 2.2.5: Integrar acceso desde historial
- **Archivo a modificar:**
  - `lib/presentation/pages/list_detail/list_detail_page.dart`

- **Subtareas:**
  1. En vista de lista completada, hacer productos clickeables
  2. Al hacer tap en producto, navegar a detalle de precio

---

### 5.3 Fase 2.3 - Analytics y Estadísticas (HU-4)

#### Tarea 2.3.1: Crear servicio de Analytics
- **Archivo a crear:**
  - `lib/domain/services/analytics_service.dart`

- **Subtareas:**
  1. Métodos para calcular:
     - Total por periodo (día, semana, mes, año)
     - Promedio de compras
     - Compra más alta/baja
     - Total por categoría
     - Tendencias

#### Tarea 2.3.2: Crear Use Cases de Analytics
- **Archivos a crear:**
  - `lib/domain/use_cases/analytics/get_spending_summary_use_case.dart`
  - `lib/domain/use_cases/analytics/get_category_breakdown_use_case.dart`

- **Subtareas:**
  1. Implementar GetSpendingSummaryUseCase
  2. Implementar GetCategoryBreakdownUseCase

#### Tarea 2.3.3: Crear página de Analytics
- **Archivos a crear:**
  - `lib/presentation/pages/analytics/analytics_page.dart`
  - `lib/presentation/pages/analytics/analytics_binding.dart`
  - `lib/presentation/controllers/analytics_controller.dart`

- **Subtareas:**
  1. Crear estructura con tabs: "Resumen", "Por Categoría", "Tendencias"
  2. Tab Resumen:
     - Cards con totales generales
     - Gráfico de barras por periodo
     - Lista de compras ordenadas por total
  3. Tab Por Categoría:
     - Gráfico circular (pie chart)
     - Lista de categorías con porcentajes
  4. Tab Tendencias:
     - Gráfico de líneas de gasto en el tiempo
     - Promedio móvil
  5. Agregar selectores de periodo
  6. Agregar filtros de fecha

#### Tarea 2.3.4: Crear widgets de gráficos reutilizables
- **Archivos a crear:**
  - `lib/presentation/widgets/charts/line_chart_widget.dart`
  - `lib/presentation/widgets/charts/bar_chart_widget.dart`
  - `lib/presentation/widgets/charts/pie_chart_widget.dart`

- **Subtareas:**
  1. Wrapper de fl_chart para gráfico de líneas
  2. Wrapper de fl_chart para gráfico de barras
  3. Wrapper de fl_chart para gráfico circular
  4. Aplicar tema de la app
  5. Agregar animaciones

#### Tarea 2.3.5: Agregar acceso a Analytics
- **Archivos a modificar:**
  - `lib/presentation/pages/profile/profile_page.dart`
  - `lib/app/routes/app_pages.dart`

- **Subtareas:**
  1. Agregar opción "Estadísticas" en ProfilePage
  2. Configurar ruta y binding
  3. O agregar como 5to tab en MainPage (decisión de diseño)

---

### 5.4 Fase 2.4 - Mejoras de UX

#### Tarea 2.4.1: Agregar indicadores visuales
- **Subtareas:**
  1. Badge en tab de historial con cantidad de compras este mes
  2. Animaciones al completar compra
  3. Empty states para historial vacío
  4. Skeleton loaders para gráficos

#### Tarea 2.4.2: Mejorar feedback al usuario
- **Subtareas:**
  1. Snackbar al completar compra con opción de deshacer
  2. Confirmaciones antes de acciones importantes
  3. Mensajes de error claros

#### Tarea 2.4.3: Optimizaciones de rendimiento
- **Subtareas:**
  1. Paginación en historial si hay muchas compras
  2. Lazy loading de gráficos
  3. Caché de cálculos de analytics

---

## 6. ESTRUCTURA DE ARCHIVOS A CREAR/MODIFICAR

### 6.1 Archivos Nuevos (30 archivos)

```
lib/
├── domain/
│   ├── entities/
│   │   └── price_history_entry.dart                    [NUEVO]
│   ├── services/
│   │   └── analytics_service.dart                      [NUEVO]
│   └── use_cases/
│       ├── shopping_list/
│       │   ├── complete_list_use_case.dart             [NUEVO]
│       │   └── get_completed_lists_use_case.dart       [NUEVO]
│       ├── price_history/
│       │   └── get_product_price_history_use_case.dart [NUEVO]
│       └── analytics/
│           ├── get_spending_summary_use_case.dart      [NUEVO]
│           └── get_category_breakdown_use_case.dart    [NUEVO]
├── data/
│   ├── models/
│   │   ├── price_history_entry_model.dart              [NUEVO]
│   │   └── price_history_entry_model.g.dart            [NUEVO]
│   └── repositories/
│       ├── price_history_repository.dart               [NUEVO]
│       └── price_history_repository_impl.dart          [NUEVO]
└── presentation/
    ├── controllers/
    │   ├── history_controller.dart                     [NUEVO]
    │   ├── product_price_detail_controller.dart        [NUEVO]
    │   └── analytics_controller.dart                   [NUEVO]
    ├── pages/
    │   ├── history/
    │   │   ├── history_page.dart                       [NUEVO]
    │   │   └── history_binding.dart                    [NUEVO]
    │   ├── product_price_detail/
    │   │   ├── product_price_detail_page.dart          [NUEVO]
    │   │   └── product_price_detail_binding.dart       [NUEVO]
    │   └── analytics/
    │       ├── analytics_page.dart                     [NUEVO]
    │       └── analytics_binding.dart                  [NUEVO]
    └── widgets/
        ├── charts/
        │   ├── line_chart_widget.dart                  [NUEVO]
        │   ├── bar_chart_widget.dart                   [NUEVO]
        │   └── pie_chart_widget.dart                   [NUEVO]
        └── history/
            ├── completed_list_card.dart                [NUEVO]
            └── history_filter_modal.dart               [NUEVO]
```

### 6.2 Archivos a Modificar (12 archivos)

```
lib/
├── domain/
│   └── entities/
│       └── shopping_list.dart                          [MODIFICAR]
├── data/
│   ├── models/
│   │   ├── shopping_list_model.dart                    [MODIFICAR]
│   │   └── shopping_list_model.g.dart                  [REGENERAR]
│   ├── providers/
│   │   └── local_storage_provider.dart                 [MODIFICAR]
│   └── repositories/
│       ├── shopping_list_repository.dart               [MODIFICAR]
│       └── shopping_list_repository_impl.dart          [MODIFICAR]
├── presentation/
│   ├── controllers/
│   │   ├── main_controller.dart                        [MODIFICAR]
│   │   └── list_detail_controller.dart                 [MODIFICAR]
│   └── pages/
│       ├── main/
│       │   └── main_page.dart                          [MODIFICAR]
│       ├── list_detail/
│       │   └── list_detail_page.dart                   [MODIFICAR]
│       └── profile/
│           └── profile_page.dart                       [MODIFICAR]
├── app/
│   ├── routes/
│   │   ├── app_routes.dart                             [MODIFICAR]
│   │   └── app_pages.dart                              [MODIFICAR]
│   └── config/
│       └── app_constants.dart                          [MODIFICAR]
└── pubspec.yaml                                        [MODIFICAR]
```

---

## 7. DEPENDENCIAS NUEVAS

### 7.1 Agregar a pubspec.yaml

```yaml
dependencies:
  fl_chart: ^0.69.0              # Gráficos interactivos
  intl: ^0.19.0                  # Formateo de fechas y números (ya existe?)

dev_dependencies:
  # (las existentes)
```

---

## 8. CONSIDERACIONES TÉCNICAS

### 8.1 Migración de Datos
- Al actualizar la app, las listas existentes deben tener `isCompleted: false`
- Agregar método de migración en LocalStorageProvider
- Verificar compatibilidad con versión anterior

### 8.2 Rendimiento
- Limitar historial de precios a últimos 2 años
- Implementar paginación en lista de historial
- Cachear resultados de analytics

### 8.3 Validaciones
- No permitir completar lista sin productos
- No permitir editar lista completada
- Validar rangos de fechas en filtros

### 8.4 Testing
- Unit tests para nuevos use cases
- Tests de serialización de nuevos modelos
- Widget tests para nuevas páginas

---

## 9. CRONOGRAMA ESTIMADO

### Fase 2.1 - Sistema de Historial
**Duración estimada:** 3-4 sesiones de desarrollo
- Tareas críticas: 2.1.1 a 2.1.9

### Fase 2.2 - Gráficos de Precio
**Duración estimada:** 2-3 sesiones de desarrollo
- Tareas críticas: 2.2.1 a 2.2.5

### Fase 2.3 - Analytics y Estadísticas
**Duración estimada:** 3-4 sesiones de desarrollo
- Tareas críticas: 2.3.1 a 2.3.5

### Fase 2.4 - Mejoras de UX
**Duración estimada:** 1-2 sesiones de desarrollo
- Tareas de polish y mejoras

**Total estimado:** 9-13 sesiones de desarrollo

---

## 10. CRITERIOS DE ÉXITO

### Funcionales
- Usuario puede completar una compra y verla en historial
- Historial muestra todas las compras con filtros funcionales
- Gráficos de precio muestran tendencias correctamente
- Analytics calcula y muestra estadísticas precisas

### No Funcionales
- Tiempo de carga de historial < 500ms
- Gráficos renderizan sin lag
- App funciona offline
- Sin pérdida de datos

### UX
- Navegación intuitiva entre secciones
- Feedback visual claro en todas las acciones
- Diseño consistente con Fase 1

---

## 11. RIESGOS Y MITIGACIONES

### Riesgo 1: Rendimiento con muchos datos
**Mitigación:** Implementar paginación y límites de datos

### Riesgo 2: Complejidad de gráficos
**Mitigación:** Usar biblioteca probada (fl_chart), empezar con gráficos simples

### Riesgo 3: Migración de datos existentes
**Mitigación:** Implementar script de migración, testear en datos mock primero

---

## 12. PRÓXIMOS PASOS

1. Revisar y aprobar este plan
2. Comenzar con Fase 2.1 - Tarea 2.1.1
3. Implementar de forma incremental
4. Testear cada feature antes de continuar
5. Iterar basado en feedback

---

**Documento creado:** 2025-12-29
**Versión:** 1.0
**Autor:** Claude Code Assistant
