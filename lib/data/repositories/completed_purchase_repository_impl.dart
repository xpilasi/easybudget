import 'package:uuid/uuid.dart';
import '../../domain/entities/completed_purchase.dart';
import '../../domain/entities/shopping_list.dart';
import '../models/completed_purchase_model.dart';
import '../models/price_history_entry_model.dart';
import '../providers/local_storage_provider.dart';
import 'completed_purchase_repository.dart';

/// Implementación del repositorio de compras completadas
/// Usa LocalStorageProvider para persistencia
class CompletedPurchaseRepositoryImpl implements CompletedPurchaseRepository {
  final LocalStorageProvider _storageProvider;
  final Uuid _uuid = const Uuid();

  CompletedPurchaseRepositoryImpl(this._storageProvider);

  // ==================== CREAR COMPRA ====================

  @override
  Future<CompletedPurchase> createFromList(ShoppingList list) async {
    print('🎯 createFromList: Creando compra desde lista ${list.name}');

    // Validar que la lista tenga productos
    if (list.isEmpty) {
      throw Exception('No se puede completar una lista sin productos');
    }

    // Crear compra con timestamp actual
    final now = DateTime.now();
    final purchase = CompletedPurchaseModel.fromShoppingList(
      purchaseId: _uuid.v4(),
      list: list,
      completedAt: now,
    );

    print('✅ Compra creada: ${purchase.listName}, Total: ${purchase.total}');

    // Obtener compras existentes
    final existingPurchases = await getCompletedPurchases();

    // Agregar nueva compra
    final updatedPurchases = [
      ...existingPurchases.map((p) => CompletedPurchaseModel.fromEntity(p)),
      purchase,
    ];

    // Guardar en storage
    await _savePurchases(updatedPurchases);
    print('💾 Guardada compra en historial');

    // Registrar precios en el historial
    await _registerPriceHistory(purchase);

    return purchase;
  }

  // ==================== CONSULTAS ====================

  @override
  Future<List<CompletedPurchase>> getCompletedPurchases() async {
    final storedPurchases = _storageProvider.getCompletedPurchases();

    if (storedPurchases != null && storedPurchases.isNotEmpty) {
      final purchases = storedPurchases
          .map((json) => CompletedPurchaseModel.fromJson(json))
          .toList();

      // Ordenar por fecha de completado (más reciente primero)
      purchases.sort((a, b) => b.completedAt.compareTo(a.completedAt));

      print('✅ getCompletedPurchases: ${purchases.length} compras en historial');
      return purchases;
    }

    print('✅ getCompletedPurchases: 0 compras en historial');
    return [];
  }

  @override
  Future<CompletedPurchase?> getPurchaseById(String id) async {
    final allPurchases = await getCompletedPurchases();
    try {
      return allPurchases.firstWhere((purchase) => purchase.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<CompletedPurchase>> getPurchasesByListId(String listId) async {
    final allPurchases = await getCompletedPurchases();
    final filtered = allPurchases
        .where((purchase) => purchase.listId == listId)
        .toList();

    // Ya están ordenados por fecha descendente desde getCompletedPurchases
    print('✅ getPurchasesByListId($listId): ${filtered.length} compras encontradas');
    return filtered;
  }

  @override
  Future<List<CompletedPurchase>> getPurchasesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final allPurchases = await getCompletedPurchases();
    final filtered = allPurchases.where((purchase) {
      return purchase.completedAt.isAfter(startDate) &&
          purchase.completedAt.isBefore(endDate);
    }).toList();

    print('✅ getPurchasesByDateRange: ${filtered.length} compras en rango');
    return filtered;
  }

  // ==================== ELIMINAR ====================

  @override
  Future<void> deletePurchase(String purchaseId) async {
    final allPurchases = await getCompletedPurchases();

    // Filtrar eliminando la compra
    final updatedPurchases = allPurchases
        .where((p) => p.id != purchaseId)
        .map((p) => CompletedPurchaseModel.fromEntity(p))
        .toList();

    await _savePurchases(updatedPurchases);
    print('✅ Compra $purchaseId eliminada del historial');
  }

  // ==================== HELPERS ====================

  /// Guardar todas las compras en storage
  Future<void> _savePurchases(List<CompletedPurchaseModel> purchases) async {
    print('💾 _savePurchases: Guardando ${purchases.length} compras');
    final purchasesJson = purchases.map((p) => p.toJson()).toList();
    await _storageProvider.saveCompletedPurchases(purchasesJson);
    print('💾 _savePurchases: Guardado completo');
  }

  /// Registrar precios de productos en el historial
  Future<void> _registerPriceHistory(CompletedPurchase purchase) async {
    final entries = purchase.products.map((product) {
      final entry = PriceHistoryEntryModel(
        id: _uuid.v4(),
        productId: product.id, // ID único del producto
        productName: product.name,
        price: product.price,
        date: purchase.completedAt,
        listId: purchase.listId,
        listName: purchase.listName,
      );
      return entry.toJson();
    }).toList();

    await _storageProvider.addPriceHistoryEntries(entries);
    print('📊 Registrados ${entries.length} precios en historial');
  }
}
