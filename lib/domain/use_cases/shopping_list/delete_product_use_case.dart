import '../../../data/repositories/shopping_list_repository.dart';
import '../../entities/shopping_list.dart';

/// Caso de uso para eliminar un producto de una lista
class DeleteProductUseCase {
  final ShoppingListRepository _repository;

  DeleteProductUseCase(this._repository);

  /// Ejecutar eliminación de producto
  Future<ShoppingList> call({
    required String listId,
    required String productId,
  }) async {
    if (listId.isEmpty) {
      throw Exception('ID de lista inválido');
    }

    if (productId.isEmpty) {
      throw Exception('ID de producto inválido');
    }

    try {
      final updatedList = await _repository.deleteProduct(
        listId: listId,
        productId: productId,
      );
      return updatedList;
    } catch (e) {
      throw Exception('Error al eliminar producto: $e');
    }
  }
}
