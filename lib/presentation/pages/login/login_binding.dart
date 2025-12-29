import 'package:get/get.dart';

/// Binding para Login Screen
/// Usa AuthController global para manejar la autenticación
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // El AuthController ya está disponible globalmente desde InitialBinding
    // Esta página usa Get.find<AuthController>() para acceder al login
  }
}
