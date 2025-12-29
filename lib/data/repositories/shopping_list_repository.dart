import '../../domain/entities/product.dart';
import '../../domain/entities/shopping_list.dart';

/// Interfaz del repositorio de listas de compras
/// Define el contrato para operaciones CRUD de listas y productos
abstract class ShoppingListRepository {
  // ==================== LISTAS ====================

  /// Obtener todas las listas
  Future<List<ShoppingList>> getLists();

  /// Obtener una lista por ID
  Future<ShoppingList?> getListById(String id);

  /// Crear una nueva lista
  Future<ShoppingList> createList({
    required String name,
    required String categoryId,
    required String currency,
  });

  /// Actualizar una lista existente
  Future<ShoppingList> updateList(ShoppingList list);

  /// Eliminar una lista
  Future<void> deleteList(String listId);

  // ==================== PRODUCTOS ====================

  /// Agregar un producto a una lista
  Future<ShoppingList> addProduct({
    required String listId,
    required Product product,
  });

  /// Actualizar un producto en una lista
  Future<ShoppingList> updateProduct({
    required String listId,
    required Product product,
  });

  /// Eliminar un producto de una lista
  Future<ShoppingList> deleteProduct({
    required String listId,
    required String productId,
  });
}
