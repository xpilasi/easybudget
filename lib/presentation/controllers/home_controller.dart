import 'package:get/get.dart';
import '../../app/config/app_constants.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/shopping_list.dart';
import '../../domain/use_cases/category/get_categories_use_case.dart';
import '../../domain/use_cases/shopping_list/get_lists_use_case.dart';
import '../../domain/use_cases/shopping_list/create_list_use_case.dart';

/// Controller del Home Screen usando GetX
/// Gestiona estadísticas y listas recientes
class HomeController extends GetxController {
  final GetListsUseCase _getListsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final CreateListUseCase _createListUseCase;

  HomeController(
    this._getListsUseCase,
    this._getCategoriesUseCase,
    this._createListUseCase,
  );

  // ==================== STATE ====================

  final RxList<ShoppingList> _lists = <ShoppingList>[].obs;
  final RxList<Category> _categories = <Category>[].obs;
  final RxBool _isLoading = false.obs;

  List<ShoppingList> get lists => _lists;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading.value;

  // ==================== COMPUTED ====================

  /// Número total de listas
  int get totalLists => _lists.length;

  /// Total gastado en todas las listas
  double get totalSpent {
    return _lists.fold(0.0, (sum, list) => sum + list.total);
  }

  /// Listas recientes (últimas N)
  List<ShoppingList> get recentLists {
    final sorted = [..._lists];
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(AppConstants.maxRecentLists).toList();
  }

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // ==================== METHODS ====================

  /// Cargar datos (listas y categorías)
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

  /// Obtener categoría por ID
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Navegar al detalle de una lista
  void navigateToListDetail(String listId) {
    Get.toNamed('/list-detail', arguments: {'listId': listId});
  }

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

      _lists.add(newList);

      Get.snackbar(
        'Éxito',
        'Lista "$name" creada correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo crear la lista',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Refrescar datos (pull to refresh)
  @override
  Future<void> refresh() async {
    await loadData();
  }
}
