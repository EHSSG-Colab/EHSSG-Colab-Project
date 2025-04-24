import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/themes/app_theme.dart';

class MyCheckBoxListTile extends StatefulWidget {
  final String title;
  final bool initialValue;
  final Function(bool) onChanged;
  final bool disabled;
  const MyCheckBoxListTile({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
    this.disabled = false,
  });

  @override
  State<MyCheckBoxListTile> createState() => _MyCheckBoxListTileState();
}

class _MyCheckBoxListTileState extends State<MyCheckBoxListTile> {
  // initiate checked state with initial value
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 12,
          color:
              widget.disabled
                  ? AppTheme().disabledTextColor()
                  : AppTheme().grayTextColor(),
        ),
        // style: AppTheme().labelMedium().copyWith(
        //       color: widget.disabled
        //           ? AppTheme().disabledTextColor()
        //           : AppTheme().grayTextColor(),
        //     ),
      ),
      value: isChecked,
      checkboxShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: BorderSide(
        color:
            widget.disabled
                ? AppTheme().disabledTextColor()
                : AppTheme().grayTextColor(),
        width: 2,
      ),
      activeColor:
          widget.disabled
              ? AppTheme().disabledTextColor()
              : AppTheme().secondaryColor(),
      onChanged:
          widget.disabled
              ? null
              : (value) {
                setState(() {
                  isChecked = value!;
                });
                widget.onChanged(isChecked);
              },
    );
  }
}
