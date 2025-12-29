import 'package:get/get.dart';
import '../app/services/deep_link_service.dart';
import '../data/providers/local_storage_provider.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/use_cases/auth/login_use_case.dart';
import '../domain/use_cases/auth/logout_use_case.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/controllers/theme_controller.dart';

/// Binding inicial que se ejecuta al iniciar la app
/// Inyecta dependencias globales que persisten durante toda la sesión
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ==================== PROVIDERS & SERVICES ====================
    // LocalStorageProvider - Singleton permanente
    Get.put<LocalStorageProvider>(
      LocalStorageProvider(),
      permanent: true,
    );

    // DeepLinkService - Singleton permanente
    Get.put<DeepLinkService>(
      DeepLinkService(),
      permanent: true,
    );

    // ==================== REPOSITORIES ====================
    // AuthRepository - Singleton permanente
    Get.put<AuthRepository>(
      AuthRepositoryImpl(Get.find<LocalStorageProvider>()),
      permanent: true,
    );

    // ==================== USE CASES ====================
    // Auth Use Cases - Singleton permanente
    Get.put<LoginUseCase>(
      LoginUseCase(Get.find<AuthRepository>()),
      permanent: true,
    );

    Get.put<LogoutUseCase>(
      LogoutUseCase(Get.find<AuthRepository>()),
      permanent: true,
    );

    // ==================== CONTROLLERS ====================
    // ThemeController - Singleton permanente
    Get.put<ThemeController>(
      ThemeController(Get.find<LocalStorageProvider>()),
      permanent: true,
    );

    // AuthController - Singleton permanente
    Get.put<AuthController>(
      AuthController(
        Get.find<LoginUseCase>(),
        Get.find<LogoutUseCase>(),
        Get.find<AuthRepository>(),
      ),
      permanent: true,
    );
  }
}
