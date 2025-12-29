import '../../../data/repositories/shopping_list_repository.dart';
import '../../entities/shopping_list.dart';

/// Caso de uso para actualizar una lista de compras existente
class UpdateListUseCase {
  final ShoppingListRepository _repository;

  UpdateListUseCase(this._repository);

  /// Ejecutar actualización de lista
  Future<ShoppingList> call(ShoppingList list) async {
    try {
      final updatedList = await _repository.updateList(list);
      return updatedList;
    } catch (e) {
      throw Exception('Error al actualizar lista: $e');
    }
  }
}
