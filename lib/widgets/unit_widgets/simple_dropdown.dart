
import 'package:flutter/material.dart';

import 'package:malaria_report_mobile/themes/app_icons.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';

class SimpleSelect extends StatefulWidget {
  final List<String> options;
  final String label;
  final String? placeholder;
  final String? disabledHintText;
  final String? initialValue;
  final void Function(String?) onSelected;
  final String? Function(String?)? validator;
  final bool disabled;
  final bool isRequired;
  final bool showClearIcon;
  const SimpleSelect({
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
    this.showClearIcon = true,
  });

  @override
  State<SimpleSelect> createState() => _SimpleSelectState();
}

class _SimpleSelectState extends State<SimpleSelect> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
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
                    value: widget.options.contains(_selectedValue)
                        ? _selectedValue
                        : null,
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
                        contentPadding:
                            const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                        filled: true,
                        fillColor: AppTheme().primaryLightColor(),
                        suffixIcon:
                            widget.showClearIcon && _selectedValue != null
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedValue = null;
                                      });
                                      widget.onSelected(null);
                                      state.didChange(null);
                                      if (widget.validator != null) {
                                        state.validate();
                                      }
                                    },
                                    icon: AppIcons().clearIcon(),
                                    color: AppTheme().secondaryDarkColor())
                                : Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      AppIcons().dropdownIcon().icon,
                                      color: AppTheme().secondaryDarkColor(),
                                    ),
                                  )),
                    icon: const SizedBox.shrink(),
                    items: widget.options.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: widget.disabled
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
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                ]);
          },
        ),
      ],
    );
  }
}