import '../../../data/repositories/shopping_list_repository.dart';
import '../../entities/product.dart';
import '../../entities/shopping_list.dart';

/// Caso de uso para actualizar un producto en una lista
class UpdateProductUseCase {
  final ShoppingListRepository _repository;

  UpdateProductUseCase(this._repository);

  /// Ejecutar actualización de producto
  Future<ShoppingList> call({
    required String listId,
    required Product product,
  }) async {
    // Validaciones
    if (product.price <= 0) {
      throw Exception('El precio debe ser mayor a 0');
    }

    if (product.quantity < 0) {
      throw Exception('La cantidad no puede ser negativa');
    }

    try {
      final updatedList = await _repository.updateProduct(
        listId: listId,
        product: product,
      );
      return updatedList;
    } catch (e) {
      throw Exception('Error al actualizar producto: $e');
    }
  }
}
