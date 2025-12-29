import 'package:get/get.dart';
import '../../app/services/deep_link_service.dart';
import '../pages/home/home_binding.dart';
import '../pages/lists/lists_binding.dart';
import '../pages/profile/profile_binding.dart';
import '../pages/history/history_binding.dart';
import '../widgets/modals/import_list_modal.dart';
import 'home_controller.dart';
import 'lists_controller.dart';
import 'history_controller.dart';

/// Controller del Main Screen usando GetX
/// Gestiona la navegación del Bottom Navigation Bar
class MainController extends GetxController {
  // ==================== STATE ====================

  final RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    // Inicializar binding del primer tab
    initializeBinding(0);

    // Configurar listener de deep links
    _setupDeepLinkListener();
  }

  // ==================== METHODS ====================

  /// Cambiar tab actual
  void changeTab(int index) {
    if (_currentIndex.value != index) {
      initializeBinding(index);
      _currentIndex.value = index;

      // Refrescar datos cuando se navega al Home
      if (index == 0 && Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().loadData();
      }

      // Refrescar datos cuando se navega a Lists
      if (index == 1 && Get.isRegistered<ListsController>()) {
        Get.find<ListsController>().refresh();
      }

      // Refrescar datos cuando se navega a History
      if (index == 2 && Get.isRegistered<HistoryController>()) {
        Get.find<HistoryController>().refresh();
      }
    }
  }

  /// Inicializar binding del tab
  void initializeBinding(int index) {
    switch (index) {
      case 0:
        if (!Get.isRegistered<HomeBinding>()) {
          HomeBinding().dependencies();
        }
        break;
      case 1:
        if (!Get.isRegistered<ListsBinding>()) {
          ListsBinding().dependencies();
        }
        break;
      case 2:
        if (!Get.isRegistered<HistoryBinding>()) {
          HistoryBinding().dependencies();
        }
        break;
      case 3:
        if (!Get.isRegistered<ProfileBinding>()) {
          ProfileBinding().dependencies();
        }
        break;
    }
  }

  /// Configurar listener para deep links entrantes
  void _setupDeepLinkListener() {
    final deepLinkService = Get.find<DeepLinkService>();

    deepLinkService.setOnListReceivedCallback((sharedListData) {
      // Cambiar a tab de listas si no estamos ahí
      if (_currentIndex.value != 1) {
        changeTab(1);
      }

      // Esperar a que el tab esté listo
      Future.delayed(const Duration(milliseconds: 300), () {
        // Obtener el ListsController
        final listsController = Get.find<ListsController>();

        // Mostrar modal de importación
        ImportListModal.show(
          sharedList: sharedListData,
          categories: listsController.categories,
          onImport: ({
            required String name,
            required String categoryId,
            required SharedListData sharedData,
          }) {
            listsController.importSharedList(
              name: name,
              categoryId: categoryId,
              sharedData: sharedData,
            );
          },
        );
      });
    });
  }
}
