import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:malaria_report_mobile/database/database_helper.dart';
import 'package:malaria_report_mobile/models/malaria.dart';
import 'package:malaria_report_mobile/providers/malaria_provider.dart';
import 'package:malaria_report_mobile/providers/profile_provider.dart';
import 'package:malaria_report_mobile/screens/malaria/malaria_form_data.dart';
import 'package:malaria_report_mobile/screens/update_volunteer.dart';
import 'package:malaria_report_mobile/themes/app_icons.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';
import 'package:malaria_report_mobile/utils/malaria_actions.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/app_bar.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/nav_wrapper.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/notification_dialog.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/sized_box.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/vertical_more_icon_button.dart';
import 'package:provider/provider.dart';

// Import the separated files
import 'package:malaria_report_mobile/screens/malaria/malaria_form_steps.dart';
import 'package:malaria_report_mobile/screens/malaria/malaria_data_handlers.dart';
import 'package:malaria_report_mobile/screens/malaria/malaria_form_utils.dart';

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

  // Step tracking variables
  int _currentStep = 0; // Tracks the current step in the stepper
  bool _isCompleted = false; // Flag for completion state

  // Form keys for validation by step
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), // Step 1 - Volunteer Information
    GlobalKey<FormState>(), // Step 2 - Patient Information
    GlobalKey<FormState>(), // Step 3 - Test Results and Symptoms
    GlobalKey<FormState>(), // Step 4 - Treatment Details
    GlobalKey<FormState>(), // Step 5 - Additional Information
  ];

  // Form data controller
  late MalariaFormData formData;

  @override
  void initState() {
    super.initState();
    formData = MalariaFormData(); // Initialize the form data controller
    _futureMalariaRecord = _loadMalariaData();
    _initializeProfiles();
    _loadVolunteers();
  }

  // Initialize profile information
  void _initializeProfiles() {
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    if (!profileProvider.isInitialized) {
      profileProvider.init().then((_) {
        setState(() {
          formData.userInfo = profileProvider.userInfo;
        });
        _checkProfileComplete();
      });
    } else {
      formData.userInfo = profileProvider.userInfo;
      _checkProfileComplete();
    }
  }

  // Load volunteer data
  void _loadVolunteers() {
    DatabaseHelper().getAllVol().then((value) {
      setState(() {
        formData.volunteerNames = List<String>.from(
          value.map((vol) => vol['vol_name'].toString()),
        );

        // Show alert if no volunteers
        if (formData.volunteerNames.isEmpty) {
          _showNoVolunteersAlert();
        }
      });
    });
  }

  // Show alert when no volunteers are available
  void _showNoVolunteersAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NotificationDialog(
          title: 'Volunteer Not Available',
          content: 'Please add a malaria volunteer first.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        hasBackArrow: false,
        leadingIcon: Icons.arrow_back_ios,
        leadingIconOnPressed: () => _navigateToHome(),
        title: Text('${widget.operation} Malaria Case Report'),
        actions: [if (widget.operation == 'Edit') _buildMoreActions()],
      ),
      body: FutureBuilder<Malaria?>(
        future: _futureMalariaRecord,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return _isCompleted
                ? _buildCompletionScreen()
                : _buildStepperForm();
          }
        },
      ),
    );
  }

  // Widget for showing "more" actions in AppBar
  Widget _buildMoreActions() {
    return VerticalMoreIconButton(
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
            onTap: () => _promptDeleteRecord(),
          ),
        ),
      ],
    );
  }

  // Prompt user to confirm deletion
  void _promptDeleteRecord() async {
    Navigator.pop(context);
    bool confirm = await MalariaActions.showDeleteConfirmationDialog(
      context,
      'Are you sure you want to delete this record?',
    );
    if (confirm && widget.id != null) {
      await MalariaActions.deleteRecord(context, widget.id!);
    }
  }

  // Navigate back to home
  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const NavWrapper(initialIndex: 0),
      ),
      (route) => false,
    );
  }

  // Loading indicator widget
  Widget _buildLoadingIndicator() {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          MediaQuery.of(context).padding.top,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme().focusedColor()),
        ),
      ),
    );
  }

  // Widget shown when form is completed
  Widget _buildCompletionScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80.0,
            ),
            sizedBoxh20(),
            Text(
              'Malaria case report ${widget.operation == 'Add' ? 'added' : 'updated'} successfully!',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            sizedBoxh30(),
            ElevatedButton(
              onPressed: () => _navigateToHome(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  // Main stepper form widget
  Widget _buildStepperForm() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(primary: AppTheme().secondaryColor()),
      ),
      child: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        steps: MalariaFormSteps.getSteps(
          context,
          formData,
          _formKeys,
          _currentStep,
          onVolunteerSelected: () {
            setState(() {});
          },
          onDateSelected: () {
            setState(() {});
          },
          onAgeUnitChanged: () {
            setState(() {});
          },
          onGenderChanged: () {
            setState(() {});
          },
        ),
        onStepContinue: () => _handleStepContinue(),
        onStepCancel: _currentStep > 0 ? () => _handleStepCancel() : null,
        onStepTapped: (step) => _handleStepTapped(step),
        controlsBuilder: (context, details) => _buildStepperControls(details),
      ),
    );
  }

  // Handles the continue button logic
  void _handleStepContinue() {
    final isLastStep = _currentStep == MalariaFormSteps.getTotalSteps() - 1;

    if (MalariaFormValidator.validateStep(
      _currentStep,
      _formKeys[_currentStep],
      formData,
    )) {
      if (isLastStep) {
        _submitForm();
      } else {
        setState(() {
          _currentStep += 1;
        });
      }
    } else {
      // Show validation error toast
      EasyLoading.showError('Please fill all required fields in this step');
    }
  }

  // Handles the cancel/back button logic
  void _handleStepCancel() {
    setState(() {
      _currentStep -= 1;
    });
  }

  // Handles tapping on a step directly
  void _handleStepTapped(int step) {
    // Only allow jumping to a step if all previous steps are valid
    bool canJump = true;

    for (int i = 0; i < step; i++) {
      if (!MalariaFormValidator.validateStep(i, _formKeys[i], formData)) {
        canJump = false;
        break;
      }
    }

    if (canJump) {
      setState(() {
        _currentStep = step;
      });
    } else {
      EasyLoading.showError('Please complete previous steps first');
    }
  }

  // Custom controls for the stepper
  Widget _buildStepperControls(ControlsDetails details) {
    final isLastStep = _currentStep == MalariaFormSteps.getTotalSteps() - 1;

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: details.onStepContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme().secondaryColor(),
              ),
              child: Text(
                isLastStep ? 'Submit' : 'Next',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          sizedBoxw10(),
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme().secondaryColor()),
                ),
                onPressed: details.onStepCancel,
                child: const Text('Back'),
              ),
            ),
        ],
      ),
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

  // Submit form data - validates all steps before submission
  Future<void> _submitForm() async {
    // Validate all steps before submission
    bool isValid = MalariaFormValidator.validateAllSteps(_formKeys, formData);

    if (isValid) {
      EasyLoading.show(status: 'Processing...');

      // Create Malaria object with form data
      Malaria malariaCase = MalariaDataTransformer.formDataToModel(
        formData,
        widget.id,
      );

      try {
        if (widget.operation == 'Add') {
          // Add new malaria case
          await Provider.of<MalariaProvider>(
            context,
            listen: false,
          ).addMalariaCase(malariaCase);
          EasyLoading.dismiss();

          // Show completion state instead of immediately navigating away
          setState(() {
            _isCompleted = true;
          });
        } else {
          // Update existing malaria case
          await Provider.of<MalariaProvider>(
            context,
            listen: false,
          ).updateMalariaCase(malariaCase);
          EasyLoading.dismiss();

          // Show completion state
          setState(() {
            _isCompleted = true;
          });
        }
      } catch (e) {
        EasyLoading.dismiss();
        EasyLoading.showError('Error saving data: $e');
      }
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
        // Transform model to form data
        MalariaDataTransformer.modelToFormData(malaria, formData);
      }
      return malaria;
    }
    return null;
  }
}
