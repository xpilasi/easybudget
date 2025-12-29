import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';

/// CustomDropdown - Selector reutilizable con diseño consistente
class CustomDropdown<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final IconData? prefixIcon;
  final bool enabled;
  final String? errorText;

  const CustomDropdown({
    super.key,
    this.label,
    this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.labelLarge(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.surfaceVariant,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.textSecondary)
                : null,
            errorText: errorText,
            errorStyle: AppTextStyles.caption(color: AppColors.error),
            border: OutlineInputBorder(
              borderRadius: AppDecorations.radiusMD,
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppDecorations.radiusMD,
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppDecorations.radiusMD,
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppDecorations.radiusMD,
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppDecorations.radiusMD,
              borderSide: const BorderSide(color: AppColors.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: AppDecorations.radiusMD,
              borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingMD,
              vertical: AppSpacing.paddingMD,
            ),
          ),
          style: AppTextStyles.bodyLarge(color: AppColors.textPrimary),
          dropdownColor: AppColors.surface,
          icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
