import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_spacing.dart';
import 'app_decorations.dart';

class LightTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        // ==================== COLOR SCHEME ====================
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryContainer,
          secondary: AppColors.secondary,
          error: AppColors.error,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightTextPrimary,
          surfaceContainerHighest: AppColors.lightSurfaceVariant,
        ),

        // ==================== SCAFFOLD ====================
        scaffoldBackgroundColor: AppColors.lightBackground,

        // ==================== APP BAR ====================
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: AppColors.lightSurface,
          foregroundColor: AppColors.lightTextPrimary,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: AppTextStyles.h3(color: AppColors.lightTextPrimary),
          iconTheme: const IconThemeData(
            color: AppColors.lightTextPrimary,
            size: AppSpacing.iconMD,
          ),
        ),

        // ==================== CARD ====================
        cardTheme: CardThemeData(
          elevation: AppSpacing.cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: AppDecorations.radiusXL,
          ),
          color: AppColors.lightSurface,
          shadowColor: AppColors.shadow,
        ),

        // ==================== INPUT ====================
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightSurfaceVariant,
          border: OutlineInputBorder(
            borderRadius: AppDecorations.radiusMD,
            borderSide: const BorderSide(color: AppColors.lightBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppDecorations.radiusMD,
            borderSide: const BorderSide(color: AppColors.lightBorder),
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
          backgroundColor: AppColors.lightSurface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.lightTextSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),

        // ==================== DIVIDER ====================
        dividerTheme: const DividerThemeData(
          color: AppColors.lightDivider,
          thickness: 1,
          space: 1,
        ),

        // ==================== TYPOGRAPHY ====================
        textTheme: TextTheme(
          displayLarge: AppTextStyles.h1(color: AppColors.lightTextPrimary),
          displayMedium: AppTextStyles.h2(color: AppColors.lightTextPrimary),
          displaySmall: AppTextStyles.h3(color: AppColors.lightTextPrimary),
          headlineMedium: AppTextStyles.h4(color: AppColors.lightTextPrimary),
          bodyLarge: AppTextStyles.bodyLarge(color: AppColors.lightTextPrimary),
          bodyMedium:
              AppTextStyles.bodyMedium(color: AppColors.lightTextPrimary),
          bodySmall:
              AppTextStyles.bodySmall(color: AppColors.lightTextSecondary),
          labelLarge:
              AppTextStyles.labelLarge(color: AppColors.lightTextPrimary),
        ),
      );
}
