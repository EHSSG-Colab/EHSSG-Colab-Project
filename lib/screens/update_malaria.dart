import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:malaria_report_mobile/constants/dropdown_options.dart';
import 'package:malaria_report_mobile/database/database_helper.dart';
import 'package:malaria_report_mobile/models/malaria.dart';
import 'package:malaria_report_mobile/providers/malaria_provider.dart';
import 'package:malaria_report_mobile/providers/profile_provider.dart';
import 'package:malaria_report_mobile/screens/update_volunteer.dart';
import 'package:malaria_report_mobile/themes/app_icons.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';
import 'package:malaria_report_mobile/utils/malaria_actions.dart';
import 'package:malaria_report_mobile/utils/string_utils.dart';
import 'package:malaria_report_mobile/widgets/form_widgets/simple_form_label.dart';
import 'package:malaria_report_mobile/widgets/form_widgets/simple_radio.dart';
import 'package:malaria_report_mobile/widgets/layouts/scaffold_for_scroll_view.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/app_bar.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/checkbox.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/divider.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/elevated_button.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/list_tile.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/nav_wrapper.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/notification_dialog.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/simple_dropdown.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/sized_box.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/text_form_field.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/vertical_more_icon_button.dart';
import 'package:provider/provider.dart';

class UpdateMalaria extends StatefulWidget {
  final int navigateToIndex; // page to navigate after the job is done
  final String operation; // Add or Edit
  final int? id; // optional for editing

  const UpdateMalaria({
    super.key,
    required this.operation,
    this.id,
    required this.navigateToIndex,
  });

  @override
  State<UpdateMalaria> createState() => _UpdateMalariaState();
}

class _UpdateMalariaState extends State<UpdateMalaria> {
  // Loading indicator purpose
  late Future<Malaria?> _futureMalariaRecord;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// READ ONLY DATA. GET DATA FROM DATABASE OR SHARED PREFERENCES
  late Map<String, dynamic> _userInfo = {};
  List<String> _volunteerNames = [];
  String? _volunteerTownshipPlaceholder;
  String? _volunteerVillagePlaceholder;

  /// USER INPUT DATA. GET INPUT FROM USER AND DISPLAY THE RESULT AND SAVE TO DATABASE
  String? _selectedVolunteer;
  String? _selectedMonth;
  String? _selectedYear;
  String? _selectedGender;
  String? _selectedAgeUnit = 'year';
  String? _selectedRdtResult;
  String? _malariaParasite;
  String? _symptomType;
  String? _receivedTreatment;
  String? _selectedOccupation;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _act24AmountController = TextEditingController();
  final TextEditingController _act18AmountController = TextEditingController();
  final TextEditingController _act12AmountController = TextEditingController();
  final TextEditingController _act6AmountController = TextEditingController();
  final TextEditingController _chloroquineAmountController =
      TextEditingController();
  final TextEditingController _primaquineAmountController =
      TextEditingController();
  final TextEditingController _otherOccupationController =
      TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  DateTime? _testDate;
  bool _isPregnant = false;
  bool _isLactatingMother = false;
  bool _act24 = false;
  bool _act18 = false;
  bool _act12 = false;
  bool _act6 = false;
  bool _chloroquine = false;
  bool _primaquine = false;
  bool _isReferred = false;
  bool _isDead = false;
  bool _hasTravelled = false;
  bool _isDisabled = false;
  bool _isIdp = false;

  /// VARIABLES FOR BUSINESS LOGIC
  bool _isDatePicked = false;

  @override
  void initState() {
    super.initState();
    _futureMalariaRecord = _loadMalariaData();

    // Initialize profile info
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    if (!profileProvider.isInitialized) {
      profileProvider.init().then((_) {
        setState(() {
          _userInfo = profileProvider.userInfo;
        });
        _checkProfileComplete();
      });
    } else {
      _userInfo = profileProvider.userInfo;
      _checkProfileComplete();
    }

    // Load volunteers
    DatabaseHelper().getAllVol().then((value) {
      setState(() {
        _volunteerNames = List<String>.from(
          value.map((vol) => vol['vol_name'].toString()),
        );

        // Show alert if no volunteers
        if (_volunteerNames.isEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return NotificationDialog(
                title: 'Volunteer Not Available',
                content: 'Please add a volunteer first',
                onClick:
                    () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const UpdateVolunteer(
                              operation: 'Add',
                              navigateToIndex: 2,
                            ),
                      ),
                      (route) => false,
                    ),
              );
            },
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldForScrollView(
      canPop: true,
      appBar: MyAppBar(
        hasBackArrow: false,
        leadingIcon: Icons.arrow_back_ios,
        leadingIconOnPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const NavWrapper(initialIndex: 0),
            ),
            (route) => false,
          );
        },
        title: Text(
          '${widget.operation} Malaria Case Report',
          style: AppTheme().displayLarge(),
        ),
        actions: [
          if (widget.operation == 'Edit')
            VerticalMoreIconButton(
              icon: AppIcons().moreIcon(),
              menuItems: [
                PopupMenuItem(
                  child: ListTile(
                    leading: AppIcons().deleteIcon(),
                    iconColor: AppTheme().rosyColor(),
                    title: const Text(
                      'Delete this record',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      bool confirm =
                          await MalariaActions.showDeleteConfirmationDialog(
                            context,
                            'Are you sure you want to delete this record?',
                          );
                      if (confirm && widget.id != null) {
                        await MalariaActions.deleteRecord(context, widget.id!);
                      }
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
      children: [
        FutureBuilder<Malaria?>(
          future: _futureMalariaRecord,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height:
                    MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme().focusedColor(),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Column(
                children: [
                  sizedBoxh20(),
                  _buildUserInfoWrapper(),
                  sizedBoxh10(),
                  _buildForm(),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  void _checkProfileComplete() {
    if (!Provider.of<ProfileProvider>(
      context,
      listen: false,
    ).isProfileComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/update-profile');
      });
    }
  }

  Widget _buildUserInfoWrapper() {
    return Row(
      children: [
        Expanded(child: _buildUserNameListTile),
        Expanded(child: _buildUserTownshipVillageListTile),
      ],
    );
  }

  Widget get _buildUserNameListTile =>
      MyListTile(label: 'Data Collector', value: _userInfo['userName'] ?? '');

  Widget get _buildUserTownshipVillageListTile => MyListTile(
    label: 'Township - Village',
    value:
        '${_userInfo['userTownship'] ?? ''} - ${_userInfo['userVillage'] ?? ''}',
  );

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MyDivider(),
          _buildVolunteerSelect,
          _buildVolunteerInfoWrapper(),
          sizedBoxh10(),
          const MyDivider(),
          _buildMonthYearWrapper,
          sizedBoxh10(),
          const MyDivider(),
          _buildRdtDateWrapper,
          sizedBoxh10(),
          const MyDivider(),
          _buildNameField,
          sizedBoxh10(),
          _buildAgeWrapper,
          sizedBoxh10(),
          _buildAddressField,
          sizedBoxh10(),
          const MyDivider(),
          _buildGenderRadioButtons,
          sizedBoxh10(),
          if (_selectedGender == 'Female') ...[
            _buildIsPregnantCheckbox,
            sizedBoxh10(),
            _buildIsLactatingMotherCheckbox,
            const MyDivider(),
          ],
          sizedBoxh10(),
          _buildRdtResultRadioButtons,
          sizedBoxh10(),
          const MyDivider(),
          if (_selectedRdtResult == 'Positive') ...[
            _buildMalariaParasiteRadioButtons,
            const MyDivider(),
            _buildSymptomTypeRadioButtons,
            const MyDivider(),
            _buildTreatmentFields,
            const MyDivider(),
            _buildReferralCheckbox,
            const MyDivider(),
            _buildDeathCheckbox,
            const MyDivider(),
            _buildReceivedTreatmentRadioButtons,
            const MyDivider(),
            _buildHasTravelledCheckbox,
            const MyDivider(),
          ],
          _buildOccupationSelect,
          if (_selectedOccupation == 'Other') _buildOtherOccupationField,
          const MyDivider(),
          _buildDisabledCheckbox,
          _buildIdpCheckbox,
          _buildRemarkField,
          sizedBoxh30(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Save'),
            ),
          ),
          sizedBoxh20(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed:
                  () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavWrapper(initialIndex: 0),
                    ),
                    (route) => false,
                  ),
              child: const Text('Cancel'),
            ),
          ),
          sizedBoxh50(),
        ],
      ),
    );
  }

  Widget get _buildVolunteerSelect => SimpleSelect(
    options: _volunteerNames,
    label: 'Volunteer',
    placeholder: 'Please select volunteer',
    isRequired: true,
    initialValue: _selectedVolunteer,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please select a volunteer';
      }
      return null;
    },
    onSelected: (value) {
      setState(() {
        _selectedVolunteer = value;
      });
      if (value != null) {
        _getVolunteerTownshipVillage(value);
      } else {
        setState(() {
          _volunteerTownshipPlaceholder = null;
          _volunteerVillagePlaceholder = null;
        });
      }
    },
  );

  Widget _buildVolunteerInfoWrapper() {
    return Row(
      children: [
        Expanded(
          child: MyListTile(
            label: 'Volunteer Township',
            value: _volunteerTownshipPlaceholder ?? 'Select volunteer',
          ),
        ),
        Expanded(
          child: MyListTile(
            label: 'Volunteer Village',
            value: _volunteerVillagePlaceholder ?? 'Select volunteer',
          ),
        ),
      ],
    );
  }

  Widget get _buildMonthYearWrapper => Row(
    children: [
      Expanded(
        flex: 2,
        child: SimpleSelect(
          options: Constants.months,
          label: 'Treatment Month',
          placeholder: 'Please select month',
          isRequired: true,
          initialValue: _selectedMonth,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a month';
            }
            return null;
          },
          onSelected: (value) {
            setState(() {
              _selectedMonth = value;
            });
          },
        ),
      ),
      sizedBoxw10(),
      Expanded(
        flex: 1,
        child: SimpleSelect(
          options: Constants.generateYearList(),
          label: 'Year',
          placeholder: 'Year',
          isRequired: true,
          initialValue: _selectedYear,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Select year';
            }
            return null;
          },
          onSelected: (value) {
            setState(() {
              _selectedYear = value;
            });
          },
        ),
      ),
    ],
  );

  Widget get _buildRdtDateWrapper => Row(
    children: [
      const Expanded(
        flex: 2,
        child: MyFormLabel(labelText: 'Date of RDT', isRequired: true),
      ),
      sizedBoxw10(),
      Expanded(
        flex: 2,
        child: ElevatedButton(
          onPressed: () => _pickDate(context),
          child: Text(_getDateText()),
        ),
      ),
    ],
  );

  String _getDateText() {
    if (_testDate == null) {
      _isDatePicked = false;
      return 'Select date';
    } else {
      _isDatePicked = true;
      return DateFormat('dd-MM-yyyy').format(_testDate!);
    }
  }

  Future _pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (newDate == null) return;
    setState(() {
      _testDate = newDate;
    });
  }

  Widget get _buildNameField => MyTextFormField(
    myController: _nameController,
    labelText: 'Patient Name',
    placeholderText: 'Enter patient name',
    isRequired: true,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter patient name';
      }
      return null;
    },
  );

  Widget get _buildAgeWrapper => Row(
    children: [
      Expanded(
        flex: 2,
        child: MyRadio(
          options: const ['day', 'month', 'year'],
          optionLabels: const ['Day', 'Month', 'Year'],
          label: 'Age Unit',
          value: _selectedAgeUnit,
          isHorizontal: true,
          onChanged: (value) {
            setState(() {
              _selectedAgeUnit = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select age unit';
            }
            return null;
          },
          isRequired: true,
        ),
      ),
      Expanded(
        flex: 1,
        child: Column(
          children: [
            MyTextFormField(
              myController: _ageController,
              labelText: 'Age',
              placeholderText: 'Age',
              isRequired: true,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter age';
                }
                return null;
              },
            ),
            Text('${capitalizeFirstLetter(_selectedAgeUnit ?? 'year')}(s)'),
          ],
        ),
      ),
    ],
  );

  Widget get _buildAddressField => MyTextFormField(
    myController: _addressController,
    labelText: 'Address',
    placeholderText: 'Enter patient address',
    isRequired: true,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter patient address';
      }
      return null;
    },
  );

  Widget get _buildGenderRadioButtons => MyRadio(
    options: const ['Male', 'Female', 'Other'],
    optionLabels: const ['Male', 'Female', 'Other'],
    label: 'Gender',
    value: _selectedGender,
    isHorizontal: true,
    onChanged: (value) {
      setState(() {
        _selectedGender = value;
        if (value != 'Female') {
          _isPregnant = false;
          _isLactatingMother = false;
        }
      });
    },
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please select gender';
      }
      return null;
    },
    isRequired: true,
  );

  Widget get _buildIsPregnantCheckbox => MyCheckBoxListTile(
    title: 'Pregnancy',
    initialValue: _isPregnant,
    onChanged: (value) {
      setState(() {
        _isPregnant = value ?? false;
      });
    },
  );

  Widget get _buildIsLactatingMotherCheckbox => MyCheckBoxListTile(
    title: 'Lactating mother of under six month infant',
    initialValue: _isLactatingMother,
    onChanged: (value) {
      setState(() {
        _isLactatingMother = value ?? false;
      });
    },
  );

  Widget get _buildRdtResultRadioButtons => MyRadio(
    options: const ['Positive', 'Negative'],
    optionLabels: const ['Positive', 'Negative'],
    label: 'RDT Test Result',
    value: _selectedRdtResult,
    isHorizontal: true,
    onChanged: (value) {
      setState(() {
        _selectedRdtResult = value;
        if (value == 'Negative') {
          _malariaParasite = null;
          _symptomType = null;
          _act24 = false;
          _act24AmountController.text = '';
          _act18 = false;
          _act18AmountController.text = '';
          _act12 = false;
          _act12AmountController.text = '';
          _act6 = false;
          _act6AmountController.text = '';
          _chloroquine = false;
          _chloroquineAmountController.text = '';
          _primaquine = false;
          _primaquineAmountController.text = '';
          _isReferred = false;
          _isDead = false;
          _receivedTreatment = null;
          _hasTravelled = false;
        }
      });
    },
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please select RDT result';
      }
      return null;
    },
    isRequired: true,
  );

  Widget get _buildMalariaParasiteRadioButtons => MyRadio(
    options: const ['Plasmodium falciparum', 'Plasmodium vivax', 'Mixed'],
    optionLabels: const ['Plasmodium falciparum', 'Plasmodium vivax', 'Mixed'],
    label: 'Malaria Parasite Type',
    value: _malariaParasite,
    isHorizontal: false,
    onChanged: (value) {
      setState(() {
        _malariaParasite = value;
      });
    },
    validator: (value) {
      if (_selectedRdtResult == 'Positive' &&
          (value == null || value.isEmpty)) {
        return 'Please select malaria parasite type';
      }
      return null;
    },
    isRequired: _selectedRdtResult == 'Positive',
  );

  Widget get _buildSymptomTypeRadioButtons => MyRadio(
    options: const ['Moderate', 'Severe'],
    optionLabels: const ['Moderate', 'Severe'],
    label: 'Symptoms',
    value: _symptomType,
    isHorizontal: true,
    onChanged: (value) {
      setState(() {
        _symptomType = value;
      });
    },
    validator: (value) {
      if (_selectedRdtResult == 'Positive' &&
          (value == null || value.isEmpty)) {
        return 'Please select symptoms';
      }
      return null;
    },
    isRequired: _selectedRdtResult == 'Positive',
  );

  Widget get _buildTreatmentFields => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const MyFormLabel(labelText: 'Antimalaria Prescribed', isRequired: true),
      MyCheckBoxListTile(
        title: 'ACT-24',
        initialValue: _act24,
        onChanged: (value) {
          setState(() {
            _act24 = value ?? false;
          });
        },
      ),
      if (_act24)
        MyTextFormField(
          myController: _act24AmountController,
          labelText: 'ACT-24 Amount',
          placeholderText: 'Enter ACT-24 amount',
          keyboardType: TextInputType.number,
          isRequired: true,
          validator: (value) {
            if (_act24 && (value == null || value.isEmpty)) {
              return 'Please enter ACT-24 amount';
            }
            return null;
          },
        ),

      MyCheckBoxListTile(
        title: 'ACT-18',
        initialValue: _act18,
        onChanged: (value) {
          setState(() {
            _act18 = value ?? false;
          });
        },
      ),
      if (_act18)
        MyTextFormField(
          myController: _act18AmountController,
          labelText: 'ACT-18 Amount',
          placeholderText: 'Enter ACT-18 amount',
          keyboardType: TextInputType.number,
          isRequired: true,
          validator: (value) {
            if (_act18 && (value == null || value.isEmpty)) {
              return 'Please enter ACT-18 amount';
            }
            return null;
          },
        ),

      MyCheckBoxListTile(
        title: 'ACT-12',
        initialValue: _act12,
        onChanged: (value) {
          setState(() {
            _act12 = value ?? false;
          });
        },
      ),
      if (_act12)
        MyTextFormField(
          myController: _act12AmountController,
          labelText: 'ACT-12 Amount',
          placeholderText: 'Enter ACT-12 amount',
          keyboardType: TextInputType.number,
          isRequired: true,
          validator: (value) {
            if (_act12 && (value == null || value.isEmpty)) {
              return 'Please enter ACT-12 amount';
            }
            return null;
          },
        ),

      MyCheckBoxListTile(
        title: 'ACT-6',
        initialValue: _act6,
        onChanged: (value) {
          setState(() {
            _act6 = value ?? false;
          });
        },
      ),
      if (_act6)
        MyTextFormField(
          myController: _act6AmountController,
          labelText: 'ACT-6 Amount',
          placeholderText: 'Enter ACT-6 amount',
          keyboardType: TextInputType.number,
          isRequired: true,
          validator: (value) {
            if (_act6 && (value == null || value.isEmpty)) {
              return 'Please enter ACT-6 amount';
            }
            return null;
          },
        ),

      MyCheckBoxListTile(
        title: 'Chloroquine',
        initialValue: _chloroquine,
        onChanged: (value) {
          setState(() {
            _chloroquine = value ?? false;
          });
        },
      ),
      if (_chloroquine)
        MyTextFormField(
          myController: _chloroquineAmountController,
          labelText: 'Chloroquine Amount',
          placeholderText: 'Enter Chloroquine amount',
          keyboardType: TextInputType.number,
          isRequired: true,
          validator: (value) {
            if (_chloroquine && (value == null || value.isEmpty)) {
              return 'Please enter Chloroquine amount';
            }
            return null;
          },
        ),

      MyCheckBoxListTile(
        title: 'Primaquine',
        initialValue: _primaquine,
        onChanged: (value) {
          setState(() {
            _primaquine = value ?? false;
          });
        },
      ),
      if (_primaquine)
        MyTextFormField(
          myController: _primaquineAmountController,
          labelText: 'Primaquine Amount',
          placeholderText: 'Enter Primaquine amount',
          keyboardType: TextInputType.number,
          isRequired: true,
          validator: (value) {
            if (_primaquine && (value == null || value.isEmpty)) {
              return 'Please enter Primaquine amount';
            }
            return null;
          },
        ),
    ],
  );

  Widget get _buildReferralCheckbox => MyCheckBoxListTile(
    title: 'Patient referred with Malaria',
    initialValue: _isReferred,
    onChanged: (value) {
      setState(() {
        _isReferred = value ?? false;
      });
    },
  );

  Widget get _buildDeathCheckbox => MyCheckBoxListTile(
    title: 'Expired with RDT Positive',
    initialValue: _isDead,
    onChanged: (value) {
      setState(() {
        _isDead = value ?? false;
      });
    },
  );

  Widget get _buildReceivedTreatmentRadioButtons => MyRadio(
    options: const ['<24', '>24'],
    optionLabels: const ['Within 24hr of fever', 'After 24hr of fever'],
    label: 'Received treatment since',
    value: _receivedTreatment,
    isHorizontal: true,
    onChanged: (value) {
      setState(() {
        _receivedTreatment = value;
      });
    },
    validator: (value) {
      if (_selectedRdtResult == 'Positive' &&
          (value == null || value.isEmpty)) {
        return 'Please select treatment interval';
      }
      return null;
    },
    isRequired: _selectedRdtResult == 'Positive',
  );

  Widget get _buildHasTravelledCheckbox => MyCheckBoxListTile(
    title: 'Travelling 2wks-1mth before',
    initialValue: _hasTravelled,
    onChanged: (value) {
      setState(() {
        _hasTravelled = value ?? false;
      });
    },
  );

  Widget get _buildOccupationSelect => SimpleSelect(
    options: Constants.jobs,
    label: 'Occupation',
    placeholder: 'Select occupation',
    initialValue: _selectedOccupation,
    onSelected: (value) {
      setState(() {
        _selectedOccupation = value;
        if (value != 'Other') {
          _otherOccupationController.text = '';
        }
      });
    },
  );

  Widget get _buildOtherOccupationField => MyTextFormField(
    myController: _otherOccupationController,
    labelText: 'Other Occupation',
    placeholderText: 'Please specify occupation',
    isRequired: _selectedOccupation == 'Other',
    validator: (value) {
      if (_selectedOccupation == 'Other' && (value == null || value.isEmpty)) {
        return 'Please specify occupation';
      }
      return null;
    },
  );

  Widget get _buildDisabledCheckbox => MyCheckBoxListTile(
    title: 'Person with disabilities',
    initialValue: _isDisabled,
    onChanged: (value) {
      setState(() {
        _isDisabled = value ?? false;
      });
    },
  );

  Widget get _buildIdpCheckbox => MyCheckBoxListTile(
    title: 'Internally displaced person',
    initialValue: _isIdp,
    onChanged: (value) {
      setState(() {
        _isIdp = value ?? false;
      });
    },
  );

  Widget get _buildRemarkField => MyTextFormField(
    myController: _remarkController,
    labelText: 'Remark',
    placeholderText: 'Enter any remarks if needed',
    validator: (value) {
      return;
    },
    isRequired: false,
  );
  // Get volunteer township and village
  Future<void> _getVolunteerTownshipVillage(String name) async {
    try {
      Map<String, dynamic> volunteerInfo = await DatabaseHelper()
          .getVolunteerByName(name);
      setState(() {
        _volunteerTownshipPlaceholder = volunteerInfo['vol_tsp'] ?? 'N/A';
        _volunteerVillagePlaceholder = volunteerInfo['vol_vil'] ?? 'N/A';
      });
    } catch (e) {
      setState(() {
        _volunteerTownshipPlaceholder = 'Error';
        _volunteerVillagePlaceholder = 'Error';
      });
    }
  }

  // Submit form data
  Future<void> _submitForm() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        _isDatePicked) {
      _formKey.currentState?.save();

      // Create Malaria object with form data
      Malaria malariaCase = Malaria(
        id: widget.id,
        dataCollectorId: _userInfo['userId'] ?? '',
        dataCollectorName: _userInfo['userName'] ?? '',
        dataCollectorTownship: _userInfo['userTownship'] ?? '',
        dataCollectorVillage: _userInfo['userVillage'] ?? '',
        volunteerId: '', // This would need to be retrieved from database
        volunteerName: _selectedVolunteer ?? '',
        volunteerTownship: _volunteerTownshipPlaceholder ?? '',
        volunteerVillage: _volunteerVillagePlaceholder ?? '',
        tMonth: _selectedMonth ?? '',
        tYear: _selectedYear ?? '',
        dateOfRdt: _testDate?.toIso8601String() ?? '',
        patientName: _nameController.text,
        ageUnit: _selectedAgeUnit ?? 'year',
        patientAge: _ageController.text,
        patientAddress: _addressController.text,
        patientSex: _selectedGender ?? '',
        isPregnant: _isPregnant ? 'Yes' : 'No',
        isLactatingMother: _isLactatingMother ? 'Yes' : 'No',
        rdtResult: _selectedRdtResult ?? '',
        malariaParasite: _malariaParasite ?? '',
        symptoms: _symptomType ?? '',
        act24: _act24 ? 'Yes' : 'No',
        act24Count: _act24AmountController.text,
        act18: _act18 ? 'Yes' : 'No',
        act18Count: _act18AmountController.text,
        act12: _act12 ? 'Yes' : 'No',
        act12Count: _act12AmountController.text,
        act6: _act6 ? 'Yes' : 'No',
        act6Count: _act6AmountController.text,
        chloroquine: _chloroquine ? 'Yes' : 'No',
        chloroquineCount: _chloroquineAmountController.text,
        primaquine: _primaquine ? 'Yes' : 'No',
        primaquineCount: _primaquineAmountController.text,
        isReferred: _isReferred ? 'Yes' : 'No',
        isDead: _isDead ? 'Yes' : 'No',
        receivedTreatment: _receivedTreatment ?? '',
        hasTravelled: _hasTravelled ? 'Yes' : 'No',
        occupation: _selectedOccupation ?? '',
        isPersonWithDisabilities: _isDisabled ? 'Yes' : 'No',
        isInternallyDisplaced: _isIdp ? 'Yes' : 'No',
        remark: _remarkController.text,
        syncStatus: 'PENDING',
      );

      try {
        if (widget.operation == 'Add') {
          // Add new malaria case
          await Provider.of<MalariaProvider>(
            context,
            listen: false,
          ).addMalariaCase(malariaCase);
          EasyLoading.showSuccess('Malaria record added successfully');
        } else {
          // Update existing malaria case
          await Provider.of<MalariaProvider>(
            context,
            listen: false,
          ).updateMalariaCase(malariaCase);
          EasyLoading.showSuccess('Malaria record updated successfully');
        }

        // Navigate back to home screen or specified destination
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder:
                (context) => NavWrapper(initialIndex: widget.navigateToIndex),
          ),
          (route) => false,
        );
      } catch (e) {
        EasyLoading.showError('Error saving data: $e');
      }
    } else if (_formKey.currentState != null &&
        _formKey.currentState!.validate() &&
        !_isDatePicked) {
      EasyLoading.showError('Please select test date');
    } else {
      EasyLoading.showError('Please fill in all required fields');
    }
  }

  // Load existing malaria data for editing
  Future<Malaria?> _loadMalariaData() async {
    if (widget.id != null && widget.operation == 'Edit') {
      final malaria = await Provider.of<MalariaProvider>(
        context,
        listen: false,
      ).getMalariaById(widget.id!);

      if (malaria != null) {
        _setInitialValues(malaria);
      }
      return malaria;
    }
    return null;
  }

  // Set initial values for editing existing record
  void _setInitialValues(Malaria malaria) {
    setState(() {
      _selectedMonth = malaria.tMonth;
      _selectedYear = malaria.tYear;

      if (malaria.dateOfRdt.isNotEmpty) {
        _testDate = DateTime.parse(malaria.dateOfRdt);
        _isDatePicked = true;
      }

      _nameController.text = malaria.patientName;
      _selectedAgeUnit = malaria.ageUnit;
      _ageController.text = malaria.patientAge;
      _addressController.text = malaria.patientAddress;
      _selectedGender = malaria.patientSex;
      _isPregnant = malaria.isPregnant == 'Yes';
      _isLactatingMother = malaria.isLactatingMother == 'Yes';
      _selectedRdtResult = malaria.rdtResult;
      _malariaParasite = malaria.malariaParasite;
      _symptomType = malaria.symptoms;

      _act24 = malaria.act24 == 'Yes';
      _act24AmountController.text = malaria.act24Count;
      _act18 = malaria.act18 == 'Yes';
      _act18AmountController.text = malaria.act18Count;
      _act12 = malaria.act12 == 'Yes';
      _act12AmountController.text = malaria.act12Count;
      _act6 = malaria.act6 == 'Yes';
      _act6AmountController.text = malaria.act6Count;
      _chloroquine = malaria.chloroquine == 'Yes';
      _chloroquineAmountController.text = malaria.chloroquineCount;
      _primaquine = malaria.primaquine == 'Yes';
      _primaquineAmountController.text = malaria.primaquineCount;

      _isReferred = malaria.isReferred == 'Yes';
      _isDead = malaria.isDead == 'Yes';
      _receivedTreatment = malaria.receivedTreatment;
      _hasTravelled = malaria.hasTravelled == 'Yes';
      _selectedOccupation = malaria.occupation;

      // Check if occupation is in the predefined list, otherwise set to "Other"
      if (malaria.occupation.isNotEmpty &&
          !Constants.jobs.contains(malaria.occupation)) {
        _selectedOccupation = 'Other';
        _otherOccupationController.text = malaria.occupation;
      }

      _isDisabled = malaria.isPersonWithDisabilities == 'Yes';
      _isIdp = malaria.isInternallyDisplaced == 'Yes';
      _remarkController.text = malaria.remark;

      _selectedVolunteer = malaria.volunteerName;
      _volunteerTownshipPlaceholder = malaria.volunteerTownship;
      _volunteerVillagePlaceholder = malaria.volunteerVillage;
    });
  }
}
