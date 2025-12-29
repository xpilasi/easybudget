import '../../../data/repositories/shopping_list_repository.dart';

/// Caso de uso para eliminar una lista de compras
class DeleteListUseCase {
  final ShoppingListRepository _repository;

  DeleteListUseCase(this._repository);

  /// Ejecutar eliminación de lista
  Future<void> call(String listId) async {
    if (listId.isEmpty) {
      throw Exception('ID de lista inválido');
    }

    try {
      await _repository.deleteList(listId);
    } catch (e) {
      throw Exception('Error al eliminar lista: $e');
    }
  }
}
