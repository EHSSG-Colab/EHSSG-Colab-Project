import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:malaria_case_report_01/providers/auth/auth_provider.dart';
import 'package:malaria_case_report_01/providers/malaria_provider.dart';
import 'package:malaria_case_report_01/providers/profile_provider.dart';
import 'package:malaria_case_report_01/screens/login.dart';
import 'package:malaria_case_report_01/screens/update_profile.dart';
import 'package:malaria_case_report_01/themes/app_theme.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/nav_wrapper.dart';
import 'package:provider/provider.dart';

import 'providers/volunteer_provider.dart';
import 'screens/update_malaria.dart';

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
            child: Consumer<ProfileProvider>(
              builder: (
                BuildContext context,
                ProfileProvider value,
                Widget? child,
              ) {
                return MaterialApp(
                  title: 'Malaria Case Report',
                  initialRoute: '/',
                  // register routes here so that we can call route names instead of full class names during navigation
                  routes: {
                    // the landing screen
                    '/': (context) {
                      // if the user has logged in, show the navwrapper
                      // we are going to build the pages inside navwrapper to make navigation easier
                      final authProvider = Provider.of<AuthProvider>(
                        context,
                      ); // get the auth provider

                      final profileProvider = Provider.of<ProfileProvider>(
                        context,
                        listen: false,
                      ); // get the profile provider

                      // redirect to login if not logged in
                      if (!authProvider.isAuthenticated) {
                        return Login();
                      }
                      // redirect to update profile if profile information is not complete
                      if (!profileProvider.isProfileComplete) {
                        EasyLoading.instance.userInteractions =
                            true; // allow user interaction
                        EasyLoading.instance.dismissOnTap =
                            true; // will close on tap
                        EasyLoading.instance.displayDuration = const Duration(
                          milliseconds: 3000,
                        ); // duration of the message
                        EasyLoading.showInfo('Please update your profile.');

                        return UpdateProfile(navigateToIndex: 1);
                      }

                      // Otherwise return the Navwrapper
                      return const NavWrapper();
                    },
                    // Update malaria route
                    '/update-malaria':
                        (context) => const UpdateMalaria(
                          operation: 'Add',
                          navigateToIndex: 0,
                        ),
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
