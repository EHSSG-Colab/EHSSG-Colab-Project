import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/screens/update_profile.dart';
import 'package:malaria_case_report_01/widgets/layouts/scaffold_for_scroll_view.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/app_bar.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/elevated_button.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/list_tile.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/logo_container.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/sized_box.dart';

import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    // Ensure the profile provider is initialized
    if (!profileProvider.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // get logged in user information from the profile provider
    final userInfo = profileProvider.userInfo;
    return ScaffoldForScrollView(
      canPop: false,
      appBar: const MyAppBar(
        hasBackArrow: false,
        title: Text('Profile Detail'),
      ),
      children: [
        sizedBoxh20(),
        const LogoContainer(width: 200),
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
        MyButton(
          buttonLabel: 'Edit Profile',
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProfile(navigateToIndex: 1),
                ),
              ),
        ),
      ],
    );
  }
}

/*
class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key, this.profileDetails});

  final ProfileDetails? profileDetails;
  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  final List<ProfileDetails> _profileDetails = [];
  //  ProfileDetails profileDetails = ProfileDetails(
  //     id: DateTime.now().toString(), // Example ID generation
  //     Reporter_name: '',
  //     ReportingTownship:  ,
  //     ReportingVillage: ,

  //   );

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize with existing data or create new empty profile
  //   profileDetails = widget.profileDetails ?? ProfileDetails(
  //     id: DateTime.now().toString(), // Example ID generation
  //     Reporter_name: '',
  //     ReportingTownship:  ,
  //     ReportingVillage: ,
  //     name: '',
  //   );
  // }

  void _openAddProfileOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      // builder: (ctx) => NewProfile(onAddProfile: _addProfile),
      builder:
          (context) => NewProfile(
            profileDetails: widget.profileDetails,
            onAddProfile: _addProfile,
          ),
      // builder: (context) => Container(
      //   height: 500,
      //   child: Column(children: [Text('test')],),
      // )
    );
  }

  void _addProfile(ProfileDetails profiledetails) {
    setState(() {
      _profileDetails.add(profiledetails);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(child: Text('No Profile Yet. Please add some'));

    if (_profileDetails.isNotEmpty) {
      mainContent = ProfileDetail(profileDetails: _profileDetails[0]);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme().primaryColor(), 
        elevation: 2, 
        title: Text(
          'Profile Detail',
          style: AppTheme().displayLarge().copyWith(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, 
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Image.asset(
                'assets/images/cliniclogo.jpg',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._profileDetails.map((profile) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reporter Name:",
                            style: AppTheme().labelLarge().copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme().primaryColor(),
                            ),
                          ),
                          Text(
                            profile.Reporter_name ?? 'N/A',
                            style: AppTheme().labelMedium().copyWith(
                              color: AppTheme().grayTextColor(),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "Reporting Township:",
                            style: AppTheme().labelLarge().copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme().primaryColor(),
                            ),
                          ),
                          Text(
                            profile.ReportingTownship?.name ?? 'N/A',
                            style: AppTheme().labelMedium().copyWith(
                              color: AppTheme().grayTextColor(),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "Reporting Village:",
                            style: AppTheme().labelLarge().copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme().primaryColor(),
                            ),
                          ),
                          Text(
                            profile.ReportingVillage?.name ?? 'N/A',
                            style: AppTheme().labelMedium().copyWith(
                              color: AppTheme().grayTextColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     ..._profileDetails.map((profile) {
          //       return Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "User Name: ${profile.Reporter_name}",
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           ),
          //           Text("Township: ${profile.ReportingTownship.name}"),
          //           Text("Village: ${profile.ReportingVillage.name}"),
          //           SizedBox(height: 10),
          //         ],
          //       );
          //     }).toList(),
          //   ],
          // ),

          // Wrap(
          //   spacing: 8.0, // Horizontal space between widgets
          //   runSpacing: 4.0, // Vertical space between lines
          //   children:
          //       _profileDetails.map((profile) {
          //         return Card(
          //           child: Padding(
          //             padding: EdgeInsets.all(8.0),
          //             child: Column(
          //               children: [
          //                 Text(
          //                   "Reporter: ${profile.Reporter_name}",
          //                   style: TextStyle(fontWeight: FontWeight.bold),
          //                 ),
          //                 Text("Township: ${profile.ReportingTownship.name}"),
          //                 Text("Village: ${profile.ReportingVillage.name}"),
          //               ],
          //             ),
          //           ),
          //         );
          //       }).toList(),
          // ),

          // Text(
          //   "Profile ID: ${widget.profileDetails?.id ?? 'N/A'}",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: 10),
          // Text(
          //   "Reporter Name: ${widget.profileDetails?.Reporter_name ?? 'N/A'}",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: 10),

          // Text(
          //   "Reporting Township: ${widget.profileDetails?.ReportingTownship ?? 'N/A'}",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: 10),
          // Text(
          //   "Reporting Village: ${widget.profileDetails?.ReportingVillage ?? 'N/A'}",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: 15),
          // ElevatedButton(
          //   onPressed: _openAddProfileOverlay,
          //   child: Text("Edit Profile"),
          // ),
          ElevatedButton(
            onPressed: _openAddProfileOverlay,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
                  AppTheme().primaryColor(), // Text color set to white
              shape: RoundedRectangleBorder(
                // Rounded corners
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ), 
              elevation: 5, 
            ),
            child: Text(
              "Edit Profile",
              style:
                  AppTheme().buttonLabel(), // Use button text style from theme
            ),
          ),

          // Card(
          //   margin: EdgeInsets.all(16),
          //   child: Padding(
          //     padding: EdgeInsets.all(16),
          //     child: mainContent,
          //   ),
          // ),
        ],
      ),
    );
  }
}
*/
