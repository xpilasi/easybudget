// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingListModel _$ShoppingListModelFromJson(Map<String, dynamic> json) =>
    ShoppingListModel(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      currency: json['currency'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ShoppingListModelToJson(ShoppingListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categoryId': instance.categoryId,
      'currency': instance.currency,
      'createdAt': instance.createdAt.toIso8601String(),
      'products': instance.products.map((e) => e.toJson()).toList(),
    };
