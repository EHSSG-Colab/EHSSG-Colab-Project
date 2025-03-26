import 'package:flutter/material.dart';

import '../../themes/app_theme.dart';

enum TileColor { primary, secondary, danger, info, warning }

class MyListTile extends StatelessWidget {
  final String label;
  final String value;
  final TileColor color;

  const MyListTile({
    super.key,
    required this.label,
    required this.value,
    this.color = TileColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color borderColor;
    Color textColor;

    switch (color) {
      case TileColor.primary:
        backgroundColor = colorScheme.primary.withOpacity(0.1);
        borderColor = colorScheme.primary.withOpacity(0.3);
        textColor = colorScheme.primary;
        break;
      case TileColor.secondary:
        backgroundColor = colorScheme.secondary.withOpacity(0.1);
        borderColor = colorScheme.secondary.withOpacity(0.3);
        textColor = colorScheme.secondary;
        break;
      case TileColor.danger:
        backgroundColor = colorScheme.error.withOpacity(0.1);
        borderColor = colorScheme.error.withOpacity(0.3);
        textColor = colorScheme.error;
        break;
      case TileColor.info:
        backgroundColor = Colors.blue.withOpacity(0.1);
        borderColor = Colors.blue.withOpacity(0.3);
        textColor = Colors.blue;
        break;
      case TileColor.warning:
        backgroundColor = Colors.orange.withOpacity(0.1);
        borderColor = Colors.orange.withOpacity(0.3);
        textColor = Colors.orange;
        break;
    }

    return ListTile(
      title: Text(label, style: AppTheme().labelMedium()),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(top: 4),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: IntrinsicWidth(
            child: Text(
              value,
              style: AppTheme().buttonLabel().copyWith(
                color: textColor,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
