import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Paleta de colores de la aplicación
/// Sigue los principios de Material Design 3
class AppColors {
  AppColors._(); // Constructor privado para evitar instanciación

  // ==================== COLORES PRIMARIOS ====================

  /// Color primario de la app (Verde)
  static const Color primary = Color(0xFF10B981);
  static const Color primaryLight = Color(0xFF34D399);
  static const Color primaryDark = Color(0xFF059669);
  static const Color primaryContainer = Color(0xFFD1FAE5);

  // ==================== COLORES SECUNDARIOS ====================

  static const Color secondary = Color(0xFF3B82F6);
  static const Color secondaryLight = Color(0xFF60A5FA);
  static const Color secondaryDark = Color(0xFF2563EB);

  // ==================== COLORES DE ESTADO ====================

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFDC2626);
  static const Color errorDark = Color(0xFFB91C1C);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // ==================== COLORES DE CATEGORÍAS ====================

  /// Colores predefinidos para categorías
  static const List<Color> categoryColors = [
    Color(0xFF10B981), // green
    Color(0xFFEF4444), // red
    Color(0xFFF59E0B), // amber
    Color(0xFF3B82F6), // blue
    Color(0xFF8B5CF6), // purple
    Color(0xFFEC4899), // pink
    Color(0xFF14B8A6), // teal
    Color(0xFFF97316), // orange
  ];

  // ==================== TEMA CLARO ====================

  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF3F4F6);

  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);

  static const Color lightDivider = Color(0xFFE5E7EB);
  static const Color lightBorder = Color(0xFFD1D5DB);

  // ==================== TEMA OSCURO ====================

  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkSurfaceVariant = Color(0xFF374151);

  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextTertiary = Color(0xFF6B7280);

  static const Color darkDivider = Color(0xFF374151);
  static const Color darkBorder = Color(0xFF4B5563);

  // ==================== COLORES ESPECIALES ====================

  /// Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  static const LinearGradient lightBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFECFDF5), Color(0xFFDBEAFE)],
  );

  /// Overlays
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color overlayLight = Color(0x40000000); // 25% black

  /// Shadows dinámicos
  static Color get shadow {
    final context = Get.context;
    if (context == null) return Colors.black.withValues(alpha: 0.1);
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.1);
  }

  static Color get shadowMedium {
    final context = Get.context;
    if (context == null) return Colors.black.withValues(alpha: 0.15);
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.4)
        : Colors.black.withValues(alpha: 0.15);
  }

  static Color get shadowHeavy {
    final context = Get.context;
    if (context == null) return Colors.black.withValues(alpha: 0.25);
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.black.withValues(alpha: 0.5)
        : Colors.black.withValues(alpha: 0.25);
  }

  // ==================== ALIASES DINÁMICOS ====================
  // Getters dinámicos que cambian según el tema actual

  static Color get background {
    final context = Get.context;
    if (context == null) return lightBackground;
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightBackground;
  }

  static Color get surface {
    final context = Get.context;
    if (context == null) return lightSurface;
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : lightSurface;
  }

  static Color get surfaceVariant {
    final context = Get.context;
    if (context == null) return lightSurfaceVariant;
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurfaceVariant
        : lightSurfaceVariant;
  }

  static Color get textPrimary {
    final context = Get.context;
    if (context == null) return lightTextPrimary;
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : lightTextPrimary;
  }

  static Color get textSecondary {
    final context = Get.context;
    if (context == null) return lightTextSecondary;
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : lightTextSecondary;
  }

  static Color get textTertiary {
    final context = Get.context;
    if (context == null) return lightTextTertiary;
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextTertiary
        : lightTextTertiary;
  }

  static Color get divider {
    final context = Get.context;
    if (context == null) return lightDivider;
    return Theme.of(context).brightness == Brightness.dark
        ? darkDivider
        : lightDivider;
  }

  static Color get border {
    final context = Get.context;
    if (context == null) return lightBorder;
    return Theme.of(context).brightness == Brightness.dark
        ? darkBorder
        : lightBorder;
  }
}
