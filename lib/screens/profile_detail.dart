// import 'package:flutter/material.dart';
// import 'package:malaria_case_report_01/provider/profile_provider.dart';
// import 'package:provider/provider.dart';

// import 'edit_profile.dart';

// class ProfileDetail extends StatelessWidget {
//   const ProfileDetail({super.key});

//   // Reusable method to build the profile graphic
//   Widget buildProfileGraphic() {
//     return Align(
//       alignment: Alignment.center,
//       child: Image.asset(
//         'assets/images/health_care_logo.png',
//         width: 300,
//         height: 200,
//         fit: BoxFit.contain,
//       ),
//     );
//   }

//   Widget _buildProfileField(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.blue),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Text(value, style: const TextStyle(fontSize: 16)),
//         ),
//         const SizedBox(height: 20),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final profile = Provider.of<ProfileProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text("User Profile")),
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Use the reusable method to display the profile graphic
//             buildProfileGraphic(),
//             const SizedBox(height: 20),
//             const Text(
//               'User Profile',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),

//             _buildProfileField("User ID", "6crh2oho-1421dqwf-141rfqwef-14fasf"),
//             _buildProfileField("Username", profile.username),
//             _buildProfileField(
//               "Township",
//               profile.township.toString().split('.').last,
//             ),
//             _buildProfileField(
//               "Village",
//               profile.village.toString().split('.').last,
//             ),

//             const SizedBox(height: 10), // Extra spacing to prevent overflow

//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const EditProfilePage(),
//                     ),
//                   );
//                 },
//                 icon: const Icon(Icons.edit),
//                 label: const Text("Edit Profile"),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                   textStyle: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ), // Prevent button from touching screen edge
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/layouts/scaffold_for_scroll_view.dart';
import '../widgets/unit_widgets/app_bar.dart';
import '../widgets/unit_widgets/elevated_button.dart';
import '../widgets/unit_widgets/list_tile.dart';
import 'update_profile.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({super.key});

  // Fetch user information from the shared preferences
  Future<Map<String, dynamic>> _getUserInfo() async {
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

  // Reusable method to build the profile graphic
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
    return FutureBuilder<Map<String, dynamic>>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final userInfo = snapshot.data!;
          return ScaffoldForScrollView(
            canPop: false,
            appBar: const MyAppBar(
              hasBackArrow: false,
              title: Text('Profile Detail'),
            ),
            children: [
              sizedBoxh20(),
              // Add the profile graphic
              buildProfileGraphic(),
              sizedBoxh20(),
              MyListTile(label: 'User ID:', value: userInfo['userId'] ?? 'N/A'),
              MyListTile(
                label: 'User Name:',
                value: userInfo['userName'] ?? 'N/A',
              ),
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
              MyButton(
                buttonLabel: 'Edit Profile',
                onPressed:
                    () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfile(navigateToIndex: 1),
                      ),
                      (route) => false,
                    ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
