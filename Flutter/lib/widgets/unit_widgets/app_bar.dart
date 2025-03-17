
import 'package:flutter/material.dart';

import '../../themes/app_theme.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(
      {super.key,
      this.title,
      required this.hasBackArrow,
      this.leadingIcon,
      this.actions,
      this.leadingIconOnPressed});

  final Widget? title;
  final bool hasBackArrow;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingIconOnPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: hasBackArrow
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new_outlined))
          : leadingIcon != null
              ? IconButton(
                  onPressed: leadingIconOnPressed, icon: Icon(leadingIcon))
              : null,
      title: title,
      actions: actions,
      backgroundColor: AppTheme().secondaryColor(),
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.grey,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppTheme.appBarHeight());
}