import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/providers/local_storage_provider.dart';

/// Controller del tema (dark/light mode) usando GetX
/// Gestiona el cambio entre tema claro y oscuro
class ThemeController extends GetxController {
  final LocalStorageProvider _storageProvider;

  ThemeController(this._storageProvider);

  // ==================== STATE ====================

  final RxBool _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  // ==================== METHODS ====================

  /// Cargar preferencia de tema guardada
  void _loadThemeMode() {
    final savedTheme = _storageProvider.getThemeMode();
    if (savedTheme != null) {
      _isDarkMode.value = savedTheme;
      // Aplicar tema guardado
      Get.changeThemeMode(themeMode);
    }
  }

  /// Alternar entre tema claro y oscuro
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(themeMode);
    update(); // Notificar a GetBuilder en MyApp
    _storageProvider.saveThemeMode(_isDarkMode.value);
  }

  /// Establecer tema específico
  void setTheme(bool isDark) {
    if (_isDarkMode.value != isDark) {
      _isDarkMode.value = isDark;
      Get.changeThemeMode(themeMode);
      update(); // Notificar a GetBuilder en MyApp
      _storageProvider.saveThemeMode(isDark);
    }
  }
}
