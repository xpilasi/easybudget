import '../../entities/shopping_list.dart';
import '../../../data/repositories/shopping_list_repository.dart';

/// Caso de uso para obtener una lista específica por ID
/// Busca en TODAS las listas (activas y completadas)
class GetListByIdUseCase {
  final ShoppingListRepository _repository;

  GetListByIdUseCase(this._repository);

  /// Ejecutar caso de uso
  Future<ShoppingList?> call(String listId) async {
    return await _repository.getListById(listId);
  }
}
