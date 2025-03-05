import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:malaria_report_mobile/providers/auth/auth_provider.dart';
import 'package:malaria_report_mobile/screens/login.dart';
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
      child: MaterialApp(
        title: 'Malaria Case Report',
        theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Inter'),
        debugShowCheckedModeBanner: false,
        home: Login(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
