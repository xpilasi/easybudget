import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/user.dart';
import 'auth_controller.dart';
import 'theme_controller.dart';
import 'lists_controller.dart';
import '../widgets/modals/manage_categories_modal.dart';

/// Controller del Profile Screen usando GetX
/// Gestiona información de perfil y configuraciones del usuario
class ProfileController extends GetxController {
  final AuthController _authController;
  final ThemeController _themeController;

  ProfileController(
    this._authController,
    this._themeController,
  );

  // ==================== STATE ====================

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // ==================== COMPUTED ====================

  /// Usuario actual (delegado a AuthController)
  User? get currentUser => _authController.currentUser;

  /// Estado de tema oscuro (delegado a ThemeController)
  bool get isDarkMode => _themeController.isDarkMode;

  /// Verificar si hay usuario logueado
  bool get isLoggedIn => _authController.isLoggedIn;

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    _checkUserStatus();
  }

  // ==================== METHODS - USER ====================

  /// Verificar estado del usuario
  void _checkUserStatus() {
    if (!isLoggedIn) {
      Get.offAllNamed('/login');
    }
  }

  /// Refrescar datos del usuario
  @override
  Future<void> refresh() async {
    // El usuario se carga desde AuthController
    // Esta función está preparada para futuras actualizaciones
    _isLoading.value = true;
    try {
      // Aquí podríamos recargar datos del usuario desde el servidor
      await Future.delayed(const Duration(milliseconds: 500));
    } finally {
      _isLoading.value = false;
    }
  }

  // ==================== METHODS - THEME ====================

  /// Alternar tema (delegado a ThemeController)
  void toggleTheme() {
    _themeController.toggleTheme();
  }

  /// Establecer tema específico (delegado a ThemeController)
  void setTheme(bool isDark) {
    _themeController.setTheme(isDark);
  }

  // ==================== METHODS - AUTH ====================

  /// Cerrar sesión (delegado a AuthController)
  Future<void> logout() async {
    // Confirmación
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authController.logout();
    }
  }

  // ==================== HELPERS ====================

  /// Navegar a gestión de categorías
  void navigateToCategories() {
    try {
      // Intentar obtener el ListsController si ya existe
      final listsController = Get.find<ListsController>();

      ManageCategoriesModal.show(
        categories: listsController.categories,
        onCreateCategory: ({required name, required color}) {
          listsController.createCategory(name: name, color: color);
        },
        onUpdateCategory: ({required categoryId, required name, required color}) {
          listsController.updateCategory(id: categoryId, name: name, color: color);
        },
        onDeleteCategory: (categoryId) {
          listsController.deleteCategory(categoryId);
        },
      );
    } catch (e) {
      // Si ListsController no está registrado, navegar a la página de categorías
      Get.toNamed('/categories');
    }
  }

  /// Navegar a notificaciones
  void navigateToNotifications() {
    Get.toNamed('/notifications');
  }

  /// Navegar a ayuda
  void navigateToHelp() {
    Get.toNamed('/help');
  }

  /// Navegar a acerca de
  void navigateToAbout() {
    Get.toNamed('/about');
  }

  // ==================== PROFILE PHOTO ====================

  /// Seleccionar y actualizar foto de perfil
  Future<void> pickAndUpdateProfilePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();

      // Mostrar opciones de fuente de imagen
      final source = await _showImageSourceDialog();
      if (source == null) return;

      // Seleccionar imagen
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      // Actualizar foto de perfil
      _isLoading.value = true;
      await _authController.updateProfilePhoto(image.path);

      Get.snackbar(
        'Foto actualizada',
        'Tu foto de perfil se ha actualizado correctamente',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar la foto de perfil: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Mostrar diálogo para seleccionar fuente de imagen
  Future<ImageSource?> _showImageSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        title: const Text('Seleccionar foto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }
}
