import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/category.dart';
import '../models/category_model.dart';
import '../providers/local_storage_provider.dart';
import '../providers/mock_data_provider.dart';
import 'category_repository.dart';

/// Implementación del repositorio de categorías
/// Usa LocalStorageProvider para persistencia
class CategoryRepositoryImpl implements CategoryRepository {
  final LocalStorageProvider _storageProvider;
  final Uuid _uuid = const Uuid();

  CategoryRepositoryImpl(this._storageProvider);

  @override
  Future<List<Category>> getCategories() async {
    // Intentar obtener categorías guardadas
    final storedCategories = _storageProvider.getCategories();

    if (storedCategories != null && storedCategories.isNotEmpty) {
      return storedCategories
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    }

    // Si no hay categorías guardadas, verificar si es la primera vez
    if (_storageProvider.isFirstTimeInit()) {
      // Solo en la primera vez, cargar y guardar datos mock
      final mockCategories = MockDataProvider.getMockCategories();
      await _saveCategories(mockCategories);
      // No llamar setFirstTimeInitDone aquí, ya lo hace ShoppingListRepository
      return mockCategories;
    }

    // Si no es primera vez y no hay categorías, crear categoría por defecto
    // (Siempre debe haber al menos una categoría)
    final defaultCategory = CategoryModel(
      id: const Uuid().v4(),
      name: 'General',
      colorHex: '#FF6B6B',
    );
    await _saveCategories([defaultCategory]);
    return [defaultCategory];
  }

  @override
  Future<Category> createCategory({
    required String name,
    required Color color,
  }) async {
    final categories = await getCategories();

    // Crear nueva categoría
    final argb = color.toARGB32();
    final hexValue = argb.toRadixString(16).padLeft(8, '0');
    final newCategory = CategoryModel(
      id: _uuid.v4(),
      name: name,
      colorHex: '#${hexValue.substring(2)}',
    );

    // Agregar y guardar
    final updatedCategories = [
      ...categories.map((c) => CategoryModel.fromEntity(c)),
      newCategory,
    ];
    await _saveCategories(updatedCategories);

    return newCategory;
  }

  @override
  Future<Category> updateCategory({
    required String id,
    required String name,
    required Color color,
  }) async {
    final categories = await getCategories();

    // Actualizar categoría con nombre y color
    final updatedCategories = categories.map((category) {
      if (category.id == id) {
        return CategoryModel.fromEntity(
          category.copyWith(
            name: name,
            color: color,
          ),
        );
      }
      return CategoryModel.fromEntity(category);
    }).toList();

    await _saveCategories(updatedCategories);

    return updatedCategories.firstWhere((c) => c.id == id);
  }

  @override
  Future<void> deleteCategory(String id) async {
    final categories = await getCategories();

    // No permitir eliminar si solo hay una categoría
    if (categories.length <= 1) {
      throw Exception('Debe haber al menos una categoría');
    }

    // Eliminar categoría
    final updatedCategories = categories
        .where((c) => c.id != id)
        .map((c) => CategoryModel.fromEntity(c))
        .toList();

    await _saveCategories(updatedCategories);
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    final categories = await getCategories();
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== HELPERS ====================

  Future<void> _saveCategories(List<CategoryModel> categories) async {
    final categoriesJson = categories.map((c) => c.toJson()).toList();
    await _storageProvider.saveCategories(categoriesJson);
  }
}
