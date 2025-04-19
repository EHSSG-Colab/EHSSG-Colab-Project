import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';

class MyIconTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String label;
  const MyIconTextButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label, style: AppTheme().labelMediumBold()),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: AppTheme().secondaryDarkColor(),
        foregroundColor: Colors.white,
      ),
    );
  }
}
