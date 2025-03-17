import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/models/profile_details.dart';

class NewProfile extends StatefulWidget {
  const NewProfile({super.key, required this.onAddProfile});

  final void Function(ProfileDetails profile) onAddProfile;

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  final _nameController = TextEditingController();
  ReportingTownship _selectedTownship = ReportingTownship.Bawlake;
  ReportingVillage _selectedVillage =
      ReportingVillage.BaHan; 

  void _showDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Invalid input'),
            content: const Text('Please make sure a valid input was entered'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ],
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
    return Container(
      width: 100,
      height: 100,
      child: Text('test'),
    );
    // return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Please enter your name '),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButton(
                      value: _selectedTownship,
                      items:
                          ReportingTownship.values
                              .map(
                                (reportingTownship) => DropdownMenuItem(
                                  value: reportingTownship,
                                  child: Text(
                                    reportingTownship.name.toUpperCase(),
                                  ),
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

                    const SizedBox(height: 10),

                    DropdownButton<ReportingVillage>(
                      value: _selectedVillage,
                      items:
                          ReportingVillage.values
                              .map(
                                (reportingVillage) => DropdownMenuItem(
                                  value: reportingVillage,
                                  child: Text(
                                    reportingVillage.name.toUpperCase(),
                                  ),
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
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: _submitProfileData,
                      child: Text("Save Profile"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
