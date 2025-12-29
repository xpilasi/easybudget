import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';

/// Notifications Screen - Pantalla de configuración de notificaciones
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _enableNotifications = true;
  bool _priceAlerts = true;
  bool _sharedListUpdates = false;
  bool _weeklyReminders = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        title: Text(
          'Notificaciones',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Descripción
            Container(
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                border: Border.all(
                  color: context.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: context.primary,
                    size: 24,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Configura cómo quieres recibir notificaciones',
                      style: AppTextStyles.bodySmall(
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Notificaciones principales
            _buildSection(
              context: context,
              title: 'General',
              items: [
                _buildSwitchTile(
                  context: context,
                  icon: Icons.notifications_active,
                  title: 'Habilitar notificaciones',
                  subtitle: 'Recibir todas las notificaciones',
                  value: _enableNotifications,
                  onChanged: (value) {
                    setState(() => _enableNotifications = value);
                  },
                ),
              ],
            ),

            SizedBox(height: AppSpacing.lg),

            // Notificaciones específicas
            _buildSection(
              context: context,
              title: 'Tipos de notificaciones',
              items: [
                _buildSwitchTile(
                  context: context,
                  icon: Icons.monetization_on,
                  title: 'Alertas de precios',
                  subtitle: 'Notificar cuando un producto cambia de precio',
                  value: _priceAlerts,
                  enabled: _enableNotifications,
                  onChanged: (value) {
                    setState(() => _priceAlerts = value);
                  },
                ),
                _buildSwitchTile(
                  context: context,
                  icon: Icons.share,
                  title: 'Listas compartidas',
                  subtitle: 'Actualizaciones de listas compartidas',
                  value: _sharedListUpdates,
                  enabled: _enableNotifications,
                  onChanged: (value) {
                    setState(() => _sharedListUpdates = value);
                  },
                ),
                _buildSwitchTile(
                  context: context,
                  icon: Icons.calendar_today,
                  title: 'Recordatorios semanales',
                  subtitle: 'Recordatorio semanal de listas pendientes',
                  value: _weeklyReminders,
                  enabled: _enableNotifications,
                  onChanged: (value) {
                    setState(() => _weeklyReminders = value);
                  },
                ),
              ],
            ),

            SizedBox(height: AppSpacing.xxl),

            // Nota informativa
            Center(
              child: Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.construction,
                      size: 48,
                      color: context.textSecondary.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Función en desarrollo',
                      style: AppTextStyles.bodyMedium(
                        color: context.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Las notificaciones estarán disponibles pronto',
                      style: AppTextStyles.bodySmall(
                        color: context.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> items,
  }) {
    return Container(
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

  Widget _buildSwitchTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
  }) {
    return ListTile(
      enabled: enabled,
      leading: Icon(
        icon,
        color: enabled ? context.primary : context.textSecondary.withValues(alpha: 0.5),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge(
          color: enabled ? context.textPrimary : context.textSecondary.withValues(alpha: 0.5),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall(
          color: enabled ? context.textSecondary : context.textSecondary.withValues(alpha: 0.5),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeTrackColor: context.primary,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
    );
  }
}
