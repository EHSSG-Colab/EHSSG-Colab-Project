import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:malaria_report_mobile/providers/volunteer_provider.dart';
import 'package:malaria_report_mobile/services/shared_preferences.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/sized_box.dart';
import 'package:provider/provider.dart';
import '../constants/dropdown_options.dart';
import '../themes/app_theme.dart';
import '../widgets/layouts/scaffold_for_scroll_view.dart';
import '../widgets/unit_widgets/app_bar.dart';
import '../widgets/unit_widgets/elevated_button.dart';
import '../widgets/unit_widgets/nav_wrapper.dart';
import '../widgets/unit_widgets/simple_dropdown.dart';
import '../widgets/unit_widgets/simple_map_dropdown.dart';
import '../widgets/unit_widgets/text_form_field.dart';

class UpdateVolunteer extends StatefulWidget {
  // navigate to after the job is done
  final int? navigateToIndex;
  const UpdateVolunteer({super.key, this.navigateToIndex});

  @override
  State<UpdateVolunteer> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateVolunteer> {
  // username
  final TextEditingController _VolunteerNameController =
      TextEditingController();
  // user township
  String? _selectedVolunteerTownship;
  // user village
  String? _selectedVolunteerVillage;

  // filtered villages for cascading dropdown
  List<String> villages = []; // initially empty

  // other village
  final TextEditingController _otherVillageController = TextEditingController();
  // form key for validation
  final GlobalKey<FormState> _key = GlobalKey();
  // error message
  String? errorMessage;

  //useremail
  //  String? _selectedemail;

  @override
  void dispose() {
    _VolunteerNameController.dispose();
    _otherVillageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo().then((_) {
      // Populate villages list after user info is loaded
      if (_selectedVolunteerTownship != null) {
        setState(() {
          villages =
              Constants.townshipVillage.firstWhere(
                    (item) => item['township'] == _selectedVolunteerTownship,
                  )['villages']
                  as List<String>;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldForScrollView(
      canPop: context.read<VolunteerProvider>().isVolunteerProfileComplete,
      appBar: MyAppBar(
        hasBackArrow:
            context.read<VolunteerProvider>().isVolunteerProfileComplete,
        title: Text('Add Volunteer', style: AppTheme().displayLarge()),
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
          const Text('Volunteer Name:'),
          MyTextFormField(
            myController: _VolunteerNameController,
            labelText: 'please enter volunteer name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter volunteer name.';
              }
              return null;
            },
            onSaved: (value) => _VolunteerNameController,
          ),

          sizedBoxh20(),

          // Township
          SimpleMapSelect(
            // existing working code
            options: Constants.townshipVillage,
            label: 'Volunteer Township:',
            placeholder: 'please select township',
            initialValue: _selectedVolunteerTownship,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select township.';
              }
              return null;
            },
            onSelected: (String? selectedValue) {
              setState(() {
                _selectedVolunteerTownship = selectedValue;
                _selectedVolunteerVillage = null;
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
          //village
          // Village
          SimpleSelect(
            options: villages,
            label: 'Volunteer Village :',
            placeholder: 'please select village',
            initialValue: _selectedVolunteerVillage,
            disabledHintText: 'please select village',

            onSelected: (String? selectedValue) {
              setState(() {
                _selectedVolunteerVillage = selectedValue;
              });
            },
            key: UniqueKey(),
          ),
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
                  onPressed:
                      () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const NavWrapper(initialIndex: 1),
                        ),
                        (route) => false,
                      ),
                  outlined: true,
                  isVisible:
                      context
                          .read<VolunteerProvider>()
                          .isVolunteerProfileComplete,
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
      _VolunteerNameController.text = userInfo['userName'] ?? '';
      _selectedVolunteerTownship = userInfo['userTownship'];
      _selectedVolunteerVillage = userInfo['userVillage'];
    });
    // final apiUserInfo = await SharedPrefService.getUserApiInfo();
    // setState(() {
    //   _userNameController.text = apiUserInfo?.apiUsername ?? '';
    //   _selectedemail = apiUserInfo?.apiEmail ?? '';

    // });
  }

  // submit form
  Future<void> _submit() async {
    if (_key.currentState!.validate()) {
      final VolunteerProvider provider = Provider.of<VolunteerProvider>(
        context,
        listen: false,
      );
      try {
        await provider.updateVolunteerInfo(
          volunteerName: _VolunteerNameController.text,
          volunteerTownship: _selectedVolunteerTownship!,
          volunteerVillage: _selectedVolunteerVillage ?? '',
        );
        EasyLoading.showSuccess('Volunteer updated successfully');
      } catch (e) {
        setState(() {
          errorMessage = e.toString().replaceAll('Exception: ', '');
          EasyLoading.showError(errorMessage ?? '');
        });
      }

      // conditional navigation after the job is done
      if (widget.navigateToIndex != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder:
                (context) => NavWrapper(initialIndex: widget.navigateToIndex!),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }
}
