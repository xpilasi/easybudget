import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';

part 'category_model.g.dart';

/// Modelo CategoryModel para serialización JSON
/// Extiende de la entidad Category del dominio
@JsonSerializable()
class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name,
    required String colorHex,
  }) : super(
          color: Color(
            int.parse(colorHex.replaceFirst('#', '0xFF')),
          ),
        );

  /// Obtener color en formato hexadecimal
  @JsonKey(name: 'color')
  String get colorHex {
    final argb = color.toARGB32();
    final hexValue = argb.toRadixString(16).padLeft(8, '0');
    return '#${hexValue.substring(2)}'; // Remover el canal alpha (FF)
  }

  /// Crear desde JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Convertir a JSON
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  /// Crear modelo desde entidad
  factory CategoryModel.fromEntity(Category category) {
    final argb = category.color.toARGB32();
    final hexValue = argb.toRadixString(16).padLeft(8, '0');
    return CategoryModel(
      id: category.id,
      name: category.name,
      colorHex: '#${hexValue.substring(2)}',
    );
  }

  /// Convertir modelo a entidad
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      color: color,
    );
  }
}
