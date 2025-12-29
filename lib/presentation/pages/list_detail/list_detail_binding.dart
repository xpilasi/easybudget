import 'package:get/get.dart';
import '../../../data/providers/local_storage_provider.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/category_repository_impl.dart';
import '../../../data/repositories/shopping_list_repository.dart';
import '../../../data/repositories/shopping_list_repository_impl.dart';
import '../../../domain/use_cases/category/get_categories_use_case.dart';
import '../../../domain/use_cases/shopping_list/add_product_use_case.dart';
import '../../../domain/use_cases/shopping_list/delete_list_use_case.dart';
import '../../../domain/use_cases/shopping_list/delete_product_use_case.dart';
import '../../../domain/use_cases/shopping_list/get_lists_use_case.dart';
import '../../../domain/use_cases/shopping_list/update_list_use_case.dart';
import '../../../domain/use_cases/shopping_list/update_product_use_case.dart';
import '../../controllers/list_detail_controller.dart';

/// Binding para List Detail Screen
/// Inyecta ListDetailController y todas las dependencias para operaciones de lista y productos
class ListDetailBinding extends Bindings {
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

    Get.lazyPut<UpdateListUseCase>(
      () => UpdateListUseCase(Get.find<ShoppingListRepository>()),
    );

    Get.lazyPut<DeleteListUseCase>(
      () => DeleteListUseCase(Get.find<ShoppingListRepository>()),
    );

    // ==================== USE CASES - PRODUCTS ====================
    Get.lazyPut<AddProductUseCase>(
      () => AddProductUseCase(Get.find<ShoppingListRepository>()),
    );

    Get.lazyPut<UpdateProductUseCase>(
      () => UpdateProductUseCase(Get.find<ShoppingListRepository>()),
    );

    Get.lazyPut<DeleteProductUseCase>(
      () => DeleteProductUseCase(Get.find<ShoppingListRepository>()),
    );

    // ==================== USE CASES - CATEGORIES ====================
    Get.lazyPut<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(Get.find<CategoryRepository>()),
    );

    // ==================== CONTROLLERS ====================
    Get.lazyPut<ListDetailController>(
      () => ListDetailController(
        Get.find<GetListsUseCase>(),
        Get.find<UpdateListUseCase>(),
        Get.find<DeleteListUseCase>(),
        Get.find<AddProductUseCase>(),
        Get.find<UpdateProductUseCase>(),
        Get.find<DeleteProductUseCase>(),
        Get.find<GetCategoriesUseCase>(),
        Get.find<LocalStorageProvider>(),
      ),
    );
  }
}
