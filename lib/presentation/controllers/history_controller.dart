import 'package:get/get.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/completed_purchase.dart';
import '../../domain/use_cases/category/get_categories_use_case.dart';
import '../../domain/use_cases/purchase/get_purchase_history_use_case.dart';
import '../pages/history/purchase_detail_page.dart';

/// Controller del History Screen usando GetX
/// Gestiona el historial completo de compras completadas
class HistoryController extends GetxController {
  final GetPurchaseHistoryUseCase _getPurchaseHistoryUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  HistoryController(
    this._getPurchaseHistoryUseCase,
    this._getCategoriesUseCase,
  );

  // ==================== STATE ====================

  final RxList<CompletedPurchase> _purchases = <CompletedPurchase>[].obs;
  final RxList<Category> _categories = <Category>[].obs;
  final RxBool _isLoading = false.obs;

  List<CompletedPurchase> get purchases => _purchases;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading.value;

  // ==================== COMPUTED ====================

  /// Total de compras
  int get totalPurchases => _purchases.length;

  /// Total gastado en todas las compras
  double get totalSpent {
    return _purchases.fold(0.0, (sum, purchase) => sum + purchase.total);
  }

  /// Gasto promedio por compra
  double get averageSpent {
    if (_purchases.isEmpty) return 0.0;
    return totalSpent / _purchases.length;
  }

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // ==================== METHODS ====================

  /// Cargar historial de compras
  Future<void> loadData() async {
    _isLoading.value = true;
    try {
      final purchasesResult = await _getPurchaseHistoryUseCase();
      final categoriesResult = await _getCategoriesUseCase();

      _purchases.value = purchasesResult;
      _categories.value = categoriesResult;
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cargar el historial',
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

  /// Navegar al detalle de una compra
  void navigateToPurchaseDetail(String purchaseId) {
    final purchase = _purchases.firstWhereOrNull((p) => p.id == purchaseId);

    if (purchase == null) {
      Get.snackbar(
        'Error',
        'No se encontró la compra',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final category = getCategoryById(purchase.categoryId);

    Get.to(
      () => PurchaseDetailPage(
        purchase: purchase,
        category: category,
      ),
    );
  }

  /// Refrescar datos (pull to refresh)
  @override
  Future<void> refresh() async {
    await loadData();
  }
}
