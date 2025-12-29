import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Extension para obtener colores dinámicos según el tema actual
/// Usa esto en lugar de AppColors estáticos para soporte de dark mode
extension ThemeExtension on BuildContext {
  /// Obtiene el brightness del tema actual
  Brightness get brightness => Theme.of(this).brightness;

  /// Verifica si está en dark mode
  bool get isDarkMode => brightness == Brightness.dark;

  /// Colores dinámicos según el tema
  Color get background => isDarkMode
      ? AppColors.darkBackground
      : AppColors.lightBackground;

  Color get surface => isDarkMode
      ? AppColors.darkSurface
      : AppColors.lightSurface;

  Color get surfaceVariant => isDarkMode
      ? AppColors.darkSurfaceVariant
      : AppColors.lightSurfaceVariant;

  Color get textPrimary => isDarkMode
      ? AppColors.darkTextPrimary
      : AppColors.lightTextPrimary;

  Color get textSecondary => isDarkMode
      ? AppColors.darkTextSecondary
      : AppColors.lightTextSecondary;

  Color get textTertiary => isDarkMode
      ? AppColors.darkTextTertiary
      : AppColors.lightTextTertiary;

  Color get divider => isDarkMode
      ? AppColors.darkDivider
      : AppColors.lightDivider;

  Color get border => isDarkMode
      ? AppColors.darkBorder
      : AppColors.lightBorder;

  /// Colores que no cambian con el tema
  Color get primary => AppColors.primary;
  Color get primaryLight => AppColors.primaryLight;
  Color get primaryDark => AppColors.primaryDark;
  Color get primaryContainer => AppColors.primaryContainer;

  Color get secondary => AppColors.secondary;
  Color get secondaryLight => AppColors.secondaryLight;
  Color get secondaryDark => AppColors.secondaryDark;

  Color get error => AppColors.error;
  Color get errorLight => AppColors.errorLight;
  Color get errorDark => AppColors.errorDark;

  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get info => AppColors.info;

  /// Shadows dinámicos
  Color get shadow => isDarkMode
      ? Colors.black.withValues(alpha: 0.3)
      : Colors.black.withValues(alpha: 0.1);

  Color get shadowMedium => isDarkMode
      ? Colors.black.withValues(alpha: 0.4)
      : Colors.black.withValues(alpha: 0.15);

  Color get shadowHeavy => isDarkMode
      ? Colors.black.withValues(alpha: 0.5)
      : Colors.black.withValues(alpha: 0.25);

  /// Acceso rápido al ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Acceso rápido al TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;
}
