import 'package:equatable/equatable.dart';

/// Entidad Product del dominio
/// Representa un producto dentro de una lista de compras
class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final int quantity;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  /// Calcular el subtotal (precio * cantidad)
  double get subtotal => price * quantity;

  /// Copiar producto con campos modificados
  Product copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, name, price, quantity];

  @override
  String toString() =>
      'Product(id: $id, name: $name, price: $price, qty: $quantity, subtotal: $subtotal)';
}
