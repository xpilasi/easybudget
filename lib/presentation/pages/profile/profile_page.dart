import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/config/app_constants.dart';
import '../../controllers/profile_controller.dart';
import '../../controllers/theme_controller.dart';

/// Profile Screen - Pantalla de perfil y configuraciones
class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: _buildAppBar(context),
      body: Obx(() {
        if (controller.isLoading) {
          return _buildLoading(context);
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          color: context.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Header de usuario
                _buildUserHeader(context),

                SizedBox(height: AppSpacing.lg),

                // Secciones de configuración
                _buildSettingsSections(context),

                SizedBox(height: AppSpacing.lg),

                // Botón de cerrar sesión
                _buildLogoutButton(context),

                SizedBox(height: AppSpacing.xl),

                // App info
                _buildAppInfo(context),

                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        );
      }),
    );
  }

  /// AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Perfil',
        style: AppTextStyles.h3(
          color: context.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: context.surface,
      elevation: 0,
    );
  }

  /// Loading indicator
  Widget _buildLoading(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.primary,
      ),
    );
  }

  /// Header de usuario
  Widget _buildUserHeader(BuildContext context) {
    return Obx(() {
      final user = controller.currentUser;
      final hasPhoto = user?.photoUrl.isNotEmpty == true && File(user!.photoUrl).existsSync();

      return GestureDetector(
        onTap: controller.pickAndUpdateProfilePhoto,
        child: Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: context.surface,
            image: hasPhoto
                ? DecorationImage(
                    image: FileImage(File(user.photoUrl)),
                    fit: BoxFit.cover,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: context.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Gradiente de transparente a negro (top to bottom)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),

              // Contenido (nombre y email)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Nombre
                      Text(
                        user?.fullName ?? 'Usuario',
                        style: AppTextStyles.h3(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      // Email
                      Text(
                        user?.email ?? '',
                        style: AppTextStyles.bodyMedium(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Botón de cámara
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Secciones de configuración
  Widget _buildSettingsSections(BuildContext context) {
    return Column(
      children: [
        // Apariencia
        _buildSection(
          context: context,
          title: 'Apariencia',
          items: [
            _buildThemeToggle(context),
          ],
        ),

        SizedBox(height: AppSpacing.lg),

        // General
        _buildSection(
          context: context,
          title: 'General',
          items: [
            _buildSettingsTile(
              context: context,
              icon: Icons.category_outlined,
              title: 'Categorías',
              subtitle: 'Gestionar categorías',
              onTap: controller.navigateToCategories,
            ),
            _buildSettingsTile(
              context: context,
              icon: Icons.notifications_outlined,
              title: 'Notificaciones',
              subtitle: 'Configurar notificaciones',
              onTap: controller.navigateToNotifications,
            ),
          ],
        ),

        SizedBox(height: AppSpacing.lg),

        // Soporte
        _buildSection(
          context: context,
          title: 'Soporte',
          items: [
            _buildSettingsTile(
              context: context,
              icon: Icons.help_outline,
              title: 'Ayuda',
              subtitle: 'Centro de ayuda',
              onTap: controller.navigateToHelp,
            ),
            _buildSettingsTile(
              context: context,
              icon: Icons.info_outline,
              title: 'Acerca de',
              subtitle: 'Información de la app',
              onTap: controller.navigateToAbout,
            ),
          ],
        ),
      ],
    );
  }

  /// Sección de configuración
  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
        boxShadow: [
          BoxShadow(
            color: context.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text(
              title,
              style: AppTextStyles.bodySmall(
                color: context.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  /// Toggle de tema
  Widget _buildThemeToggle(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode;

      return ListTile(
        leading: Icon(
          isDark ? Icons.dark_mode : Icons.light_mode,
          color: context.primary,
        ),
        title: Text(
          'Tema oscuro',
          style: AppTextStyles.bodyLarge(
            color: context.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Switch(
          value: isDark,
          onChanged: (value) => themeController.setTheme(value),
          activeTrackColor: context.primary,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
      );
    });
  }

  /// Tile de configuración
  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: context.primary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge(
          color: context.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall(
          color: context.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: context.textSecondary,
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
    );
  }

  /// Botón de cerrar sesión
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: SizedBox(
        width: double.infinity,
        height: AppSpacing.buttonHeight,
        child: OutlinedButton.icon(
          onPressed: controller.logout,
          icon: Icon(
            Icons.logout,
            color: context.error,
          ),
          label: Text(
            'Cerrar Sesión',
            style: AppTextStyles.button(
              color: context.error,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: context.error, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
            ),
          ),
        ),
      ),
    );
  }

  /// Información de la app
  Widget _buildAppInfo(BuildContext context) {
    return Column(
      children: [
        // Logo
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: context.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
          ),
          child: Icon(
            Icons.shopping_cart_rounded,
            size: 32,
            color: context.primary,
          ),
        ),

        SizedBox(height: AppSpacing.md),

        // Nombre de la app
        Text(
          AppConstants.appName,
          style: AppTextStyles.bodyLarge(
            color: context.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: AppSpacing.xs),

        // Versión
        Text(
          'Versión ${AppConstants.appVersion}',
          style: AppTextStyles.bodySmall(
            color: context.textSecondary,
          ),
        ),

        SizedBox(height: AppSpacing.md),

        // Copyright
        Text(
          '© 2025 ${AppConstants.appName}',
          style: AppTextStyles.bodySmall(
            color: context.textSecondary,
          ),
        ),
      ],
    );
  }
}
