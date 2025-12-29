import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_theme.dart';
import 'buttons/create_button.dart';
import 'buttons/cancel_button.dart';

/// ConfirmationDialog - Diálogo de confirmación reutilizable
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDangerous;
  final IconData? icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirmar',
    this.cancelText = 'Cancelar',
    this.onConfirm,
    this.onCancel,
    this.isDangerous = false,
    this.icon,
  });

  /// Mostrar diálogo de confirmación
  static Future<bool?> show({
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    bool isDangerous = false,
    IconData? icon,
  }) {
    return Get.dialog<bool>(
      ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDangerous: isDangerous,
        icon: icon,
      ),
    );
  }

  /// Mostrar diálogo de eliminación
  static Future<bool?> showDelete({
    required String itemName,
    String? customMessage,
  }) {
    return show(
      title: 'Eliminar $itemName',
      message: customMessage ?? '¿Estás seguro de que deseas eliminar $itemName?',
      confirmText: 'Eliminar',
      cancelText: 'Cancelar',
      isDangerous: true,
      icon: Icons.delete_outline,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppDecorations.radiusXL,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono
            if (icon != null) ...[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: (isDangerous ? AppColors.error : AppColors.primary)
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: isDangerous ? AppColors.error : AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Título
            Text(
              title,
              style: AppTextStyles.h3(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.md),

            // Mensaje
            Text(
              message,
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xl),

            // Botones
            Row(
              children: [
                Expanded(
                  child: CancelButton(
                    buttonText: cancelText,
                    onPressed: () {
                      Get.back(result: false);
                      onCancel?.call();
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CreateButton(
                    buttonText: confirmText,
                    backgroundColor: isDangerous ? AppColors.error : null,
                    onPressed: () {
                      Get.back(result: true);
                      onConfirm?.call();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
