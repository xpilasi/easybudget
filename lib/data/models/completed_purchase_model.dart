import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/completed_purchase.dart';
import '../../domain/entities/shopping_list.dart';
import 'product_model.dart';

part 'completed_purchase_model.g.dart';

/// Modelo CompletedPurchaseModel para serialización JSON
/// Extiende de la entidad CompletedPurchase del dominio
@JsonSerializable(explicitToJson: true)
class CompletedPurchaseModel extends CompletedPurchase {
  @override
  @JsonKey(name: 'products')
  // ignore: overridden_fields
  final List<ProductModel> products;

  // ignore: prefer_const_constructors_in_immutables
  CompletedPurchaseModel({
    required super.id,
    required super.listId,
    required super.listName,
    required super.categoryId,
    required super.currency,
    required this.products,
    required super.createdAt,
    required super.completedAt,
    required super.total,
  }) : super(products: products);

  /// Crear desde JSON
  factory CompletedPurchaseModel.fromJson(Map<String, dynamic> json) =>
      _$CompletedPurchaseModelFromJson(json);

  /// Convertir a JSON
  Map<String, dynamic> toJson() => _$CompletedPurchaseModelToJson(this);

  /// Crear modelo desde entidad CompletedPurchase
  factory CompletedPurchaseModel.fromEntity(CompletedPurchase purchase) {
    return CompletedPurchaseModel(
      id: purchase.id,
      listId: purchase.listId,
      listName: purchase.listName,
      categoryId: purchase.categoryId,
      currency: purchase.currency,
      products:
          purchase.products.map((p) => ProductModel.fromEntity(p)).toList(),
      createdAt: purchase.createdAt,
      completedAt: purchase.completedAt,
      total: purchase.total,
    );
  }

  /// Crear modelo desde ShoppingList
  /// Esto se usa cuando se completa una lista
  factory CompletedPurchaseModel.fromShoppingList({
    required String purchaseId,
    required ShoppingList list,
    required DateTime completedAt,
  }) {
    return CompletedPurchaseModel(
      id: purchaseId,
      listId: list.id,
      listName: list.name,
      categoryId: list.categoryId,
      currency: list.currency,
      products:
          list.products.map((p) => ProductModel.fromEntity(p)).toList(),
      createdAt: list.createdAt,
      completedAt: completedAt,
      total: list.total,
    );
  }

  /// Convertir modelo a entidad
  CompletedPurchase toEntity() {
    return CompletedPurchase(
      id: id,
      listId: listId,
      listName: listName,
      categoryId: categoryId,
      currency: currency,
      products: products,
      createdAt: createdAt,
      completedAt: completedAt,
      total: total,
    );
  }
}
