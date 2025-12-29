import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/shopping_list.dart';
import 'product_model.dart';

part 'shopping_list_model.g.dart';

/// Modelo ShoppingListModel para serialización JSON
/// Extiende de la entidad ShoppingList del dominio
@JsonSerializable(explicitToJson: true)
class ShoppingListModel extends ShoppingList {
  @override
  @JsonKey(name: 'products')
  // ignore: overridden_fields
  final List<ProductModel> products;

  // ignore: prefer_const_constructors_in_immutables
  ShoppingListModel({
    required super.id,
    required super.name,
    required super.categoryId,
    required super.currency,
    required this.products,
    required super.createdAt,
  }) : super(products: products);

  /// Crear desde JSON
  factory ShoppingListModel.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListModelFromJson(json);

  /// Convertir a JSON
  Map<String, dynamic> toJson() => _$ShoppingListModelToJson(this);

  /// Crear modelo desde entidad
  factory ShoppingListModel.fromEntity(ShoppingList list) {
    return ShoppingListModel(
      id: list.id,
      name: list.name,
      categoryId: list.categoryId,
      currency: list.currency,
      products:
          list.products.map((p) => ProductModel.fromEntity(p)).toList(),
      createdAt: list.createdAt,
    );
  }

  /// Convertir modelo a entidad
  ShoppingList toEntity() {
    return ShoppingList(
      id: id,
      name: name,
      categoryId: categoryId,
      currency: currency,
      products: products,
      createdAt: createdAt,
    );
  }
}
