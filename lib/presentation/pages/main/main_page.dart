import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../controllers/main_controller.dart';
import '../home/home_page.dart';
import '../lists/lists_page.dart';
import '../profile/profile_page.dart';

/// Main Screen - Pantalla principal con Bottom Navigation
/// Contiene los 3 tabs principales: Home, Lists, Profile
class MainPage extends GetView<MainController> {
  const MainPage({super.key});

  // Método para obtener la página actual
  Widget _getCurrentPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return ListsPage();
      case 2:
        return ProfilePage();
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _getCurrentPage(controller.currentIndex)),
      bottomNavigationBar: Obx(() {
        // Acceder directamente a currentIndex dentro del Obx
        final currentIndex = controller.currentIndex;

        return NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: controller.changeTab,
          backgroundColor: context.surface,
          elevation: 8,
          shadowColor: context.shadow,
          indicatorColor: Colors.transparent,
          height: 64,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home_outlined,
                color: currentIndex == 0
                    ? context.primary
                    : context.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.home,
                color: context.primary,
              ),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.list_outlined,
                color: currentIndex == 1
                    ? context.primary
                    : context.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.list,
                color: context.primary,
              ),
              label: 'Listas',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.person_outline,
                color: currentIndex == 2
                    ? context.primary
                    : context.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.person,
                color: context.primary,
              ),
              label: 'Perfil',
            ),
          ],
        );
      }),
    );
  }
}
