import 'package:flutter/material.dart';

import '../../themes/app_theme.dart';

class MyRadio extends StatelessWidget {
  final List<String> options;
  final String label;
  final List<String> optionLabels;
  final String? value;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool disabled;
  final bool isRequired;
  final bool isHorizontal;
  const MyRadio({
    super.key,
    required this.options,
    required this.label,
    required this.optionLabels,
    this.value,
    required this.onChanged,
    this.validator,
    this.disabled = false,
    this.isRequired = false,
    this.isHorizontal = false,
  }) : assert(
         options.length == optionLabels.length,
         'Options and optionLabels must have the same length',
       );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(color: Colors.black),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppTheme().rosyColor()),
                ),
            ],
          ),
        ),
        FormField<String>(
          validator: validator,
          initialValue: value,
          builder: (FormFieldState<String> state) {
            return Column(
              children: [
                if (isHorizontal)
                  Wrap(
                    direction: Axis.horizontal,
                    children: _buildRadioOptions(state),
                  )
                else
                  Column(children: _buildRadioOptions(state)),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                    child: Text(
                      state.errorText ?? '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildRadioOptions(FormFieldState<String> state) {
    return List.generate(options.length, (index) {
      String option = options[index];
      String optionLabel = optionLabels[index];
      return SizedBox(
        width: isHorizontal ? null : double.infinity,
        child: RadioListTile<String>(
          title: Text(
            optionLabel,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.normal,
              fontSize: 14,
              color:
                  disabled
                      ? AppTheme().disabledTextColor()
                      : AppTheme().grayTextColor(),
            ),
          ),
          value: option,
          groupValue: state.value,
          onChanged:
              disabled
                  ? null
                  : (String? newValue) {
                    state.didChange(newValue);
                    onChanged(newValue);
                  },
          activeColor: AppTheme().secondaryColor(),
          tileColor: AppTheme().primaryLightColor(),
        ),
      );
    });
  }
}
