import '../../../data/repositories/shopping_list_repository.dart';
import '../../entities/shopping_list.dart';

/// Caso de uso para obtener todas las listas de compras
class GetListsUseCase {
  final ShoppingListRepository _repository;

  GetListsUseCase(this._repository);

  /// Ejecutar obtención de listas
  /// Ordenadas por fecha de creación (más recientes primero)
  Future<List<ShoppingList>> call() async {
    try {
      final lists = await _repository.getLists();

      // Ordenar por fecha de creación descendente
      lists.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return lists;
    } catch (e) {
      throw Exception('Error al obtener listas: $e');
    }
  }
}
