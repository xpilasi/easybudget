import 'package:flutter/material.dart';
import '../../../app/config/app_constants.dart';
import '../../../data/repositories/category_repository.dart';
import '../../entities/category.dart';

/// Caso de uso para actualizar una categoría existente
class UpdateCategoryUseCase {
  final CategoryRepository _repository;

  UpdateCategoryUseCase(this._repository);

  /// Ejecutar actualización de categoría
  Future<Category> call({
    required String id,
    required String name,
    required Color color,
  }) async {
    // Validaciones
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      throw Exception('El nombre de la categoría no puede estar vacío');
    }

    if (trimmedName.length > AppConstants.maxCategoryNameLength) {
      throw Exception(
        'El nombre no puede tener más de ${AppConstants.maxCategoryNameLength} caracteres',
      );
    }

    try {
      final category = await _repository.updateCategory(
        id: id,
        name: trimmedName,
        color: color,
      );
      return category;
    } catch (e) {
      throw Exception('Error al actualizar categoría: $e');
    }
  }
}
