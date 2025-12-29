import 'package:flutter/material.dart';
import '../../../app/config/app_constants.dart';
import '../../../data/repositories/category_repository.dart';
import '../../entities/category.dart';

/// Caso de uso para crear una nueva categoría
class CreateCategoryUseCase {
  final CategoryRepository _repository;

  CreateCategoryUseCase(this._repository);

  /// Ejecutar creación de categoría
  /// Valida la longitud del nombre antes de crear
  Future<Category> call({
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
      final category = await _repository.createCategory(
        name: trimmedName,
        color: color,
      );
      return category;
    } catch (e) {
      throw Exception('Error al crear categoría: $e');
    }
  }
}
