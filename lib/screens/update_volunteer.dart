import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/sized_box.dart';

import 'package:provider/provider.dart';
import '../constants/dropdown_options.dart';
import '../providers/volunteer_provider.dart';
import '../themes/app_icons.dart';
import '../widgets/layouts/scaffold_for_scroll_view.dart';
import '../widgets/unit_widgets/app_bar.dart';
import '../widgets/unit_widgets/delete_confirmation_dialog.dart';
import '../widgets/unit_widgets/elevated_button.dart';
import '../widgets/unit_widgets/nav_wrapper.dart';
import '../widgets/unit_widgets/simple_dropdown.dart';
import '../widgets/unit_widgets/simple_map_dropdown.dart';
import '../widgets/unit_widgets/tappable_icon.dart';
import '../widgets/unit_widgets/text_form_field.dart';

class UpdateVolunteer extends StatefulWidget {
  // navigate to after the job is done
  final int? navigateToIndex;
  final int? id;
  final String? volName;
  final String? volTsp;
  final String? volVillage;
  final String operation;
  const UpdateVolunteer({
    super.key,
    this.id,
    this.volName,
    this.volTsp,
    this.volVillage,
    required this.operation,
    this.navigateToIndex,
  });

  @override
  State<UpdateVolunteer> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateVolunteer> {
  // DEFAULT VALUE TO LOAD FOR EDITINT PURPOSE
  // volunteer id
  int? id;

  // volunter name
  String? volName;

  // CONTROLLER FOR INSERTING PURPOSE
  // username
  final TextEditingController _VolunteerNameController =
      TextEditingController();

  // other village
  final TextEditingController _otherVillageController = TextEditingController();

  // FORM VARIABLES
  // form key for validation
  final GlobalKey<FormState> _key = GlobalKey();
  // error message
  String? errorMessage;

  // user township
  String? _selectedVolunteerTownship;

  // user village
  String? _selectedVolunteerVillage;

  // filtered villages for cascading dropdown
  List<String> villages = []; // initially empty

  @override
  void dispose() {
    _VolunteerNameController.dispose();
    _otherVillageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // pass the values to the screen if the widget is provided with information for editing purposes
    id = widget.id;
    volName = widget.volName;
    _selectedVolunteerTownship = widget.volTsp;
    _selectedVolunteerVillage = widget.volVillage;
    _VolunteerNameController.text = volName ?? '';

    // populate the village dropdown if township is selected by default during editing purposes
    if (_selectedVolunteerTownship != null) {
      villages =
          Constants.townshipVillage.firstWhere(
                (item) => item['township'] == _selectedVolunteerTownship,
              )['villages']
              as List<String>;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldForScrollView(
      canPop: context.read<VolunteerProvider>().volunteers.isNotEmpty,
      appBar: MyAppBar(
        hasBackArrow: false,
        title: Text('${widget.operation} Volunteer'),
        actions: [
          if (widget.operation == 'Edit')
            TappableIcon(
              icon: AppIcons().deleteIcon(),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DeleteConfirmationDialog(
                      title: 'Delete Volunteer?',
                      content: 'Are you sure to delete this volunteer?',
                      onDelete: _delete,
                    );
                  },
                );
              },
            ),
        ],
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
            placeholderText: 'please enter volunteer name',
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

          sizedBoxh20(),

          Row(
            children: [
              // submit button
              Expanded(
                flex: 2,
                child: MyButton(
                  buttonLabel: 'Save volunteer',
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
                              (context) => const NavWrapper(initialIndex: 2),
                        ),
                        (route) => false,
                      ),
                  outlined: true,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ];

  // submit form
  Future<void> _submit() async {
    if (_key.currentState!.validate()) {
      final VolunteerProvider provider = Provider.of<VolunteerProvider>(
        context,
        listen: false,
      );
      try {
        if (widget.operation == 'Edit') {
          await provider.editVolunteerInfo(
            id: id!,
            volunteerName: _VolunteerNameController.text,
            volunteerTownship: _selectedVolunteerTownship!,
            volunteerVillage: _selectedVolunteerVillage ?? '',
          );
          EasyLoading.showSuccess('Volunteer updated successfully');
        } else {
          await provider.insertVolunteerInfo(
            volunteerName: _VolunteerNameController.text,
            volunteerTownship: _selectedVolunteerTownship!,
            volunteerVillage: _selectedVolunteerVillage ?? '',
          );
          EasyLoading.showSuccess('Volunteer added successfully');
        }
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

  Future<void> _delete() async {
    final VolunteerProvider provider = Provider.of<VolunteerProvider>(
      context,
      listen: false,
    );
    try {
      await provider.deleteVolunteer(id!);
      EasyLoading.showSuccess('Volunteer deleted successfully');
      Navigator.pop(context);
    } catch (e) {
      EasyLoading.showError('Failed to delete volunteer: ${e.toString()}');
    }
  }
}
