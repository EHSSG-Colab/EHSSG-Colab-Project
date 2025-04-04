import 'package:flutter/material.dart';

class TappableIcon extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  const TappableIcon({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: icon,
      ),
    );
  }
}