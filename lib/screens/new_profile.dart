/*import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/models/profile_details.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';

class NewProfile extends StatefulWidget {
  const NewProfile({
    super.key,
    required this.profileDetails,
    required this.onAddProfile,
  });

  final ProfileDetails? profileDetails;
  final void Function(ProfileDetails profile) onAddProfile;

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  final _nameController = TextEditingController();
  ReportingTownship _selectedTownship = ReportingTownship.Bawlake;
  ReportingVillage _selectedVillage = ReportingVillage.BaHan;

  void _showDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              'Invalid input',
              style: AppTheme().labelLarge().copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme().primaryColor(),
              ),
            ),
            content: Text(
              'Please make sure a valid input was entered',
              style: AppTheme().labelMedium().copyWith(
                color: AppTheme().grayTextColor(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text(
                  'Okay',
                  style: AppTheme().labelMedium().copyWith(
                    color: AppTheme().secondaryColor(),
                  ),
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: AppTheme().backgroundColor(),
          ),
    );
  }

  void _submitProfileData() {
    if (_nameController.text.trim().isEmpty) {
      _showDialog();
      return;
    }
    widget.onAddProfile(
      ProfileDetails(
        Reporter_name: _nameController.text,
        ReportingTownship: _selectedTownship,
        ReportingVillage: _selectedVillage,
      ),
    );
    Navigator.pop(context);
  }

  void disposer() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   width: 100,
    //   height: 100,
    //   child: Text('test'),
    // );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Type your name",
            style: AppTheme().labelLarge().copyWith(
              fontWeight: FontWeight.bold,
            ), // Use theme text style
          ),
          SizedBox(height: 8),
          TextField(
            controller: _nameController,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Please enter your name',
              labelStyle: AppTheme().labelMedium(), // Use theme label style
              border:
                  AppTheme()
                      .normalOutlineInputBorder(), // Use custom border style from theme
            ),
          ),
          SizedBox(height: 20),

          Text(
            "Reporting Township",
            style: AppTheme().labelLarge().copyWith(
              fontWeight: FontWeight.bold,
            ), // Use theme text style
          ),
          SizedBox(height: 8),
          DropdownButton<ReportingTownship>(
            value: _selectedTownship,
            isExpanded: true,
            items:
                ReportingTownship.values
                    .map(
                      (reportingTownship) => DropdownMenuItem(
                        value: reportingTownship,
                        child: Text(reportingTownship.name.toUpperCase()),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedTownship = value;
              });
            },
          ),
          SizedBox(height: 20),

          Text(
            "Reporting Village",
            style: AppTheme().labelLarge().copyWith(
              fontWeight: FontWeight.bold,
            ), // Use theme text style
          ),
          SizedBox(height: 8),
          DropdownButton<ReportingVillage>(
            value: _selectedVillage,
            isExpanded: true,
            items:
                ReportingVillage.values
                    .map(
                      (reportingVillage) => DropdownMenuItem(
                        value: reportingVillage,
                        child: Text(reportingVillage.name.toUpperCase()),
                      ),
                    )
                    .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selectedVillage = value;
              });
            },
          ),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _submitProfileData,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      AppTheme().primaryColor(), // Text color set to white
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ), // Padding based on theme
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  "Save Profile",
                  style:
                      AppTheme()
                          .buttonLabel(), // Use button text style from theme
                ),
              ),
              SizedBox(width: 20),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: AppTheme().labelMedium().copyWith(
                    color: AppTheme().rosyColor(),
                  ), // Use theme text style for cancel
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
*/