import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

/// LoadingIndicator - Indicador de carga reutilizable
class LoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final String? message;

  const LoadingIndicator({
    super.key,
    this.size,
    this.color,
    this.message,
  });

  /// Loading indicator pequeño
  const LoadingIndicator.small({
    super.key,
    this.color,
    this.message,
  }) : size = 20;

  /// Loading indicator mediano (por defecto)
  const LoadingIndicator.medium({
    super.key,
    this.color,
    this.message,
  }) : size = 40;

  /// Loading indicator grande
  const LoadingIndicator.large({
    super.key,
    this.color,
    this.message,
  }) : size = 60;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size ?? 40,
            height: size ?? 40,
            child: CircularProgressIndicator(
              strokeWidth: (size ?? 40) / 10,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppColors.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// LoadingOverlay - Overlay de carga para uso en pantallas completas
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: AppColors.overlay,
            child: LoadingIndicator(message: message),
          ),
      ],
    );
  }
}
