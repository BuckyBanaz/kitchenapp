import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CustomRedButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;

  const CustomRedButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final child = icon != null
        ? ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: textColor ?? Colors.white),
      label: Text(
        text,
        style: TextStyle(fontSize: 16, color: textColor ?? Colors.white),
      ),
      style: _buttonStyle,
    )
        : ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: textColor ?? Colors.white),
      ),
      style: _buttonStyle,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: SizedBox(width: double.infinity, child: child),
    );
  }

  ButtonStyle get _buttonStyle => ElevatedButton.styleFrom(
    backgroundColor: color ?? AppColors.primary,
    foregroundColor: textColor ?? Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );
}
