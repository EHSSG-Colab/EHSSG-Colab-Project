import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.buttonLabel,
    required this.onPressed,
    this.backgroundColor,
    this.outlined = false,
  });
  final String buttonLabel;
  final void Function() onPressed;
  final WidgetStateProperty<Color?>? backgroundColor;
  final bool outlined;

  // button loading status
  final bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        textStyle: AppTheme().buttonLabel(),
        backgroundColor:
            outlined ? Colors.transparent : AppTheme().secondaryColor(),
        foregroundColor:
            outlined
                ? AppTheme().secondaryColor()
                : AppTheme().primaryLightColor(),
        side: BorderSide(
          color:
              outlined
                  ? AppTheme().secondaryColor()
                  : AppTheme().transparentColor(),
        ),
        elevation: outlined ? 0 : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(buttonLabel),
    );
  }
}
