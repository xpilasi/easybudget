import '../../../app/config/app_constants.dart';
import '../../../data/repositories/shopping_list_repository.dart';
import '../../entities/product.dart';
import '../../entities/shopping_list.dart';

/// Caso de uso para agregar un producto a una lista
class AddProductUseCase {
  final ShoppingListRepository _repository;

  AddProductUseCase(this._repository);

  /// Ejecutar adición de producto
  Future<ShoppingList> call({
    required String listId,
    required String productName,
    required double price,
    required int quantity,
  }) async {
    // Validaciones
    final trimmedName = productName.trim();

    if (trimmedName.isEmpty) {
      throw Exception('El nombre del producto no puede estar vacío');
    }

    if (trimmedName.length > AppConstants.maxProductNameLength) {
      throw Exception(
        'El nombre no puede tener más de ${AppConstants.maxProductNameLength} caracteres',
      );
    }

    if (price <= 0) {
      throw Exception('El precio debe ser mayor a 0');
    }

    if (quantity <= 0) {
      throw Exception('La cantidad debe ser mayor a 0');
    }

    try {
      // Crear producto (el ID se genera en el repository)
      final product = Product(
        id: '', // Se genera en el repository
        name: trimmedName,
        price: price,
        quantity: quantity,
      );

      final updatedList = await _repository.addProduct(
        listId: listId,
        product: product,
      );

      return updatedList;
    } catch (e) {
      throw Exception('Error al agregar producto: $e');
    }
  }
}
