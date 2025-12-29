import '../../../app/config/app_constants.dart';
import '../../../data/repositories/shopping_list_repository.dart';
import '../../entities/shopping_list.dart';

/// Caso de uso para crear una nueva lista de compras
class CreateListUseCase {
  final ShoppingListRepository _repository;

  CreateListUseCase(this._repository);

  /// Ejecutar creación de lista
  Future<ShoppingList> call({
    required String name,
    required String categoryId,
    required String currency,
  }) async {
    // Validaciones
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw Exception('El nombre de la lista no puede estar vacío');
    }

    if (trimmedName.length > AppConstants.maxListNameLength) {
      throw Exception(
        'El nombre no puede tener más de ${AppConstants.maxListNameLength} caracteres',
      );
    }

    if (categoryId.isEmpty) {
      throw Exception('Debes seleccionar una categoría');
    }

    if (currency.isEmpty) {
      throw Exception('Debes seleccionar una moneda');
    }

    try {
      final list = await _repository.createList(
        name: trimmedName,
        categoryId: categoryId,
        currency: currency,
      );
      return list;
    } catch (e) {
      throw Exception('Error al crear lista: $e');
    }
  }
}
