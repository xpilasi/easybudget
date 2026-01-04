import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/services/deep_link_service.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/shopping_list.dart';
import '../../domain/use_cases/category/create_category_use_case.dart';
import '../../domain/use_cases/category/delete_category_use_case.dart';
import '../../domain/use_cases/category/get_categories_use_case.dart';
import '../../domain/use_cases/category/update_category_use_case.dart';
import '../../domain/use_cases/shopping_list/add_product_use_case.dart';
import '../../domain/use_cases/shopping_list/create_list_use_case.dart';
import '../../domain/use_cases/shopping_list/delete_list_use_case.dart';
import '../../domain/use_cases/shopping_list/get_lists_use_case.dart';

/// Controller de Lists Screen usando GetX
/// Gestiona listas de compras y categorías
class ListsController extends GetxController {
  final GetListsUseCase _getListsUseCase;
  final CreateListUseCase _createListUseCase;
  final DeleteListUseCase _deleteListUseCase;
  final AddProductUseCase _addProductUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final CreateCategoryUseCase _createCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final DeleteCategoryUseCase _deleteCategoryUseCase;

  ListsController(
    this._getListsUseCase,
    this._createListUseCase,
    this._deleteListUseCase,
    this._addProductUseCase,
    this._getCategoriesUseCase,
    this._createCategoryUseCase,
    this._updateCategoryUseCase,
    this._deleteCategoryUseCase,
  );

  // ==================== STATE ====================

  final RxList<ShoppingList> _lists = <ShoppingList>[].obs;
  final RxList<Category> _categories = <Category>[].obs;
  final RxList<String> _selectedCategoryFilters = <String>[].obs;
  final RxBool _isLoading = false.obs;

  List<ShoppingList> get lists => _lists;
  List<Category> get categories => _categories;
  List<String> get selectedCategoryFilters => _selectedCategoryFilters;
  bool get isLoading => _isLoading.value;

  // ==================== COMPUTED ====================

  /// Listas filtradas por categoría
  List<ShoppingList> get filteredLists {
    if (_selectedCategoryFilters.isEmpty) {
      return _lists;
    }
    return _lists
        .where((list) => _selectedCategoryFilters.contains(list.categoryId))
        .toList();
  }

  /// Listas agrupadas por categoría
  Map<String, List<ShoppingList>> get groupedLists {
    final Map<String, List<ShoppingList>> grouped = {};
    for (final category in _categories) {
      grouped[category.id] = filteredLists
          .where((list) => list.categoryId == category.id)
          .toList();
    }
    return grouped;
  }

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // ==================== METHODS - DATA ====================

  /// Cargar datos
  Future<void> loadData() async {
    _isLoading.value = true;
    try {
      final listsResult = await _getListsUseCase();
      final categoriesResult = await _getCategoriesUseCase();

      _lists.value = listsResult;
      _categories.value = categoriesResult;
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron cargar los datos',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Refrescar datos
  @override
  Future<void> refresh() async {
    await loadData();
  }

  // ==================== METHODS - FILTERS ====================

  /// Establecer filtros de categorías
  void setSelectedCategoryFilters(List<String> categoryIds) {
    _selectedCategoryFilters.value = categoryIds;
  }

  /// Toggle filtro de categoría individual
  void toggleCategoryFilter(String categoryId) {
    if (_selectedCategoryFilters.contains(categoryId)) {
      _selectedCategoryFilters.remove(categoryId);
    } else {
      _selectedCategoryFilters.add(categoryId);
    }
  }

  /// Limpiar filtros
  void clearFilter() {
    _selectedCategoryFilters.clear();
  }

  // ==================== METHODS - LISTS ====================

  /// Crear nueva lista
  Future<void> createList({
    required String name,
    required String categoryId,
    required String currency,
  }) async {
    try {
      final newList = await _createListUseCase(
        name: name,
        categoryId: categoryId,
        currency: currency,
      );

      _lists.insert(0, newList); // Insertar al inicio
      Get.back(); // Cerrar modal
      Get.snackbar(
        'Éxito',
        'Lista creada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Importar lista compartida
  Future<void> importSharedList({
    required String name,
    required String categoryId,
    required SharedListData sharedData,
  }) async {
    try {
      // 1. Crear la lista vacía
      final newList = await _createListUseCase(
        name: name,
        categoryId: categoryId,
        currency: sharedData.currency,
      );

      // 2. Filtrar productos con cantidad > 0 (evitar productos vacíos)
      final validProducts = sharedData.products.where((p) => p.quantity > 0).toList();

      // 3. Agregar todos los productos válidos
      var updatedList = newList;
      for (final product in validProducts) {
        updatedList = await _addProductUseCase(
          listId: updatedList.id,
          productName: product.name,
          price: product.price,
          quantity: product.quantity,
        );
      }

      // 3. Actualizar la lista en el estado
      _lists.insert(0, updatedList);

      Get.snackbar(
        'Éxito',
        'Lista "${name}" importada correctamente con ${sharedData.totalProducts} productos',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // La lista ya se muestra en el tab de listas actual
      // No navegamos automáticamente para evitar problemas de contexto
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo importar la lista: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Eliminar lista
  Future<void> deleteList(String listId) async {
    try {
      await _deleteListUseCase(listId);
      _lists.removeWhere((list) => list.id == listId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo eliminar la lista: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ==================== METHODS - CATEGORIES ====================

  /// Crear nueva categoría
  Future<void> createCategory({
    required String name,
    required Color color,
  }) async {
    try {
      final newCategory = await _createCategoryUseCase(
        name: name,
        color: color,
      );

      _categories.add(newCategory);

      // Refrescar listas para actualizar las categorías mostradas
      await refresh();

      Get.snackbar(
        'Éxito',
        'Categoría creada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Actualizar categoría
  Future<void> updateCategory({
    required String id,
    required String name,
    required Color color,
  }) async {
    try {
      final updatedCategory = await _updateCategoryUseCase(
        id: id,
        name: name,
        color: color,
      );

      final index = _categories.indexWhere((c) => c.id == id);
      if (index != -1) {
        _categories[index] = updatedCategory;
      }

      // Refrescar listas para actualizar las categorías mostradas
      await refresh();

      Get.snackbar(
        'Éxito',
        'Categoría actualizada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Eliminar categoría
  Future<void> deleteCategory(String categoryId) async {
    try {
      await _deleteCategoryUseCase(categoryId);
      _categories.removeWhere((c) => c.id == categoryId);

      // Refrescar listas para actualizar las categorías mostradas
      await refresh();

      Get.snackbar(
        'Éxito',
        'Categoría eliminada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ==================== HELPERS ====================

  /// Obtener categoría por ID
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Navegar al detalle de lista
  void navigateToListDetail(String listId) {
    Get.toNamed('/list-detail', arguments: {'listId': listId});
  }
}
