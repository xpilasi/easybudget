import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'app_decorations.dart';

class DarkTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        // ==================== COLOR SCHEME ====================
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryDark,
          secondary: AppColors.secondary,
          error: AppColors.error,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkTextPrimary,
          surfaceContainerHighest: AppColors.darkSurfaceVariant,
        ),

        // ==================== SCAFFOLD ====================
        scaffoldBackgroundColor: AppColors.darkBackground,

        // ==================== APP BAR ====================
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkTextPrimary,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: AppTextStyles.h3(color: AppColors.darkTextPrimary),
          iconTheme: const IconThemeData(
            color: AppColors.darkTextPrimary,
            size: AppSpacing.iconMD,
          ),
        ),

        // ==================== CARD ====================
        cardTheme: CardThemeData(
          elevation: AppSpacing.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: AppDecorations.radiusXL,
          ),
          color: AppColors.darkSurface,
          shadowColor: Colors.black.withValues(alpha: 0.3),
        ),

        // ==================== INPUT ====================
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurfaceVariant,
          border: OutlineInputBorder(
            borderRadius: AppDecorations.radiusMD,
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppDecorations.radiusMD,
            borderSide: const BorderSide(color: AppColors.darkBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppDecorations.radiusMD,
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingMD,
            vertical: AppSpacing.paddingMD,
          ),
        ),

        // ==================== BUTTONS ====================
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: AppDecorations.radiusXL,
            ),
            elevation: 0,
            textStyle: AppTextStyles.button(),
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.button(),
          ),
        ),

        // ==================== BOTTOM NAV ====================
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.darkTextSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // ==================== DIVIDER ====================
        dividerTheme: const DividerThemeData(
          color: AppColors.darkDivider,
          thickness: 1,
          space: 1,
        ),

        // ==================== TYPOGRAPHY ====================
        textTheme: TextTheme(
          displayLarge: AppTextStyles.h1(color: AppColors.darkTextPrimary),
          displayMedium: AppTextStyles.h2(color: AppColors.darkTextPrimary),
          displaySmall: AppTextStyles.h3(color: AppColors.darkTextPrimary),
          headlineMedium: AppTextStyles.h4(color: AppColors.darkTextPrimary),
          bodyLarge: AppTextStyles.bodyLarge(color: AppColors.darkTextPrimary),
          bodyMedium: AppTextStyles.bodyMedium(color: AppColors.darkTextPrimary),
          bodySmall: AppTextStyles.bodySmall(color: AppColors.darkTextSecondary),
          labelLarge: AppTextStyles.labelLarge(color: AppColors.darkTextPrimary),
        ),
      );
}
