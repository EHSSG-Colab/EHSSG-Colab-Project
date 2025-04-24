import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/themes/app_theme.dart';

class NotificationDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function onClick;

  const NotificationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: AppTheme().secondaryColor()),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await onClick();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              AppTheme().secondaryColor(),
            ),
          ),
          child: const Text('OK', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
