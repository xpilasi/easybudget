import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'app/config/app_constants.dart';
import 'bindings/initial_binding.dart';
import 'presentation/controllers/theme_controller.dart';

void main() async {
  // Asegurar que los bindings de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar GetStorage
  await GetStorage.init();

  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('🔥 Firebase inicializado');

  // Inicializar bindings globales ANTES de runApp
  InitialBinding().dependencies();

  // Ejecutar la aplicación
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return GetMaterialApp(
          // ==================== APP INFO ====================
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,

          // ==================== THEME ====================
          theme: LightTheme.theme,
          darkTheme: DarkTheme.theme,
          themeMode: controller.themeMode,

          // ==================== ROUTING ====================
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          unknownRoute: GetPage(
            name: '/not-found',
            page: () => const Scaffold(
              body: Center(
                child: Text('Página no encontrada'),
              ),
            ),
          ),

          // ==================== LOCALE ====================
          locale: const Locale('es', 'ES'),
          fallbackLocale: const Locale('es', 'ES'),

          // ==================== DEFAULT TRANSITION ====================
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
