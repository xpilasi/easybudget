# 📱 Plan de Migración: React Shopping List App → Flutter

> **Proyecto:** ListShare - Organiza y comparte tus listas fácilmente
> **Versión:** 1.0.0
> **Fecha:** Diciembre 2025
> **Stack:** Flutter + GetX + Clean Architecture + SOLID

---

## 📑 Tabla de Contenidos

1. [Análisis de la App React](#1-análisis-de-la-app-react)
2. [Arquitectura Flutter Propuesta](#2-arquitectura-flutter-propuesta)
3. [Estructura de Carpetas Completa](#3-estructura-de-carpetas-completa)
4. [Configuración de Dependencias](#4-configuración-de-dependencias)
5. [Sistema de Theme y Constantes](#5-sistema-de-theme-y-constantes)
6. [Modelos y Entidades](#6-modelos-y-entidades)
7. [Repositorios y Providers](#7-repositorios-y-providers)
8. [Controllers (GetX)](#8-controllers-getx)
9. [Páginas y Widgets](#9-páginas-y-widgets)
10. [Plan de Implementación por Fases](#10-plan-de-implementación-por-fases)
11. [Checklist de Migración](#11-checklist-de-migración)

---

## 1. Análisis de la App React

### 1.1 Modelos de Datos

#### **User**
```typescript
{
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  photoUrl: string;
}
```

#### **Category**
```typescript
{
  id: string;
  name: string;
  color: string; // Hex color
}
```

#### **Product**
```typescript
{
  id: string;
  name: string;
  price: number;
  quantity: number;
}
```

#### **ShoppingList**
```typescript
{
  id: string;
  name: string;
  categoryId: string;
  currency: string;
  products: Product[];
  createdAt: string; // ISO date
}
```

### 1.2 Funcionalidades Identificadas

#### **Autenticación**
- ✅ Login con Google (mock - desarrollo)
- ✅ Logout con limpieza de estado
- ✅ Persistencia de sesión

#### **Navegación**
- ✅ Bottom Navigation Bar (3 tabs)
  - Home
  - Lists
  - Profile
- ✅ Navegación a detalle de lista
- ✅ Back navigation

#### **Dark Mode**
- ✅ Toggle claro/oscuro
- ✅ Persistencia del tema
- ✅ Transiciones smooth

#### **Home Screen**
- ✅ Saludo personalizado con foto
- ✅ Estadísticas:
  - Listas activas (count)
  - Total gastado (sum)
- ✅ Botón crear lista
- ✅ Listas recientes (últimas 5, ordenadas por fecha)
- ✅ Click para ver detalle

#### **Lists Screen**
- ✅ Ver todas las listas
- ✅ Filtro por categoría (chips)
- ✅ Agrupación por categoría
- ✅ FAB para crear lista
- ✅ Modal gestión de categorías
- ✅ Empty state

#### **List Detail Screen**
- ✅ Header sticky con acciones
- ✅ Edición inline de nombre
- ✅ Edición inline de moneda
- ✅ CRUD productos:
  - Agregar producto (modal)
  - Editar precio/cantidad (inline)
  - Eliminar producto
- ✅ Cálculo automático de total
- ✅ Compartir lista (modal)
- ✅ Eliminar lista (con confirmación)

#### **Profile Screen**
- ✅ Foto de perfil
- ✅ Información personal (nombre, email)
- ✅ Toggle dark mode
- ✅ Versión de app
- ✅ Links (Términos, Privacidad)
- ✅ Logout button

#### **Modales**
1. **CreateListModal**
   - Nombre de lista
   - Selección de categoría
   - Selección de moneda
   - Validación

2. **AddProductModal**
   - Nombre de producto
   - Precio
   - Cantidad
   - Preview de subtotal

3. **ManageCategoriesModal**
   - Listar categorías
   - Agregar categoría (con color auto)
   - Editar nombre (inline)
   - Eliminar categoría (mínimo 1)

4. **ShareModal**
   - Compartir por WhatsApp
   - Compartir por Email
   - Copiar enlace
   - Preview del enlace

### 1.3 Características UI/UX

- 🎨 **Design System:**
  - Color primario: Verde (`#10B981`)
  - Border radius grandes (16-24px)
  - Sombras suaves
  - Max width: 512px (mobile-first)

- ⚡ **Interacciones:**
  - Transiciones smooth
  - Hover states
  - Inline editing
  - Confirmaciones para acciones destructivas

- 📱 **Mobile-First:**
  - Optimizado para móvil
  - Touch-friendly
  - Bottom navigation
  - FAB para acciones principales

---

## 2. Arquitectura Flutter Propuesta

### 2.1 Patrón: Clean Architecture + SOLID

```
┌─────────────────────────────────────────┐
│         PRESENTATION LAYER              │
│   (Pages, Widgets, Controllers)         │
│         ↓ Uses ↓                        │
│         DOMAIN LAYER                    │
│   (Entities, Use Cases)                 │
│         ↓ Uses ↓                        │
│         DATA LAYER                      │
│   (Models, Repositories, Providers)     │
└─────────────────────────────────────────┘
```

### 2.2 Principios SOLID Aplicados

#### **S - Single Responsibility Principle**
- Cada clase tiene UNA responsabilidad
- Controllers → Gestión de estado
- Repositories → Acceso a datos
- Use Cases → Lógica de negocio
- Widgets → UI

#### **O - Open/Closed Principle**
- Extensible sin modificar código existente
- Uso de interfaces para repositories
- Strategy pattern para filtros y ordenamiento

#### **L - Liskov Substitution Principle**
- Implementaciones intercambiables
- Repositorios mockables para testing
- Providers abstractos

#### **I - Interface Segregation Principle**
- Interfaces específicas y cohesivas
- Separación de concerns (Auth, Storage, Lists)

#### **D - Dependency Inversion Principle**
- Depender de abstracciones, no implementaciones
- Injection vía GetX bindings
- Repositories como interfaces

### 2.3 State Management: GetX

**¿Por qué GetX?**
- ✅ Reactividad simple
- ✅ Dependency injection integrado
- ✅ Route management
- ✅ Performance excelente
- ✅ Menos boilerplate que BLoC

**Estructura de Controllers:**
```dart
class HomeController extends GetxController {
  // Observables
  final lists = <ShoppingList>[].obs;

  // Computed
  int get totalLists => lists.length;

  // Methods
  void loadLists() { }

  // Lifecycle
  @override
  void onInit() { }
}
```

---

## 3. Estructura de Carpetas Completa

```
lib/
├── main.dart
│
├── app/
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   │
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_decorations.dart
│   │   ├── app_spacing.dart
│   │   ├── light_theme.dart
│   │   ├── dark_theme.dart
│   │   └── app_theme.dart
│   │
│   └── config/
│       ├── app_constants.dart
│       ├── app_strings.dart
│       └── app_assets.dart
│
├── core/
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   └── helpers.dart
│   │
│   ├── extensions/
│   │   ├── string_extensions.dart
│   │   ├── datetime_extensions.dart
│   │   ├── color_extensions.dart
│   │   └── list_extensions.dart
│   │
│   └── errors/
│       ├── failures.dart
│       └── exceptions.dart
│
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── category_model.dart
│   │   ├── product_model.dart
│   │   └── shopping_list_model.dart
│   │
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── auth_repository_impl.dart
│   │   ├── category_repository.dart
│   │   ├── category_repository_impl.dart
│   │   ├── shopping_list_repository.dart
│   │   └── shopping_list_repository_impl.dart
│   │
│   └── providers/
│       ├── local_storage_provider.dart
│       └── mock_data_provider.dart
│
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   ├── category.dart
│   │   ├── product.dart
│   │   └── shopping_list.dart
│   │
│   └── use_cases/
│       ├── auth/
│       │   ├── login_use_case.dart
│       │   └── logout_use_case.dart
│       │
│       ├── category/
│       │   ├── get_categories_use_case.dart
│       │   ├── create_category_use_case.dart
│       │   ├── update_category_use_case.dart
│       │   └── delete_category_use_case.dart
│       │
│       └── shopping_list/
│           ├── get_lists_use_case.dart
│           ├── create_list_use_case.dart
│           ├── update_list_use_case.dart
│           ├── delete_list_use_case.dart
│           ├── add_product_use_case.dart
│           ├── update_product_use_case.dart
│           └── delete_product_use_case.dart
│
├── presentation/
│   ├── controllers/
│   │   ├── auth_controller.dart
│   │   ├── theme_controller.dart
│   │   ├── home_controller.dart
│   │   ├── lists_controller.dart
│   │   ├── list_detail_controller.dart
│   │   └── profile_controller.dart
│   │
│   ├── pages/
│   │   ├── splash/
│   │   │   ├── splash_page.dart
│   │   │   └── splash_binding.dart
│   │   │
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   └── login_binding.dart
│   │   │
│   │   ├── main/
│   │   │   ├── main_page.dart
│   │   │   └── main_binding.dart
│   │   │
│   │   ├── home/
│   │   │   ├── home_page.dart
│   │   │   ├── home_binding.dart
│   │   │   └── widgets/
│   │   │       ├── stats_card.dart
│   │   │       ├── recent_list_card.dart
│   │   │       └── quick_actions_section.dart
│   │   │
│   │   ├── lists/
│   │   │   ├── lists_page.dart
│   │   │   ├── lists_binding.dart
│   │   │   └── widgets/
│   │   │       ├── category_filter_chips.dart
│   │   │       ├── list_card.dart
│   │   │       └── empty_lists_state.dart
│   │   │
│   │   ├── list_detail/
│   │   │   ├── list_detail_page.dart
│   │   │   ├── list_detail_binding.dart
│   │   │   └── widgets/
│   │   │       ├── list_header.dart
│   │   │       ├── product_card.dart
│   │   │       ├── product_editor.dart
│   │   │       └── total_section.dart
│   │   │
│   │   └── profile/
│   │       ├── profile_page.dart
│   │       ├── profile_binding.dart
│   │       └── widgets/
│   │           ├── profile_header.dart
│   │           ├── user_info_card.dart
│   │           └── settings_section.dart
│   │
│   └── widgets/
│       ├── common/
│       │   ├── custom_button.dart
│       │   ├── custom_text_field.dart
│       │   ├── custom_dropdown.dart
│       │   ├── loading_indicator.dart
│       │   ├── empty_state.dart
│       │   ├── error_view.dart
│       │   └── confirmation_dialog.dart
│       │
│       └── modals/
│           ├── create_list_modal.dart
│           ├── add_product_modal.dart
│           ├── manage_categories_modal.dart
│           └── share_modal.dart
│
└── bindings/
    └── initial_binding.dart
```

---

## 4. Configuración de Dependencias

### pubspec.yaml

```yaml
name: easy_budget
description: "ListShare - Organiza y comparte tus listas fácilmente"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.10.4

dependencies:
  flutter:
    sdk: flutter

  # State Management
  get: ^4.6.6

  # Networking & Serialization
  dio: ^5.4.0
  json_annotation: ^4.8.1

  # Local Storage
  shared_preferences: ^2.2.2
  get_storage: ^2.1.1

  # UI
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1

  # Utilities
  intl: ^0.19.0
  uuid: ^4.3.3
  share_plus: ^7.2.2
  url_launcher: ^6.2.4

  # Icons
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  build_runner: ^2.4.8
  json_serializable: ^6.7.1

flutter:
  uses-material-design: true

  # Descomentar cuando tengamos assets
  # assets:
  #   - assets/images/
  #   - assets/icons/
```

---

## 5. Sistema de Theme y Constantes

### 5.1 Colores (app/theme/app_colors.dart)

```dart
import 'package:flutter/material.dart';

/// Paleta de colores de la aplicación
/// Sigue los principios de Material Design 3
class AppColors {
  AppColors._();

  // ==================== COLORES PRIMARIOS ====================

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

  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  static Color shadow = Colors.black.withOpacity(0.1);
  static Color shadowMedium = Colors.black.withOpacity(0.15);
  static Color shadowHeavy = Colors.black.withOpacity(0.25);
}
```

### 5.2 Espaciados (app/theme/app_spacing.dart)

```dart
/// Espaciados consistentes - Sistema de 4px
class AppSpacing {
  AppSpacing._();

  // ==================== ESPACIADOS ====================
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // ==================== PADDING ====================
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;

  // ==================== MARGIN ====================
  static const double marginXS = 4.0;
  static const double marginSM = 8.0;
  static const double marginMD = 16.0;
  static const double marginLG = 24.0;
  static const double marginXL = 32.0;

  // ==================== BORDER RADIUS ====================
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusFull = 9999.0;

  // ==================== ICONOS ====================
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 40.0;
  static const double iconXXL = 48.0;

  // ==================== AVATARES ====================
  static const double avatarSM = 32.0;
  static const double avatarMD = 48.0;
  static const double avatarLG = 64.0;
  static const double avatarXL = 80.0;

  // ==================== BOTONES ====================
  static const double buttonHeight = 48.0;
  static const double buttonHeightSM = 40.0;
  static const double buttonHeightLG = 56.0;

  // ==================== CARDS ====================
  static const double cardElevation = 2.0;
  static const double cardElevationHover = 4.0;

  // ==================== BOTTOM NAV BAR ====================
  static const double bottomNavHeight = 64.0;

  // ==================== APP BAR ====================
  static const double appBarHeight = 56.0;

  // ==================== MAX WIDTHS ====================
  static const double maxContentWidth = 512.0;
}
```

### 5.3 Estilos de Texto (app/theme/app_text_styles.dart)

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

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

  static TextStyle bodyLarge({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: fontWeight ?? FontWeight.normal,
        height: 1.5,
        color: color,
      );

  static TextStyle bodyMedium({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        height: 1.5,
        color: color,
      );

  static TextStyle bodySmall({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.normal,
        height: 1.5,
        color: color,
      );

  // ==================== LABELS ====================

  static TextStyle labelLarge({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: fontWeight ?? FontWeight.w500,
        height: 1.4,
        color: color,
        letterSpacing: 0.1,
      );

  static TextStyle labelMedium({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: fontWeight ?? FontWeight.w500,
        height: 1.4,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle labelSmall({Color? color, FontWeight? fontWeight}) => TextStyle(
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
```

### 5.4 Decoraciones (app/theme/app_decorations.dart)

```dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

class AppDecorations {
  AppDecorations._();

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

  static BorderRadius get radiusSM => BorderRadius.circular(AppSpacing.radiusSM);
  static BorderRadius get radiusMD => BorderRadius.circular(AppSpacing.radiusMD);
  static BorderRadius get radiusLG => BorderRadius.circular(AppSpacing.radiusLG);
  static BorderRadius get radiusXL => BorderRadius.circular(AppSpacing.radiusXL);
  static BorderRadius get radiusXXL => BorderRadius.circular(AppSpacing.radiusXXL);
  static BorderRadius get radiusFull => BorderRadius.circular(AppSpacing.radiusFull);

  // ==================== BOX DECORATIONS ====================

  static BoxDecoration cardLight({Color? color}) => BoxDecoration(
        color: color ?? AppColors.lightSurface,
        borderRadius: radiusXL,
        boxShadow: shadowSM,
      );

  static BoxDecoration cardDark({Color? color}) => BoxDecoration(
        color: color ?? AppColors.darkSurface,
        borderRadius: radiusXL,
        boxShadow: shadowSM,
      );

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
        fillColor: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
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
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusMD,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingMD,
          vertical: AppSpacing.paddingMD,
        ),
      );
}
```

### 5.5 Constantes (app/config/app_constants.dart)

```dart
class AppConstants {
  AppConstants._();

  // ==================== APP INFO ====================

  static const String appName = 'ListShare';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appDescription = 'Organiza y comparte tus listas fácilmente';

  // ==================== MONEDAS ====================

  static const List<Map<String, String>> currencies = [
    {'code': 'USD', 'name': 'Dólar'},
    {'code': 'EUR', 'name': 'Euro'},
    {'code': 'GBP', 'name': 'Libra'},
    {'code': 'ARS', 'name': 'Peso argentino'},
    {'code': 'MXN', 'name': 'Peso mexicano'},
    {'code': 'COP', 'name': 'Peso colombiano'},
    {'code': 'CLP', 'name': 'Peso chileno'},
  ];

  // ==================== LÍMITES ====================

  static const int maxListNameLength = 50;
  static const int maxProductNameLength = 100;
  static const int maxCategoryNameLength = 30;
  static const int minCategories = 1;
  static const int maxRecentLists = 5;

  // ==================== TIMEOUTS ====================

  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration shortDelay = Duration(milliseconds: 300);
  static const Duration mediumDelay = Duration(milliseconds: 600);
  static const Duration longDelay = Duration(seconds: 1);

  // ==================== STORAGE KEYS ====================

  static const String keyThemeMode = 'theme_mode';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserData = 'user_data';
  static const String keyCategories = 'categories';
  static const String keyLists = 'shopping_lists';

  // ==================== MOCK URLs ====================

  static const String mockShareUrl = 'https://listshare.app/list/';
  static const String termsUrl = 'https://listshare.app/terms';
  static const String privacyUrl = 'https://listshare.app/privacy';
}
```

### 5.6 Strings (app/config/app_strings.dart)

```dart
class AppStrings {
  AppStrings._();

  // ==================== GENERAL ====================
  static const String appName = 'ListShare';
  static const String ok = 'OK';
  static const String cancel = 'Cancelar';
  static const String save = 'Guardar';
  static const String delete = 'Eliminar';
  static const String edit = 'Editar';
  static const String create = 'Crear';
  static const String add = 'Agregar';
  static const String share = 'Compartir';
  static const String close = 'Cerrar';
  static const String done = 'Listo';
  static const String search = 'Buscar';

  // ==================== LOGIN ====================
  static const String welcome = 'Bienvenido';
  static const String loginTitle = 'Inicia sesión para continuar';
  static const String continueWithGoogle = 'Continuar con Google';
  static const String devModeNote = 'Modo desarrollo - El login te llevará directamente a la app';
  static const String termsAcceptance = 'Al continuar, aceptas nuestros términos y condiciones';

  // ==================== HOME ====================
  static const String helloAgain = 'Hola de nuevo,';
  static const String quickActions = 'Acciones rápidas';
  static const String createNewList = 'Crear nueva lista';
  static const String recentLists = 'Listas recientes';
  static const String activeLists = 'Listas activas';
  static const String totalSpent = 'Total gastado';

  // ==================== LISTS ====================
  static const String myLists = 'Mis Listas';
  static const String all = 'Todas';
  static const String noLists = 'No hay listas aquí';
  static const String createFirstList = 'Crea tu primera lista para comenzar';
  static const String products = 'productos';

  // ==================== LIST DETAIL ====================
  static const String noProducts = 'No hay productos en esta lista';
  static const String addFirstProduct = 'Agrega tu primer producto';
  static const String addProduct = 'Agregar producto';
  static const String total = 'Total';
  static const String deleteListConfirm = '¿Estás seguro de que deseas eliminar esta lista?';

  // ==================== CREATE LIST ====================
  static const String newList = 'Nueva lista';
  static const String listName = 'Nombre de la lista';
  static const String listNameHint = 'Ej: Compras semanales';
  static const String category = 'Categoría';
  static const String currency = 'Moneda';

  // ==================== ADD PRODUCT ====================
  static const String newProduct = 'Nuevo producto';
  static const String productName = 'Nombre del producto';
  static const String productNameHint = 'Ej: Leche';
  static const String price = 'Precio';
  static const String quantity = 'Cantidad';
  static const String subtotal = 'Subtotal';

  // ==================== CATEGORIES ====================
  static const String manageCategories = 'Gestionar categorías';
  static const String newCategory = 'Nueva categoría';
  static const String categoryName = 'Nombre de la categoría';
  static const String saveChanges = 'Guardar cambios';
  static const String deleteCategoryConfirm = '¿Estás seguro de que deseas eliminar esta categoría?';
  static const String minCategoriesWarning = 'Debes tener al menos una categoría';

  // ==================== SHARE ====================
  static const String shareList = 'Compartir lista';
  static const String shareWith = 'Comparte con otros usuarios';
  static const String copyLink = 'Copiar enlace';
  static const String copyToClipboard = 'Copiar al portapapeles';
  static const String linkCopied = '¡Enlace copiado al portapapeles!';
  static const String shareNote = 'Los usuarios con el enlace podrán ver y guardar la lista';

  // ==================== PROFILE ====================
  static const String profile = 'Perfil';
  static const String fullName = 'Nombre completo';
  static const String email = 'Correo electrónico';
  static const String settings = 'Configuración';
  static const String darkMode = 'Modo oscuro';
  static const String lightMode = 'Modo claro';
  static const String appTheme = 'Tema de la aplicación';
  static const String about = 'Acerca de';
  static const String appVersion = 'Versión de la app';
  static const String termsAndConditions = 'Términos y condiciones';
  static const String privacyPolicy = 'Política de privacidad';
  static const String logout = 'Cerrar sesión';

  // ==================== NAVIGATION ====================
  static const String navHome = 'Inicio';
  static const String navLists = 'Listas';
  static const String navProfile = 'Perfil';
}
```

---

## 6. Modelos y Entidades

### 6.1 Entidad User (domain/entities/user.dart)

```dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String photoUrl;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.photoUrl,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, email, firstName, lastName, photoUrl];
}
```

### 6.2 Model User (data/models/user_model.dart)

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      photoUrl: user.photoUrl,
    );
  }
}
```

### 6.3 Entidad Category (domain/entities/category.dart)

```dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final Color color;

  const Category({
    required this.id,
    required this.name,
    required this.color,
  });

  @override
  List<Object?> get props => [id, name, color];
}
```

### 6.4 Model Category (data/models/category_model.dart)

```dart
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name,
    required String colorHex,
  }) : super(color: Color(int.parse(colorHex.replaceFirst('#', '0xFF'))));

  @JsonKey(name: 'color')
  String get colorHex => '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      colorHex: '#${category.color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
    );
  }
}
```

### 6.5 Entidad Product (domain/entities/product.dart)

```dart
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final int quantity;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  @override
  List<Object?> get props => [id, name, price, quantity];
}
```

### 6.6 Model Product (data/models/product_model.dart)

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: product.quantity,
    );
  }
}
```

### 6.7 Entidad ShoppingList (domain/entities/shopping_list.dart)

```dart
import 'package:equatable/equatable.dart';
import 'product.dart';

class ShoppingList extends Equatable {
  final String id;
  final String name;
  final String categoryId;
  final String currency;
  final List<Product> products;
  final DateTime createdAt;

  const ShoppingList({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.currency,
    required this.products,
    required this.createdAt,
  });

  double get total {
    return products.fold(0, (sum, product) => sum + product.subtotal);
  }

  @override
  List<Object?> get props => [id, name, categoryId, currency, products, createdAt];
}
```

### 6.8 Model ShoppingList (data/models/shopping_list_model.dart)

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/shopping_list.dart';
import 'product_model.dart';

part 'shopping_list_model.g.dart';

@JsonSerializable()
class ShoppingListModel extends ShoppingList {
  ShoppingListModel({
    required super.id,
    required super.name,
    required super.categoryId,
    required super.currency,
    required List<ProductModel> products,
    required super.createdAt,
  }) : super(products: products);

  factory ShoppingListModel.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingListModelToJson(this);

  factory ShoppingListModel.fromEntity(ShoppingList list) {
    return ShoppingListModel(
      id: list.id,
      name: list.name,
      categoryId: list.categoryId,
      currency: list.currency,
      products: list.products.map((p) => ProductModel.fromEntity(p)).toList(),
      createdAt: list.createdAt,
    );
  }
}
```

---

## 7. Repositorios y Providers

### 7.1 Local Storage Provider (data/providers/local_storage_provider.dart)

```dart
import 'package:get_storage/get_storage.dart';
import '../../app/config/app_constants.dart';

class LocalStorageProvider {
  final GetStorage _storage = GetStorage();

  // ==================== THEME ====================

  Future<void> saveThemeMode(bool isDark) async {
    await _storage.write(AppConstants.keyThemeMode, isDark);
  }

  bool? getThemeMode() {
    return _storage.read<bool>(AppConstants.keyThemeMode);
  }

  // ==================== AUTH ====================

  Future<void> saveLoginStatus(bool isLoggedIn) async {
    await _storage.write(AppConstants.keyIsLoggedIn, isLoggedIn);
  }

  bool getLoginStatus() {
    return _storage.read<bool>(AppConstants.keyIsLoggedIn) ?? false;
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(AppConstants.keyUserData, userData);
  }

  Map<String, dynamic>? getUserData() {
    return _storage.read<Map<String, dynamic>>(AppConstants.keyUserData);
  }

  // ==================== CATEGORIES ====================

  Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    await _storage.write(AppConstants.keyCategories, categories);
  }

  List<Map<String, dynamic>>? getCategories() {
    final data = _storage.read<List>(AppConstants.keyCategories);
    return data?.cast<Map<String, dynamic>>();
  }

  // ==================== SHOPPING LISTS ====================

  Future<void> saveLists(List<Map<String, dynamic>> lists) async {
    await _storage.write(AppConstants.keyLists, lists);
  }

  List<Map<String, dynamic>>? getLists() {
    final data = _storage.read<List>(AppConstants.keyLists);
    return data?.cast<Map<String, dynamic>>();
  }

  // ==================== CLEAR ====================

  Future<void> clearAll() async {
    await _storage.erase();
  }
}
```

### 7.2 Auth Repository Interface (data/repositories/auth_repository.dart)

```dart
import '../../domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login();
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isLoggedIn();
}
```

### 7.3 Auth Repository Implementation (data/repositories/auth_repository_impl.dart)

```dart
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import '../providers/local_storage_provider.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LocalStorageProvider _storageProvider;

  AuthRepositoryImpl(this._storageProvider);

  @override
  Future<User> login() async {
    // Mock login - siempre exitoso
    await Future.delayed(const Duration(seconds: 1));

    final mockUser = const UserModel(
      id: '1',
      email: 'usuario@ejemplo.com',
      firstName: 'Juan',
      lastName: 'Pérez',
      photoUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400&h=400&fit=crop',
    );

    await _storageProvider.saveUserData(mockUser.toJson());
    await _storageProvider.saveLoginStatus(true);

    return mockUser;
  }

  @override
  Future<void> logout() async {
    await _storageProvider.saveLoginStatus(false);
    await _storageProvider.clearAll();
  }

  @override
  Future<User?> getCurrentUser() async {
    final userData = _storageProvider.getUserData();
    if (userData == null) return null;
    return UserModel.fromJson(userData);
  }

  @override
  Future<bool> isLoggedIn() async {
    return _storageProvider.getLoginStatus();
  }
}
```

### 7.4 Category Repository Interface (data/repositories/category_repository.dart)

```dart
import '../../domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<Category> createCategory(String name, String colorHex);
  Future<Category> updateCategory(String id, String name);
  Future<void> deleteCategory(String id);
}
```

### 7.5 Shopping List Repository Interface (data/repositories/shopping_list_repository.dart)

```dart
import '../../domain/entities/shopping_list.dart';
import '../../domain/entities/product.dart';

abstract class ShoppingListRepository {
  Future<List<ShoppingList>> getLists();
  Future<ShoppingList> createList({
    required String name,
    required String categoryId,
    required String currency,
  });
  Future<ShoppingList> updateList(ShoppingList list);
  Future<void> deleteList(String listId);
  Future<ShoppingList> addProduct(String listId, Product product);
  Future<ShoppingList> updateProduct(String listId, Product product);
  Future<ShoppingList> deleteProduct(String listId, String productId);
}
```

---

## 8. Controllers (GetX)

### 8.1 Auth Controller (presentation/controllers/auth_controller.dart)

```dart
import 'package:get/get.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  // ==================== STATE ====================

  final Rx<User?> _currentUser = Rx<User?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isLoggedIn = false.obs;

  User? get currentUser => _currentUser.value;
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // ==================== METHODS ====================

  Future<void> checkLoginStatus() async {
    _isLoading.value = true;
    try {
      final loggedIn = await _authRepository.isLoggedIn();
      _isLoggedIn.value = loggedIn;

      if (loggedIn) {
        final user = await _authRepository.getCurrentUser();
        _currentUser.value = user;
      }
    } catch (e) {
      _isLoggedIn.value = false;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> login() async {
    _isLoading.value = true;
    try {
      final user = await _authRepository.login();
      _currentUser.value = user;
      _isLoggedIn.value = true;
      Get.offAllNamed('/main');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo iniciar sesión');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    _isLoading.value = true;
    try {
      await _authRepository.logout();
      _currentUser.value = null;
      _isLoggedIn.value = false;
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo cerrar sesión');
    } finally {
      _isLoading.value = false;
    }
  }
}
```

### 8.2 Theme Controller (presentation/controllers/theme_controller.dart)

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/providers/local_storage_provider.dart';

class ThemeController extends GetxController {
  final LocalStorageProvider _storageProvider;

  ThemeController(this._storageProvider);

  // ==================== STATE ====================

  final RxBool _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode => _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
  }

  // ==================== METHODS ====================

  void loadThemeMode() {
    final savedTheme = _storageProvider.getThemeMode();
    if (savedTheme != null) {
      _isDarkMode.value = savedTheme;
    }
  }

  Future<void> toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    await _storageProvider.saveThemeMode(_isDarkMode.value);
    Get.changeThemeMode(themeMode);
  }
}
```

### 8.3 Home Controller (presentation/controllers/home_controller.dart)

```dart
import 'package:get/get.dart';
import '../../domain/entities/shopping_list.dart';
import '../../domain/entities/category.dart';
import '../../data/repositories/shopping_list_repository.dart';
import '../../data/repositories/category_repository.dart';
import '../../app/config/app_constants.dart';

class HomeController extends GetxController {
  final ShoppingListRepository _listRepository;
  final CategoryRepository _categoryRepository;

  HomeController(this._listRepository, this._categoryRepository);

  // ==================== STATE ====================

  final RxList<ShoppingList> _lists = <ShoppingList>[].obs;
  final RxList<Category> _categories = <Category>[].obs;
  final RxBool _isLoading = false.obs;

  List<ShoppingList> get lists => _lists;
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading.value;

  // ==================== COMPUTED ====================

  int get totalLists => _lists.length;

  double get totalSpent {
    return _lists.fold(0.0, (sum, list) => sum + list.total);
  }

  List<ShoppingList> get recentLists {
    final sorted = [..._lists];
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(AppConstants.maxRecentLists).toList();
  }

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // ==================== METHODS ====================

  Future<void> loadData() async {
    _isLoading.value = true;
    try {
      final lists = await _listRepository.getLists();
      final categories = await _categoryRepository.getCategories();
      _lists.value = lists;
      _categories.value = categories;
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los datos');
    } finally {
      _isLoading.value = false;
    }
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  void navigateToListDetail(String listId) {
    Get.toNamed('/list-detail', arguments: {'listId': listId});
  }
}
```

### 8.4 Lists Controller (presentation/controllers/lists_controller.dart)

```dart
import 'package:get/get.dart';
import '../../domain/entities/shopping_list.dart';
import '../../domain/entities/category.dart';
import '../../data/repositories/shopping_list_repository.dart';
import '../../data/repositories/category_repository.dart';

class ListsController extends GetxController {
  final ShoppingListRepository _listRepository;
  final CategoryRepository _categoryRepository;

  ListsController(this._listRepository, this._categoryRepository);

  // ==================== STATE ====================

  final RxList<ShoppingList> _lists = <ShoppingList>[].obs;
  final RxList<Category> _categories = <Category>[].obs;
  final Rx<String?> _selectedCategoryFilter = Rx<String?>(null);
  final RxBool _isLoading = false.obs;

  List<ShoppingList> get lists => _lists;
  List<Category> get categories => _categories;
  String? get selectedCategoryFilter => _selectedCategoryFilter.value;
  bool get isLoading => _isLoading.value;

  // ==================== COMPUTED ====================

  List<ShoppingList> get filteredLists {
    if (_selectedCategoryFilter.value == null) {
      return _lists;
    }
    return _lists.where((list) => list.categoryId == _selectedCategoryFilter.value).toList();
  }

  Map<String, List<ShoppingList>> get groupedLists {
    final Map<String, List<ShoppingList>> grouped = {};
    for (final category in _categories) {
      grouped[category.id] = filteredLists.where((list) => list.categoryId == category.id).toList();
    }
    return grouped;
  }

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // ==================== METHODS ====================

  Future<void> loadData() async {
    _isLoading.value = true;
    try {
      final lists = await _listRepository.getLists();
      final categories = await _categoryRepository.getCategories();
      _lists.value = lists;
      _categories.value = categories;
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los datos');
    } finally {
      _isLoading.value = false;
    }
  }

  void setSelectedCategoryFilter(String? categoryId) {
    _selectedCategoryFilter.value = categoryId;
  }

  Future<void> createList({
    required String name,
    required String categoryId,
    required String currency,
  }) async {
    try {
      final newList = await _listRepository.createList(
        name: name,
        categoryId: categoryId,
        currency: currency,
      );
      _lists.add(newList);
      Get.back();
      Get.snackbar('Éxito', 'Lista creada correctamente');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo crear la lista');
    }
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  void navigateToListDetail(String listId) {
    Get.toNamed('/list-detail', arguments: {'listId': listId});
  }
}
```

---

## 9. Páginas y Widgets

### 9.1 Main Page (presentation/pages/main/main_page.dart)

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/home_page.dart';
import '../lists/lists_page.dart';
import '../profile/profile_page.dart';
import '../../../app/config/app_strings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ListsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.navHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: AppStrings.navLists,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.navProfile,
          ),
        ],
      ),
    );
  }
}
```

### 9.2 Login Page (presentation/pages/auth/login_page.dart)

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../../app/theme/app_theme.dart';
import '../../../app/config/app_strings.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(() {
      final isDark = themeController.isDarkMode;

      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark ? null : AppColors.lightBackgroundGradient,
            color: isDark ? AppColors.darkBackground : null,
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.paddingLG),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Title
                      Text(
                        AppStrings.appName,
                        style: AppTextStyles.h1(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // Subtitle
                      Text(
                        AppConstants.appDescription,
                        style: AppTextStyles.bodyMedium(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xxxl),

                      // Login Card
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.paddingXL),
                        decoration: isDark
                            ? AppDecorations.cardDark()
                            : AppDecorations.cardLight(),
                        child: Column(
                          children: [
                            Text(
                              AppStrings.welcome,
                              style: AppTextStyles.h2(
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.sm),

                            Text(
                              AppStrings.loginTitle,
                              style: AppTextStyles.bodyMedium(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),

                            const SizedBox(height: AppSpacing.xl),

                            // Google Sign In Button
                            ElevatedButton(
                              onPressed: controller.isLoading ? null : () => controller.login(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                elevation: 2,
                              ),
                              child: controller.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Google Icon (simplified)
                                        Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            color: AppColors.error,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.md),
                                        Text(AppStrings.continueWithGoogle),
                                      ],
                                    ),
                            ),

                            const SizedBox(height: AppSpacing.md),

                            Text(
                              AppStrings.devModeNote,
                              style: AppTextStyles.caption(color: AppColors.lightTextTertiary),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Terms
                      Text(
                        AppStrings.termsAcceptance,
                        style: AppTextStyles.bodySmall(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
```

---

## 10. Plan de Implementación por Fases

### **FASE 1: Setup Inicial** ✅ (2-3 horas)
- [ ] Actualizar `pubspec.yaml` con todas las dependencias
- [ ] Ejecutar `flutter pub get`
- [ ] Crear estructura de carpetas completa
- [ ] Configurar `analysis_options.yaml`
- [ ] Configurar tema (colores, espaciados, decoraciones, text styles)
- [ ] Crear constantes (`app_constants.dart`, `app_strings.dart`)
- [ ] Configurar rutas con GetX (`app_routes.dart`, `app_pages.dart`)
- [ ] Crear `InitialBinding` para inyección de dependencias

### **FASE 2: Capa de Datos** 🔄 (4-5 horas)
- [ ] Crear entidades del dominio (User, Category, Product, ShoppingList)
- [ ] Crear modelos de datos con JSON serialization
- [ ] Ejecutar `build_runner` para generar archivos `.g.dart`
- [ ] Implementar `LocalStorageProvider`
- [ ] Crear interfaces de repositorios
- [ ] Implementar repositorios concretos
- [ ] Crear mock data provider con datos iniciales

### **FASE 3: Use Cases** 🔄 (3-4 horas)
- [ ] Implementar casos de uso de autenticación
  - LoginUseCase
  - LogoutUseCase
- [ ] Implementar casos de uso de categorías
  - GetCategoriesUseCase
  - CreateCategoryUseCase
  - UpdateCategoryUseCase
  - DeleteCategoryUseCase
- [ ] Implementar casos de uso de listas
  - GetListsUseCase
  - CreateListUseCase
  - UpdateListUseCase
  - DeleteListUseCase
  - AddProductUseCase
  - UpdateProductUseCase
  - DeleteProductUseCase

### **FASE 4: Controllers** 🔄 (5-6 horas)
- [ ] `AuthController` (login, logout, estado de sesión)
- [ ] `ThemeController` (dark mode toggle)
- [ ] `HomeController` (estadísticas, listas recientes)
- [ ] `ListsController` (CRUD listas, filtros)
- [ ] `ListDetailController` (CRUD productos, cálculos)
- [ ] `ProfileController` (info usuario, logout)
- [ ] Configurar bindings para cada página

### **FASE 5: Widgets Comunes** 🔄 (4-5 horas)
- [ ] `CustomButton` (botón reutilizable)
- [ ] `CustomTextField` (input reutilizable)
- [ ] `CustomDropdown` (selector reutilizable)
- [ ] `LoadingIndicator`
- [ ] `EmptyState`
- [ ] `ErrorView`
- [ ] `ConfirmationDialog`

### **FASE 6: Páginas Principales** 🔄 (8-10 horas)
- [ ] **SplashPage** (pantalla inicial, check de sesión)
- [ ] **LoginPage** (diseño + integración con AuthController)
- [ ] **MainPage** (BottomNavigationBar con 3 tabs)
- [ ] **HomePage**
  - Header con saludo y foto
  - Cards de estadísticas
  - Botón crear lista
  - Lista de recientes
- [ ] **ListsPage**
  - Header con título y settings
  - Chips de filtro por categoría
  - Listas agrupadas
  - FAB para crear
  - Empty state
- [ ] **ListDetailPage**
  - Header sticky con acciones
  - Edición inline de nombre
  - Edición inline de moneda
  - Lista de productos
  - Total sticky al bottom
  - FAB agregar producto
- [ ] **ProfilePage**
  - Header de perfil
  - Información de usuario
  - Settings (dark mode)
  - Información de app
  - Botón logout

### **FASE 7: Modales** 🔄 (5-6 horas)
- [ ] `CreateListModal`
  - Input nombre
  - Dropdown categoría
  - Dropdown moneda
  - Validación
  - Botones acción
- [ ] `AddProductModal`
  - Input nombre
  - Input precio
  - Input cantidad
  - Preview subtotal
  - Validación
  - Botones acción
- [ ] `ManageCategoriesModal`
  - Input nueva categoría
  - Lista de categorías
  - Edición inline
  - Eliminación con confirmación
  - Validación mínimo 1
- [ ] `ShareModal`
  - Opciones de compartir (WhatsApp, Email, Copy)
  - Preview de URL
  - Integración con `share_plus` y `url_launcher`

### **FASE 8: Funcionalidades Avanzadas** 🔄 (4-5 horas)
- [ ] Inline editing (TextFields editables)
- [ ] Confirmaciones de eliminación (Dialogs)
- [ ] Compartir (WhatsApp, Email, Clipboard)
- [ ] Animaciones y transiciones
- [ ] Pull-to-refresh
- [ ] Gestures (swipe to delete, etc.)

### **FASE 9: Polish y UX** 🔄 (3-4 horas)
- [ ] Validaciones de formularios
- [ ] Error handling completo
- [ ] Loading states
- [ ] Empty states
- [ ] Feedback visual (snackbars, toasts)
- [ ] Keyboard handling
- [ ] Focus management

### **FASE 10: Testing y Refactorización** 🔄 (5-6 horas)
- [ ] Unit tests para controllers
- [ ] Unit tests para use cases
- [ ] Widget tests para componentes clave
- [ ] Refactorización según principios SOLID
- [ ] Code review
- [ ] Performance optimization
- [ ] Documentación de código

---

## 11. Checklist de Migración

### Configuración Inicial
- [ ] Proyecto Flutter creado
- [ ] Dependencias instaladas
- [ ] Estructura de carpetas creada
- [ ] Theme configurado
- [ ] Constantes definidas
- [ ] Rutas configuradas

### Modelos de Datos
- [ ] User entity + model
- [ ] Category entity + model
- [ ] Product entity + model
- [ ] ShoppingList entity + model
- [ ] JSON serialization funcionando

### Repositorios
- [ ] LocalStorageProvider implementado
- [ ] AuthRepository implementado
- [ ] CategoryRepository implementado
- [ ] ShoppingListRepository implementado
- [ ] Mock data provider con datos iniciales

### State Management
- [ ] AuthController funcionando
- [ ] ThemeController funcionando
- [ ] HomeController funcionando
- [ ] ListsController funcionando
- [ ] ListDetailController funcionando
- [ ] ProfileController funcionando

### Pantallas Completas
- [ ] Login screen (100% funcional)
- [ ] Home screen (100% funcional)
- [ ] Lists screen (100% funcional)
- [ ] List Detail screen (100% funcional)
- [ ] Profile screen (100% funcional)

### Funcionalidades
- [ ] Autenticación (login/logout)
- [ ] Dark mode (toggle + persistencia)
- [ ] CRUD listas
- [ ] CRUD productos
- [ ] CRUD categorías
- [ ] Filtros por categoría
- [ ] Compartir listas
- [ ] Cálculos automáticos

### Testing
- [ ] Unit tests (controllers)
- [ ] Widget tests
- [ ] Integration tests básicos

### Deployment Ready
- [ ] Code review completo
- [ ] No warnings ni errors
- [ ] Performance optimizado
- [ ] Documentación completa
- [ ] README actualizado

---

## 📝 Notas Finales

### Principios Clave a Seguir

1. **DRY (Don't Repeat Yourself)**
   - Usar widgets reutilizables
   - Extraer lógica común a helpers
   - Centralizar constantes y estilos

2. **KISS (Keep It Simple, Stupid)**
   - Evitar sobre-ingeniería
   - Código claro y legible
   - Soluciones simples primero

3. **YAGNI (You Aren't Gonna Need It)**
   - No anticipar features futuras
   - Implementar solo lo necesario
   - Refactorizar cuando sea necesario

4. **SOLID**
   - Single Responsibility
   - Open/Closed
   - Liskov Substitution
   - Interface Segregation
   - Dependency Inversion

### Mejores Prácticas Flutter

- ✅ Usar `const` constructors siempre que sea posible
- ✅ Evitar `setState()` innecesarios
- ✅ Usar `ListView.builder` para listas dinámicas
- ✅ Implementar `dispose()` para controllers
- ✅ Usar keys para widgets dinámicos
- ✅ Extraer widgets complejos a archivos separados
- ✅ Nombrar widgets de forma descriptiva
- ✅ Comentar código complejo

### Convenciones de Nombres

- **Archivos:** `snake_case.dart`
- **Clases:** `PascalCase`
- **Variables/Métodos:** `camelCase`
- **Constantes:** `SCREAMING_SNAKE_CASE` o `camelCase` en clases
- **Privados:** Prefijo `_`

---

**¿Listo para comenzar la implementación? 🚀**

Este documento servirá como guía completa para la migración. Actualiza el checklist conforme avances.
