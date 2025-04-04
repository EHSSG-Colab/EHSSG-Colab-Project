import 'package:flutter/material.dart';

import '../../themes/app_icons.dart';
import '../../themes/app_theme.dart';

class SimpleMapSelect extends StatefulWidget {
  final List<Map<String, dynamic>> options;
  final String label;
  final String? placeholder;
  final String? disabledHintText;
  final String? initialValue;
  final void Function(String?) onSelected;
  final String? Function(String?)? validator;
  final bool disabled;
  final bool isRequired;
  final String labelKey;
  final String valueKey;
  const SimpleMapSelect({
    super.key,
    required this.options,
    required this.label,
    this.placeholder,
    this.disabledHintText,
    this.initialValue,
    required this.onSelected,
    this.validator,
    this.disabled = false,
    this.isRequired = false,
    required this.labelKey,
    required this.valueKey,
  });

  @override
  State<SimpleMapSelect> createState() => _SimpleMapSelectState();
}

class _SimpleMapSelectState extends State<SimpleMapSelect> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  // Helper method to check if the selected value exists in options
  bool _valueExistsInOptions(String? value) {
    if (value == null) return false;
    return widget.options.any((option) => option[widget.valueKey].toString() == value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: const TextStyle(color: Colors.black),
            children: [
              if (widget.isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppTheme().rosyColor()),
                ),
            ],
          ),
        ),
        FormField(
          validator: (value) {
            if (widget.validator != null) {
              return widget.validator!(_selectedValue);
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  // Only set value if it exists in the options list
                  value: _valueExistsInOptions(_selectedValue) ? _selectedValue : null,
                  hint: Text(
                    widget.placeholder ?? 'Select an option',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      color: AppTheme().grayTextColor(),
                    ),
                  ),
                  disabledHint: Text(
                    widget.disabledHintText ?? 'disabled',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.normal,
                      color: AppTheme().disabledTextColor(),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: AppTheme().grayTextColor(),
                  ),
                  isExpanded: true,
                  decoration: InputDecoration(
                    enabledBorder: AppTheme().normalOutlineInputBorder(),
                    focusedBorder: AppTheme().focusedOutlineInputBorder(),
                    contentPadding: const EdgeInsetsDirectional.fromSTEB(
                      20,
                      0,
                      0,
                      0,
                    ),
                    filled: true,
                    fillColor: AppTheme().primaryLightColor(),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        AppIcons().dropdownIcon().icon,
                        color: AppTheme().secondaryDarkColor(),
                      ),
                    ),
                  ),
                  icon: const SizedBox.shrink(),
                  items:
                      widget.options.map((Map<String, dynamic> option) {
                        return DropdownMenuItem<String>(
                          value: option[widget.valueKey].toString(),
                          child: Text(option[widget.labelKey].toString()),
                        );
                      }).toList(),
                  onChanged:
                      widget.disabled
                          ? null
                          : (String? newValue) {
                            setState(() {
                              _selectedValue = newValue;
                            });
                            widget.onSelected(newValue);
                            state.didChange(newValue);
                            state.validate();
                          },
                ),
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
}