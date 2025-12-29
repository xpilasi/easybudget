import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

/// Interfaz del repositorio de categorías
/// Define el contrato para operaciones CRUD de categorías
abstract class CategoryRepository {
  /// Obtener todas las categorías
  Future<List<Category>> getCategories();

  /// Crear una nueva categoría
  Future<Category> createCategory({
    required String name,
    required Color color,
  });

  /// Actualizar una categoría existente
  Future<Category> updateCategory({
    required String id,
    required String name,
    required Color color,
  });

  /// Eliminar una categoría
  Future<void> deleteCategory(String id);

  /// Obtener una categoría por ID
  Future<Category?> getCategoryById(String id);
}
