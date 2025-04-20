import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';

class MyFloatingButton extends StatelessWidget {
  const MyFloatingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.isVisible = true,
    this.tooltip,
    this.label,
  });
  final Icon icon; // Icon for the FAB
  final void Function() onPressed; // Action on click
  final Color? backgroundColor; // Background color customization
  final bool isVisible; // Visibility control
  final String? tooltip; // Tooltip for the FAB
  final String? label; // Text label for the FAB

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child:
          label != null
              ? FloatingActionButton.extended(
                onPressed: onPressed,
                backgroundColor: backgroundColor ?? AppTheme().secondaryColor(),
                tooltip: tooltip ?? 'Floating Button',
                icon: icon,
                label: Text(label!, style: AppTheme().buttonLabel()),
              )
              : FloatingActionButton(
                onPressed: onPressed,
                backgroundColor: backgroundColor ?? AppTheme().secondaryColor(),
                tooltip: tooltip ?? 'Floating Button',
                child: icon,
              ),
    );
  }
}
