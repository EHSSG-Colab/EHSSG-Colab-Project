import 'package:flutter/material.dart';

class VerticalMoreIconButton extends StatelessWidget {
  final Widget icon;
  final List<PopupMenuEntry<dynamic>> menuItems;
  /// Controls whether the button is enabled or disabled
  final bool enabled;
  /// Controls the opacity of the button when enabled/disabled
  final double opacity;

  const VerticalMoreIconButton({
    super.key,
    required this.icon,
    required this.menuItems,
    this.enabled = true, // Default to enabled
    this.opacity = 1.0, // Default to fully opaque
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: PopupMenuButton(
        enabled: enabled, // Use the enabled parameter to control button state
        icon: icon,
        itemBuilder: (context) => menuItems,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
