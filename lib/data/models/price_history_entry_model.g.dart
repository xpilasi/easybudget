// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_history_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceHistoryEntryModel _$PriceHistoryEntryModelFromJson(
  Map<String, dynamic> json,
) => PriceHistoryEntryModel(
  id: json['id'] as String,
  productId: json['productId'] as String?,
  productName: json['productName'] as String,
  price: (json['price'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  listId: json['listId'] as String,
  listName: json['listName'] as String,
);

Map<String, dynamic> _$PriceHistoryEntryModelToJson(
  PriceHistoryEntryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'productName': instance.productName,
  'price': instance.price,
  'date': instance.date.toIso8601String(),
  'listId': instance.listId,
  'listName': instance.listName,
};
