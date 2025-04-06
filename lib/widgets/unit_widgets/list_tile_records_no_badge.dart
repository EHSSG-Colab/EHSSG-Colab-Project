import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class MyListTileRecordsNoBadge extends StatelessWidget {
  final String caption;
  final String label;
  final Icon? leadingIcon;
  final Widget? trailingButton;
  final List<Widget>? badges;

  const MyListTileRecordsNoBadge({
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
          children: [Text(caption, style: AppTheme().labelSmallBold())],
        ),
        subtitle: Text(label, style: AppTheme().labelSmall()),
        leading: leadingIcon,
        trailing: trailingButton,
        iconColor: AppTheme().secondaryDarkColor(),
        contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
      ),
    );
  }
}
