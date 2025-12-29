# Arquitectura: Listas Reutilizables vs Compras Completadas

## Fecha
29 de Diciembre, 2024

## Estado
📋 Diseño Aprobado - Pendiente de Implementación

---

## Visión General

El sistema distingue entre dos conceptos fundamentales que deben manejarse como entidades separadas:

1. **Listas de Compras** (`ShoppingList`): Plantillas reutilizables para planificar compras
2. **Compras Completadas** (`CompletedPurchase`): Registros históricos inmutables de compras realizadas

---

## Conceptos Fundamentales

### 🛒 Listas de Compras (Shopping Lists)

**Propósito**: Plantillas permanentes y reutilizables para planificar compras futuras.

**Características**:
- ✅ **Persistentes**: Nunca se eliminan al completar una compra
- ✅ **Editables**: Se pueden modificar en cualquier momento
- ✅ **Reutilizables**: Se pueden usar múltiples veces
- ✅ **Planificación**: Representan la **intención** de compra

**Ejemplos de Uso**:
- Lista "Mercadona Semanal" con productos básicos
- Lista "Despensa Mensual" con productos de stock
- Lista "Cumpleaños" con productos para eventos

### 📊 Compras Completadas (Completed Purchases)

**Propósito**: Registro histórico inmutable de compras realmente realizadas.

**Características**:
- ✅ **Inmutables**: Una vez creadas, no se pueden editar
- ✅ **Históricas**: Representan **hechos** consumados
- ✅ **Timestamped**: Cada compra tiene fecha exacta de realización
- ✅ **Snapshot**: Captura el estado exacto al momento de completar

**Ejemplos de Uso**:
- Compra en Mercadona el 10/12/2024 por €52.30
- Compra en Lidl el 15/12/2024 por €87.15
- Compra en Carrefour el 20/12/2024 por €45.90

---

## Flujo de Uso

### Ciclo de Vida Completo

```
┌─────────────────────────────────────────────────────────────┐
│ 1. CREAR LISTA                                              │
│    Usuario crea "Mercadona Semanal"                         │
│    Productos: Leche, Pan, Huevos                            │
│    Estado: ShoppingList (activa)                            │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. MODIFICAR (opcional)                                     │
│    Usuario agrega: Queso, Jamón                             │
│    Estado: ShoppingList (activa)                            │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. COMPLETAR COMPRA - Semana 1                              │
│    Usuario presiona "Completar compra"                      │
│    • Se CLONA → CompletedPurchase #1                        │
│    • Fecha: 10/12/2024, Total: €25.50                       │
│    • Lista PERMANECE sin cambios                            │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. REUTILIZAR - Semana 2                                    │
│    Usuario modifica lista: agrega Café                      │
│    Usuario presiona "Completar compra"                      │
│    • Se CLONA → CompletedPurchase #2                        │
│    • Fecha: 17/12/2024, Total: €28.90                       │
│    • Lista PERMANECE para semana 3                          │
└─────────────────────────────────────────────────────────────┘
```

### Resultado Final

**Almacenamiento**:
```
keyLists (Storage):
  └─ "Mercadona Semanal" (versión actual con Café)

keyCompletedPurchases (Storage):
  ├─ CompletedPurchase #1 (10/12/2024, €25.50)
  │  └─ Productos: Leche, Pan, Huevos, Queso, Jamón
  └─ CompletedPurchase #2 (17/12/2024, €28.90)
     └─ Productos: Leche, Pan, Huevos, Queso, Jamón, Café
```

---

## Arquitectura Técnica

### Modelos de Datos

#### ShoppingList (Lista Activa)

```dart
class ShoppingList extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String currency;
  final List<Product> products;
  final DateTime createdAt;

  // ❌ NO TIENE campos de completado:
  // - isCompleted
  // - completedAt
  // - completedTotal
}
```

#### CompletedPurchase (Compra Histórica)

```dart
class CompletedPurchase extends Equatable {
  final String id;                    // ID único de la compra
  final String listId;                // ID de la lista original
  final String listName;              // Nombre de la lista al momento
  final String categoryId;
  final String currency;
  final List<Product> products;       // Snapshot de productos
  final DateTime createdAt;           // Fecha original de la lista
  final DateTime completedAt;         // Fecha de esta compra
  final double total;                 // Total gastado

  // Campos opcionales para futuro:
  final String? storeName;            // Tienda donde se compró
  final String? notes;                // Notas adicionales
  final PaymentMethod? paymentMethod; // Método de pago
}
```

### Repositorios

#### ShoppingListRepository

**Responsabilidades**:
- CRUD de listas activas
- Gestión de productos en listas
- NO maneja completado de compras

**Métodos**:
```dart
Future<List<ShoppingList>> getLists()
Future<ShoppingList?> getListById(String id)
Future<ShoppingList> createList({...})
Future<ShoppingList> updateList(ShoppingList list)
Future<void> deleteList(String listId)
Future<ShoppingList> addProduct({...})
Future<ShoppingList> updateProduct({...})
Future<ShoppingList> deleteProduct({...})
```

#### CompletedPurchaseRepository (NUEVO)

**Responsabilidades**:
- Crear compras desde listas
- Consultar historial
- Gestionar registros históricos

**Métodos**:
```dart
Future<CompletedPurchase> createFromList(ShoppingList list)
Future<List<CompletedPurchase>> getCompletedPurchases()
Future<List<CompletedPurchase>> getPurchasesByDateRange(DateTime start, DateTime end)
Future<List<CompletedPurchase>> getPurchasesByListId(String listId)
Future<CompletedPurchase?> getPurchaseById(String id)
Future<void> deletePurchase(String id) // Solo admin/limpieza
```

### Storage

#### Separación de Almacenamiento

```dart
// LocalStorageProvider

// Listas Activas
static const String keyLists = 'shopping_lists';

// Compras Completadas (NUEVO)
static const String keyCompletedPurchases = 'completed_purchases';

// Historial de Precios
static const String keyPriceHistory = 'price_history';
```

---

## Casos de Uso

### Use Case: CompleteListUseCase (REFACTORIZADO)

```dart
class CompleteListUseCase {
  final ShoppingListRepository _listRepository;
  final CompletedPurchaseRepository _purchaseRepository;

  CompleteListUseCase(
    this._listRepository,
    this._purchaseRepository,
  );

  Future<CompletedPurchase> execute(String listId) async {
    // 1. Obtener lista actual
    final list = await _listRepository.getListById(listId);
    if (list == null) throw Exception('Lista no encontrada');

    // 2. Validar que tenga productos
    if (list.products.isEmpty) {
      throw Exception('No puedes completar una lista vacía');
    }

    // 3. CLONAR a CompletedPurchase
    final purchase = await _purchaseRepository.createFromList(list);

    // 4. Lista PERMANECE intacta (NO se elimina, NO se modifica)

    // 5. Retornar compra completada
    return purchase;
  }
}
```

### Use Case: GetPurchaseHistoryUseCase (NUEVO)

```dart
class GetPurchaseHistoryUseCase {
  final CompletedPurchaseRepository _repository;

  GetPurchaseHistoryUseCase(this._repository);

  Future<List<CompletedPurchase>> execute({
    DateTime? startDate,
    DateTime? endDate,
    String? listId,
    String? categoryId,
  }) async {
    // Obtener historial con filtros opcionales
    var purchases = await _repository.getCompletedPurchases();

    // Aplicar filtros
    if (startDate != null) {
      purchases = purchases.where((p) =>
        p.completedAt.isAfter(startDate)
      ).toList();
    }

    if (endDate != null) {
      purchases = purchases.where((p) =>
        p.completedAt.isBefore(endDate)
      ).toList();
    }

    if (listId != null) {
      purchases = purchases.where((p) =>
        p.listId == listId
      ).toList();
    }

    // Ordenar por fecha descendente (más reciente primero)
    purchases.sort((a, b) => b.completedAt.compareTo(a.completedAt));

    return purchases;
  }
}
```

---

## Interfaz de Usuario

### Home Page

#### Listas Recientes
- **Fuente de datos**: `ShoppingListRepository.getLists()`
- **Ordenamiento**: Por `createdAt` o `updatedAt`
- **Límite**: Últimas 3 listas
- **Comportamiento**: Click → Editar lista

#### Últimas Compras
- **Fuente de datos**: `CompletedPurchaseRepository.getCompletedPurchases()`
- **Ordenamiento**: Por `completedAt` descendente
- **Límite**: Últimas 3 compras
- **Comportamiento**: Click → Ver detalle (solo lectura)

### Lists Page (Tab Listas)

- **Fuente de datos**: `ShoppingListRepository.getLists()`
- **Comportamiento**: CRUD completo, editable
- **Acción**: Botón "Completar compra" → Crea `CompletedPurchase`

### History Page (Tab Historial - NUEVO)

- **Fuente de datos**: `CompletedPurchaseRepository.getCompletedPurchases()`
- **Vista**: Solo lectura, no editable
- **Filtros**:
  - Por fecha (hoy, semana, mes, año, rango)
  - Por lista origen
  - Por categoría
  - Por tienda (futuro)
- **Acciones**:
  - Ver detalle de compra
  - Eliminar compra (opcional)
  - Crear nueva lista desde compra (clonar al revés)

---

## Beneficios de esta Arquitectura

### 1. Separación de Conceptos
- ✅ **Intención vs Realidad**: Listas son planes, compras son hechos
- ✅ **Mutabilidad clara**: Listas editables, compras inmutables
- ✅ **Responsabilidades únicas**: Cada modelo tiene un propósito claro

### 2. Experiencia de Usuario
- ✅ **Listas reutilizables**: No perder trabajo al completar
- ✅ **Historial completo**: Ver todas las compras realizadas
- ✅ **Plantillas**: Crear listas una vez, usar múltiples veces

### 3. Análisis y Estadísticas
- ✅ **Datos reales**: Estadísticas basadas en compras reales, no planes
- ✅ **Evolución de precios**: Comparar precios del mismo producto en el tiempo
- ✅ **Patrones de compra**: Cuándo y dónde compras más
- ✅ **Presupuesto**: Comparar total planificado vs total gastado

### 4. Escalabilidad
- ✅ **Performance**: Listas activas no se mezclan con historial extenso
- ✅ **Almacenamiento**: Posibilidad de archivar compras antiguas
- ✅ **Queries eficientes**: Índices separados para cada tipo

---

## Migración desde Arquitectura Actual

### Estado Actual (Antes)

```dart
class ShoppingList {
  // ...
  final bool isCompleted;           // ❌ Se elimina
  final DateTime? completedAt;      // ❌ Se elimina
  final double? completedTotal;     // ❌ Se elimina
}

// Storage unificado
keyLists: [
  {id: "1", name: "Lista1", isCompleted: false},
  {id: "2", name: "Lista2", isCompleted: true},  // Se mueve
  {id: "3", name: "Lista3", isCompleted: true},  // Se mueve
]
```

### Estado Nuevo (Después)

```dart
class ShoppingList {
  // ... sin campos de completado
}

class CompletedPurchase {
  // ... nuevo modelo
}

// Storages separados
keyLists: [
  {id: "1", name: "Lista1"},
]

keyCompletedPurchases: [
  {id: "p1", listId: "2", completedAt: "...", ...},
  {id: "p2", listId: "3", completedAt: "...", ...},
]
```

### Plan de Migración

1. **Crear nuevo modelo**: `CompletedPurchase` con entity y model
2. **Migrar datos existentes**: Mover listas con `isCompleted: true` a nuevo storage
3. **Limpiar modelo**: Remover campos `isCompleted`, `completedAt`, `completedTotal` de `ShoppingList`
4. **Actualizar repositorios**: Separar responsabilidades
5. **Actualizar controllers**: Usar repositorios correctos
6. **Actualizar UI**: Conectar páginas a nuevas fuentes de datos

---

## Próximos Pasos

### Fase 1: Modelos y Datos
- [ ] Crear `CompletedPurchase` entity
- [ ] Crear `CompletedPurchaseModel` con serialización
- [ ] Actualizar `LocalStorageProvider` con nuevo storage
- [ ] Crear migración de datos

### Fase 2: Lógica de Negocio
- [ ] Crear `CompletedPurchaseRepository` interface e implementación
- [ ] Refactorizar `CompleteListUseCase`
- [ ] Crear `GetPurchaseHistoryUseCase`
- [ ] Actualizar `ShoppingListRepository` (eliminar métodos de completado)

### Fase 3: Presentación
- [ ] Actualizar `HomeController` (separar fuentes)
- [ ] Actualizar `ListsController` (eliminar gestión de completadas)
- [ ] Crear `HistoryController` (nuevo)
- [ ] Actualizar UI del Home
- [ ] Crear nueva página de Historial

### Fase 4: Navegación
- [ ] Agregar 4to tab "Historial" en navegación principal
- [ ] Configurar routing
- [ ] Implementar bindings

---

## Casos de Uso Futuros

Con esta arquitectura, se habilitan funcionalidades avanzadas:

### Estadísticas
- Gasto total por período
- Gasto promedio por compra
- Productos más comprados
- Tiendas más frecuentes

### Análisis de Precios
- Evolución de precio de cada producto
- Comparativa de precios entre tiendas
- Alertas de aumento de precios

### Presupuestos
- Comparar total planificado vs total gastado
- Proyección de gastos futuros
- Alertas de presupuesto

### Inteligencia
- Recomendaciones de compra basadas en historial
- Predicción de próxima fecha de compra
- Sugerencias de productos olvidados

---

## Conclusión

Esta arquitectura separa claramente dos conceptos fundamentales:

1. **Listas**: Herramientas de planificación reutilizables
2. **Compras**: Registros históricos de lo que realmente ocurrió

Esta separación permite:
- Mejor experiencia de usuario (listas permanentes)
- Análisis preciso (basado en datos reales)
- Escalabilidad (queries eficientes)
- Futuras funcionalidades (estadísticas, presupuestos, ML)

**Esta es la base sólida para todas las funcionalidades de Fase 2 y futuras.**
