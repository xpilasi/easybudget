import 'package:get/get.dart';
import '../../presentation/pages/list_detail/list_detail_binding.dart';
import '../../presentation/pages/list_detail/list_detail_page.dart';
import '../../presentation/pages/login/login_binding.dart';
import '../../presentation/pages/login/login_page.dart';
import '../../presentation/pages/main/main_binding.dart';
import '../../presentation/pages/main/main_page.dart';
import '../../presentation/pages/splash/splash_binding.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/categories/categories_page.dart';
import '../../presentation/pages/categories/categories_binding.dart';
import '../../presentation/pages/notifications/notifications_page.dart';
import '../../presentation/pages/help/help_page.dart';
import '../../presentation/pages/about/about_page.dart';
import 'app_routes.dart';

/// Configuración de páginas y bindings de GetX
class AppPages {
  AppPages._(); // Constructor privado

  // Ruta inicial
  static const String initial = AppRoutes.splash;

  // Lista de páginas
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: AppRoutes.listDetail,
      page: () => const ListDetailPage(),
      binding: ListDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoriesPage(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsPage(),
    ),
    GetPage(
      name: AppRoutes.help,
      page: () => const HelpPage(),
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutPage(),
    ),
  ];
}
