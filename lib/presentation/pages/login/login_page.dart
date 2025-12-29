import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';

/// Login Screen - Pantalla de autenticación
/// Permite al usuario iniciar sesión con Notion
class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Espaciador superior
              const Spacer(),

              // Logo y título
              _buildHeader(),

              SizedBox(height: AppSpacing.xxl),

              // Descripción
              _buildDescription(),

              SizedBox(height: AppSpacing.xxxl),

              // Botón de login
              _buildLoginButton(),

              // Espaciador inferior
              const Spacer(),

              // Footer
              _buildFooter(),

              SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  /// Header con logo y título
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.shopping_cart_rounded,
            size: 56,
            color: Colors.white,
          ),
        ),

        SizedBox(height: AppSpacing.lg),

        // Título
        Text(
          'ListShare',
          style: AppTextStyles.h1(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Descripción de la app
  Widget _buildDescription() {
    return Column(
      children: [
        Text(
          '¡Bienvenido!',
          style: AppTextStyles.h3(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Organiza tus listas de compras y compártelas con quien quieras',
          style: AppTextStyles.bodyMedium(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Botón de inicio de sesión
  Widget _buildLoginButton() {
    return Obx(() {
      final isLoading = controller.isLoading;

      return SizedBox(
        width: double.infinity,
        height: AppSpacing.buttonHeight,
        child: ElevatedButton(
          onPressed: isLoading ? null : () => controller.login(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
            elevation: 2,
            shadowColor: AppColors.primary.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.login, size: 24),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      'Iniciar sesión con Notion',
                      style: AppTextStyles.button(color: Colors.white),
                    ),
                  ],
                ),
        ),
      );
    });
  }

  /// Footer con información adicional
  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'Al iniciar sesión aceptas nuestros',
          style: AppTextStyles.bodySmall(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          'Términos y Condiciones',
          style: AppTextStyles.bodySmall(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
