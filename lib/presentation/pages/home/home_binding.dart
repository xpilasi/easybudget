import 'package:get/get.dart';
import '../../../data/providers/local_storage_provider.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../data/repositories/shopping_list_repository.dart';
import '../../../data/repositories/shopping_list_repository_impl.dart';
import '../../../data/repositories/completed_purchase_repository.dart';
import '../../../data/repositories/completed_purchase_repository_impl.dart';
import '../../../domain/use_cases/category/get_categories_use_case.dart';
import '../../../domain/use_cases/shopping_list/get_lists_use_case.dart';
import '../../../domain/use_cases/shopping_list/create_list_use_case.dart';
import '../../../domain/use_cases/purchase/get_purchase_history_use_case.dart';
import '../../controllers/home_controller.dart';

/// Binding para Home Screen
/// Inyecta HomeController y sus dependencias
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // ==================== REPOSITORIES ====================
    // Lazy - solo se crean cuando se necesitan
    Get.lazyPut<ShoppingListRepository>(
      () => ShoppingListRepositoryImpl(Get.find<LocalStorageProvider>()),
    );

    Get.lazyPut<CategoryRepository>(
      () => CategoryRepositoryImpl(Get.find<LocalStorageProvider>()),
    );

    Get.lazyPut<CompletedPurchaseRepository>(
      () => CompletedPurchaseRepositoryImpl(Get.find<LocalStorageProvider>()),
    );

    // ==================== USE CASES ====================
    Get.lazyPut<GetListsUseCase>(
      () => GetListsUseCase(Get.find<ShoppingListRepository>()),
    );

    Get.lazyPut<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(Get.find<CategoryRepository>()),
    );

    Get.lazyPut<CreateListUseCase>(
      () => CreateListUseCase(Get.find<ShoppingListRepository>()),
    );

    Get.lazyPut<GetPurchaseHistoryUseCase>(
      () => GetPurchaseHistoryUseCase(Get.find<CompletedPurchaseRepository>()),
    );

    // ==================== CONTROLLERS ====================
    Get.lazyPut<HomeController>(
      () => HomeController(
        Get.find<GetListsUseCase>(),
        Get.find<GetCategoriesUseCase>(),
        Get.find<CreateListUseCase>(),
        Get.find<GetPurchaseHistoryUseCase>(),
      ),
    );
  }
}
