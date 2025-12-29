import 'package:get/get.dart';
import '../../../data/providers/local_storage_provider.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../data/repositories/shopping_list_repository.dart';
import '../../../data/repositories/shopping_list_repository_impl.dart';
import '../../../domain/use_cases/category/create_category_use_case.dart';
import '../../../domain/use_cases/category/delete_category_use_case.dart';
import '../../../domain/use_cases/category/get_categories_use_case.dart';
import '../../../domain/use_cases/category/update_category_use_case.dart';
import '../../../domain/use_cases/shopping_list/add_product_use_case.dart';
import '../../../domain/use_cases/shopping_list/create_list_use_case.dart';
import '../../../domain/use_cases/shopping_list/delete_list_use_case.dart';
import '../../../domain/use_cases/shopping_list/get_lists_use_case.dart';
import '../../controllers/lists_controller.dart';

/// Binding para Categories Page
class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    // Solo registrar si no está ya disponible
    if (!Get.isRegistered<ListsController>()) {
      // ==================== REPOSITORIES ====================
      if (!Get.isRegistered<ShoppingListRepository>()) {
        Get.lazyPut<ShoppingListRepository>(
          () => ShoppingListRepositoryImpl(Get.find<LocalStorageProvider>()),
        );
      }

      if (!Get.isRegistered<CategoryRepository>()) {
        Get.lazyPut<CategoryRepository>(
          () => CategoryRepositoryImpl(Get.find<LocalStorageProvider>()),
        );
      }

      // ==================== USE CASES - SHOPPING LISTS ====================
      if (!Get.isRegistered<GetListsUseCase>()) {
        Get.lazyPut<GetListsUseCase>(
          () => GetListsUseCase(Get.find<ShoppingListRepository>()),
        );
      }

      if (!Get.isRegistered<CreateListUseCase>()) {
        Get.lazyPut<CreateListUseCase>(
          () => CreateListUseCase(Get.find<ShoppingListRepository>()),
        );
      }

      if (!Get.isRegistered<DeleteListUseCase>()) {
        Get.lazyPut<DeleteListUseCase>(
          () => DeleteListUseCase(Get.find<ShoppingListRepository>()),
        );
      }

      if (!Get.isRegistered<AddProductUseCase>()) {
        Get.lazyPut<AddProductUseCase>(
          () => AddProductUseCase(Get.find<ShoppingListRepository>()),
        );
      }

      // ==================== USE CASES - CATEGORIES ====================
      if (!Get.isRegistered<GetCategoriesUseCase>()) {
        Get.lazyPut<GetCategoriesUseCase>(
          () => GetCategoriesUseCase(Get.find<CategoryRepository>()),
        );
      }

      if (!Get.isRegistered<CreateCategoryUseCase>()) {
        Get.lazyPut<CreateCategoryUseCase>(
          () => CreateCategoryUseCase(Get.find<CategoryRepository>()),
        );
      }

      if (!Get.isRegistered<UpdateCategoryUseCase>()) {
        Get.lazyPut<UpdateCategoryUseCase>(
          () => UpdateCategoryUseCase(Get.find<CategoryRepository>()),
        );
      }

      if (!Get.isRegistered<DeleteCategoryUseCase>()) {
        Get.lazyPut<DeleteCategoryUseCase>(
          () => DeleteCategoryUseCase(Get.find<CategoryRepository>()),
        );
      }

      // ==================== CONTROLLERS ====================
      Get.lazyPut<ListsController>(
        () => ListsController(
          Get.find<GetListsUseCase>(),
          Get.find<CreateListUseCase>(),
          Get.find<DeleteListUseCase>(),
          Get.find<AddProductUseCase>(),
          Get.find<GetCategoriesUseCase>(),
          Get.find<CreateCategoryUseCase>(),
          Get.find<UpdateCategoryUseCase>(),
          Get.find<DeleteCategoryUseCase>(),
        ),
      );
    }
  }
}
