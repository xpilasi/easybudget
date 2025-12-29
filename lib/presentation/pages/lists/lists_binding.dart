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

/// Binding para Lists Screen
/// Inyecta ListsController y todas las dependencias para listas y categorías
class ListsBinding extends Bindings {
  @override
  void dependencies() {
    // ==================== REPOSITORIES ====================
    Get.lazyPut<ShoppingListRepository>(
      () => ShoppingListRepositoryImpl(Get.find<LocalStorageProvider>()),
    );

    Get.lazyPut<CategoryRepository>(
      () => CategoryRepositoryImpl(Get.find<LocalStorageProvider>()),
    );

    // ==================== USE CASES - SHOPPING LISTS ====================
    Get.lazyPut<GetListsUseCase>(
      () => GetListsUseCase(Get.find<ShoppingListRepository>()),
    );

    Get.lazyPut<CreateListUseCase>(
      () => CreateListUseCase(Get.find<ShoppingListRepository>()),
    );

    Get.lazyPut<DeleteListUseCase>(
      () => DeleteListUseCase(Get.find<ShoppingListRepository>()),
    );

    Get.lazyPut<AddProductUseCase>(
      () => AddProductUseCase(Get.find<ShoppingListRepository>()),
    );

    // ==================== USE CASES - CATEGORIES ====================
    Get.lazyPut<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(Get.find<CategoryRepository>()),
    );

    Get.lazyPut<CreateCategoryUseCase>(
      () => CreateCategoryUseCase(Get.find<CategoryRepository>()),
    );

    Get.lazyPut<UpdateCategoryUseCase>(
      () => UpdateCategoryUseCase(Get.find<CategoryRepository>()),
    );

    Get.lazyPut<DeleteCategoryUseCase>(
      () => DeleteCategoryUseCase(Get.find<CategoryRepository>()),
    );

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
