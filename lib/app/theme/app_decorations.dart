import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

/// Decoraciones reutilizables (sombras, bordes, etc.)
class AppDecorations {
  AppDecorations._(); // Constructor privado

  // ==================== BOX SHADOWS ====================

  static List<BoxShadow> get shadowSM => [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get shadowMD => [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowLG => [
        BoxShadow(
          color: AppColors.shadowMedium,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowXL => [
        BoxShadow(
          color: AppColors.shadowHeavy,
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  // ==================== BORDER RADIUS ====================

  static BorderRadius get radiusSM =>
      BorderRadius.circular(AppSpacing.radiusSM);
  static BorderRadius get radiusMD =>
      BorderRadius.circular(AppSpacing.radiusMD);
  static BorderRadius get radiusLG =>
      BorderRadius.circular(AppSpacing.radiusLG);
  static BorderRadius get radiusXL =>
      BorderRadius.circular(AppSpacing.radiusXL);
  static BorderRadius get radiusXXL =>
      BorderRadius.circular(AppSpacing.radiusXXL);
  static BorderRadius get radiusFull =>
      BorderRadius.circular(AppSpacing.radiusFull);

  // ==================== BOX DECORATIONS ====================

  /// Card decoration (light theme)
  static BoxDecoration cardLight({Color? color}) => BoxDecoration(
        color: color ?? AppColors.lightSurface,
        borderRadius: radiusXL,
        boxShadow: shadowSM,
      );

  /// Card decoration (dark theme)
  static BoxDecoration cardDark({Color? color}) => BoxDecoration(
        color: color ?? AppColors.darkSurface,
        borderRadius: radiusXL,
        boxShadow: shadowSM,
      );

  /// Input decoration base
  static InputDecoration inputDecoration({
    required bool isDark,
    String? labelText,
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) =>
      InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: radiusMD,
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusMD,
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusMD,
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusMD,
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingMD,
          vertical: AppSpacing.paddingMD,
        ),
      );
}
