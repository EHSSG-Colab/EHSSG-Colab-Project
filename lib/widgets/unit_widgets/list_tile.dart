import 'package:flutter/material.dart';

import 'package:malaria_report_mobile/themes/app_theme.dart';

enum TileColor { primary, secondary, danger, warning, info }

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
    Color textColor;
    Color borderColor;

    switch (color) {
      case TileColor.primary:
        backgroundColor = colorScheme.primary.withAlpha(20);
        borderColor = colorScheme.primary.withAlpha(50);
        textColor = colorScheme.primary;
        break;
      case TileColor.secondary:
        backgroundColor = colorScheme.secondary.withAlpha(20);
        borderColor = colorScheme.secondary.withAlpha(50);
        textColor = colorScheme.secondary;
        break;
      case TileColor.danger:
        backgroundColor = colorScheme.error.withAlpha(20);
        borderColor = colorScheme.error.withAlpha(50);
        textColor = colorScheme.error;
        break;
      case TileColor.warning:
        backgroundColor = Colors.orange;
        borderColor = Colors.orange;
        textColor = Colors.orange;
        break;
      case TileColor.info:
        backgroundColor = Colors.blue;
        textColor = Colors.blue;
        borderColor = Colors.blue;
        break;
    }

    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
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
