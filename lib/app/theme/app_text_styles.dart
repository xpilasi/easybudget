import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Estilos de texto consistentes en toda la aplicación
class AppTextStyles {
  AppTextStyles._(); // Constructor privado

  // ==================== FONT FAMILY ====================

  static String get _fontFamily => GoogleFonts.inter().fontFamily!;

  // ==================== HEADINGS ====================

  static TextStyle h1({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        fontWeight: fontWeight ?? FontWeight.bold,
        height: 1.2,
        color: color,
        letterSpacing: -0.5,
      );

  static TextStyle h2({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        fontWeight: fontWeight ?? FontWeight.bold,
        height: 1.3,
        color: color,
        letterSpacing: -0.3,
      );

  static TextStyle h3({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: fontWeight ?? FontWeight.w600,
        height: 1.4,
        color: color,
        letterSpacing: -0.2,
      );

  static TextStyle h4({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: fontWeight ?? FontWeight.w600,
        height: 1.4,
        color: color,
        letterSpacing: -0.1,
      );

  // ==================== BODY ====================

  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        height: 1.5,
        color: color,
      );

  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        height: 1.5,
        color: color,
      );

  static TextStyle bodySmall({Color? color, FontWeight? fontWeight}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.normal,
        height: 1.5,
        color: color,
      );

  // ==================== LABELS ====================

  static TextStyle labelLarge({Color? color, FontWeight? fontWeight}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w500,
        height: 1.4,
        color: color,
        letterSpacing: 0.1,
      );

  static TextStyle labelMedium({Color? color, FontWeight? fontWeight}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w500,
        height: 1.4,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle labelSmall({Color? color, FontWeight? fontWeight}) =>
      TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10,
        fontWeight: fontWeight ?? FontWeight.w500,
        height: 1.4,
        color: color,
        letterSpacing: 0.5,
      );

  // ==================== BOTONES ====================

  static TextStyle button({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
        letterSpacing: 0.2,
      );

  static TextStyle buttonSmall({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: color,
        letterSpacing: 0.2,
      );

  // ==================== SPECIAL ====================

  static TextStyle caption({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.3,
        color: color,
      );

  static TextStyle overline({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.6,
        color: color,
        letterSpacing: 1.5,
      );
}
