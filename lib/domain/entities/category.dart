import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entidad Category del dominio
/// Representa una categoría para organizar listas
class Category extends Equatable {
  final String id;
  final String name;
  final Color color;

  const Category({
    required this.id,
    required this.name,
    required this.color,
  });

  /// Obtener color con opacidad
  Color colorWithOpacity(double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Copiar categoría con campos modificados
  Category copyWith({
    String? id,
    String? name,
    Color? color,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [id, name, color];

  @override
  String toString() => 'Category(id: $id, name: $name)';
}
