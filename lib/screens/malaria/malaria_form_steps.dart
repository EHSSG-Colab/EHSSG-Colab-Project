import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/screens/malaria/malaria_form_data.dart';
import 'package:malaria_report_mobile/screens/malaria/malaria_form_fields.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/divider.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/sized_box.dart';

/// Class responsible for defining and building form steps
class MalariaFormSteps {
  // Get total number of steps
  static int getTotalSteps() {
    return 5; // Total of 5 steps in our form
  }

  // Define all stepper steps
  static List<Step> getSteps(
    BuildContext context,
    MalariaFormData formData,
    List<GlobalKey<FormState>> formKeys,
    int currentStep, {
    Function? onVolunteerSelected,
    Function? onDateSelected,
    Function? onAgeUnitChanged,
    Function? onGenderChanged,
  }) {
    return [
      _buildVolunteerStep(
        context,
        formData,
        formKeys[0],
        currentStep,
        onVolunteerSelected: onVolunteerSelected,
      ),
      _buildPatientInfoStep(
        context,
        formData,
        formKeys[1],
        currentStep,
        onDateSelected: onDateSelected,
        onAgeUnitChanged: onAgeUnitChanged,
        onGenderChanged: onGenderChanged,
      ),
      _buildTestResultsStep(context, formData, formKeys[2], currentStep),
      _buildTreatmentStep(context, formData, formKeys[3], currentStep),
      _buildAdditionalInfoStep(context, formData, formKeys[4], currentStep),
    ];
  }

  // Step 1: Volunteer Information
  static Step _buildVolunteerStep(
    BuildContext context,
    MalariaFormData formData,
    GlobalKey<FormState> formKey,
    int currentStep, {
    Function? onVolunteerSelected,
  }) {
    return Step(
      title: const Text('Volunteer Information'),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            MalariaFormFields.buildUserInfoWrapper(context, formData),
            sizedBoxh10(),
            const MyDivider(),
            MalariaFormFields.buildVolunteerSelect(
              context,
              formData,
              onVolunteerSelected: onVolunteerSelected,
            ),
            MalariaFormFields.buildVolunteerInfoWrapper(context, formData),
          ],
        ),
      ),
      isActive: currentStep >= 0,
      state: _getStepState(0, currentStep),
    );
  }

  // Step 2: Patient Information
  static Step _buildPatientInfoStep(
    BuildContext context,
    MalariaFormData formData,
    GlobalKey<FormState> formKey,
    int currentStep, {
    Function? onDateSelected,
    Function? onAgeUnitChanged,
    Function? onGenderChanged,
  }) {
    return Step(
      title: const Text('Patient Information'),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            MalariaFormFields.buildMonthYearWrapper(context, formData),
            sizedBoxh10(),
            MalariaFormFields.buildRdtDateWrapper(
              context,
              formData,
              onDateSelected: onDateSelected,
            ),
            sizedBoxh10(),
            MalariaFormFields.buildNameField(context, formData),
            sizedBoxh10(),
            MalariaFormFields.buildAgeWrapper(
              context,
              formData,
              onAgeUnitChanged: onAgeUnitChanged,
            ),
            sizedBoxh10(),
            MalariaFormFields.buildAddressField(context, formData),
            sizedBoxh10(),
            MalariaFormFields.buildGenderRadioButtons(
              context,
              formData,
              onGenderChanged: onGenderChanged,
            ),
            sizedBoxh10(),
            if (formData.selectedGender == 'Female') ...[
              MalariaFormFields.buildIsPregnantCheckbox(context, formData),
              sizedBoxh10(),
              MalariaFormFields.buildIsLactatingMotherCheckbox(
                context,
                formData,
              ),
            ],
          ],
        ),
      ),
      isActive: currentStep >= 1,
      state: _getStepState(1, currentStep),
    );
  }

  // Step 3: Test Results & Symptoms
  static Step _buildTestResultsStep(
    BuildContext context,
    MalariaFormData formData,
    GlobalKey<FormState> formKey,
    int currentStep, {
    Function? onRdtResultChanged,
  }) {
    return Step(
      title: const Text('Test Results'),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            MalariaFormFields.buildRdtResultRadioButtons(
              context,
              formData,
              onRdtResultChanged: onRdtResultChanged,
            ),
            sizedBoxh10(),
            if (formData.selectedRdtResult == 'Positive') ...[
              const MyDivider(),
              MalariaFormFields.buildMalariaParasiteRadioButtons(
                context,
                formData,
              ),
              sizedBoxh10(),
              const MyDivider(),
              MalariaFormFields.buildSymptomTypeRadioButtons(context, formData),
            ],
          ],
        ),
      ),
      isActive: currentStep >= 2,
      state: _getStepState(2, currentStep),
    );
  }

  // Step 4: Treatment Details (only visible if RDT is positive)
  static Step _buildTreatmentStep(
    BuildContext context,
    MalariaFormData formData,
    GlobalKey<FormState> formKey,
    int currentStep, {
    Function? onTreatmentChanged,
  }) {
    return Step(
      title: const Text('Treatment'),
      content: Form(
        key: formKey,
        child:
            formData.selectedRdtResult == 'Positive'
                ? Column(
                  children: [
                    MalariaFormFields.buildTreatmentFields(
                      context,
                      formData,
                      onTreatmentChanged: onTreatmentChanged,
                    ),
                    sizedBoxh10(),
                    const MyDivider(),
                    MalariaFormFields.buildReferralCheckbox(context, formData),
                    MalariaFormFields.buildDeathCheckbox(context, formData),
                    sizedBoxh10(),
                    const MyDivider(),
                    MalariaFormFields.buildReceivedTreatmentRadioButtons(
                      context,
                      formData,
                    ),
                  ],
                )
                : const Center(
                  child: Text(
                    'No treatment needed for negative RDT result',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
      ),
      isActive: currentStep >= 3,
      state: _getStepState(3, currentStep),
    );
  }

  // Step 5: Additional Information
  static Step _buildAdditionalInfoStep(
    BuildContext context,
    MalariaFormData formData,
    GlobalKey<FormState> formKey,
    int currentStep, {
    Function? on,
  }) {
    return Step(
      title: const Text('Additional Information'),
      content: Form(
        key: formKey,
        child: Column(
          children: [
            if (formData.selectedRdtResult == 'Positive')
              MalariaFormFields.buildHasTravelledCheckbox(context, formData),
            sizedBoxh10(),
            MalariaFormFields.buildOccupationSelect(context, formData),
            if (formData.selectedOccupation == 'Other')
              MalariaFormFields.buildOtherOccupationField(context, formData),
            sizedBoxh10(),
            const MyDivider(),
            MalariaFormFields.buildDisabledCheckbox(context, formData),
            MalariaFormFields.buildIdpCheckbox(context, formData),
            sizedBoxh10(),
            MalariaFormFields.buildRemarkField(context, formData),
          ],
        ),
      ),
      isActive: currentStep >= 4,
      state: _getStepState(4, currentStep),
    );
  }

  // Determine step state (completed, current, or inactive)
  static StepState _getStepState(int step, int currentStep) {
    if (currentStep > step) {
      return StepState.complete; // Step is completed
    } else if (currentStep == step) {
      return StepState.editing; // Current step
    } else {
      return StepState.indexed; // Step is ahead
    }
  }
}
