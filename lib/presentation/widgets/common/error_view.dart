import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import 'buttons/create_button.dart';

/// ErrorView - Vista de error reutilizable con retry logic
class ErrorView extends StatelessWidget {
  final String title;
  final String? message;
  final String? retryText;
  final VoidCallback? onRetry;
  final bool isRetrying;
  final IconData icon;

  const ErrorView({
    super.key,
    required this.title,
    this.message,
    this.retryText,
    this.onRetry,
    this.isRetrying = false,
    this.icon = Icons.error_outline,
  });

  /// Error view por defecto
  factory ErrorView.standard({
    String? message,
    VoidCallback? onRetry,
    bool isRetrying = false,
  }) {
    return ErrorView(
      title: 'Algo salió mal',
      message: message ?? 'Ocurrió un error inesperado. Por favor intenta nuevamente.',
      retryText: 'Reintentar',
      onRetry: onRetry,
      isRetrying: isRetrying,
      icon: Icons.error_outline,
    );
  }

  /// Error de red
  factory ErrorView.network({
    VoidCallback? onRetry,
    bool isRetrying = false,
  }) {
    return ErrorView(
      title: 'Sin conexión',
      message: 'No se pudo conectar al servidor. Verifica tu conexión a internet.',
      retryText: 'Reintentar',
      onRetry: onRetry,
      isRetrying: isRetrying,
      icon: Icons.wifi_off,
    );
  }

  /// Error de carga
  factory ErrorView.loadFailed({
    String? message,
    VoidCallback? onRetry,
    bool isRetrying = false,
  }) {
    return ErrorView(
      title: 'Error al cargar',
      message: message ?? 'No se pudieron cargar los datos. Intenta nuevamente.',
      retryText: 'Recargar',
      onRetry: onRetry,
      isRetrying: isRetrying,
      icon: Icons.refresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono de error
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.error,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Título
            Text(
              title,
              style: AppTextStyles.h3(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message!,
                style: AppTextStyles.bodyMedium(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            if (retryText != null && onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              CreateButton(
                buttonText: isRetrying ? 'Reintentando...' : retryText!,
                onPressed: isRetrying ? null : onRetry,
                isLoading: isRetrying,
                icon: isRetrying ? null : Icons.refresh,
                iconSize: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
