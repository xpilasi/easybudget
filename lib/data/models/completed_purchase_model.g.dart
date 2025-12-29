// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_purchase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletedPurchaseModel _$CompletedPurchaseModelFromJson(
  Map<String, dynamic> json,
) => CompletedPurchaseModel(
  id: json['id'] as String,
  listId: json['listId'] as String,
  listName: json['listName'] as String,
  categoryId: json['categoryId'] as String,
  currency: json['currency'] as String,
  products: (json['products'] as List<dynamic>)
      .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  completedAt: DateTime.parse(json['completedAt'] as String),
  total: (json['total'] as num).toDouble(),
);

Map<String, dynamic> _$CompletedPurchaseModelToJson(
  CompletedPurchaseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'listId': instance.listId,
  'listName': instance.listName,
  'categoryId': instance.categoryId,
  'currency': instance.currency,
  'createdAt': instance.createdAt.toIso8601String(),
  'completedAt': instance.completedAt.toIso8601String(),
  'total': instance.total,
  'products': instance.products.map((e) => e.toJson()).toList(),
};
