import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/price_history_entry.dart';

part 'price_history_entry_model.g.dart';

/// Modelo PriceHistoryEntryModel para serialización JSON
/// Extiende de la entidad PriceHistoryEntry del dominio
@JsonSerializable(explicitToJson: true)
class PriceHistoryEntryModel extends PriceHistoryEntry {
  // ignore: prefer_const_constructors_in_immutables
  PriceHistoryEntryModel({
    required super.id,
    super.productId, // Opcional para compatibilidad con datos antiguos
    required super.productName,
    required super.price,
    required super.date,
    required super.listId,
    required super.listName,
  });

  /// Crear desde JSON
  factory PriceHistoryEntryModel.fromJson(Map<String, dynamic> json) =>
      _$PriceHistoryEntryModelFromJson(json);

  /// Convertir a JSON
  Map<String, dynamic> toJson() => _$PriceHistoryEntryModelToJson(this);

  /// Crear modelo desde entidad
  factory PriceHistoryEntryModel.fromEntity(PriceHistoryEntry entry) {
    return PriceHistoryEntryModel(
      id: entry.id,
      productId: entry.productId,
      productName: entry.productName,
      price: entry.price,
      date: entry.date,
      listId: entry.listId,
      listName: entry.listName,
    );
  }

  /// Convertir modelo a entidad
  PriceHistoryEntry toEntity() {
    return PriceHistoryEntry(
      id: id,
      productId: productId,
      productName: productName,
      price: price,
      date: date,
      listId: listId,
      listName: listName,
    );
  }
}
