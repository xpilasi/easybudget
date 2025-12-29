import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/config/app_constants.dart';

/// About Screen - Pantalla de información de la aplicación
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(
          'Acerca de',
          style: AppTextStyles.h3(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: context.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: context.textPrimary,
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            SizedBox(height: AppSpacing.xl),

            // Logo de la app
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.primary,
                    context.primary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: context.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_cart_rounded,
                size: 64,
                color: Colors.white,
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Nombre de la app
            Text(
              AppConstants.appName,
              style: AppTextStyles.h2(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: AppSpacing.xs),

            // Versión
            Text(
              'Versión ${AppConstants.appVersion}',
              style: AppTextStyles.bodyMedium(
                color: context.textSecondary,
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Descripción
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                boxShadow: [
                  BoxShadow(
                    color: context.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Una manera simple y efectiva de organizar tus listas de compras.',
                    style: AppTextStyles.bodyMedium(
                      color: context.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Crea, comparte y gestiona tus listas de forma intuitiva. Mantén el control de tus gastos y nunca olvides lo que necesitas comprar.',
                    style: AppTextStyles.bodySmall(
                      color: context.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Características
            _buildFeatureCard(
              context: context,
              icon: Icons.checklist,
              title: 'Listas inteligentes',
              description: 'Organiza tus compras por categorías',
            ),

            SizedBox(height: AppSpacing.md),

            _buildFeatureCard(
              context: context,
              icon: Icons.share,
              title: 'Comparte fácilmente',
              description: 'Comparte listas con amigos y familia',
            ),

            SizedBox(height: AppSpacing.md),

            _buildFeatureCard(
              context: context,
              icon: Icons.calculate,
              title: 'Calcula totales',
              description: 'Control total de tus gastos',
            ),

            SizedBox(height: AppSpacing.xxl),

            // Información legal y contacto
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
              ),
              child: Column(
                children: [
                  _buildInfoTile(
                    context: context,
                    icon: Icons.code,
                    title: 'Desarrollado con',
                    value: 'Flutter & Dart',
                  ),
                  Divider(height: AppSpacing.lg),
                  _buildInfoTile(
                    context: context,
                    icon: Icons.calendar_today,
                    title: 'Año',
                    value: '2025',
                  ),
                  Divider(height: AppSpacing.lg),
                  _buildInfoTile(
                    context: context,
                    icon: Icons.copyright,
                    title: 'Copyright',
                    value: '© 2025 ${AppConstants.appName}',
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Enlaces
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLinkButton(
                  context: context,
                  icon: Icons.privacy_tip,
                  label: 'Privacidad',
                  onTap: () {
                    Get.snackbar(
                      'Privacidad',
                      'Política de privacidad disponible próximamente',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
                SizedBox(width: AppSpacing.md),
                _buildLinkButton(
                  context: context,
                  icon: Icons.description,
                  label: 'Términos',
                  onTap: () {
                    Get.snackbar(
                      'Términos',
                      'Términos de uso disponibles próximamente',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: AppSpacing.xl),

            // Hecho con amor
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hecho con',
                  style: AppTextStyles.bodySmall(
                    color: context.textSecondary,
                  ),
                ),
                SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.favorite,
                  size: 16,
                  color: Colors.red,
                ),
                SizedBox(width: AppSpacing.xs),
                Text(
                  'por el equipo de ${AppConstants.appName}',
                  style: AppTextStyles.bodySmall(
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),

            SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
        border: Border.all(
          color: context.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
            child: Icon(
              icon,
              color: context.primary,
              size: 24,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTextStyles.bodySmall(
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: context.textSecondary,
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodySmall(
              color: context.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall(
            color: context.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLinkButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: context.textSecondary,
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.bodySmall(
                color: context.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
