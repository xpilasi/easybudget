import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
  text,
  danger,
}

enum ButtonSize {
  small,
  medium,
  large,
}

/// CustomButton - Botón reutilizable con múltiples variantes y tamaños
/// Sigue los principios del design system de la aplicación
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final Widget? child;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
    this.child,
  });

  /// Factory constructor para botón primario
  factory CustomButton.primary({
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = true,
    IconData? icon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.primary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
    );
  }

  /// Factory constructor para botón secundario
  factory CustomButton.secondary({
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = true,
    IconData? icon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.secondary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
    );
  }

  /// Factory constructor para botón outline
  factory CustomButton.outline({
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = true,
    IconData? icon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.outline,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
    );
  }

  /// Factory constructor para botón de texto
  factory CustomButton.text({
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
    IconData? icon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.text,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
    );
  }

  /// Factory constructor para botón de peligro
  factory CustomButton.danger({
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = true,
    IconData? icon,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      variant: ButtonVariant.danger,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (variant) {
      case ButtonVariant.primary:
        return _buildElevatedButton(context);
      case ButtonVariant.secondary:
        return _buildSecondaryButton(context);
      case ButtonVariant.outline:
        return _buildOutlinedButton(context);
      case ButtonVariant.text:
        return _buildTextButton(context);
      case ButtonVariant.danger:
        return _buildDangerButton(context);
    }
  }

  Widget _buildElevatedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: AppDecorations.radiusMD,
        ),
        elevation: 0,
        padding: _getPadding(),
      ),
      child: _buildContent(context, Colors.white),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.secondary.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: AppDecorations.radiusMD,
        ),
        elevation: 0,
        padding: _getPadding(),
      ),
      child: _buildContent(context, Colors.white),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(
          color: isLoading || onPressed == null
              ? AppColors.border
              : AppColors.primary,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDecorations.radiusMD,
        ),
        padding: _getPadding(),
      ),
      child: _buildContent(context, AppColors.primary),
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: AppDecorations.radiusMD,
        ),
        padding: _getPadding(),
      ),
      child: _buildContent(context, AppColors.primary),
    );
  }

  Widget _buildDangerButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.error.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: AppDecorations.radiusMD,
        ),
        elevation: 0,
        padding: _getPadding(),
      ),
      child: _buildContent(context, Colors.white),
    );
  }

  Widget _buildContent(BuildContext context, Color defaultColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(defaultColor),
        ),
      );
    }

    if (child != null) {
      return child!;
    }

    final textStyle = _getTextStyle();
    final textWidget = Text(
      text,
      style: textStyle.copyWith(color: defaultColor),
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _getIconSize(), color: defaultColor),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: textWidget,
          ),
        ],
      );
    }

    return textWidget;
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.buttonHeightSM;
      case ButtonSize.medium:
        return AppSpacing.buttonHeight;
      case ButtonSize.large:
        return AppSpacing.buttonHeightLG;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        );
      case ButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTextStyles.buttonSmall();
      case ButtonSize.medium:
      case ButtonSize.large:
        return AppTextStyles.button();
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.iconSM;
      case ButtonSize.medium:
        return AppSpacing.iconMD;
      case ButtonSize.large:
        return AppSpacing.iconLG;
    }
  }
}
