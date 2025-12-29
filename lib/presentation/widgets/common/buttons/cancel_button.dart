import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final String buttonText;
  final double? iconSize;
  final IconData? icon;

  const CancelButton({super.key,
  required this.buttonText,
  required this.onPressed,
   this.backgroundColor,
   this.foregroundColor,
   this.elevation,
   this.iconSize,
   this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? AppColors.primary,
          side: BorderSide(
            color: foregroundColor ?? AppColors.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: iconSize ?? 20),
                  const SizedBox(width: 8),
                  Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}