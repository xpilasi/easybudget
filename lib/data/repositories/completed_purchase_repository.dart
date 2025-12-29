import '../../domain/entities/completed_purchase.dart';
import '../../domain/entities/shopping_list.dart';

/// Interfaz del repositorio de compras completadas
/// Define el contrato para operaciones con el historial de compras
abstract class CompletedPurchaseRepository {
  // ==================== CREAR COMPRA ====================

  /// Crear una compra completada desde una lista
  /// Toma una snapshot de la lista actual y la guarda como compra
  Future<CompletedPurchase> createFromList(ShoppingList list);

  // ==================== CONSULTAS ====================

  /// Obtener todas las compras completadas
  /// Retorna ordenado por fecha de completado (más reciente primero)
  Future<List<CompletedPurchase>> getCompletedPurchases();

  /// Obtener una compra por ID
  Future<CompletedPurchase?> getPurchaseById(String id);

  /// Obtener compras por ID de lista original
  /// Útil para ver todas las veces que se completó una lista específica
  Future<List<CompletedPurchase>> getPurchasesByListId(String listId);

  /// Obtener compras en un rango de fechas
  Future<List<CompletedPurchase>> getPurchasesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  // ==================== ELIMINAR ====================

  /// Eliminar una compra del historial
  /// Normalmente no se usa, pero útil para limpieza o correcciones
  Future<void> deletePurchase(String purchaseId);
}
