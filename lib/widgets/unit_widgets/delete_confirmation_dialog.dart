import 'package:flutter/material.dart';

import '../../themes/app_theme.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function onDelete;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onDelete,
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
            style: TextStyle(color: AppTheme().rosyColor()),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await onDelete();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              AppTheme().rosyColor(),
            ),
          ),
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
