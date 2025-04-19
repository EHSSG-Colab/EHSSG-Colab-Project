import 'package:flutter/material.dart';

class VerticalMoreIconButton extends StatelessWidget {
  final Widget icon;
  final List<PopupMenuEntry<dynamic>> menuItems;

  const VerticalMoreIconButton({
    super.key,
    required this.icon,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: icon,
      itemBuilder: (context) => menuItems,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
