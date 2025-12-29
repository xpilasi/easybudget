import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';

/// Widget que observa cambios de tema y reconstruye su hijo
/// Soluciona el problema de AppColors usando Get.context cacheado
class ThemeObserver extends StatelessWidget {
  final Widget child;

  const ThemeObserver({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      // Observar isDarkMode para forzar rebuild cuando cambia
      final _ = themeController.isDarkMode;

      // Retornar el hijo con key única basada en el tema
      // Esto fuerza la recreación del widget hijo
      return KeyedSubtree(
        key: ValueKey(themeController.isDarkMode),
        child: child,
      );
    });
  }
}
