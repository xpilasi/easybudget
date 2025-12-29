import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/theme/app_theme.dart';

enum TextFieldType {
  text,
  email,
  password,
  number,
  decimal,
  phone,
  multiline,
}

/// CustomTextField - Input reutilizable con validación y diferentes tipos
/// Sigue los principios del design system de la aplicación
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextFieldType type;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? errorText;
  final String? helperText;
  final TextCapitalization? textCapitalization;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.type = TextFieldType.text,
    this.controller,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffix,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines,
    this.maxLength,
    this.textInputAction,
    this.focusNode,
    this.errorText,
    this.helperText,
    this.textCapitalization,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  String? _errorText;
  bool _hasInteracted = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _errorText = widget.errorText;
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != oldWidget.errorText) {
      setState(() {
        _errorText = widget.errorText;
      });
    }
  }

  void _enableAutoValidation() {
    if (!_hasInteracted) {
      setState(() {
        _hasInteracted = true;
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelLarge(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          obscureText: widget.type == TextFieldType.password && _obscureText,
          keyboardType: _getKeyboardType(),
          textInputAction: widget.textInputAction ?? _getDefaultTextInputAction(),
          textCapitalization: widget.textCapitalization ?? _getDefaultTextCapitalization(),
          maxLines: widget.type == TextFieldType.multiline
              ? (widget.maxLines ?? 4)
              : (widget.maxLines ?? 1),
          maxLength: widget.maxLength,
          inputFormatters: _getInputFormatters(),
          decoration: _buildDecoration(context),
          style: AppTextStyles.bodyLarge(color: AppColors.textPrimary),
          autovalidateMode: _autovalidateMode,
          validator: (value) {
            if (widget.validator != null) {
              final error = widget.validator!(value);
              if (error != null) {
                _enableAutoValidation();
              }
              setState(() {
                _errorText = error;
              });
              return error;
            }
            return null;
          },
          onChanged: (value) {
            // Limpiar error al cambiar texto si aún no hay validación automática
            if (_errorText != null && !_hasInteracted) {
              setState(() {
                _errorText = null;
              });
            }
            widget.onChanged?.call(value);
          },
          onEditingComplete: () {
            _enableAutoValidation();
          },
          onFieldSubmitted: widget.onSubmitted,
        ),
        if (widget.helperText != null && _errorText == null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.helperText!,
            style: AppTextStyles.caption(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.surfaceVariant,
      prefixIcon: widget.prefixIcon != null
          ? Icon(widget.prefixIcon, color: AppColors.textSecondary)
          : null,
      suffixIcon: _buildSuffixIcon(),
      errorText: _errorText,
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
      counterStyle: AppTextStyles.caption(color: AppColors.textSecondary),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffix != null) {
      return widget.suffix;
    }

    if (widget.type == TextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: AppColors.textSecondary,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return null;
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case TextFieldType.email:
        return TextInputType.emailAddress;
      case TextFieldType.number:
        return TextInputType.number;
      case TextFieldType.decimal:
        return const TextInputType.numberWithOptions(decimal: true);
      case TextFieldType.phone:
        return TextInputType.phone;
      case TextFieldType.multiline:
        return TextInputType.multiline;
      case TextFieldType.text:
      case TextFieldType.password:
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getDefaultTextInputAction() {
    switch (widget.type) {
      case TextFieldType.multiline:
        return TextInputAction.newline;
      default:
        return TextInputAction.done;
    }
  }

  TextCapitalization _getDefaultTextCapitalization() {
    switch (widget.type) {
      case TextFieldType.text:
      case TextFieldType.multiline:
        return TextCapitalization.sentences;
      case TextFieldType.email:
      case TextFieldType.password:
      case TextFieldType.number:
      case TextFieldType.decimal:
      case TextFieldType.phone:
        return TextCapitalization.none;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case TextFieldType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case TextFieldType.decimal:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ];
      case TextFieldType.phone:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }
}

/// Validadores comunes para CustomTextField
class TextFieldValidators {
  /// Validador para campo requerido
  static String? Function(String?) required(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName es requerido';
      }
      return null;
    };
  }

  /// Validador para email
  static String? Function(String?) email() {
    return (value) {
      if (value == null || value.isEmpty) return null;

      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );

      if (!emailRegex.hasMatch(value)) {
        return 'Email inválido';
      }
      return null;
    };
  }

  /// Validador para longitud mínima
  static String? Function(String?) minLength(int min, String fieldName) {
    return (value) {
      if (value == null || value.isEmpty) return null;

      if (value.length < min) {
        return '$fieldName debe tener al menos $min caracteres';
      }
      return null;
    };
  }

  /// Validador para longitud máxima
  static String? Function(String?) maxLength(int max, String fieldName) {
    return (value) {
      if (value == null || value.isEmpty) return null;

      if (value.length > max) {
        return '$fieldName debe tener máximo $max caracteres';
      }
      return null;
    };
  }

  /// Validador para número mayor que cero
  static String? Function(String?) positiveNumber() {
    return (value) {
      if (value == null || value.isEmpty) return null;

      final number = double.tryParse(value);
      if (number == null || number <= 0) {
        return 'Debe ser un número mayor que 0';
      }
      return null;
    };
  }

  /// Validador para número entero
  static String? Function(String?) integerNumber() {
    return (value) {
      if (value == null || value.isEmpty) return null;

      final number = int.tryParse(value);
      if (number == null) {
        return 'Debe ser un número entero';
      }
      return null;
    };
  }

  /// Validador para valor máximo
  static String? Function(String?) maxValue(int max, String fieldName) {
    return (value) {
      if (value == null || value.isEmpty) return null;

      final number = int.tryParse(value);
      if (number == null) return null;

      if (number > max) {
        return '$fieldName no puede ser mayor a $max';
      }
      return null;
    };
  }

  /// Combinar múltiples validadores
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
