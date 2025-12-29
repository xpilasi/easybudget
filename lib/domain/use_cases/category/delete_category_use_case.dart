import '../../../app/config/app_constants.dart';
import '../../../data/repositories/category_repository.dart';

/// Caso de uso para eliminar una categoría
class DeleteCategoryUseCase {
  final CategoryRepository _repository;

  DeleteCategoryUseCase(this._repository);

  /// Ejecutar eliminación de categoría
  /// Valida que quede al menos una categoría
  Future<void> call(String categoryId) async {
    try {
      // Validar que existan categorías suficientes
      final categories = await _repository.getCategories();

      if (categories.length <= AppConstants.minCategories) {
        throw Exception(
          'Debes tener al menos ${AppConstants.minCategories} categoría',
        );
      }

      await _repository.deleteCategory(categoryId);
    } catch (e) {
      throw Exception('Error al eliminar categoría: $e');
    }
  }
}
