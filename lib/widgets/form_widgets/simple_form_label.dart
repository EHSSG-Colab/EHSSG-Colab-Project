import 'package:flutter/material.dart';

import '../../themes/app_theme.dart';

class MyFormLabel extends StatelessWidget {
  final String labelText;
  final bool isRequired;
  const MyFormLabel(
      {super.key, required this.labelText, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: labelText,
        style: const TextStyle(color: Colors.black),
        children: [
          if (isRequired)
            TextSpan(
              text: ' *',
              style: TextStyle(color: AppTheme().rosyColor()),
            ),
        ],
      ),
    );
  }
}
