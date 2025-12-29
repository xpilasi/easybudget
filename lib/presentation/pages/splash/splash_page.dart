import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';

/// Splash Screen - Primera pantalla de la aplicación
/// Verifica el estado de autenticación y redirige
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  /// Verificar autenticación y navegar
  Future<void> _checkAuthAndNavigate() async {
    // Esperar mínimo 2 segundos para mostrar splash
    await Future.delayed(const Duration(seconds: 2));

    final authController = Get.find<AuthController>();

    // Navegar según estado de autenticación
    if (authController.isLoggedIn) {
      Get.offAllNamed('/main');
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono principal
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shopping_cart_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // Título
              Text(
                'ListShare',
                style: AppTextStyles.h1(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: AppSpacing.xs),

              // Subtítulo
              Text(
                'Organiza y comparte tus listas fácilmente',
                style: AppTextStyles.bodyMedium(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSpacing.xxl),

              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
