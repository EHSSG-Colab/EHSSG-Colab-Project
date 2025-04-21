import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:malaria_report_mobile/providers/auth/auth_provider.dart';
import 'package:malaria_report_mobile/services/network_check.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';
import 'package:malaria_report_mobile/widgets/layouts/scaffold_for_scroll_view.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/elevated_button.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/sized_box.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/text_form_field.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = '';

  // To track if login is in progress
  bool _isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldForScrollView(
      canPop: false,
      children: [
        buildAppTitle(),
        buildLoginGraphic(),
        sizedBoxh20(),
        buildLoginColumn(),
      ],
    );
  }

  Widget buildAppTitle() {
    return Container(
      width: double.infinity,
      height: 100,
      alignment: const AlignmentDirectional(-1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
        child: Text(
          'Malaria Case Report',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }

  Widget buildLoginGraphic() {
    return Align(
      alignment: const AlignmentDirectional(0, 0),
      child: Image.asset(
        'assets/images/logo.png',
        width: 300,
        height: 150,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget buildLoginColumn() {
    return Container(
      width: double.infinity,
      alignment: const AlignmentDirectional(-1, 0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLoginText(),
            sizedBoxh10(),
            buildLoginDescription(),
            sizedBoxh10(),
            buildLoginForm(),
            buildCopyrightMessage(),
          ],
        ),
      ),
    );
  }

  Widget buildLoginText() {
    return Text('Login', style: Theme.of(context).textTheme.displayLarge);
  }

  Widget buildLoginDescription() {
    return const Text(
      'Please login with the user account created at Malaria Case Report Web Application.',
    );
  }

  Widget buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          MyTextFormField(
            myController: emailController,
            keyboardType: TextInputType.emailAddress,
            labelText: 'Email',
            placeholderText: 'Enter your email',
            validator: (String? value) {
              if (value!.trim().isEmpty) {
                return 'Please enter email';
              }
              return null;
            },
          ),
          sizedBoxh10(),
          MyPasswordFormField(
            myController: passwordController,
            labelText: 'Password',
            validator: (String? value) {
              if (value!.trim().isEmpty) {
                return 'Please enter passsword';
              }
              return null;
            },
          ),
          sizedBoxh10(),
          MyButton(
            buttonLabel: 'Log In',
            // Login button will be disabled when logging in process
            onPressed: _isLoggingIn ? (){} : () {
              submit();
            },
            backgroundColor: WidgetStatePropertyAll(
              AppTheme().secondaryColor(),
            ),
          ),
          Text(errorMessage, style: TextStyle(color: AppTheme().rosyColor())),
        ],
      ),
    );
  }

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }
    if (await NetworkCheck.isConnected()) {
      // Set login state to true to disable button
      setState(() {
        _isLoggingIn = true;
      });
      EasyLoading.show(status: 'logging in...');
      final AuthProvider provider = Provider.of<AuthProvider>(
        context,
        listen: false,
      );
      try {
        // login with user input credentials
        await provider.login(emailController.text, passwordController.text);

        // Show success message
        EasyLoading.showSuccess('Logged in successfully!');
      } catch (Exception) {
        setState(() {
          errorMessage = Exception.toString().replaceAll('Exception: ', '');
          EasyLoading.showError(errorMessage);
        });
      } finally {
        // Reset login state to false to enable button
        setState(() {
          _isLoggingIn = false;
        });
      }
    } else {
      // Show error message if no internet connection
      EasyLoading.showError('No Internet Connection');
    }
  }

  Widget buildCopyrightMessage() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Developed by EHSSG Internship.',
          style: TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}