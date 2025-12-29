import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/config/app_constants.dart';
import '../../data/providers/local_storage_provider.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/shopping_list.dart';
import '../../domain/use_cases/category/get_categories_use_case.dart';
import '../../domain/use_cases/shopping_list/add_product_use_case.dart';
import '../../domain/use_cases/shopping_list/delete_list_use_case.dart';
import '../../domain/use_cases/shopping_list/delete_product_use_case.dart';
import '../../domain/use_cases/shopping_list/get_lists_use_case.dart';
import '../../domain/use_cases/shopping_list/get_list_by_id_use_case.dart';
import '../../domain/use_cases/shopping_list/update_list_use_case.dart';
import '../../domain/use_cases/shopping_list/update_product_use_case.dart';
import '../../domain/use_cases/shopping_list/complete_list_use_case.dart';
import 'home_controller.dart';
import 'lists_controller.dart';

/// Controller del List Detail Screen usando GetX
/// Gestiona detalles de una lista y operaciones CRUD de productos
class ListDetailController extends GetxController {
  final GetListsUseCase _getListsUseCase;
  final GetListByIdUseCase _getListByIdUseCase;
  final UpdateListUseCase _updateListUseCase;
  final DeleteListUseCase _deleteListUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final CompleteListUseCase _completeListUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final LocalStorageProvider _storageProvider;

  ListDetailController(
    this._getListsUseCase,
    this._getListByIdUseCase,
    this._updateListUseCase,
    this._deleteListUseCase,
    this._addProductUseCase,
    this._updateProductUseCase,
    this._deleteProductUseCase,
    this._completeListUseCase,
    this._getCategoriesUseCase,
    this._storageProvider,
  );

  // ==================== STATE ====================

  final Rx<ShoppingList?> _shoppingList = Rx<ShoppingList?>(null);
  final RxList<Category> _categories = <Category>[].obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isEditingName = false.obs;
  final RxString _editingListName = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxString _sortOrder = 'none'.obs; // 'none', 'price_desc', 'name_asc'
  final RxBool _filterQuantityGreaterThanZero = false.obs;
  final RxBool _filterPendingOnly = false.obs;
  final RxSet<String> _selectedProductIds = <String>{}.obs;

  ShoppingList? get shoppingList => _shoppingList.value;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading.value;
  bool get isEditingName => _isEditingName.value;
  String get editingListName => _editingListName.value;
  String get searchQuery => _searchQuery.value;
  String get sortOrder => _sortOrder.value;
  bool get filterQuantityGreaterThanZero => _filterQuantityGreaterThanZero.value;
  bool get filterPendingOnly => _filterPendingOnly.value;
  Set<String> get selectedProductIds => _selectedProductIds;

  // ==================== COMPUTED ====================

  /// Total de la lista
  double get total => _shoppingList.value?.total ?? 0.0;

  /// Total de productos (items únicos)
  int get totalProducts => _shoppingList.value?.totalProducts ?? 0;

  /// Total de items (suma de cantidades)
  int get totalItems => _shoppingList.value?.totalItems ?? 0;

  /// Símbolo de moneda
  String get currencySymbol => _shoppingList.value?.currency ?? '\$';

  /// Categoría de la lista
  Category? get category {
    if (_shoppingList.value == null) return null;
    try {
      return _categories
          .firstWhere((cat) => cat.id == _shoppingList.value!.categoryId);
    } catch (e) {
      return null;
    }
  }

  /// Lista vacía
  bool get isEmpty => _shoppingList.value?.isEmpty ?? true;

  /// Productos filtrados según búsqueda y ordenados según filtro
  List<Product> get filteredProducts {
    if (_shoppingList.value == null) return [];

    var products = _shoppingList.value!.products;
    final query = _searchQuery.value.trim().toLowerCase();

    // Filtrar por búsqueda
    if (query.isNotEmpty) {
      products = products.where((product) {
        return product.name.toLowerCase().contains(query);
      }).toList();
    }

    // Filtrar por cantidad > 0
    if (_filterQuantityGreaterThanZero.value) {
      products = products.where((product) {
        return product.quantity > 0;
      }).toList();
    }

    // Filtrar por pendientes (no seleccionados)
    if (_filterPendingOnly.value) {
      products = products.where((product) {
        return !_selectedProductIds.contains(product.id);
      }).toList();
    }

    // Ordenar según filtro seleccionado
    final sortedProducts = List<Product>.from(products);
    switch (_sortOrder.value) {
      case 'price_desc':
        sortedProducts.sort((a, b) => b.subtotal.compareTo(a.subtotal));
        break;
      case 'name_asc':
        sortedProducts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case 'none':
      default:
        // Sin ordenamiento, mantener orden original
        break;
    }

    return sortedProducts;
  }

  /// Hay búsqueda activa
  bool get hasActiveSearch => _searchQuery.value.trim().isNotEmpty;

  /// Número de filtros activos
  int get activeFiltersCount {
    int count = 0;
    if (_sortOrder.value != 'none') count++;
    if (_filterQuantityGreaterThanZero.value) count++;
    if (_filterPendingOnly.value) count++;
    return count;
  }

  /// Número de productos seleccionados
  int get selectedProductsCount => _selectedProductIds.length;

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  // ==================== METHODS - DATA ====================

  /// Cargar datos iniciales
  Future<void> _loadInitialData() async {
    final args = Get.arguments as Map<String, dynamic>?;
    final listId = args?['listId'] as String?;

    if (listId == null) {
      Get.snackbar(
        'Error',
        'ID de lista no encontrado',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
      return;
    }

    await loadList(listId);
    await _loadCategories();
  }

  /// Cargar lista específica
  Future<void> loadList(String listId) async {
    _isLoading.value = true;
    try {
      // Usar getListById que busca en TODAS las listas (activas y completadas)
      final list = await _getListByIdUseCase(listId);

      if (list == null) {
        throw Exception('Lista no encontrada');
      }

      _shoppingList.value = list;
      _editingListName.value = list.name;

      // Cargar estado guardado
      _loadSavedState(listId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cargar la lista',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Cargar estado guardado de la lista
  void _loadSavedState(String listId) {
    // Cargar productos seleccionados
    final selectedProducts = _storageProvider.getListSelectedProducts(listId);
    _selectedProductIds.clear();
    _selectedProductIds.addAll(selectedProducts);

    // Cargar ordenamiento
    _sortOrder.value = _storageProvider.getListSortOrder(listId);

    // Cargar filtros
    _filterQuantityGreaterThanZero.value = _storageProvider.getListFilterQuantity(listId);
    _filterPendingOnly.value = _storageProvider.getListFilterPending(listId);
  }

  /// Guardar productos seleccionados
  void _saveSelectedProducts() {
    if (_shoppingList.value == null) return;
    _storageProvider.saveListSelectedProducts(
      _shoppingList.value!.id,
      _selectedProductIds.toList(),
    );
  }

  /// Guardar ordenamiento
  void _saveSortOrder() {
    if (_shoppingList.value == null) return;
    _storageProvider.saveListSortOrder(
      _shoppingList.value!.id,
      _sortOrder.value,
    );
  }

  /// Guardar filtro de cantidad
  void _saveFilterQuantity() {
    if (_shoppingList.value == null) return;
    _storageProvider.saveListFilterQuantity(
      _shoppingList.value!.id,
      _filterQuantityGreaterThanZero.value,
    );
  }

  /// Guardar filtro de pendientes
  void _saveFilterPending() {
    if (_shoppingList.value == null) return;
    _storageProvider.saveListFilterPending(
      _shoppingList.value!.id,
      _filterPendingOnly.value,
    );
  }

  /// Cargar categorías
  Future<void> _loadCategories() async {
    try {
      final categories = await _getCategoriesUseCase();
      _categories.value = categories;
    } catch (e) {
      // Error silencioso, no afecta funcionalidad principal
    }
  }

  /// Refrescar datos
  @override
  Future<void> refresh() async {
    if (_shoppingList.value != null) {
      await loadList(_shoppingList.value!.id);
    }
  }

  // ==================== METHODS - SEARCH ====================

  /// Actualizar término de búsqueda
  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  /// Limpiar búsqueda
  void clearSearch() {
    _searchQuery.value = '';
  }

  // ==================== METHODS - SORTING ====================

  /// Cambiar orden de productos
  void setSortOrder(String order) {
    _sortOrder.value = order;
    _saveSortOrder();
  }

  /// Limpiar ordenamiento
  void clearSort() {
    _sortOrder.value = 'none';
    _saveSortOrder();
  }

  /// Activar/desactivar filtro de cantidad > 0
  void setFilterQuantityGreaterThanZero(bool value) {
    _filterQuantityGreaterThanZero.value = value;
    _saveFilterQuantity();
  }

  /// Limpiar filtro de cantidad
  void clearQuantityFilter() {
    _filterQuantityGreaterThanZero.value = false;
    _saveFilterQuantity();
  }

  /// Activar/desactivar filtro de pendientes
  void setFilterPendingOnly(bool value) {
    _filterPendingOnly.value = value;
    _saveFilterPending();
  }

  /// Limpiar filtro de pendientes
  void clearPendingFilter() {
    _filterPendingOnly.value = false;
    _saveFilterPending();
  }

  // ==================== METHODS - SELECTION ====================

  /// Toggle selección de producto
  void toggleProductSelection(String productId) {
    if (_selectedProductIds.contains(productId)) {
      _selectedProductIds.remove(productId);
    } else {
      _selectedProductIds.add(productId);
    }
    _saveSelectedProducts();
  }

  /// Verificar si un producto está seleccionado
  bool isProductSelected(String productId) {
    return _selectedProductIds.contains(productId);
  }

  /// Limpiar todas las selecciones
  void clearSelection() {
    _selectedProductIds.clear();
    _saveSelectedProducts();
  }

  /// Seleccionar todos los productos
  void selectAllProducts() {
    if (_shoppingList.value == null) return;
    _selectedProductIds.clear();
    for (var product in _shoppingList.value!.products) {
      _selectedProductIds.add(product.id);
    }
    _saveSelectedProducts();
  }

  // ==================== METHODS - LIST EDITING ====================

  /// Activar edición de nombre
  void startEditingName() {
    _isEditingName.value = true;
    _editingListName.value = _shoppingList.value?.name ?? '';
  }

  /// Cancelar edición de nombre
  void cancelEditingName() {
    _isEditingName.value = false;
    _editingListName.value = _shoppingList.value?.name ?? '';
  }

  /// Actualizar nombre temporal (mientras se edita)
  void updateEditingName(String value) {
    _editingListName.value = value;
  }

  /// Guardar nombre editado
  Future<void> saveListName() async {
    if (_shoppingList.value == null) return;

    final trimmedName = _editingListName.value.trim();
    if (trimmedName.isEmpty) {
      Get.snackbar(
        'Error',
        'El nombre no puede estar vacío',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (trimmedName == _shoppingList.value!.name) {
      _isEditingName.value = false;
      return;
    }

    try {
      final updatedList = _shoppingList.value!.copyWith(name: trimmedName);
      final result = await _updateListUseCase(updatedList);

      _shoppingList.value = result;
      _isEditingName.value = false;

      Get.snackbar(
        'Éxito',
        'Nombre actualizado',
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

  /// Actualizar moneda
  Future<void> updateCurrency(String currency) async {
    if (_shoppingList.value == null) return;
    if (currency == _shoppingList.value!.currency) return;

    try {
      final updatedList = _shoppingList.value!.copyWith(currency: currency);
      final result = await _updateListUseCase(updatedList);

      _shoppingList.value = result;

      Get.snackbar(
        'Éxito',
        'Moneda actualizada',
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

  // ==================== METHODS - PRODUCTS ====================

  /// Agregar producto
  Future<void> addProduct({
    required String productName,
    required double price,
    required int quantity,
  }) async {
    if (_shoppingList.value == null) return;

    try {
      final updatedList = await _addProductUseCase(
        listId: _shoppingList.value!.id,
        productName: productName,
        price: price,
        quantity: quantity,
      );

      _shoppingList.value = updatedList;

      // Refrescar otros controllers
      _refreshOtherControllers();

      Get.snackbar(
        'Éxito',
        'Producto agregado',
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

  /// Actualizar producto
  Future<void> updateProduct({
    required String productId,
    String? name,
    double? price,
    int? quantity,
    bool showSnackbar = true, // Mostrar snackbar por defecto
  }) async {
    if (_shoppingList.value == null) return;

    try {
      // Obtener producto actual
      final currentProduct = getProductById(productId);
      if (currentProduct == null) {
        throw Exception('Producto no encontrado');
      }

      // Construir producto actualizado
      final updatedProduct = Product(
        id: productId,
        name: name ?? currentProduct.name,
        price: price ?? currentProduct.price,
        quantity: quantity ?? currentProduct.quantity,
      );

      final updatedList = await _updateProductUseCase(
        listId: _shoppingList.value!.id,
        product: updatedProduct,
      );

      _shoppingList.value = updatedList;

      // Refrescar otros controllers
      _refreshOtherControllers();

      // Solo mostrar snackbar si se solicita (cuando se edita via modal)
      if (showSnackbar) {
        Get.snackbar(
          'Éxito',
          'Producto actualizado',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Eliminar producto
  Future<void> deleteProduct(String productId) async {
    if (_shoppingList.value == null) return;

    try {
      final updatedList = await _deleteProductUseCase(
        listId: _shoppingList.value!.id,
        productId: productId,
      );

      _shoppingList.value = updatedList;

      // Refrescar otros controllers
      _refreshOtherControllers();

      Get.snackbar(
        'Éxito',
        'Producto eliminado',
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

  /// Incrementar cantidad de producto
  Future<void> incrementProductQuantity(Product product) async {
    // Limitar a máximo según constante
    if (product.quantity >= AppConstants.maxProductQuantity) return;

    await updateProduct(
      productId: product.id,
      quantity: product.quantity + 1,
      showSnackbar: false, // No mostrar snackbar
    );
  }

  /// Decrementar cantidad de producto
  Future<void> decrementProductQuantity(Product product) async {
    // Limitar a mínimo 0
    if (product.quantity > 0) {
      await updateProduct(
        productId: product.id,
        quantity: product.quantity - 1,
        showSnackbar: false, // No mostrar snackbar
      );
    }
  }

  // ==================== METHODS - LIST ACTIONS ====================

  /// Actualizar lista (nombre, categoría y moneda)
  Future<void> updateList({
    required String name,
    required String categoryId,
    required String currency,
  }) async {
    if (_shoppingList.value == null) return;

    try {
      // Crear lista actualizada con los nuevos valores usando copyWith
      final listToUpdate = _shoppingList.value!.copyWith(
        name: name,
        categoryId: categoryId,
        currency: currency,
      );

      final updatedList = await _updateListUseCase(listToUpdate);

      _shoppingList.value = updatedList;

      // Refrescar otros controllers que puedan tener copias de las listas
      _refreshOtherControllers();

      Get.snackbar(
        'Éxito',
        'Lista actualizada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar la lista: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Eliminar lista completa
  Future<void> deleteList() async {
    if (_shoppingList.value == null) return;

    // Confirmación
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Eliminar lista'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar esta lista? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _deleteListUseCase(_shoppingList.value!.id);

      // Refrescar otros controllers
      _refreshOtherControllers();

      Get.back(); // Volver a la pantalla anterior
      Get.snackbar(
        'Éxito',
        'Lista eliminada',
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

  /// Completar compra (guardar en historial, lista permanece)
  Future<void> completeList() async {
    if (_shoppingList.value == null) return;

    // Validar que tenga productos
    if (_shoppingList.value!.isEmpty) {
      Get.snackbar(
        'Aviso',
        'No puedes completar una compra sin productos',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Confirmación
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Completar compra'),
        content: Text(
          '¿Confirmas que has completado esta compra?\n\n'
          'Total: ${currencySymbol}${total.toStringAsFixed(2)}\n'
          'Productos: $totalProducts\n\n'
          'Se guardará en tu historial y podrás seguir usando esta lista.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Completar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _completeListUseCase.execute(_shoppingList.value!.id);

      // Refrescar otros controllers
      _refreshOtherControllers();

      Get.back(); // Volver a la pantalla anterior
      Get.snackbar(
        'Éxito',
        'Compra completada y guardada en el historial',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Compartir lista
  Future<void> shareList() async {
    if (_shoppingList.value == null) return;

    // Placeholder - será implementado en la UI con share_plus
    Get.snackbar(
      'Compartir',
      'Funcionalidad de compartir será implementada en la UI',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ==================== HELPERS ====================

  /// Refrescar otros controllers que puedan tener copias de las listas
  void _refreshOtherControllers() {
    // Refrescar HomeController si está registrado
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadData();
    }

    // Refrescar ListsController si está registrado
    if (Get.isRegistered<ListsController>()) {
      Get.find<ListsController>().refresh();
    }
  }

  /// Obtener producto por ID
  Product? getProductById(String productId) {
    if (_shoppingList.value == null) return null;
    try {
      return _shoppingList.value!.products
          .firstWhere((prod) => prod.id == productId);
    } catch (e) {
      return null;
    }
  }
}
