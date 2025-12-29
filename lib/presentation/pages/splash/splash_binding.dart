import 'package:get/get.dart';

/// Binding para Splash Screen
/// No requiere dependencias adicionales, solo verifica auth con AuthController global
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // El AuthController ya está disponible globalmente desde InitialBinding
    // Esta página solo necesita leerlo para verificar el estado de login
  }
}
