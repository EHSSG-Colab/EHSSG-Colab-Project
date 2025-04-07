import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/provider/profile_provider.dart';
import 'package:malaria_case_report_01/screens/update_profile.dart';
import 'package:malaria_case_report_01/widgets/layouts/scaffold_for_scroll_view.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/app_bar.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/elevated_button.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/list_tile.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/sized_box.dart';
import 'package:provider/provider.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({super.key});

  Widget buildProfileGraphic() {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/health_care_logo.png',
        width: 300,
        height: 300,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    if (!profileProvider.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final userInfo = profileProvider.userInfo;
    return ScaffoldForScrollView(
      canPop: false,
      appBar: const MyAppBar(
        hasBackArrow: false,
        title: Text('Profile Detail'),
      ),
      children: [
        sizedBoxh20(),
        buildProfileGraphic(),
        sizedBoxh20(),
        MyListTile(label: 'User ID:', value: userInfo['userId'] ?? 'N/A'),
        MyListTile(label: 'User Name:', value: userInfo['userName'] ?? 'N/A'),
        MyListTile(
          label: 'Township:',
          value: userInfo['userTownship'] ?? 'N/A',
        ),
        MyListTile(
          label: 'Village:',
          value:
              userInfo['villageNotFound'] == true
                  ? userInfo['userOtherVillage'] ?? 'N/A'
                  : userInfo['userVillage'] ?? 'N/A',
        ),
        sizedBoxh20(),
        MyButton(
          buttonLabel: 'Edit Profile',
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateProfile(navigateToIndex: 1),
                ),
              ),
        ),
      ],
    );
  }
}
