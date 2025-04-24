import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/themes/app_theme.dart';

class MyListTileRecordsWithBadge extends StatelessWidget {
  final String caption;
  final String label;
  final Icon? leadingIcon;
  final Widget? trailingButton;
  final List<Widget>? badges;

  const MyListTileRecordsWithBadge({
    super.key,
    required this.caption,
    required this.label,
    this.leadingIcon,
    this.trailingButton,
    this.badges,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme().listTileBackgroundColor(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      child: ListTile(
        title: Row(
          children: [
            Text('$caption | $label', style: AppTheme().labelSmallBold()),
          ],
        ),
        // subtitle: Text(value, style: AppTheme().labelSmall()),
        subtitle: Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 1,
          runSpacing: 10,
          children: [if (badges != null) ...badges!],
        ),
        leading: leadingIcon,
        trailing: trailingButton,
        iconColor: AppTheme().secondaryDarkColor(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
      ),
    );
  }
}
