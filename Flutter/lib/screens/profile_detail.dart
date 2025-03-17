import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/sized_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/layouts/scaffold_for_scroll_view.dart';
import '../widgets/unit_widgets/app_bar.dart';
import '../widgets/unit_widgets/elevated_button.dart';
import '../widgets/unit_widgets/list_tile.dart';
import '../widgets/unit_widgets/logo_container.dart';
import 'update_profile.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({super.key});

  // Fetch user information from the shared preferences
  // A map is like an array in javascript
  Future<Map<String, dynamic>> _getUserInfo() async {
    // Load shared preferences
    final prefs = await SharedPreferences.getInstance();

    return {
      'userId': prefs.getInt('userId').toString(),
      'userName': prefs.getString('userName') ?? '',
      'userTownship': prefs.getString('userTownship') ?? '',
      'userVillage': prefs.getString('userVillage') ?? '',
      'villageNotFound': prefs.getBool('villageNotFound') ?? false,
      'userOtherVillage': prefs.getString('userOtherVillage') ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final userInfo = snapshot.data!;
          return ScaffoldForScrollView(
            canPop: false,
            appBar: const MyAppBar(
                hasBackArrow: false, title: Text('Profile Detail')),
            children: [
              sizedBoxh20(),
              const LogoContainer(
                width: 200,
              ),
              sizedBoxh20(),
              MyListTile(label: 'User ID:', value: userInfo['userId'] ?? 'N/A'),
              MyListTile(
                  label: 'User Name:', value: userInfo['userName'] ?? 'N/A'),
              MyListTile(
                  label: 'Township:', value: userInfo['userTownship'] ?? 'N/A'),
              MyListTile(
                  label: 'Village:',
                  value: userInfo['villageNotFound'] == true
                      ? userInfo['userOtherVillage'] ?? 'N/A'
                      : userInfo['userVillage'] ?? 'N/A'),
              MyButton(
                buttonLabel: 'Edit Profile',
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateProfile(
                              navigateToIndex: 1,
                            )),
                    (route) => false),
              )
            ],
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}