import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:malaria_case_report_01/themes/app_theme.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController myController;
  final String labelText;
  final String? placeholderText;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;
  final bool isNumeric;
  final bool isRequired;
  final FormFieldSetter<String>? onSaved;
  const MyTextFormField({
    super.key,
    required this.myController,
    required this.labelText,
    this.placeholderText,
    required this.validator,
    this.onSaved,
    this.keyboardType,
    this.isNumeric = false,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
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
        ),
        TextFormField(
          controller: myController,
          autocorrect: false,
          autofocus: false,
          keyboardType: keyboardType,
          textCapitalization: TextCapitalization.words,
          validator: validator,
          onSaved: onSaved,
          inputFormatters:
              isNumeric ? [FilteringTextInputFormatter.digitsOnly] : null,
          style: TextStyle(
            fontFamily: 'Inter',
            color: AppTheme().grayTextColor(),
            fontSize: MediaQuery.of(context).size.width * 0.03,
          ),
          cursorColor: AppTheme().secondaryDarkColor(),
          decoration: InputDecoration(
            labelText: placeholderText,
            labelStyle: TextStyle(
              fontFamily: 'Inter',
              color: AppTheme().grayTextColor(),
            ),
            contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: AppTheme().normalOutlineInputBorder(),
            focusedBorder: AppTheme().focusedOutlineInputBorder(),
            errorBorder: AppTheme().errorOutlineInputBorder(),
            focusedErrorBorder: AppTheme().errorOutlineInputBorder(),
            filled: true,
            fillColor: AppTheme().primaryLightColor(),
          ),
        ),
      ],
    );
  }
}

class MyPasswordFormField extends StatefulWidget {
  final TextEditingController myController;
  final String labelText;
  final FormFieldValidator<String> validator;
  const MyPasswordFormField({
    super.key,
    required this.myController,
    required this.labelText,
    required this.validator,
  });

  @override
  State<MyPasswordFormField> createState() => _MyPasswordFormFieldState();
}

class _MyPasswordFormFieldState extends State<MyPasswordFormField> {
  bool autocorrect = false;
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.myController,
      obscureText: obscureText,
      autocorrect: autocorrect,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(fontFamily: 'Inter'),
        contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: AppTheme().normalOutlineInputBorder(),
        focusedBorder: AppTheme().focusedOutlineInputBorder(),
        errorBorder: AppTheme().errorOutlineInputBorder(),
        focusedErrorBorder: AppTheme().errorOutlineInputBorder(),
        filled: true,
        fillColor: AppTheme().primaryLightColor(),
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }
}
