import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final String buttonText;
  final double? iconSize;
  final IconData? icon;

  const CustomButton ({super.key, 
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
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? Colors.white,
          elevation: elevation ?? 0,
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