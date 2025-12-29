import '../../../data/repositories/category_repository.dart';
import '../../entities/category.dart';

/// Caso de uso para obtener todas las categorías
class GetCategoriesUseCase {
  final CategoryRepository _repository;

  GetCategoriesUseCase(this._repository);

  /// Ejecutar obtención de categorías
  Future<List<Category>> call() async {
    try {
      final categories = await _repository.getCategories();

      // Ordenar por nombre
      categories.sort((a, b) => a.name.compareTo(b.name));

      return categories;
    } catch (e) {
      throw Exception('Error al obtener categorías: $e');
    }
  }
}
