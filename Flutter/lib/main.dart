import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:malaria_report_mobile/providers/auth/auth_provider.dart';
import 'package:malaria_report_mobile/providers/malaria_provider.dart';
import 'package:malaria_report_mobile/providers/profile_provider.dart';
import 'package:malaria_report_mobile/providers/volunteer_provider.dart';
import 'package:malaria_report_mobile/screens/login.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/nav_wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MultiProvider(
            providers: [
              // providers are loaded here in the main.dart
              ChangeNotifierProvider(create: (context) => ProfileProvider()),
              ChangeNotifierProvider(create: (context) => VolunteerProvider()),
              ChangeNotifierProvider(create: (context) => MalariaProvider()),
            ],
            child: MaterialApp(
              title: 'Malaria Case Report',
              // register routes here so that we can call route names instead of full class names during navigation
              routes: {
                // the landing screen
                '/': (context) {
                  // if the user has logged in, show the navwrapper
                  // we are going to build the pages inside navwrapper to make navigation easier
                  final authProvider = Provider.of<AuthProvider>(
                    context,
                  ); // get the auth provider
                  if (authProvider.isAuthenticated) {
                    return const NavWrapper();
                  } else {
                    return Login();
                  }
                },
              },
              theme: ThemeData(
                fontFamily: 'Inter',
                textTheme: TextTheme(
                  displayLarge: AppTheme().displayLarge(),
                  labelMedium: AppTheme().labelMedium(),
                ),
                primaryColor: AppTheme().primaryColor(),
                highlightColor: AppTheme().highlightColor(),
                colorScheme: ColorScheme.fromSwatch(
                  backgroundColor: AppTheme().backgroundColor(),
                  accentColor: AppTheme().accentColor(),
                ),
                useMaterial3: true,
              ),
              debugShowCheckedModeBanner: false,
              builder: EasyLoading.init(),
            ),
          );
        },
      ),
    );
  }
}
