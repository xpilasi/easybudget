import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

/// Modelo ProductModel para serialización JSON
/// Extiende de la entidad Product del dominio
@JsonSerializable()
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.quantity,
  });

  /// Crear desde JSON
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Convertir a JSON
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  /// Crear modelo desde entidad
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: product.quantity,
    );
  }

  /// Convertir modelo a entidad
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
    );
  }
}
