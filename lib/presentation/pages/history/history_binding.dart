import 'package:get/get.dart';
import '../../../data/providers/local_storage_provider.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../data/repositories/completed_purchase_repository.dart';
import '../../../data/repositories/completed_purchase_repository_impl.dart';
import '../../../domain/use_cases/category/get_categories_use_case.dart';
import '../../../domain/use_cases/purchase/get_purchase_history_use_case.dart';
import '../../controllers/history_controller.dart';

/// Binding para History Screen
/// Inyecta HistoryController y sus dependencias
class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    // ==================== REPOSITORIES ====================
    Get.lazyPut<CompletedPurchaseRepository>(
      () => CompletedPurchaseRepositoryImpl(Get.find<LocalStorageProvider>()),
    );

    Get.lazyPut<CategoryRepository>(
      () => CategoryRepositoryImpl(Get.find<LocalStorageProvider>()),
    );

    // ==================== USE CASES ====================
    Get.lazyPut<GetPurchaseHistoryUseCase>(
      () => GetPurchaseHistoryUseCase(Get.find<CompletedPurchaseRepository>()),
    );

    Get.lazyPut<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(Get.find<CategoryRepository>()),
    );

    // ==================== CONTROLLERS ====================
    Get.lazyPut<HistoryController>(
      () => HistoryController(
        Get.find<GetPurchaseHistoryUseCase>(),
        Get.find<GetCategoriesUseCase>(),
      ),
    );
  }
}
