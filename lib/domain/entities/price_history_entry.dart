import 'package:equatable/equatable.dart';

/// Entidad PriceHistoryEntry del dominio
/// Representa un registro del precio de un producto en una compra específica
class PriceHistoryEntry extends Equatable {
  final String id;
  final String? productId; // Nullable para compatibilidad con datos antiguos
  final String productName;
  final double price;
  final DateTime date;
  final String listId;
  final String listName;

  const PriceHistoryEntry({
    required this.id,
    this.productId, // Opcional para datos antiguos
    required this.productName,
    required this.price,
    required this.date,
    required this.listId,
    required this.listName,
  });

  /// Copiar entrada con campos modificados
  PriceHistoryEntry copyWith({
    String? id,
    String? productId,
    String? productName,
    double? price,
    DateTime? date,
    String? listId,
    String? listName,
  }) {
    return PriceHistoryEntry(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      date: date ?? this.date,
      listId: listId ?? this.listId,
      listName: listName ?? this.listName,
    );
  }

  @override
  List<Object?> get props => [id, productId, productName, price, date, listId, listName];

  @override
  String toString() =>
      'PriceHistoryEntry(productId: $productId, product: $productName, price: $price, date: $date)';
}
