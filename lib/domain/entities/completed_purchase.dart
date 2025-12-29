import 'package:equatable/equatable.dart';
import 'product.dart';

/// Entidad CompletedPurchase del dominio
/// Representa una compra completada (registro histórico inmutable)
///
/// A diferencia de ShoppingList (que es una plantilla reutilizable),
/// CompletedPurchase es un snapshot inmutable de una compra real.
class CompletedPurchase extends Equatable {
  /// ID único de la compra
  final String id;

  /// ID de la lista original desde la que se creó esta compra
  final String listId;

  /// Nombre de la lista al momento de completar la compra
  final String listName;

  /// ID de la categoría
  final String categoryId;

  /// Moneda utilizada
  final String currency;

  /// Snapshot de productos al momento de completar
  final List<Product> products;

  /// Fecha de creación de la lista original
  final DateTime createdAt;

  /// Fecha en que se completó esta compra
  final DateTime completedAt;

  /// Total gastado en esta compra
  final double total;

  const CompletedPurchase({
    required this.id,
    required this.listId,
    required this.listName,
    required this.categoryId,
    required this.currency,
    required this.products,
    required this.createdAt,
    required this.completedAt,
    required this.total,
  });

  /// Cantidad total de productos en la compra
  int get totalProducts => products.length;

  /// Cantidad total de items (suma de quantities)
  int get totalItems {
    return products.fold(0, (sum, product) => sum + product.quantity);
  }

  /// Verificar si la compra está vacía
  bool get isEmpty => products.isEmpty;

  /// Verificar si la compra tiene productos
  bool get isNotEmpty => products.isNotEmpty;

  /// Copiar compra con campos modificados
  /// Nota: Normalmente las compras no se modifican, pero es útil para testing
  CompletedPurchase copyWith({
    String? id,
    String? listId,
    String? listName,
    String? categoryId,
    String? currency,
    List<Product>? products,
    DateTime? createdAt,
    DateTime? completedAt,
    double? total,
  }) {
    return CompletedPurchase(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      listName: listName ?? this.listName,
      categoryId: categoryId ?? this.categoryId,
      currency: currency ?? this.currency,
      products: products ?? this.products,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [
        id,
        listId,
        listName,
        categoryId,
        currency,
        products,
        createdAt,
        completedAt,
        total,
      ];

  @override
  String toString() =>
      'CompletedPurchase(id: $id, listName: $listName, products: $totalProducts, total: $total $currency, completedAt: $completedAt)';
}
