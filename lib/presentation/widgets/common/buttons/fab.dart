import 'package:flutter/material.dart';

class FabButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final Widget child;
  final double iconSize;
  final IconData icon;

  const FabButton({super.key, required this.onPressed, required this.backgroundColor, required this.foregroundColor, required this.elevation, required this.child, required this.iconSize, required this.icon});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      shape: const CircleBorder(),
      child: child,
    );
  }
}