import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:malaria_case_report_01/provider/profile_provider.dart'
    show ProfileProvider;
import 'package:malaria_case_report_01/services/shared_preferences.dart';

import 'package:provider/provider.dart';

import '../constants/dropdown_options.dart';

import '../themes/app_theme.dart';
import '../widgets/layouts/scaffold_for_scroll_view.dart';
import '../widgets/unit_widgets/app_bar.dart';
import '../widgets/unit_widgets/checkbox.dart';
import '../widgets/unit_widgets/elevated_button.dart';
import '../widgets/unit_widgets/nav_wrapper.dart';
import '../widgets/unit_widgets/simple_dropdown.dart';
import '../widgets/unit_widgets/simple_map_dropdown.dart';
import '../widgets/unit_widgets/text_form_field.dart';

class UpdateProfile extends StatefulWidget {
  // navigate to after the job is done
  final int? navigateToIndex;
  const UpdateProfile({super.key, this.navigateToIndex});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  // username
  final TextEditingController _userNameController = TextEditingController();
  // user township
  String? _selectedTownship;
  // user village
  String? _selectedVillage;

  // filtered villages for cascading dropdown
  List<String> villages = []; // initially empty

  // village not found initial value
  bool _villageNotFound = false;
  // other village
  final TextEditingController _otherVillageController = TextEditingController();
  // form key for validation
  final GlobalKey<FormState> _key = GlobalKey();
  // error message
  String? errorMessage;

  @override
  void dispose() {
    _userNameController.dispose();
    _otherVillageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo().then((_) {
      // Populate villages list after user info is loaded
      if (_selectedTownship != null) {
        setState(() {
          villages =
              Constants.townshipVillage.firstWhere(
                    (item) => item['township'] == _selectedTownship,
                  )['villages']
                  as List<String>;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldForScrollView(
      canPop: context.read<ProfileProvider>().isProfileComplete,
      appBar: MyAppBar(
        hasBackArrow: context.read<ProfileProvider>().isProfileComplete,
        title: Text('Update Profile', style: AppTheme().displayLarge()),
      ),
      children: children,
    );
  }

  List<Widget> get children => [
    Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizedBoxh20(),

          // Name
          const Text('Reporting Person/ အချက်အလက်ပေးပို့သူအမည်:'),
          MyTextFormField(
            myController: _userNameController,
            labelText: 'please enter your name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name.';
              }
              return null;
            },
            onSaved: (value) => _userNameController,
          ),

          sizedBoxh20(),

          // Township
          SimpleMapSelect(
            // existing working code
            options: Constants.townshipVillage,
            label: 'Reporting Township/မြို့နယ်:',
            placeholder: 'please select township',
            initialValue: _selectedTownship,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select township.';
              }
              return null;
            },
            onSelected: (String? selectedValue) {
              setState(() {
                _selectedTownship = selectedValue;
                _selectedVillage = null;
                villages =
                    Constants.townshipVillage.firstWhere(
                          (item) => item['township'] == selectedValue,
                        )['villages']
                        as List<String>;
              });
            },
            key: UniqueKey(),
            labelKey: 'township',
            valueKey: 'township',
          ),

          sizedBoxh20(),

          // Village
          SimpleSelect(
            options: villages,
            label: 'Reporting Village/ ကျေးရွာ :',
            placeholder: 'please select village',
            initialValue: _selectedVillage,
            disabledHintText: 'please select village',
            validator:
                _villageNotFound
                    ? null
                    : (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select village.';
                      }
                      return null;
                    },
            onSelected: (String? selectedValue) {
              setState(() {
                _selectedVillage = selectedValue;
              });
            },
            disabled: _villageNotFound,
            key: UniqueKey(),
          ),

          // village not found
          MyCheckBoxListTile(
            title: 'ကျေးရွာအမည်ရှာမတွေ့ပါ',
            initialValue: _villageNotFound,
            onChanged:
                (value) => setState(() {
                  _villageNotFound = value;
                  if (value) {
                    setState(() {
                      _selectedVillage = null;
                    });
                  } else {
                    setState(() {
                      _otherVillageController.clear();
                    });
                  }
                }),
          ),

          // other village
          if (_villageNotFound)
            MyTextFormField(
              myController: _otherVillageController,
              labelText: 'please enter village name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter village name.';
                }
                return null;
              },
            ),

          sizedBoxh20(),

          Row(
            children: [
              // submit button
              Expanded(
                flex: 2,
                child: MyButton(
                  buttonLabel: 'Save Profile',
                  onPressed: _submit,
                ),
              ),
              sizedBoxw10(),
              Expanded(
                flex: 1,
                child: MyButton(
                  buttonLabel: 'Cancel',
                  onPressed: () => Navigator.pop(context), // simply go back
                  outlined: true,
                  isVisible: context.read<ProfileProvider>().isProfileComplete,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ];

  // preload user info
  Future<void> _loadUserInfo() async {
    final userInfo = await SharedPrefService.getUserInfo();
    setState(() {
      _userNameController.text = userInfo['userName'] ?? '';
      _selectedTownship = userInfo['userTownship'];
      _selectedVillage = userInfo['userVillage'];
      _villageNotFound = userInfo['villageNotFound'] ?? false;
      _otherVillageController.text = userInfo['userOtherVillage'] ?? '';
    });
  }

  // submit form
  Future<void> _submit() async {
    if (_key.currentState!.validate()) {
      final ProfileProvider provider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );
      try {
        await provider.updateUserInfo(
          userName: _userNameController.text,
          userTownship: _selectedTownship!,
          userVillage: _selectedVillage ?? '',
          villageNotFound: _villageNotFound,
          userOtherVillage: _otherVillageController.text,
        );
        EasyLoading.showSuccess('Profile updated successfully');

        // conditional navigation after the job is done
        if (widget.navigateToIndex != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      NavWrapper(initialIndex: widget.navigateToIndex!),
            ),
          );
        } else {
          Navigator.pop(context); // just go back if no index is provided
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      } catch (e) {
        setState(() {
          errorMessage = e.toString().replaceAll('Exception: ', '');
          EasyLoading.showError(errorMessage ?? '');
        });
      }
    }
  }
}
