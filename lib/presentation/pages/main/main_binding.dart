import 'package:get/get.dart';
import '../../controllers/main_controller.dart';

/// Binding para Main Screen (Bottom Navigation)
/// Inyecta MainController para gestionar la navegación entre tabs
class MainBinding extends Bindings {
  @override
  void dependencies() {
    // ==================== CONTROLLERS ====================
    Get.lazyPut<MainController>(
      () => MainController(),
    );
  }
}
