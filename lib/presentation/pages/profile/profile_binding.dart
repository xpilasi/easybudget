import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/theme_controller.dart';

/// Binding para Profile Screen
/// Inyecta ProfileController que coordina con controllers globales
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // ==================== CONTROLLERS ====================
    // ProfileController usa AuthController y ThemeController que ya están globalmente disponibles
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        Get.find<AuthController>(),
        Get.find<ThemeController>(),
      ),
    );
  }
}
