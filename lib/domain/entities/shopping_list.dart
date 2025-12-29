import 'package:equatable/equatable.dart';
import 'product.dart';

/// Entidad ShoppingList del dominio
/// Representa una lista de compras con sus productos
class ShoppingList extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String currency;
  final List<Product> products;
  final DateTime createdAt;

  const ShoppingList({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.currency,
    required this.products,
    required this.createdAt,
  });

  /// Calcular el total de la lista (suma de todos los subtotales)
  double get total {
    return products.fold(0.0, (sum, product) => sum + product.subtotal);
  }

  /// Cantidad total de productos en la lista
  int get totalProducts => products.length;

  /// Cantidad total de items (suma de quantities)
  int get totalItems {
    return products.fold(0, (sum, product) => sum + product.quantity);
  }

  /// Verificar si la lista está vacía
  bool get isEmpty => products.isEmpty;

  /// Verificar si la lista tiene productos
  bool get isNotEmpty => products.isNotEmpty;

  /// Copiar lista con campos modificados
  ShoppingList copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? currency,
    List<Product>? products,
    DateTime? createdAt,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      currency: currency ?? this.currency,
      products: products ?? this.products,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Agregar un producto a la lista
  ShoppingList addProduct(Product product) {
    return copyWith(products: [...products, product]);
  }

  /// Actualizar un producto en la lista
  ShoppingList updateProduct(Product updatedProduct) {
    final updatedProducts = products.map((p) {
      return p.id == updatedProduct.id ? updatedProduct : p;
    }).toList();
    return copyWith(products: updatedProducts);
  }

  /// Eliminar un producto de la lista
  ShoppingList removeProduct(String productId) {
    final updatedProducts =
        products.where((p) => p.id != productId).toList();
    return copyWith(products: updatedProducts);
  }

  @override
  List<Object?> get props =>
      [id, name, categoryId, currency, products, createdAt];

  @override
  String toString() =>
      'ShoppingList(id: $id, name: $name, products: $totalProducts, total: $total $currency)';
}
