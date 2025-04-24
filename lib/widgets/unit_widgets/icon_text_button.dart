import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/themes/app_theme.dart';

class MyIconTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final String label;
  final double opacity;
  const MyIconTextButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(label, style: AppTheme().labelMediumBold()),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: AppTheme().secondaryDarkColor(),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
