import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController myController;
  final String labelText;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;
  const MyTextFormField(
      {super.key,
      required this.myController,
      required this.labelText,
      required this.validator,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      autocorrect: false,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
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
    );
  }
}

class MyPasswordFormField extends StatefulWidget {
  final TextEditingController myController;
  final String labelText;
  final FormFieldValidator<String> validator;
  const MyPasswordFormField(
      {super.key,
      required this.myController,
      required this.labelText,
      required this.validator});

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
        labelStyle: const TextStyle(
          fontFamily: 'Inter',
        ),
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
          child: Icon(obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
        ),
      ),
    );
  }
}