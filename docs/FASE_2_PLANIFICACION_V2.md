# Fase 2 - Planificación de Implementación (Revisión 2)
## Easy Budget App - Historial y Analytics

**Fecha**: 29 de Diciembre, 2024
**Versión**: 2.0 (Arquitectura Actualizada)

---

## CAMBIO ARQUITECTÓNICO FUNDAMENTAL

⚠️ **IMPORTANTE**: Esta versión refleja un cambio arquitectónico significativo respecto a la versión inicial.

**Cambio Principal**:
- ❌ **Antes**: Listas con flag `isCompleted` (single model)
- ✅ **Ahora**: Dos modelos separados `ShoppingList` + `CompletedPurchase`

📖 **Ver documento completo**: `ARQUITECTURA_LISTAS_COMPRAS.md`

---

## 1. RESUMEN EJECUTIVO

Esta fase implementa funcionalidades avanzadas de historial, análisis de datos y visualización de información para convertir Easy Budget en una herramienta completa de seguimiento de gastos.

### Cambios Principales vs V1
1. **Separación de Modelos**: Listas activas vs Compras completadas
2. **Listas Reutilizables**: Las listas no se eliminan al completar
3. **Almacenamiento Dual**: Dos storages independientes
4. **Nuevo Tab**: Historial completo de compras

### Objetivos de la Fase 2
- ✅ Implementar modelo de compras completadas (`CompletedPurchase`)
- ✅ Refactorizar sistema de historial (separación de storages)
- ✅ Crear tab de Historial con vista completa
- ✅ Agregar visualización de variaciones de precio
- ✅ Crear módulo de analytics y estadísticas
- ✅ Mejorar la experiencia del usuario con gráficos interactivos

---

## 2. ARQUITECTURA ACTUALIZADA

### 2.1 Nuevos Modelos

#### ShoppingList (Refactorizado)
```dart
class ShoppingList extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String currency;
  final List<Product> products;
  final DateTime createdAt;

  // ❌ ELIMINADOS:
  // final bool isCompleted;
  // final DateTime? completedAt;
  // final double? completedTotal;
}
```

#### CompletedPurchase (NUEVO)
```dart
class CompletedPurchase extends Equatable {
  final String id;                    // ID único de compra
  final String listId;                // ID de lista origen
  final String listName;              // Nombre al momento de compra
  final String categoryId;
  final String currency;
  final List<Product> products;       // Snapshot de productos
  final DateTime createdAt;           // Fecha creación lista
  final DateTime completedAt;         // Fecha de esta compra
  final double total;                 // Total gastado

  // Opcionales (futuro):
  final String? storeName;
  final String? notes;
}
```

### 2.2 Storage Separado

```dart
// LocalStorageProvider

// Listas Activas (editables, reutilizables)
static const String keyLists = 'shopping_lists';

// Compras Completadas (inmutables, históricas)
static const String keyCompletedPurchases = 'completed_purchases';

// Historial de Precios (para gráficos)
static const String keyPriceHistory = 'price_history';
```

### 2.3 Flujo de Completar Compra

```
Usuario en Lista "Mercadona"
           │
           ▼
    Presiona "Completar Compra"
           │
           ├─────────────────────────────────┐
           │                                 │
           ▼                                 ▼
    CLONA Lista                    Lista PERMANECE
    → CompletedPurchase            → ShoppingList
    → Storage: keyCompletedPurchases   → Storage: keyLists
    → Inmutable                    → Editable
    → Vista: Historial             → Vista: Listas
```

---

## 3. HISTORIAS DE USUARIO (ACTUALIZADAS)

### HU-1: Guardar compra completada (REFACTORIZADO)
**Como** usuario
**Quiero** poder marcar una lista como "compra completada" sin perder la lista original
**Para** tener un registro de mis compras pasadas y poder reutilizar la lista

**Criterios de Aceptación:**
- ✅ Botón de "Completar Compra" visible en el detalle de la lista
- ✅ Dialog de confirmación antes de completar
- ✅ Se crea una `CompletedPurchase` (snapshot inmutable)
- ✅ La lista original PERMANECE sin cambios
- ✅ Puedo seguir editando y reutilizando la lista original
- ✅ Puedo completar la misma lista múltiples veces
- ✅ Se guarda la fecha exacta de finalización
- ✅ Los precios se registran en el historial

**Cambios respecto a V1:**
- ❌ Antes: Lista se marcaba como `isCompleted: true`
- ✅ Ahora: Se clona a nuevo modelo `CompletedPurchase`

### HU-2: Ver historial completo en tab dedicado (ACTUALIZADO)
**Como** usuario
**Quiero** ver todas mis compras completadas en un tab dedicado
**Para** consultar mi historial completo de gastos

**Criterios de Aceptación:**
- ✅ Nuevo tab "Historial" en navegación principal
- ✅ Muestra TODAS las compras completadas (no solo últimas 3)
- ✅ Vista solo lectura (no editable)
- ✅ Filtros por fecha (hoy, semana, mes, año, rango personalizado)
- ✅ Filtros por lista origen
- ✅ Filtros por categoría
- ✅ Ordenamiento por fecha (descendente por defecto)
- ✅ Búsqueda por nombre
- ✅ Muestra total gastado por período filtrado
- ✅ Click en compra → Ver detalle completo

**Cambios respecto a V1:**
- ❌ Antes: Historial como filtro en mismo tab de listas
- ✅ Ahora: Tab completamente separado con navegación dedicada

### HU-3: Ver evolución de precios de productos
**Como** usuario
**Quiero** ver cómo ha variado el precio de un producto en el tiempo
**Para** identificar tendencias y tomar mejores decisiones de compra

**Criterios de Aceptación:**
- ✅ Desde detalle de compra, click en producto → Modal de historial
- ✅ Gráfico de línea con evolución de precio
- ✅ Eje X: Fechas de compras
- ✅ Eje Y: Precio
- ✅ Puntos marcados con fecha y precio exacto
- ✅ Indicador de aumento/disminución porcentual
- ✅ Color: Verde (bajó), Rojo (subió), Gris (igual)
- ✅ Mínimo 2 compras para mostrar gráfico
- ✅ Mensaje si solo hay 1 compra registrada

**Datos Fuente:**
- ✅ Se obtiene de `CompletedPurchase` (compras reales)
- ❌ NO de `ShoppingList` (son planes, no hechos)

### HU-4: Ver estadísticas de gastos (NUEVO)
**Como** usuario
**Quiero** ver estadísticas de mis gastos en forma de gráficos
**Para** entender mejor mis patrones de consumo

**Criterios de Aceptación:**
- ✅ Sección de estadísticas en tab Historial
- ✅ Selector de período (semana, mes, trimestre, año)
- ✅ **Gráfico 1**: Total gastado por día/semana/mes (barras)
- ✅ **Gráfico 2**: Distribución por categoría (pie chart)
- ✅ **Gráfico 3**: Top 10 productos más comprados
- ✅ **Métrica**: Total gastado en período
- ✅ **Métrica**: Promedio de gasto por compra
- ✅ **Métrica**: Número total de compras
- ✅ Comparación con período anterior (% cambio)

**Datos Fuente:**
- ✅ Solo `CompletedPurchase` (datos reales)

---

## 4. PLAN DE IMPLEMENTACIÓN

### FASE 2.1: Refactorización de Modelos y Storage (CRÍTICO)

#### Tarea 1: Crear modelo CompletedPurchase
- [ ] Crear `lib/domain/entities/completed_purchase.dart`
- [ ] Crear `lib/data/models/completed_purchase_model.dart`
- [ ] Generar código de serialización JSON

**Archivos a crear:**
```
lib/domain/entities/completed_purchase.dart
lib/data/models/completed_purchase_model.dart
```

#### Tarea 2: Limpiar modelo ShoppingList
- [ ] Eliminar campos: `isCompleted`, `completedAt`, `completedTotal`
- [ ] Actualizar `ShoppingListModel`
- [ ] Regenerar código JSON

**Archivos a modificar:**
```
lib/domain/entities/shopping_list.dart
lib/data/models/shopping_list_model.dart
```

#### Tarea 3: Actualizar LocalStorageProvider
- [ ] Agregar constante `keyCompletedPurchases`
- [ ] Crear método `saveCompletedPurchases(List<Map> purchases)`
- [ ] Crear método `getCompletedPurchases() → List<Map>?`
- [ ] Crear método `addCompletedPurchase(Map purchase)`

**Archivo a modificar:**
```
lib/data/providers/local_storage_provider.dart
```

#### Tarea 4: Migración de datos existentes
- [ ] Crear script de migración
- [ ] Leer listas con `isCompleted: true` del storage actual
- [ ] Convertir a `CompletedPurchase`
- [ ] Guardar en nuevo storage `keyCompletedPurchases`
- [ ] Eliminar listas completadas del storage de listas activas

**Archivo a crear:**
```
lib/core/utils/data_migration.dart
```

---

### FASE 2.2: Repositorios y Casos de Uso

#### Tarea 5: Crear CompletedPurchaseRepository
- [ ] Crear interface `lib/data/repositories/completed_purchase_repository.dart`
- [ ] Crear implementación `lib/data/repositories/completed_purchase_repository_impl.dart`

**Métodos del repositorio:**
```dart
Future<CompletedPurchase> createFromList(ShoppingList list)
Future<List<CompletedPurchase>> getCompletedPurchases()
Future<CompletedPurchase?> getPurchaseById(String id)
Future<List<CompletedPurchase>> getPurchasesByDateRange(DateTime start, DateTime end)
Future<List<CompletedPurchase>> getPurchasesByListId(String listId)
Future<void> deletePurchase(String id)
```

#### Tarea 6: Refactorizar ShoppingListRepository
- [ ] Eliminar método `completeList()`
- [ ] Eliminar método `getCompletedLists()`
- [ ] Limpiar implementación de métodos obsoletos

**Archivo a modificar:**
```
lib/data/repositories/shopping_list_repository_impl.dart
```

#### Tarea 7: Actualizar Use Cases
- [ ] Refactorizar `CompleteListUseCase` (usar ambos repositorios)
- [ ] Eliminar `GetCompletedListsUseCase` (obsoleto)
- [ ] Crear `GetPurchaseHistoryUseCase`
- [ ] Crear `GetPurchasesByDateRangeUseCase`
- [ ] Crear `GetPriceHistoryForProductUseCase`

**Archivos:**
```
lib/domain/use_cases/shopping_list/complete_list_use_case.dart (modificar)
lib/domain/use_cases/purchase/get_purchase_history_use_case.dart (crear)
lib/domain/use_cases/purchase/get_purchases_by_date_range_use_case.dart (crear)
lib/domain/use_cases/purchase/get_price_history_for_product_use_case.dart (crear)
```

---

### FASE 2.3: Controllers y Bindings

#### Tarea 8: Actualizar HomeController
- [ ] Cambiar `_completedLists` por `_recentPurchases`
- [ ] Usar `GetPurchaseHistoryUseCase` en lugar de `GetCompletedListsUseCase`
- [ ] Actualizar getter `recentCompletedLists` → `recentPurchases`
- [ ] Limpiar referencias obsoletas

**Archivo a modificar:**
```
lib/presentation/controllers/home_controller.dart
```

#### Tarea 9: Actualizar ListDetailController
- [ ] Actualizar `completeList()` para usar nuevo flow
- [ ] Eliminar lógica de marcar `isCompleted`
- [ ] Integrar con `CompletedPurchaseRepository`

**Archivo a modificar:**
```
lib/presentation/controllers/list_detail_controller.dart
```

#### Tarea 10: Crear HistoryController (NUEVO)
- [ ] Crear `lib/presentation/controllers/history_controller.dart`
- [ ] Estado: lista de compras, filtros, período seleccionado
- [ ] Métodos: filtrar por fecha, categoría, lista
- [ ] Método: calcular estadísticas del período

**Archivo a crear:**
```
lib/presentation/controllers/history_controller.dart
```

#### Tarea 11: Actualizar Bindings
- [ ] Modificar `HomeBinding` (nuevos use cases)
- [ ] Modificar `ListDetailBinding` (nuevo repositorio)
- [ ] Crear `HistoryBinding` (nuevo)

**Archivos:**
```
lib/presentation/pages/home/home_binding.dart (modificar)
lib/presentation/pages/list_detail/list_detail_binding.dart (modificar)
lib/presentation/pages/history/history_binding.dart (crear)
```

---

### FASE 2.4: Interfaz de Usuario

#### Tarea 12: Actualizar HomePage
- [ ] Cambiar "Últimas Compras" para usar `CompletedPurchase`
- [ ] Actualizar método `_buildCompletedListCard` → `_buildPurchaseCard`
- [ ] Ajustar navegación al hacer click

**Archivo a modificar:**
```
lib/presentation/pages/home/home_page.dart
```

#### Tarea 13: Crear HistoryPage (NUEVO)
- [ ] Crear `lib/presentation/pages/history/history_page.dart`
- [ ] Vista de lista de compras completadas
- [ ] Filtros: fecha, categoría, lista origen
- [ ] Búsqueda
- [ ] Resumen de estadísticas en header

**Estructura:**
```
┌─────────────────────────────────┐
│ Historial                       │
│ [Filtros] [Búsqueda]           │
├─────────────────────────────────┤
│ Total período: €XXX             │
│ XX compras | Promedio: €YY      │
├─────────────────────────────────┤
│ [Compra 1] 25/12 - €50.00      │
│ [Compra 2] 20/12 - €75.50      │
│ [Compra 3] 15/12 - €32.80      │
│ ...                             │
└─────────────────────────────────┘
```

#### Tarea 14: Crear PurchaseDetailPage (NUEVO)
- [ ] Vista de detalle de compra completada (solo lectura)
- [ ] Muestra: productos, precios, fecha, total
- [ ] Botón: Ver historial de precio por producto
- [ ] Botón: Crear nueva lista desde esta compra

**Archivo a crear:**
```
lib/presentation/pages/history/purchase_detail_page.dart
```

#### Tarea 15: Crear PriceHistoryModal (NUEVO)
- [ ] Modal que muestra gráfico de evolución de precio
- [ ] Usa library de charts (fl_chart o syncfusion_flutter_charts)
- [ ] Muestra lista de compras con fechas y precios

**Archivo a crear:**
```
lib/presentation/widgets/modals/price_history_modal.dart
```

---

### FASE 2.5: Navegación

#### Tarea 16: Agregar 4to Tab "Historial"
- [ ] Modificar `MainPage` para agregar nuevo tab
- [ ] Actualizar `MainController` para gestionar 4 tabs
- [ ] Agregar ícono de historial

**Cambio en navegación:**
```
Antes: [Inicio] [Listas] [Perfil]
Ahora: [Inicio] [Listas] [Historial] [Perfil]
```

**Archivos a modificar:**
```
lib/presentation/pages/main/main_page.dart
lib/presentation/controllers/main_controller.dart
```

#### Tarea 17: Configurar rutas
- [ ] Agregar ruta `/history`
- [ ] Agregar ruta `/purchase-detail/:id`
- [ ] Configurar bindings en rutas

**Archivo a modificar:**
```
lib/app/routes/app_routes.dart
lib/app/routes/app_pages.dart
```

---

### FASE 2.6: Gráficos y Estadísticas

#### Tarea 18: Agregar dependencia de charts
- [ ] Agregar `fl_chart: ^0.68.0` a pubspec.yaml
- [ ] O `syncfusion_flutter_charts: ^24.2.3`

#### Tarea 19: Crear StatsSection en HistoryPage
- [ ] Card con métricas principales
- [ ] Gráfico de barras: Gasto por período
- [ ] Gráfico circular: Distribución por categoría
- [ ] Toggle para cambiar período (semana/mes/año)

#### Tarea 20: Implementar gráfico de evolución de precios
- [ ] Gráfico de línea en `PriceHistoryModal`
- [ ] Eje X: Fechas
- [ ] Eje Y: Precios
- [ ] Puntos interactivos con tooltip

---

## 5. ESTIMACIÓN Y PRIORIDADES

### Prioridad CRÍTICA (Core del cambio)
- ✅ Tarea 1-4: Refactorización de modelos y storage
- ✅ Tarea 5-7: Repositorios y casos de uso
- ✅ Tarea 8-11: Controllers y bindings

**Tiempo estimado**: Base fundamental (completar primero)

### Prioridad ALTA (Features principales)
- ✅ Tarea 12-14: UI del historial
- ✅ Tarea 16-17: Navegación

**Tiempo estimado**: Segunda iteración

### Prioridad MEDIA (Features avanzadas)
- ✅ Tarea 15: Modal de historial de precios
- ✅ Tarea 18-20: Gráficos y estadísticas

**Tiempo estimado**: Tercera iteración

---

## 6. RIESGOS Y MITIGACIONES

### Riesgo 1: Pérdida de datos en migración
**Mitigación**:
- Script de migración con validación
- Backup automático antes de migrar
- Logs detallados de proceso

### Riesgo 2: Breaking changes en UI
**Mitigación**:
- Tests de regresión visual
- Validación con usuarios beta
- Rollback plan

### Riesgo 3: Performance con historial grande
**Mitigación**:
- Paginación en lista de historial
- Caché de estadísticas calculadas
- Lazy loading de gráficos

---

## 7. TESTING

### Unit Tests
- [ ] CompletedPurchaseRepository
- [ ] Nuevos Use Cases
- [ ] HistoryController

### Integration Tests
- [ ] Flujo completo de completar compra
- [ ] Filtros de historial
- [ ] Cálculo de estadísticas

### Widget Tests
- [ ] HistoryPage rendering
- [ ] PurchaseDetailPage rendering
- [ ] PriceHistoryModal

---

## 8. ENTREGABLES

### Entregable 1: Core refactoring
- ✅ Modelos separados funcionando
- ✅ Storage dual operativo
- ✅ Migración de datos existentes

### Entregable 2: Historial básico
- ✅ Tab de historial visible
- ✅ Lista de compras completadas
- ✅ Detalle de compra

### Entregable 3: Analytics
- ✅ Gráficos de gastos
- ✅ Historial de precios
- ✅ Estadísticas por período

---

## 9. DIFERENCIAS CLAVE vs V1

| Aspecto | V1 (Original) | V2 (Actual) |
|---------|---------------|-------------|
| **Modelo** | ShoppingList con flag `isCompleted` | `ShoppingList` + `CompletedPurchase` separados |
| **Storage** | Un solo storage con todas las listas | Dos storages independientes |
| **Listas** | Se marcan como completadas | Permanecen activas, son reutilizables |
| **Completar** | `isCompleted = true` | Clonar a `CompletedPurchase` |
| **Historial** | Filtro en mismo tab | Tab dedicado completo |
| **Edición** | Listas completadas no editables | Listas siempre editables |
| **Reutilización** | No, lista queda "consumida" | Sí, usar misma lista N veces |

---

## 10. CONCLUSIÓN

Esta Fase 2 (Revisión 2) representa un cambio arquitectónico fundamental que:

1. **Separa conceptualmente** listas (intención) de compras (realidad)
2. **Habilita reutilización** de listas como plantillas
3. **Permite análisis preciso** basado en datos reales
4. **Escala mejor** con storages separados
5. **Facilita features futuras** (presupuestos, ML, recomendaciones)

Este cambio es **más ambicioso** que V1 pero crea una **base sólida** para:
- Estadísticas precisas
- Análisis de tendencias
- Comparaciones temporales
- Predicciones
- Recomendaciones inteligentes

**Documentación relacionada**:
- `ARQUITECTURA_LISTAS_COMPRAS.md` - Diseño detallado de arquitectura
